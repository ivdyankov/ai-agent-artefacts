# Claude Code Skills
My reusable skills for Claude Code.

## List

| Skill | Description | Trigger |
| ----- | ----------- | ------- |
| `clean-code-architect` | Clean code review and architecture guidance | Auto on code generation/review |
| `obsidian-cli` | Manage Obsidian vault via CLI | Manual — `/obsidian-cli` |

## Installation

Uses the [skills](https://www.npmjs.com/package/skills) CLI. No global install needed — just run via `npx`.

From the root of this repo, install a skill:

```bash
npx skills add ./skills/<skill_folder_name>
```

For example:

```bash
npx skills add ./skills/clean-code-architect
```

Useful options:

```bash
npx skills add ./skills/clean-code-architect -g   # Install globally (user-level)
npx skills add ./skills/clean-code-architect -y    # Skip confirmation prompts
npx skills list                                    # View installed skills
npx skills remove <skill_name>                     # Uninstall a skill
```

💡 Remeber to restart Claude Code afterwards.
