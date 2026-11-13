# Reformat Games studio standards

How Reformat Games makes games: the rules every repository keeps, the engine
they share, and the steps that start a new game. These pages were distilled
from the studio's working repositories (Persian Strike, SHAHANSHAH, Galaxy
Brain, the Qanat engine and the game sites) so that a new game starts from
what already works instead of reinventing it.

## How to use these pages

- **Starting a new game:** follow [NEW_GAME.md](NEW_GAME.md). It copies
  [templates/new-game/](../templates/new-game/) and lists every decision to
  make on day one.
- **Working in an existing game:** that game's own `AGENTS.md`/`CLAUDE.md`
  and docs win for that game. These pages are the default a game's rules
  start from and the place a rule moves when a second game needs it.
- **Changing a studio rule:** edit the page here in a pull request, and in the
  same pull request (or a linked one per game) bring any game that should
  follow it into line. Record a game that deliberately differs in
  [CONFLICTS.md](CONFLICTS.md).

## Precedence

1. The owner's current instruction in the conversation or thread.
2. The game's own rules file (`AGENTS.md`, with `CLAUDE.md` pointing to it)
   and its `docs/HANDOFF.md`.
3. These studio standards.
4. The game's subject docs. Code and data are the final evidence of behaviour:
   when a doc disagrees with them, fix the doc.

## The pages

| Page | What it holds |
| --- | --- |
| [POLICIES.md](POLICIES.md) | **The policy list.** Every studio rule in one line, with an ID to cite in reviews |
| [WORKING_WITH_AGENTS.md](WORKING_WITH_AGENTS.md) | How agents and the owner work together: approvals, codewords, models, threads, handoffs |
| [ENGINEERING.md](ENGINEERING.md) | Code conventions for Godot, GDScript and C#: ownership, lifecycle, comments, saves |
| [ENGINE.md](ENGINE.md) | Qanat, the studio engine: the split, the modules, the host pattern, determinism, how a game adopts it |
| [REPO_LAYOUT.md](REPO_LAYOUT.md) | The standard repository layout and the standard doc set |
| [VERIFICATION.md](VERIFICATION.md) | Tiered checks, runner contracts, Godot import hygiene, visual truth |
| [GIT_AND_CI.md](GIT_AND_CI.md) | Branches, pull requests, merging, hooks, CI and line endings |
| [PERFORMANCE.md](PERFORMANCE.md) | The performance contract every system keeps and how it is measured |
| [ASSETS.md](ASSETS.md) | Licences, provenance, Sketchfab and other sources, Codex image generation, audio, fonts |
| [RELEASES.md](RELEASES.md) | Versions, export presets, itch and butler, demos, branding in builds, changelogs, legal naming |
| [WEBSITES.md](WEBSITES.md) | Game sites and the studio site: hosting, generators, copy, media, deploys |
| [CONFLICTS.md](CONFLICTS.md) | Where the repositories disagree, what the standard picked, and the decisions left for the owner |
| [NEW_GAME.md](NEW_GAME.md) | The new-game bootstrap checklist |

## Keeping these pages honest

- Current state only. No diaries, dated logs or superseded plans; git keeps
  the history.
- This repository is **public** (it serves reformatgames.com). Nothing here
  names a person, an email, a home path, a machine, a token location or an
  account id. Those belong in each game's private `docs/HANDOFF.md`.
- `standards/`, `templates/` and `tools/` are kept out of the published site
  by `_config.yml`; they are read on GitHub, not on reformatgames.com.
