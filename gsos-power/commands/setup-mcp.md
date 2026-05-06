---
name: setup-mcp
description: Local MCP server setup helper for GSOS. Installs and configures the Notion local MCP server. Claude Code only - aborts if invoked from Cowork.
disable-model-invocation: false
---

You are running `/gsos-power:setup-mcp`. This command is intended for **Claude Code** users only.

## Environment guard

If running in Cowork (no terminal access, no shell tool available), abort with:

> This command requires Claude Code (CLI). It is not supported in Cowork.
>
> Why: setup-mcp installs a local MCP server binary on your machine and configures Claude Code to use it. Cowork's plugin sandbox does not allow shell command execution outside MCP-allowlisted tools.
>
> If you want the Notion local MCP experience, switch to Claude Code and re-install this plugin via `claude plugin install gsos-power@generative-startup-os`.

If running in Claude Code (terminal/shell tool available), continue.

## Workflow

1. **Detect platform**: macOS / Linux / Windows. Note Windows currently has limited support — see TODOS.md.

2. **Confirm with founder before install**:
   > I am about to:
   > 1. Install the Notion MCP server binary into `${CLAUDE_PLUGIN_DATA}/notion-mcp/`
   > 2. Configure `${CLAUDE_PLUGIN_ROOT}/.mcp.json` to point to it
   > 3. Run a 1-shot health check (`notion-mcp --version`)
   >
   > Continue? (yes/no)

3. **Install**: per platform, run the install command. Print clear progress messages. Use `${CLAUDE_PLUGIN_DATA}` for state that survives plugin updates.

4. **Verify**: run health check. If success, tell founder: "Notion MCP installed at `${CLAUDE_PLUGIN_DATA}/notion-mcp/`. Restart Claude Code or run `/reload-plugins` to activate."

5. **Rollback on failure**: if any step fails, remove anything written and tell the founder explicitly:
   > Setup failed at step {N}: {reason}
   > Rollback completed — your environment is unchanged.
   > Common fixes: {1-3 actionable suggestions}

## Failure handling

This command modifies the user's local filesystem. Apply CLAUDE.md "founder-triggered, not automated" principle: do not retry destructively without founder consent. Always offer rollback before proceeding to remediation steps.
