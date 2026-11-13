# Qanat, the studio engine

**Qanat** is Reformat Games' C# game engine. A qanat is the Persian
underground water channel: unseen, and everything grows because of it. The
engine is the same idea: Godot draws the world; Qanat decides and moves it.
Policy IDs: Q1–Q6 in [POLICIES.md](POLICIES.md); brand rules in
[RELEASES.md](RELEASES.md#branding-in-builds).

## The split

**The engine decides; Godot presents.**

| C# engine owns | Godot owns |
| --- | --- |
| Every rule that decides or moves: ticks, economy, units, AI, navigation, combat, match state, saves' authoritative data | Scene construction, rendering, animation, particles, audio, input, UI |
| Every random draw (one seeded RNG) | Cosmetic randomness that never feeds back into rules |
| Validation: a rejected command changes nothing and returns a reason | Highlighting legal moves by asking the engine to validate |

```
GDScript / UI ──command──▶ src/engine/<X>Host.cs (Godot node) ──▶ engine (plain C#)
      ▲                                                              │
      └──── events (ordered, one signal each) + snapshot(viewer) ◀───┘
```

- **Commands** are plain records. `Validate` checks one without applying it;
  `Apply` (or `Submit`) applies it and produces events.
- **Events** are an ordered list of plain facts from each accepted command.
  The host drains them after every command and emits one Godot signal per
  event. Presentation animates from events and never infers state from them.
- **Snapshots** are full state as one viewer may see it (hidden information
  stays hidden), rebuilt on request, holding no engine objects.
- **The host** (`src/engine/*Host.cs`) is the only Godot boundary. It loads
  data, converts records to dictionaries or packed arrays in one place, paces
  AI steps for presentation, and contains no rules.
- **AI** reads only its own snapshot and public data and acts only through
  `Validate`/`Apply`, like a player (Q5).
- **Determinism** (Q3): the same seed, data and command sequence give the same
  result. This is what replays, golden tests, parity checks and netplay rely
  on. `Qanat.Core`'s `GodotRandom` reproduces Godot's PCG32 bit for bit and
  `Vec2` reproduces Godot's float32 rounding, so a GDScript reference and its
  C# port can be compared draw for draw.

## Where the code lives today

| Code | Location | Consumers |
| --- | --- | --- |
| `Qanat.Core` (clock, entity handles, stores, ordered events, `GodotRandom`, `Vec2`, packed snapshots) | `engine/` in the SHAHANSHAH repository | SHAHANSHAH |
| `Qanat.Navigation` (grid and road graphs, `GridAStar`, flow fields, faction nav grids) | same | SHAHANSHAH |
| `Qanat.Combat` (units, targeting, melee and missiles, formations, RTS orders, unit AI) | same | SHAHANSHAH |
| `Qanat.Destruction` (building collapse, debris, rubble fires, debris budget) | same | SHAHANSHAH |
| `Qanat.Naval` (ships, ramming, boarding, missiles) | same | SHAHANSHAH |
| `GalaxyBrain.Engine` (card-duel rules on the Qanat split, its own code) | `engine/` in the Galaxy Brain repository | Galaxy Brain and its match server |
| The `rhicksrad/Qanat` repository | A README only | — |

Each `Qanat.*` project has a sibling `Qanat.*.Tests` console project (no test
framework: every check prints `PASS`/`FAIL`, any failure exits 1). The
`engine/` folder carries a `.gdignore` so Godot does not import it; the game
csproj references the projects it needs.

The shared modules have not yet moved to the Qanat repository: the rule is
that a module moves to a shared home once a second game consumes it (Q4).
When the next game needs one, see [CONFLICTS.md](CONFLICTS.md) D2 for the
decision on how it is shared.

## Project conventions

- Engine projects: `Microsoft.NET.Sdk`, `net10.0`, `ImplicitUsings` and
  `Nullable` enabled, `TreatWarningsAsErrors` true. No Godot package.
- Test projects: `OutputType` `Exe`, same settings, run with
  `dotnet run --project engine/<Name>.Tests -c Release`.
- Namespaces: shared code `Qanat.<Module>`; game code `<Game>.<Area>`
  (`Shahanshah.Sim`, `GalaxyBrain.Engine`). Never name game code `Qanat.*`.
- Data: card, level and balance data are JSON or embedded data the engine
  loads and validates. The loader refuses anything it cannot run; extend the
  vocabulary (handler, schema doc and a test case together) rather than
  special-casing one item. **[GB]**
- Undecided design numbers live in a config record (`RulesConfig`,
  `Defs`), never inline (E4).
- Hot code uses shared stores and family-level batched work, never one
  callback per actor. Changing language is not a speed-up by itself; the perf
  tour proves each step. **[SH]**

## Porting a GDScript system into Qanat

The method SHAHANSHAH used, and the one to reuse:

1. Write down the rule owner and the API the rest of the game uses (keep that
   facade unchanged).
2. Port rule for rule into a C# module, with the GDScript original kept as a
   reference that never runs in the same launch.
3. Record the reference on a fixed seed (state digests over a fixed span) as a
   golden file, and replay it against the port in a test.
4. Gate the step on: CI green, engine tests passing, the golden replay
   matching (or each difference listed and accepted as different-but-working;
   broken behaviour never is), the perf tour no worse in any segment, and old
   saves still loading.
5. Delete the GDScript original.

## Starting a game on Qanat

[NEW_GAME.md](NEW_GAME.md) has the checklist; the template csproj, engine
project and test project are in
[templates/new-game/](../templates/new-game/). In short: Godot 4.7.2 .NET,
a `<Game>.Engine` project plus its `.Tests`, a `src/engine/<Game>Host.cs`,
`Directory.Build.props` with `Optimize` on, and the boot sequence ending on
the "Powered by Qanat" card.
