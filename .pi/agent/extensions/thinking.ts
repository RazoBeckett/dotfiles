/**
 * /thinking command — opens the Thinking Level selector.
 *
 * Faithfully replicates the exact layout of the "Thinking Level" submenu
 * inside /settings using the same exported theme primitives and SelectList
 * theme that the built-in settings-selector uses. Available levels are
 * queried from the current model via getSupportedThinkingLevels so only
 * levels the model actually supports are shown.
 *
 * Built-in /settings handler is private (InteractiveMode.showSettingsSelector);
 * its SelectSubmenu class is not exported. This extension rebuilds that
 * submenu identically from the publicly-exported building blocks.
 */

import type { ThinkingLevel } from "@earendil-works/pi-agent-core";
import { getSupportedThinkingLevels } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { DynamicBorder, getSelectListTheme } from "@earendil-works/pi-coding-agent";
import {
  Container,
  type SelectItem,
  SelectList,
  type SelectListLayoutOptions,
  Spacer,
  Text,
} from "@earendil-works/pi-tui";

// ---------------------------------------------------------------------------
// Mirrors the constant from settings-selector.ts (not exported, so inlined)
// ---------------------------------------------------------------------------
const SELECT_LIST_LAYOUT: SelectListLayoutOptions = {
  minPrimaryColumnWidth: 12,
  maxPrimaryColumnWidth: 32,
};

// ---------------------------------------------------------------------------
// Descriptions — same map used in both thinking-selector.ts and settings-selector.ts
// ---------------------------------------------------------------------------
const LEVEL_DESCRIPTIONS: Record<string, string> = {
  off: "No reasoning",
  minimal: "Very brief reasoning (~1k tokens)",
  low: "Light reasoning (~2k tokens)",
  medium: "Moderate reasoning (~8k tokens)",
  high: "Deep reasoning (~16k tokens)",
  xhigh: "Maximum reasoning (~32k tokens)",
};

// ---------------------------------------------------------------------------
// Fallback when no model is loaded (mirrors agent-session's THINKING_LEVELS)
// ---------------------------------------------------------------------------
const DEFAULT_THINKING_LEVELS: ThinkingLevel[] = [
  "off", "minimal", "low", "medium", "high",
];

// ---------------------------------------------------------------------------
// All known level names (for argument validation)
// ---------------------------------------------------------------------------
const AVAILABLE_THINKING_LEVELS: ThinkingLevel[] = [
  "off", "minimal", "low", "medium", "high", "xhigh",
];

// ===========================================================================
// Extension
// ===========================================================================
export default function (pi: ExtensionAPI) {
  pi.registerCommand("thinking", {
    description: "Set thinking level or open selector",
    handler: async (args, ctx) => {
      if (!ctx.hasUI) {
        ctx.ui.notify("/thinking requires an interactive terminal", "warning");
        return;
      }

      // Query the model for its actual supported thinking levels (same as /settings does)
      const availableLevels: ThinkingLevel[] = ctx.model
        ? getSupportedThinkingLevels(ctx.model)
        : DEFAULT_THINKING_LEVELS;

      const currentLevel = pi.getThinkingLevel();

      // ---- Direct set via argument ----
      const arg = args?.trim().toLowerCase();
      if (arg) {
        if (AVAILABLE_THINKING_LEVELS.includes(arg as ThinkingLevel)) {
          if (availableLevels.includes(arg as ThinkingLevel)) {
            pi.setThinkingLevel(arg as ThinkingLevel);
            ctx.ui.notify(`Thinking level: ${arg}`, "info");
          } else {
            ctx.ui.notify(
              `"${arg}" is not available for the current model`,
              "warning",
            );
          }
          return;
        }

        ctx.ui.notify(
          `Unknown level "${arg}". Available: ${availableLevels.join(", ")}`,
          "warning",
        );
        return;
      }

      // ---- No args: open selector ----
      const options: SelectItem[] = availableLevels.map((level) => ({
        value: level,
        label: level,
        description: LEVEL_DESCRIPTIONS[level],
      }));

      const selected = await ctx.ui.custom<string | null>(
        (tui, theme, _kb, done) => {
          // -- Bordered layout with title, description, and hint --

          const container = new Container();

          // Top border bar
          container.addChild(new DynamicBorder());

          // Title
          container.addChild(
            new Text(theme.bold(theme.fg("accent", "Thinking Level")), 0, 0),
          );

          // Description
          container.addChild(new Spacer(1));
          container.addChild(
            new Text(
              theme.fg("muted", "Select reasoning depth for thinking-capable models"),
              0,
              0,
            ),
          );

          // Spacer
          container.addChild(new Spacer(1));

          // SelectList — same SelectListTheme and layout as built-in
          const selectList = new SelectList(
            options,
            Math.min(options.length, 10),
            getSelectListTheme(),
            SELECT_LIST_LAYOUT,
          );

          // Pre-select current level
          const currentIndex = options.findIndex(
            (o) => o.value === currentLevel,
          );
          if (currentIndex !== -1) {
            selectList.setSelectedIndex(currentIndex);
          }

          selectList.onSelect = (item) => done(item.value);
          selectList.onCancel = () => done(null);

          container.addChild(selectList);

          // Hint
          container.addChild(new Spacer(1));
          container.addChild(
            new Text(
              theme.fg("dim", "  ↑↓/j k navigate · Enter select · Esc back"),
              0,
              0,
            ),
          );

          // Bottom border bar
          container.addChild(new DynamicBorder());

          return {
            render: (w: number) => container.render(w),
            invalidate: () => container.invalidate(),
            handleInput: (data: string) => {
              // Translate vim-style j/k to arrow keys for the SelectList
              if (data === "j") {
                selectList.handleInput("\x1b[B"); // down
              } else if (data === "k") {
                selectList.handleInput("\x1b[A"); // up
              } else {
                selectList.handleInput(data);
              }
              tui.requestRender();
            },
          };
        },
      );

      if (selected === null || selected === undefined) return;

      // setThinkingLevel clamps to model capabilities internally
      pi.setThinkingLevel(selected);
      ctx.ui.notify(`Thinking level: ${selected}`, "info");
    },
  });
}
