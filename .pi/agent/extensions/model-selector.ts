/**
 * models-list.ts — Model Selector Overlay (Ctrl+P)
 *
 * Opens a centered overlay that lets you search and select a model,
 * replacing the default model-cycling behavior of Ctrl+P.
 *
 * Features:
 *   - Ctrl+P to open the selector
 *   - Substring search by model name, ID, or provider
 *   - Ctrl+n / Ctrl+p to navigate down/up (plus arrow keys)
 *   - Enter to select, Esc to cancel
 *   - Long model IDs truncated with "…" at 32 chars
 *   - Current model shown with a ✓ checkmark
 *
 * Usage: copy to ~/.pi/agent/extensions/ or .pi/extensions/
 */

import { modelsAreEqual } from "@earendil-works/pi-ai";
import type { ExtensionContext, ExtensionAPI } from "@earendil-works/pi-coding-agent";
import {
  Input,
  matchesKey,
  truncateToWidth,
  visibleWidth,
} from "@earendil-works/pi-tui";

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

/** Fixed overlay width (inner = width - 2 borders). */
const OVERLAY_WIDTH = 64;
/** Maximum visible model rows (kept constant so the box doesn't resize). */
const MAX_VISIBLE = 10;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/** Truncate a string to maxLen, appending "…" if truncated. */
function truncateId(str: string, maxLen: number): string {
  if (str.length <= maxLen) return str;
  return str.slice(0, maxLen - 1) + "…";
}

// ---------------------------------------------------------------------------
// Model info (provider + id + model reference)
// ---------------------------------------------------------------------------
interface ModelItem {
  provider: string;
  id: string;
  model: any; // Model<any>
}

// ---------------------------------------------------------------------------
// Extension
// ---------------------------------------------------------------------------
export default function (pi: ExtensionAPI) {
  // Re-entry guard: only one selector overlay at a time
  let selectorOpen = false;
  // Active terminal-input unsubscribe (cleaned up on shutdown/reload)
  let unsubscribeTerminal: (() => void) | null = null;

  pi.on("session_start", (_event, ctx: ExtensionContext) => {
    // Only active in TUI mode (interactive terminal)
    if (ctx.mode !== "tui") return;

    // Tear down any previous listener (e.g. after /reload)
    unsubscribeTerminal?.();
    unsubscribeTerminal = ctx.ui.onTerminalInput((data) => {
      // Skip if a selector is already showing
      if (selectorOpen) return;

      // Intercept Ctrl+P *before* the editor's keybinding processor
      if (matchesKey(data, "ctrl+p")) {
        void showModelSelector(ctx, pi).finally(() => {
          selectorOpen = false;
        });
        selectorOpen = true;
        return { consume: true };
      }
    });
  });

  // Clean up the input listener on shutdown
  pi.on("session_shutdown", () => {
    unsubscribeTerminal?.();
    unsubscribeTerminal = null;
  });
}

// ---------------------------------------------------------------------------
// Show the model selector overlay
// ---------------------------------------------------------------------------
async function showModelSelector(ctx: ExtensionContext, pi: ExtensionAPI) {
  const currentModel = ctx.model;

  // Refresh and load available models
  ctx.modelRegistry.refresh();
  let allModels: ModelItem[] = [];

  try {
    const available = ctx.modelRegistry.getAvailable();
    allModels = available.map((m: any) => ({
      provider: m.provider,
      id: m.id,
      model: m,
    }));
  } catch (_err) {
    // Fall through — will show empty list with "No matching models"
  }

  // Sort: current model first, then alphabetical by provider
  const sortedModels = [...allModels].sort((a, b) => {
    const aIsCurrent = modelsAreEqual(currentModel, a.model);
    const bIsCurrent = modelsAreEqual(currentModel, b.model);
    if (aIsCurrent && !bIsCurrent) return -1;
    if (!aIsCurrent && bIsCurrent) return 1;
    return a.provider.localeCompare(b.provider);
  });

  // Show the overlay
  const selectedModel: any | null = await ctx.ui.custom<any | null>(
    (tui: any, theme: any, _kb: any, done: (val: any | null) => void) => {
      // --- Component state ---
      let query = "";
      let selectedIndex = 0;
      let filteredModels: ModelItem[] = sortedModels;

      // Search input
      const searchInput = new Input();
      searchInput.onSubmit = () => {
        const selected = filteredModels[selectedIndex];
        if (selected) done(selected.model);
      };

      // --- Helpers ---

      const applyFilter = () => {
        const q = query.trim().toLowerCase();
        if (q.length > 0) {
          filteredModels = sortedModels.filter((item) => {
            const haystack =
              `${item.id} ${item.provider} ${item.provider}/${item.id} ${item.model.name ?? ""}`.toLowerCase();
            return haystack.includes(q);
          });
        } else {
          filteredModels = sortedModels;
        }
        // Clamp selection
        if (filteredModels.length === 0) {
          selectedIndex = 0;
        } else {
          selectedIndex = Math.min(selectedIndex, filteredModels.length - 1);
        }
      };

      const moveSelection = (delta: number) => {
        if (filteredModels.length === 0) return;
        selectedIndex =
          (selectedIndex + delta + filteredModels.length) %
          filteredModels.length;
        tui.requestRender();
      };

      // --- Render one model row ---
      const renderModelRow = (item: ModelItem, isSelected: boolean, isCurrent: boolean): string => {
        const maxLabelLen = 32;
        const prefix = isSelected ? theme.fg("accent", "→ ") : "   ";
        const modelText = isSelected
          ? theme.fg("accent", truncateId(item.id, maxLabelLen))
          : truncateId(item.id, maxLabelLen);
        const badge = theme.fg("muted", ` [${item.provider}]`);
        const check = isCurrent ? theme.fg("success", " ✓") : "";
        return `  ${prefix}${modelText}${badge}${check}`;
      };

      // --- Build a fixed-size bordered box ---
      const padInner = (s: string): string => {
        // Pad or truncate to inner width (OVERLAY_WIDTH - 2 borders)
        const innerW = OVERLAY_WIDTH - 2;
        const vis = visibleWidth(s);
        if (vis >= innerW) return truncateToWidth(s, innerW, "…", true);
        return s + " ".repeat(innerW - vis);
      };

      const buildBox = (): string[] => {
        const innerW = OVERLAY_WIDTH - 2;
        const lines: string[] = [];

        // --- Top border with title ---
        const titlePlain = " Model Selector ";
        const titlePlainVis = titlePlain.length;
        const dashTotal = innerW - titlePlainVis;
        const dashLeft = Math.floor(dashTotal / 2);
        const dashRight = dashTotal - dashLeft;
        lines.push(
          theme.fg("border", "╭" + "─".repeat(dashLeft)) +
            theme.bold(theme.fg("accent", titlePlain)) +
            theme.fg("border", "─".repeat(dashRight) + "╮"),
        );

        // --- Search row ---
        lines.push(theme.fg("border", "│") + padInner("") + theme.fg("border", "│"));

        const [searchLine] = searchInput.render(innerW);
        // Prefix with a small indent so the input doesn't touch the border
        lines.push(
          theme.fg("border", "│") +
            " " +
            truncateToWidth(searchLine, innerW - 1, "…", true) +
            theme.fg("border", "│"),
        );

        lines.push(theme.fg("border", "│") + padInner("") + theme.fg("border", "│"));

        // --- Model list (fixed height: MAX_VISIBLE rows) ---
        const startIndex = Math.max(
          0,
          Math.min(
            selectedIndex - Math.floor(MAX_VISIBLE / 2),
            Math.max(0, filteredModels.length - MAX_VISIBLE),
          ),
        );
        const endIndex = Math.min(startIndex + MAX_VISIBLE, filteredModels.length);

        for (let i = startIndex; i < endIndex; i++) {
          const item = filteredModels[i];
          if (!item) {
            lines.push(theme.fg("border", "│") + padInner("") + theme.fg("border", "│"));
            continue;
          }
          const isCurrent = modelsAreEqual(currentModel, item.model);
          lines.push(
            theme.fg("border", "│") +
              padInner(renderModelRow(item, i === selectedIndex, isCurrent)) +
              theme.fg("border", "│"),
          );
        }

        // Pad remaining rows to keep height constant
        const shown = endIndex - startIndex;
        for (let i = shown; i < MAX_VISIBLE; i++) {
          lines.push(theme.fg("border", "│") + padInner("") + theme.fg("border", "│"));
        }

        // --- Scroll indicator + model detail ---
        lines.push(theme.fg("border", "│") + padInner("") + theme.fg("border", "│"));

        if (filteredModels.length > 0) {
          const scrollInfo =
            startIndex > 0 || endIndex < filteredModels.length
              ? theme.fg("muted", `  (${selectedIndex + 1}/${filteredModels.length})`)
              : "";
          lines.push(
            theme.fg("border", "│") + padInner(scrollInfo) + theme.fg("border", "│"),
          );

          const selected = filteredModels[selectedIndex];
          if (selected) {
            const detail = theme.fg("muted", `  Name: ${selected.model.name}`);
            lines.push(
              theme.fg("border", "│") + padInner(detail) + theme.fg("border", "│"),
            );
          }
        } else {
          lines.push(
            theme.fg("border", "│") +
              padInner(theme.fg("muted", "  No matching models")) +
              theme.fg("border", "│"),
          );
        }

        // --- Hint row ---
        lines.push(theme.fg("border", "│") + padInner("") + theme.fg("border", "│"));
        lines.push(
          theme.fg("border", "│") +
            padInner(
              theme.fg("dim", "  ↑↓/ctrl+n ctrl+p navigate · type to search · Enter select · Esc cancel"),
            ) +
            theme.fg("border", "│"),
        );

        // --- Bottom border ---
        lines.push(theme.fg("border", "╰" + "─".repeat(innerW) + "╯"));

        return lines;
      };

      // Initial state
      applyFilter();

      // --- Return component ---
      return {
        render: (_width: number) => buildBox(),
        invalidate: () => {},
        handleInput: (data: string) => {
          // Cancel: Esc or Ctrl+C
          if (matchesKey(data, "escape") || matchesKey(data, "ctrl+c")) {
            done(null);
            return;
          }

          // Confirm: Enter
          if (matchesKey(data, "enter") || matchesKey(data, "return")) {
            const selected = filteredModels[selectedIndex];
            if (selected) done(selected.model);
            return;
          }

          // Ctrl+n / Ctrl+p navigation (vim-style: n=next↓, p=prev↑)
          if (matchesKey(data, "ctrl+n")) {
            moveSelection(1);
            return;
          }
          if (matchesKey(data, "ctrl+p")) {
            moveSelection(-1);
            return;
          }

          // Arrow key navigation
          if (matchesKey(data, "down")) {
            moveSelection(1);
            return;
          }
          if (matchesKey(data, "up")) {
            moveSelection(-1);
            return;
          }

          // Everything else → forward to the search input
          searchInput.handleInput(data);
          query = searchInput.getValue();
          applyFilter();
          tui.requestRender();
        },
        dispose: () => {},
      };
    },
    {
      overlay: true,
      overlayOptions: {
        anchor: "center",
        width: OVERLAY_WIDTH,
      },
    },
  );

  // --- Post-selection: set the model ---
  if (selectedModel) {
    try {
      const ok = await pi.setModel(selectedModel);
      if (!ok) {
        ctx.ui.notify(
          "No API key configured for this model. Use /login to add a provider.",
          "warning",
        );
      }
    } catch (err) {
      ctx.ui.notify(
        `Failed to set model: ${err instanceof Error ? err.message : String(err)}`,
        "error",
      );
    }
  }
}
