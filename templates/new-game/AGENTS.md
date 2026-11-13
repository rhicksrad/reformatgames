# GAME_NAME: agent rules

This file is the complete bootstrap for every agent (`CLAUDE.md` imports it).
Read it once per task; open further docs only for the part of the task they
govern. Where it is silent, the Reformat Games studio standards apply:
<https://github.com/rhicksrad/reformatgames/tree/main/standards>. Cite their
policy IDs (W1, E4, V3...) in reviews.

**GAME_NAME** is a Reformat Games title on **Qanat**: a C# engine owns every
rule and all game state, presented by Godot 4.7.2 .NET. The design source of
truth is [docs/GDD.md](docs/GDD.md). Where the game stands, its machines and
how a release goes out: [docs/HANDOFF.md](docs/HANDOFF.md).

## Standing rules

- **The ask is the approval.** Finish the authorized scope end to end:
  implementation, checks, docs, commit, pull request, merge on green. Decide
  routine choices; ask only for a real blocker, as one question.
- **Hold orders stick** until the owner lifts them. Current ones are in
  `docs/HANDOFF.md`.
- **No paid API calls.** Use the subscription tools or write content by hand.
- **No personal names, emails or addresses** in public text or in this
  repository. Public text is signed "Reformat Games".
- **Reuse first.** Look for a working implementation here, then in the
  studio's other games, before writing anything new; a licensed external
  asset comes before a project-authored one. Say in the handoff what was
  reused, or why nothing fit.
- **One Godot per machine.** Never run a check over the owner's game.

## Hard rules

<!-- Replace with this game's own: banned franchises and terms, monetization
     limits, regions, tone. -->
- No third-party IP in names, art, code or marketing: <list the franchises
  and terms this game must never use>.
- Monetization: <what may be sold, and what never is>.

## Export, publish and deploy gate

<!-- Pick one and delete the other (studio standards, CONFLICTS.md C1). -->
- Never export a playable build, upload to a store, deploy a server or site,
  or touch `build/` unless the owner explicitly asks for that step.
  Finishing an implementation is not export authorization.
- *Or:* agents cut and push builds as part of finishing work, following
  `docs/HANDOFF.md`; a hold order stops them.

Never auto-launch a newly exported game; report it ready.

## Codewords

- **`tie it off`**: finish the active approved scope: resolve loose wiring;
  update docs, changelog, credits and provenance; delete obsolete regenerable
  scratch output; run the suite and import hygiene; commit, push the branch,
  and confirm the local and remote SHAs match. It never authorizes an export,
  publication or release.

## Engine authority

- `engine/GameNs.Engine` (plain C#, no Godot reference) owns every rule,
  every random draw and all game state. Godot presents: scripts submit
  commands to `GameNsHost` (`src/engine/`) and draw what its events and
  snapshots say. A GDScript file that decides legality, computes an outcome
  or edits state is a defect.
- Commands in; ordered events, snapshots and reject reasons out. Runs are
  deterministic for a seed, data and command sequence.
- Undecided design numbers live in `RulesConfig`, never inline.
- AI opponents act only through `Validate`/`Apply`.
- Every rules change adds or updates a case in `engine/GameNs.Engine.Tests`.

## Engineering invariants

- One authoritative owner and one clock per system.
- Add nodes to the tree before assigning global transforms; validate retained
  node references with `is_instance_valid()` and clear them at teardown.
- `await signal`, never `await x.connect()`. Typed arrays and dictionaries
  get explicit casts at dynamic boundaries.
- Every `res://` path matches its file name exactly, case included.
- Saves made before a change load after it.
- Player-facing strings go through the translations.
- Every persistent or mass-spawned system declares a cap, a fade, a cadence
  and a cleanup ([docs/PERFORMANCE.md](docs/PERFORMANCE.md)).
- Comments state the current rule in the present tense: no dates, chat
  quotes or history.

## Verification

```bash
dotnet run --project engine/GameNs.Engine.Tests -c Release   # T1 engine rules
dotnet build GameNs.csproj                                    # Godot assembly
godot --headless --path . --import                            # after a fresh clone or merge
godot --headless --path . --script res://src/dev/boot_smoke.gd   # T1 boot smoke
tools/ci/run_tests.sh                                         # T2 whole suite, as CI runs it
```

- Every runner ends with a PASS/FAIL line and a nonzero exit on failure; an
  `ERROR` or `SCRIPT ERROR` in its log fails it (`tools/ci/log_errors.sh`).
- **Visual truth:** for every visual change, inspect full-resolution renders
  made after the last change. A passing test never makes a visibly broken
  screen acceptable.
- **Import hygiene:** after any Godot run, these three are empty:

  ```bash
  git status --short --untracked-files=all -- '*.import'
  git diff --name-only -- '*.import'
  git diff --cached --name-only -- '*.import'
  ```

## Git

- Never push to `main`. Branch, pull request, merge only when every check on
  the current head is green; never auto-merge. Docs-only pull requests merge
  on the pre-push hook.
- Turn the hook on once per clone: `git config core.hooksPath tools/hooks`.
- Inspect the worktree first and preserve unrelated changes.

## Documentation map

Current user instructions first, then this file, then the subject doc. Code
and data are the final evidence; when a doc disagrees, fix the doc. Docs hold
current state only; ledgers are append-only.

| Task area | Authoritative source |
| --- | --- |
| Where things stand, machines, releases, deploys | [docs/HANDOFF.md](docs/HANDOFF.md) |
| Design, rules, economy, tone | [docs/GDD.md](docs/GDD.md) |
| Engine architecture, commands, events, interpretations | [docs/ENGINE.md](docs/ENGINE.md) |
| Performance gates and the perf tour | [docs/PERFORMANCE.md](docs/PERFORMANCE.md) |
| Image generation and briefs | [docs/IMAGE_GEN.md](docs/IMAGE_GEN.md) |
| Asset provenance and licences | [docs/ASSET_MANIFEST.md](docs/ASSET_MANIFEST.md), [CREDITS.txt](CREDITS.txt) |
| Player-facing changes | [docs/release/CHANGELOG.md](docs/release/CHANGELOG.md) |

## Handoff checklist

Re-read the request and every changed file. Run the checks the change calls
for, and import hygiene if Godot ran. Update the docs it makes stale,
`HANDOFF.md` if the state moved, and the changelog if players will notice.
Report evidence by kind. Confirm every export, upload or deploy had its
required authorization.
