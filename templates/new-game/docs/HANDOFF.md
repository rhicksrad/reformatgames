# Handoff: where GAME_NAME stands

The starting point for any agent or person picking the game up: what is live,
what is open, and how a build, deploy or site update goes out. Update it in
the same pull request as any change that makes it stale. Current state only;
the rules every change follows are in [AGENTS.md](../AGENTS.md).

## Standing rules and hold orders

<The owner's rules for this game that are not in AGENTS.md, and any hold
order in force ("no store pushes for now"), each with its date.>

## What is live

| Piece | Version / source | Where it runs |
| --- | --- | --- |
| Game client | not released | itch.io `reformatgames/game-slug` |
| Website | not started | game-slug domain |

The next release is **0.1.0**.

## Open work

1. <item>

## Branches

| Branch | What it holds |
| --- | --- |
| `main` | The game |

## How a release goes out

1. Checks: `tools/ci/run_tests.sh` passes on the release commit.
2. Version: bump `config/version` in `project.godot`; add the
   `## 0.1.N: title` heading to `docs/release/CHANGELOG.md`.
3. Merge to `main`.
4. Export and upload, only as AGENTS.md's gate allows: <the machine, the
   export command, the butler channels, the smoke test>.
5. Tag `v0.1.N`.

## Machines

| Machine | Use |
| --- | --- |
| <name> | <what runs there: perf timing, exports and butler, art, CI runner> |
