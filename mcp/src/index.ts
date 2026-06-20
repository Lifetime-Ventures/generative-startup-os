// GSOS MCP server (Stage 1) — McpAgent over Streamable HTTP.
//
// Serves the 6 GSOS commands as MCP PROMPTS (composed with the canonical
// safeguard preamble by mcp/scripts/build-mcp.mjs) + a zero-arg onboarding
// conductor TOOL. No founder data or credentials pass through this server: it
// returns only public methodology text. All prompts/tools are ZERO-ARGUMENT
// (eng-review hard invariant P4) so no PII can transit the Worker.
//
// Transport: McpAgent.serve() = Streamable HTTP (current MCP standard).
// Spike proved McpAgent (Durable Objects) renders prompts as commands + tools
// in Claude.ai; eng-review kept it for Stage 1 (stateless createMcpHandler is a
// later optimization, not load-bearing for correctness at low founder volume).

import { McpAgent } from "agents/mcp";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { PROMPTS } from "../generated/manifest";

interface Env {
  // Set with: wrangler secret put / wrangler.toml [vars]. Optional — if unset,
  // start_onboarding tells the founder the template isn't published yet.
  NOTION_TEMPLATE_URL?: string;
}

export class GsosMCP extends McpAgent<Env> {
  server = new McpServer({ name: "generative-startup-os", version: "0.1.0" });

  async init() {
    // --- the 5 core commands + /help, as MCP prompts (zero-arg) -------------
    for (const p of PROMPTS) {
      this.server.registerPrompt(
        p.name,
        { description: p.description, argsSchema: {} },
        async () => ({
          messages: [
            { role: "user", content: { type: "text", text: p.body } },
          ],
        })
      );
    }

    // --- onboarding conductor (zero-arg tool) -------------------------------
    // Reliably-surfaced entry point. Guides the founder through the steps MCP
    // cannot perform for them (template duplicate + connector auth). Kept
    // ABSTRACT on purpose (eng-review TODO-2: do not hardcode vendor UI click
    // paths that go stale when Anthropic/Notion change their screens).
    this.server.registerTool(
      "start_onboarding",
      {
        description:
          "Start here. Walks a new founder through setting up Generative Startup OS: duplicate the Notion template and connect the required accounts. Zero arguments.",
        inputSchema: {},
      },
      async () => {
        const tmpl = this.env?.NOTION_TEMPLATE_URL?.trim();
        const templateLine = tmpl
          ? `1. Duplicate the GSOS Notion template into your own workspace: ${tmpl}`
          : `1. Duplicate the GSOS Notion template into your own workspace. (Template URL not yet configured on this server — ask your GSOS provider for the duplicate link.)`;
        const text = [
          "# Welcome to Generative Startup OS",
          "",
          "Walk the founder through these steps conversationally, ONE at a time,",
          "confirming each before moving on. Do not dump the whole list at once.",
          "You cannot perform these for them — guide, then verify by asking.",
          "",
          templateLine,
          "2. In Claude Settings → Connectors, connect **Notion** (so GSOS can read/write your workspace).",
          "3. Connect **Google Calendar** (for daily focus reminders and time-blocking).",
          "4. Connect your meeting-notes tool: **Circleback** (or Granola via Zapier).",
          "5. Verify: ask the founder to confirm each connector shows as connected.",
          "",
          "## How to run GSOS commands (IMPORTANT — tell the founder this explicitly)",
          "Your commands (okr-set, sync-all, today, weekly-roast, investor-update) are",
          "NOT run by typing their name in chat. They live in the **+ / attachments menu**",
          "next to the message box (under this connector's name). To start: open the + menu,",
          "pick **okr-set**. This trips up most people — the commands are easy to miss.",
          "",
          "First run: open the + menu and choose `okr-set` to draft your OKRs from recent meetings.",
          "",
          "Note: connector screens change over time. If a step looks different from",
          "the above, guide by intent ('find Connectors in Settings and add Notion'),",
          "not by exact button labels.",
        ].join("\n");
        return { content: [{ type: "text", text }] };
      }
    );

    // --- health ping (zero-arg tool) ----------------------------------------
    this.server.registerTool(
      "ping",
      { description: "Health check. Zero arguments.", inputSchema: {} },
      async () => ({ content: [{ type: "text", text: "gsos-mcp ok" }] })
    );
  }
}

export default {
  fetch(request: Request, env: Env, ctx: ExecutionContext) {
    const url = new URL(request.url);
    if (url.pathname === "/mcp") {
      // @ts-expect-error agents SDK wires env/ctx at runtime
      return GsosMCP.serve("/mcp").fetch(request, env, ctx);
    }
    if (url.pathname === "/" || url.pathname === "/health") {
      return new Response("generative-startup-os MCP ok. Endpoint: /mcp", { status: 200 });
    }
    return new Response("Not found", { status: 404 });
  },
};
