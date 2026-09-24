# Claude Code Skills

Reusable, manually invoked skills for Claude Code. Both skills are configured
to stay available to the user without being invoked automatically.

## List

| Skill | Description | Trigger |
| ----- | ----------- | ------- |
| [`clean-code-architect`](clean-code-architect/) | Clean-code and anti-slop guidance for writing, reviewing, or refactoring code | Manual — `/clean-code-architect` |
| [`obsidian-cli`](obsidian-cli/) | Manage an Obsidian vault through its CLI | Manual — `/obsidian-cli` |

## Installation

Use the [skills](https://www.npmjs.com/package/skills) CLI through `npx`; no
global install is needed.

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

Restart Claude Code after installing or updating a skill.
