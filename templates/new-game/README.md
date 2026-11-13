# GAME_NAME

<One paragraph: what the game is, in a player's words.>

A Reformat Games title, powered by Qanat: a C# engine owns every rule and all
game state, and Godot 4.7.2 .NET presents it.

## Running

You need the **.NET 10 SDK** and **Godot 4.7.2 .NET** (the mono build).

```bash
dotnet build GameNs.csproj
godot --headless --path . --import
godot --path .
```

## Controls

| Action | Input |
| --- | --- |
| <action> | <keys> |

## Tests

```bash
tools/ci/run_tests.sh                                        # the whole suite, as CI runs it
dotnet run --project engine/GameNs.Engine.Tests -c Release   # engine rules
godot --headless --path . --script res://src/dev/boot_smoke.gd
```

Every runner ends with a PASS or FAIL line and a nonzero exit on failure.
After any Godot run, `git status --short -- '*.import'` must be empty.

## Project layout

| Path | What it is |
| --- | --- |
| `engine/GameNs.Engine/` | The C# rules engine, no Godot reference |
| `engine/GameNs.Engine.Tests/` | Engine rule tests (console runner) |
| `src/engine/` | `GameNsHost`, the Godot node that pipes commands in and events out |
| `src/ui/`, `src/render/`, `scenes/` | Presentation only |
| `src/dev/` | Headless smokes and capture runners (not exported) |
| `data/` | Game data (JSON) |
| `assets/` | Shipped assets, each folder with its attribution or provenance |
| `tests/` | Godot rule tests and tours |
| `tools/` | CI, hooks, release and art scripts |
| `docs/` | Design, engine, handoff, performance, assets, changelog |

## Documentation

Agents and new contributors start with [AGENTS.md](AGENTS.md) and
[docs/HANDOFF.md](docs/HANDOFF.md).

## Credits

Created by Reformat Games. Third-party assets are CC0 or recorded with their
licences in [docs/ASSET_MANIFEST.md](docs/ASSET_MANIFEST.md) and
[CREDITS.txt](CREDITS.txt).
