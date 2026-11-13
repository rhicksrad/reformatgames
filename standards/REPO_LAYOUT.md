# Repository layout and the standard doc set

One game, one private repository, laid out the same way so an agent or a
person who knows one game can find their way in another. Policy IDs: R1–R7
in [POLICIES.md](POLICIES.md). The files below exist as a starting copy in
[templates/new-game/](../templates/new-game/).

## Top level

| Path | What it holds |
| --- | --- |
| `AGENTS.md` | The rules file: what the game is, standing rules, hard rules, gates, invariants, verification commands and the documentation map |
| `CLAUDE.md` | `@AGENTS.md` and nothing else, so Claude Code loads the same rules |
| `README.md` | Public-facing summary: what the game is, controls, how to build and run, tests, project layout, doc links |
| `CREDITS.txt` | Player-facing credits for every licensed asset |
| `project.godot`, `export_presets.cfg` | Committed, no secrets ([RELEASES.md](RELEASES.md)) |
| `<Game>.csproj`, `<Game>.sln`, `Directory.Build.props` | The Godot assembly and the solution ([ENGINEERING.md](ENGINEERING.md)) |
| `.gitattributes`, `.gitignore`, `.editorconfig` | [GIT_AND_CI.md](GIT_AND_CI.md) |
| `engine/` | Plain C# projects and their `.Tests`, with a `.gdignore` |
| `src/engine/` | Godot hosts and adapters (C#) |
| `src/core/` | GDScript facades the UI and renderers read, game modes, save/load glue |
| `src/render/`, `src/ui/`, `src/input/`, `src/audio/`, `src/main/` | Presentation, by concern |
| `src/dev/` | Headless smokes and rendered capture runners (excluded from exports) |
| `scenes/` | Godot scenes |
| `data/` | Content: levels, cards, decks, balance, encyclopedia (JSON) |
| `assets/` | Shipped models, textures, audio, fonts, each folder with its `ATTRIBUTION.md` or `PROVENANCE.md` |
| `translations/` | Translation tables |
| `tests/` | Rule tests (`test_*.gd`), tours and reviews, golden files |
| `tools/` | CI (`tools/ci/`), hooks (`tools/hooks/`), release, art and site scripts |
| `docs/` | The doc set below |
| `.github/workflows/` | CI ([GIT_AND_CI.md](GIT_AND_CI.md)) |
| `.dev/` | Ignored local output: captures, logs, scratch. Never documentation |
| `build/` | Ignored export output. Touched only for an authorized export |

Older games differ in places (Persian Strike keeps runners in `scripts/` and
`src/dev/` and has no `engine/`; Galaxy Brain keeps UI art in `ui/`). New
games use this layout.

## The doc set

Every game has these. Names are fixed so links work across games.

| Doc | Holds | Kind |
| --- | --- | --- |
| `docs/README.md` | Every doc by subject, one line each (or the doc map in `AGENTS.md` for a small game) | Index |
| `docs/HANDOFF.md` | Where the game stands: what is live (versions, URLs), open work, parked branches, hold orders, how a release, server deploy and site deploy go out, the machines | Current state, private |
| `docs/GDD.md` | The design: pitch, core loop, modes, content plan, tone, legal guardrails | Design |
| `docs/ENGINE.md` | The engine split for this game, its commands, events, snapshots, rule interpretations | Design |
| `docs/PERFORMANCE.md` | This game's gates, perf tour, current baseline | Contract |
| `docs/ASSET_MANIFEST.md` | One row per shipped external or generated asset | Append-only ledger |
| `docs/IMAGE_GEN.md` and brief files | How art is generated, the briefs | Procedure |
| `docs/release/CHANGELOG.md` | Player-facing changes per version, newest first | Append-only ledger |
| `docs/release/` | Store copy, press kit, devlog drafts, player README | Public text drafts |
| `docs/LEGAL.md` (once selling) | Licence audit, privacy note, store disclosures, open legal questions | Audit |

Older games use other names for some of these (SHAHANSHAH: `ASSETS.md`,
`release/RELEASE_NOTES.md`, `CAMPAIGN.md`; Galaxy Brain: `game-design.md`;
Persian Strike: `TECH.md`, no `HANDOFF.md`). See
[CONFLICTS.md](CONFLICTS.md) C6. New games use the names above.

Kinds of page **[SH]**: a **design** doc says how a feature works and names
its code and tests; a **sources** brief is the cited research a design was
built from; an **audit** is a dated check, true as of its date; a **ledger**
is append-only.

## Writing the rules file

`AGENTS.md` is the complete bootstrap. Keep it short enough to read once per
task. It holds:

1. One paragraph: what the game is, engine, studio.
2. Standing rules (the owner's, quoted where the wording matters).
3. Hard rules for this game (IP bans, monetization limits, regions).
4. Gates: export/publish approval, the codewords, reuse-first, visual truth.
5. Engine authority and engineering invariants specific to this game.
6. Verification commands.
7. The documentation map: task area to authoritative doc.
8. The handoff checklist.

It points to these studio standards for anything it does not change. Every
rule it states in the present tense, with no history.
