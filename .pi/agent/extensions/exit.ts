import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

/**
 * Add /exit command as an alias for /quit
 */
export default function (pi: ExtensionAPI) {
  pi.registerCommand("exit", {
    description: "Exit pi (alias for quit)",
    handler: async (_args, ctx) => {
      ctx.shutdown();
    },
  });
}
