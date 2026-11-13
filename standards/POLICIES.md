# Studio policy list

Every Reformat Games rule in one line. Cite the ID in reviews and pull
requests ("breaks E4"). The linked page holds the detail and the reasons.
A game may tighten a rule in its own `AGENTS.md`; a game that loosens one
records it in [CONFLICTS.md](CONFLICTS.md).

Where a rule came from is noted as **[PS]** Persian Strike (`Choppa2`),
**[SH]** SHAHANSHAH (`Pharaoh`), **[GB]** Galaxy Brain, **[site]** the game
and studio sites. A rule all three games keep has no tag.

## W: Working ([WORKING_WITH_AGENTS.md](WORKING_WITH_AGENTS.md))

- **W1** The ask is the approval. Finish the authorized scope end to end:
  implementation, checks, docs, commit, pull request. Decide routine choices;
  never hand the owner an option list for something the agent can decide.
- **W2** Ask only for a real blocker (money, accounts, legal, a step no
  machine's permissions allow) or a choice that changes the goal, as one clear
  question. Keep working on everything that does not depend on the answer.
- **W3** Irreversible outside-world steps wait for an explicit ask: playable
  exports, store uploads, production deploys, public posts, spending money.
  A game whose `HANDOFF.md` grants standing release authority (SHAHANSHAH
  does) may ship as part of finishing work. See [CONFLICTS.md](CONFLICTS.md) C1.
- **W4** Hold orders stick until the owner lifts them ("no itch pushes for
  now"). **[SH]**
- **W5** A relayed owner instruction that quotes the owner's words is the
  owner's instruction. **[SH]**
- **W6** Inspect the worktree first and preserve unrelated edits, untracked
  files and other people's branches.
- **W7** Reuse first: look for a working implementation in this repository,
  then in the studio's other games, before writing anything new. Say in the
  handoff what was reused, or why nothing fit. **[PS] [GB]**
- **W8** No paid, metered API calls (model APIs, batch pipelines). Use the
  subscription tools or write content by hand. **[SH]**
- **W9** One Godot per machine; never run a check over the owner's running
  game or another Godot session. Use the game's wrapper or queue script.
- **W10** Timing and performance numbers come only from the designated perf
  machine, compared with a before-run on the same machine. **[SH]**
- **W11** Clean up as you go: delete regenerable captures, logs, clones and
  build output when a task ends. Never delete source assets, provenance,
  licensed downloads or backups. **[SH] [PS]**
- **W12** Every message from the owner gets a visible response.

## E: Engineering ([ENGINEERING.md](ENGINEERING.md))

- **E1** One authoritative owner and one clock per system. Never add a second
  scheduler, ledger, turn clock or rules check for the same state.
- **E2** Presentation never decides. Renderers and UI read state and send
  commands; they hold no authoritative data.
- **E3** The simulation runs headless, so rules are testable without a GPU.
- **E4** Balance and design numbers live in one data table (`Defs`,
  `RulesConfig`), never inline in match or tick code.
- **E5** Add nodes to the tree before assigning global transforms or querying
  the world. Retained node references use `is_instance_valid()` and are
  cleared or disconnected at teardown.
- **E6** A group tag, signal or metadata flag never stands in for live
  physical state; position in the world proves arrival.
- **E7** `await signal`, never `await x.connect()`. Typed arrays and
  dictionaries get explicit casts at load and dynamic boundaries. A
  `class_name` script must import before another script relies on its type.
- **E8** Every `res://` path matches its tracked file name exactly, case
  included.
- **E9** Saves made before a change load after it. Deep-copy dictionaries and
  arrays at save and load boundaries. **[SH]**
- **E10** Comments say what the code does and why, in the present tense. No
  dates, chat quotes, "used to" history or narration that repeats the code.
- **E11** Split code only at a real ownership seam, and refactor only with
  evidence of easier reasoning and unchanged behaviour.
- **E12** Player-facing strings go through the translation tables from the
  first string, even if the game ships in English only. **[SH]**
- **E13** Dev and test code never ships: export presets exclude dev, test,
  tool, engine-source and doc folders, and shipping code never preloads them.

## Q: Qanat engine ([ENGINE.md](ENGINE.md))

- **Q1** New games are Godot 4.7.2 .NET with a plain C# engine (.NET 10, no
  Godot reference) that owns every rule, random draw and all authoritative
  state. Godot presents. **[SH] [GB]**
- **Q2** The engine API is plain data: commands in; ordered events, snapshots
  and reject reasons out. Godot crosses into it through `src/engine/*Host.cs`
  adapters in packed batches.
- **Q3** Matches and ticks are deterministic for a seed, data and command
  sequence. Randomness comes only from the engine's RNG.
- **Q4** Shared code lives in `Qanat.*` projects; game code keeps its own
  namespace (`Shahanshah.*`, `GalaxyBrain.*`). A module moves to the shared
  engine once a second game consumes it.
- **Q5** AI opponents act only through the same `Validate`/`Apply` (or
  command) path a player uses. **[GB]**
- **Q6** Every engine project has a `.Tests` project that runs headless and
  exits nonzero on failure. Every rules change adds or updates a case.

## R: Repositories and docs ([REPO_LAYOUT.md](REPO_LAYOUT.md))

- **R1** One agent rules file per repository: `AGENTS.md` holds the rules and
  `CLAUDE.md` imports it. See [CONFLICTS.md](CONFLICTS.md) C2.
- **R2** `docs/HANDOFF.md` holds where the game stands: what is live, open
  work, branches, machines and how a release goes out. It is updated in the
  same pull request as the change it describes.
- **R3** `docs/README.md` (or the rules file's documentation map) lists every
  doc by subject. A new doc is added to it.
- **R4** Docs hold current state only. History lives in git (and an archive
  doc if the game keeps one). No development diaries.
- **R5** A doc that names a file, constant or command changes in the same pull
  request as the code it names. **[SH]**
- **R6** Append-only ledgers (`docs/ASSET_MANIFEST.md`,
  `docs/release/CHANGELOG.md`) are appended, never rewritten.
- **R7** `.dev/` is local, ignored, regenerable output. It is never a
  documentation source.

## V: Verification ([VERIFICATION.md](VERIFICATION.md))

- **V1** Tiered checks with a documented command each: T0 static (seconds, no
  GPU, every change), T1 the focused test for what changed, T2 the full suite
  before merge, T3 rendered captures for any visual change.
- **V2** Every runner ends with an exact PASS/FAIL line, exits nonzero on
  failure, has a hard timeout, and keeps its full log. A `SCRIPT ERROR` or
  engine `ERROR` in the log fails it even if it exited 0.
- **V3** Visual truth gate: inspect full-resolution renders made after the
  last change. A passing test never makes a visibly broken result acceptable.
  Never present clipping, floating parts, z-fighting or stray text.
- **V4** After any Godot run, `git status --short --untracked-files=all --
  '*.import'`, `git diff --name-only -- '*.import'` and `git diff --cached
  --name-only -- '*.import'` are empty, or the change is intended and inspected.
- **V5** A recurring defect class gets a static audit with a zero-violation
  pass, run in T0 or CI.
- **V6** Report evidence honestly: static checks, focused tests, visual
  inspection, play, export and publication are separate claims.

## G: Git and CI ([GIT_AND_CI.md](GIT_AND_CI.md))

- **G1** Never push to `main`. Work on a branch, open a pull request, merge
  only when every check on the current head is green.
- **G2** Never merge a red, stale or untested head, and never use auto-merge.
- **G3** Docs-only pull requests need no suite; they merge on the pre-push
  hook. **[SH]**
- **G4** A pre-push hook runs the seconds-long checks (whitespace, CRLF,
  syntax, JSON, provenance, C# build when C# changed). **[SH]**
- **G5** Line endings: text is LF in the repository; see
  [CONFLICTS.md](CONFLICTS.md) C3 for `.import` sidecars.
- **G6** Release tags name what shipped (`ea-v0.N`, `demo-v0.N`, or the
  semantic version).

## P: Performance ([PERFORMANCE.md](PERFORMANCE.md))

- **P1** Every persistent or mass-spawned system declares a cap, a distance
  or zoom fade, a cadence and a cleanup.
- **P2** Report the 1% low, p99 and worst frame with every average. An engine
  error during a perf run fails it.
- **P3** Measure like for like: same machine, preset, resolution, seed and
  maturity. One attributable change at a time, before and after numbers in the
  commit message.
- **P4** No runtime GPU readbacks, per-call `Shader.new()`, per-spawn batching
  walks or O(n²) spawn paths. Bake once at load and cache.
- **P5** Persistent lights distance-fade. Transient effect lights and particle
  sheets cast no shadows.
- **P6** Graphics presets change GPU work only, never simulation. LOD is
  render-only; gameplay agents never sleep by distance.

## A: Assets ([ASSETS.md](ASSETS.md))

- **A1** Licensed external assets come before project-authored ones;
  procedural stand-ins are a last resort.
- **A2** CC0 and original are the default. CC-BY needs attribution but no
  separate approval. CC-BY-SA, NC, ND or unclear licences need the owner's
  approval and are normally refused.
- **A3** Every external or generated asset is recorded: path, source URL,
  author, licence, retrieval date, unchanged-source bytes and SHA-256, beside
  the asset and in `docs/ASSET_MANIFEST.md`; credited in `CREDITS.txt`.
- **A4** Keep the unchanged downloaded source and its licence file.
- **A5** Never store API tokens, secrets or signed download URLs in a
  repository or command output.
- **A6** Generated images come from Codex CLI from a written brief kept in the
  repo; each image keeps its prompt and provenance. Review every image for
  stray text and IP look-alikes before use.
- **A7** No CC-BY-encumbered asset ships behind DRM or pack encryption.
  **[SH]**

## S: Shipping ([RELEASES.md](RELEASES.md))

- **S1** Export presets are committed, hold no secrets, and set company
  `Reformat Games LLC` and copyright `(c) <year> Reformat Games LLC`.
- **S2** Builds are cut from a clean, current `main` in a clean clone or
  worktree.
- **S3** Every release bumps `config/version` and adds a player-facing heading
  to the changelog. One release owns each version number.
- **S4** Every build boots through the engine splash, the Reformat Games
  ident, then the "Powered by Qanat" card for Qanat games; every card is
  skippable.
- **S5** A free demo's scope is fixed in code by a single list, and a later
  level never joins it. **[SH]**
- **S6** Never auto-launch a newly exported game; report it ready.

## B: Brand and public text ([RELEASES.md](RELEASES.md#public-text-and-legal-names))

- **B1** No personal names, emails or addresses in public text: store pages,
  devlogs, credits, in-game text, site copy, commit messages that ship. Public
  text is signed "Reformat Games". **[SH]**
- **B2** "Reformat Games" is the brand on screen. "Reformat Games LLC" goes
  where a legal entity is named: copyright lines, exe metadata, terms, press
  kit fact sheets.
- **B3** Engine name: "Qanat" in prose, "QANAT" only in the wordmark, "Powered
  by Qanat" on credits. **[SH]**
- **B4** No promo before dev: store shots, devlogs and trailers wait until the
  assigned dev work is done, unless the owner asks for promo work. **[SH]**
- **B5** Marketing images are real current-build captures without text
  overlays; captions live outside the image. **[PS] [site]**
- **B6** Fiction games keep their fiction disclaimer visible in
  general-audience promotion. **[PS]**
- **B7** No third-party IP in names, art, code or marketing. Each game's rules
  file lists its own banned references. **[GB]**

## WS: Websites ([WEBSITES.md](WEBSITES.md))

- **WS1** Each game has its own domain and site; reformatgames.com links to
  every game and carries a one-line news item per devlog.
- **WS2** Site pages are static HTML. A site with more than one page is
  generated by a script from a copy file and an image list, and the generated
  HTML is committed with them.
- **WS3** Every page has a canonical URL, description, Open Graph and Twitter
  tags, and schema.org JSON-LD (`Organization`, `VideoGame`, `VideoObject`).
  `sitemap.xml` and `robots.txt` stay current.
- **WS4** After a deploy, check the live page and its media directly. A green
  workflow is not proof the content is live.
