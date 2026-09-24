---
name: obsidian-cli
description: >
  Manage an Obsidian vault through its CLI: read, write, search, organize,
  and query notes.
user-invocable: true
disable-model-invocation: true
---

# Obsidian CLI

## Setup

Resolve the vault name from host-provided persistent memory/configuration. Do
not assume a host-specific path or format. If none exists, ask for the vault
name and save it using the host's persistence mechanism; if unavailable, use
it for the session and say it will not persist. Store named mappings for
multiple vaults and ask which one to use when ambiguous.

Before any other command:

1. Run `obsidian --help`. If unavailable, tell the user to enable **Command
   line interface** in Obsidian → Options → General and restart Obsidian.
2. Use the installed CLI's documented vault/status command to confirm Obsidian
   is running and the vault is accessible. If it fails, ask the user to open
   Obsidian and load the vault.

Do not bypass the CLI or read vault files directly. Stop and report prerequisite
failures instead of using a silent fallback.

## Invocation and safety

Run one narrowly scoped command per operation:

```bash
obsidian <action> [key=value ...] [flags] vault="<name>"
```

- Use exact `path=` for targets; use `file=` only for intentional,
  unambiguous wikilink-style resolution. Quote values with spaces.
- Pass arguments through a safe argument mechanism. Never interpolate
  untrusted note content, paths, queries, or vault names into shell commands.
  Avoid putting sensitive content in history/process arguments when a safer
  input mechanism exists.
- Preserve stderr. Use the installed CLI's help/discovery commands for unknown
  actions or flags; syntax can vary by version.
- Treat delete, permanent delete, overwrite, move, rename, and bulk
  property/tag changes as mutations. Resolve the exact target, show the
  operation, and confirm before destructive, overwriting, bulk, or ambiguous
  changes.
- After every mutation, reread the note or check metadata/listings and report
  the result, skipped items, and errors. Avoid printing whole sensitive notes
  unless requested.

## Common conventions

- `active` targets the focused note, when supported by that action.
- `format=json|tsv|csv` selects machine-readable output where supported;
  `outline` also supports `md|tree|json`, and `properties` defaults to YAML.
- `total` returns a count; `verbose` adds details. Prefer `format=json` when
  parsing output programmatically.
- Use `\n` for newlines in `content=` values.

## Actions

| Actions | Parameters / purpose |
|---|---|
| `read` | `path=` — read a note |
| `create` | `path=`, `content=`; `overwrite`, `template=` optional |
| `append`, `prepend` | `path=`, `content=`; `inline` optional |
| `delete` | `path=`; trash by default, `permanent` optional |
| `move` | `path=`, `to=` |
| `rename` | `path=`, `name=` |
| `open` | `path=`; `newtab` optional |
| `search` | `query=`; `case`, `limit=`, `format=` optional |
| `search:context` | `query=` — matches with surrounding context |
| `files`, `folders` | `folder=`; `ext=` and `total` optional |
| `file`, `vault`, `recents` | Metadata, vault stats (`info=name\|path\|files\|folders\|size`), or recent notes |
| `outline` | `path=`, `format=md\|tree\|json` |
| `links`, `backlinks` | `path=`; `counts` optional for backlinks |
| `wordcount` | `path=` — word/character count |
| `aliases` | `path=` or vault-wide; `verbose` optional |
| `unresolved`, `orphans`, `deadends` | Vault hygiene: broken links, unlinked notes, or notes without outgoing links |
| `properties` | `path=` for frontmatter; omit for vault-wide property names |
| `property:read` | `path=`, `name=` |
| `property:set` | `path=`, `name=`, `value=`; `type=text\|list\|number\|checkbox\|date\|datetime` optional |
| `property:remove` | `path=`, `name=` |
| `tags` | `path=` or vault-wide; `counts`, `sort=count` optional |
| `tag` | `name=`; `verbose` lists files |
| `daily`, `daily:read`, `daily:path` | Open, read, or locate today's daily note |
| `daily:append`, `daily:prepend` | `content=` for today's daily note |
| `tasks` | `path=` optional; filter with `done`, `todo`, or `status=`; `verbose` adds lines |
| `task` | `ref=<path:line>`; `toggle`, `done`, `todo`, or `status=` |
| `templates` | List templates |
| `template:read` | `name=`; `resolve` optional |
| `template:insert` | `name=` into the active note |
| `bookmarks` | List bookmarks |
| `bookmark` | One of `file=`, `folder=`, `url=`, `search=`; `title=` optional |
| `commands` | `filter=` optional; discover command IDs |
| `command` | `id=` — run a discovered Obsidian command |

## Links and note shape

Use wikilinks for internal references:
`[[Note]]`, `[[Note|label]]`, `[[Note#Heading]]`, `[[Note^block]]`; use
`![[Note]]` or `![[Note#Heading]]` for embeds. After link changes, run
`unresolved` and fix or report broken targets.

Before creating or appending, consider splitting notes over ~300 lines, with
multiple independently useful topics, audiences, or update cadences. Search
first for existing targets. Propose the parent/sub-note structure and confirm
before creating files. Preserve frontmatter, aliases, tags, tasks, links,
embeds, block references, and heading anchors when splitting.
