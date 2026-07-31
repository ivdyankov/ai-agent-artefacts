---
name: obsidian-cli
description: >
  Manage Obsidian vault via CLI. Use when the user asks to read, write, search,
  organize, or query notes in their Obsidian vault.
---

# Obsidian CLI Skill

## Vault name

On first activation, check for a memory file matching `~/.claude/projects/*/memory/obsidian-vault-config.md`. If it does not exist, ask the user for their Obsidian vault name, then save it as a memory:

```markdown
---
name: obsidian-vault-config
description: User's Obsidian vault name for CLI commands
metadata:
  type: user
---

Vault name: <name>
```

Then add a pointer line to `MEMORY.md`: `- [Obsidian vault](obsidian-vault-config.md) — vault name for CLI commands`.

## Prerequisites

Before running any other CLI commands, verify both prerequisites are met:

1. **Obsidian CLI is enabled**: Run `obsidian --help 2>/dev/null`. If this fails or the command is not found, tell the user: "The Obsidian CLI is not available. Please enable it in Obsidian → Options → General → toggle 'Command line interface' on, then restart Obsidian."

2. **Obsidian is running**: Run `obsidian vault vault="<name>" 2>/dev/null` with the vault name from above. If the output contains "Vault not found" or the command fails to connect, tell the user: "Obsidian does not appear to be running or the vault is not open. Please open the Obsidian app and make sure your vault is loaded, then try again."

**Do not bypass the CLI or fall back to reading vault files directly from disk.** If either prerequisite is not met, stop and guide the user through the steps above. Only proceed with CLI commands once both checks pass.

## CLI usage

All operations go through a single Bash call:

```bash
obsidian <action> [key=value ...] [flags] vault="<name>"
```

- `path=<path>` for exact file paths; `file=<name>` for wikilink-style resolution.
- Quote values with spaces: `path="My Folder/note.md"`.
- Use `\n` for newlines in content values.
- Don't suppress stderr by default — real errors (vault offline, bad args) come through there. Only add `2>/dev/null` when you're probing for existence and handling the failure deliberately (as in the prerequisite checks above).

## Conventions

Most commands share a small set of flags worth knowing before reading the action tables:

- **`active`** — operate on the currently-focused note in Obsidian instead of passing `path=`/`file=`. Use this when the user says "this note" or "the open note" without specifying. Supported on `aliases`, `tags`, `properties`, `tasks`, and others.
- **`format=json|tsv|csv`** (varies per command) — listing/query commands default to TSV or plain text; pass `format=json` when parsing output programmatically. `outline` also supports `format=md|tree|json`; `properties` defaults to `yaml`.
- **`total`** — return just a count instead of a list. Cheap way to ask "how many" without pulling all the rows.
- **`verbose`** — usually adds extra columns (paths, types, counts) to listings.
- **`file=<name>` vs `path=<path>`** — `file=` resolves like a wikilink (just the note name, ambiguous if duplicated); `path=` is exact (`folder/note.md`). When in doubt, prefer `path=`.

## Actions

### Read & write

| Action | Key parameters | Notes |
|---|---|---|
| `read` | `path=` | Read note contents |
| `create` | `path=` `content=` | Add `overwrite` to replace existing; `template=<name>` to base on a template |
| `append` | `path=` `content=` | Add `inline` to skip the leading newline |
| `prepend` | `path=` `content=` | Add `inline` to skip the trailing newline |
| `delete` | `path=` | Moves to trash; add `permanent` to skip trash |
| `move` | `path=` `to=` | Move or rename to a new path |
| `rename` | `path=` `name=` | Rename in place |
| `open` | `path=` | Open the note in Obsidian (`newtab` for new tab) |

### Search & list

| Action | Key parameters | Notes |
|---|---|---|
| `search` | `query=` | Add `case` for case-sensitive, `limit=<n>` to cap results, `format=json` to parse |
| `search:context` | `query=` | Search with surrounding line context |
| `files` | `folder=` | Optional `ext=` filter; `total` for count only |
| `folders` | `folder=` | List folders under a parent |
| `file` | `path=` | File metadata |
| `vault` | | Vault stats; `info=name\|path\|files\|folders\|size` for one field |
| `recents` | | Recently opened files |

### Structure & navigation

| Action | Key parameters | Notes |
|---|---|---|
| `outline` | `path=` | Headings of a note; `format=md\|json\|tree` |
| `links` | `path=` | Outgoing links from a note |
| `backlinks` | `path=` | What links to this note; `counts` adds link counts |
| `wordcount` | `path=` | Word/character count |
| `aliases` | `path=` (or vault-wide) | List aliases; `verbose` adds file paths |

### Vault hygiene

| Action | Key parameters | Notes |
|---|---|---|
| `unresolved` | | Broken links across the entire vault; `verbose` includes source files. Use this instead of checking links one at a time. |
| `orphans` | | Notes with no incoming links |
| `deadends` | | Notes with no outgoing links |

### Properties (frontmatter)

| Action | Key parameters | Notes |
|---|---|---|
| `properties` | `path=` | All frontmatter for a file (default `format=yaml`); omit `path=` for vault-wide property names |
| `property:read` | `path=` `name=` | Read one property |
| `property:set` | `path=` `name=` `value=` | Add `type=text\|list\|number\|checkbox\|date\|datetime` when the type matters |
| `property:remove` | `path=` `name=` | Remove a property |

### Tags

| Action | Key parameters | Notes |
|---|---|---|
| `tags` | `path=` (or vault-wide) | Add `counts` for occurrence counts, `sort=count` to sort by frequency |
| `tag` | `name=` | Info about one tag; `verbose` lists files that use it |

### Daily notes

| Action | Key parameters | Notes |
|---|---|---|
| `daily` | | Open today's daily note |
| `daily:read` | | Read today's daily note |
| `daily:path` | | Get today's daily note path |
| `daily:append` | `content=` | Append to today's daily note |
| `daily:prepend` | `content=` | Prepend to today's daily note |

### Tasks

| Action | Key parameters | Notes |
|---|---|---|
| `tasks` | `path=` (optional) | List tasks; filter with `done` / `todo` / `status="<char>"`; `verbose` groups by file with line numbers |
| `task` | `ref=<path:line>` | Show or update one task: `toggle`, `done`, `todo`, or `status="<char>"` |

### Templates

| Action | Key parameters | Notes |
|---|---|---|
| `templates` | | List available templates |
| `template:read` | `name=` | Read template content; `resolve` expands variables |
| `template:insert` | `name=` | Insert template into the active note |

### Bookmarks

| Action | Key parameters | Notes |
|---|---|---|
| `bookmarks` | | List bookmarks; `verbose` includes types |
| `bookmark` | `file=` / `folder=` / `url=` / `search=` | Add a bookmark; optional `title=` |

### Obsidian commands (advanced)

| Action | Key parameters | Notes |
|---|---|---|
| `commands` | `filter=<prefix>` | Discover available Obsidian command IDs |
| `command` | `id=<command-id>` | Run any Obsidian command (anything in the command palette) |

## Linking notes

When writing note content, use Obsidian's wikilink syntax for internal references:

- `[[Note Name]]` — basic link to another note in the vault
- `[[Note Name|Display Text]]` — link with custom display text
- `[[Note Name#Header]]` — link to a specific header inside a note
- `[[Note Name^block-id]]` — link to a specific block (a line tagged with `^block-id`)
- `![[Note Name]]` — embed/preview another note's content inline (transclusion)
- `![[Note Name#Header]]` — embed a specific section
- `![[image.png]]` — embed an image

Use wikilinks instead of raw paths when one note references another. To find broken links across the vault in one pass, run `obsidian unresolved vault="<name>"` — much better than verifying each target individually. If a link you're about to write would be unresolved, either create the target first or warn the user.

## Splitting large notes

A monolithic note is often the wrong shape. Before creating or appending, evaluate whether the content should be split into several linked notes.

**Split when any of these are true:**

- The note would exceed ~300 lines or cover more than ~3 distinct topics that could stand alone.
- Some sections are independently useful and likely to be referenced from other notes.
- Different sections have different update cadences or audiences.
- The user is producing reusable knowledge (prompts, recipes, runbooks) rather than a single coherent document.

**How to split:**

1. Create an index/parent note that introduces the topic and links to each sub-note via `[[Sub-Note Name]]`.
2. Each sub-note should be self-contained but include a link back to the parent.
3. Before creating sub-notes, run `search` or `files` to check whether any of them already exist — if so, link to the existing note instead of duplicating.
4. Use `![[Sub-Note Name]]` in the parent only when an inline preview adds genuine value; otherwise prefer plain `[[…]]` links.

**Decide, then confirm:** propose the split structure (parent + sub-note titles) to the user before creating files. Do not silently fan a single requested note into many — the user might have wanted one note. Once the user agrees, create the parent and sub-notes in a single batch.
