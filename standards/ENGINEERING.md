# Engineering conventions

The code rules every Reformat Games project keeps. Policy IDs: E1–E13 in
[POLICIES.md](POLICIES.md). The engine split itself (what C# owns and what
Godot owns) is in [ENGINE.md](ENGINE.md).

## Stack

| Piece | Standard | Notes |
| --- | --- | --- |
| Engine | Godot **4.7.2 .NET** (mono build) | A standard build cannot load the C# host. Persian Strike is still on standard 4.7 GDScript ([CONFLICTS.md](CONFLICTS.md) C5) |
| Rules engine | C# on **.NET 10**, plain class libraries with no Godot reference | [ENGINE.md](ENGINE.md) |
| Godot assembly | `Godot.NET.Sdk/4.7.2`, `net10.0`, `Nullable` enabled, `EnableDefaultCompileItems` false with `src/**/*.cs` included | Galaxy Brain also sets `TreatWarningsAsErrors`; new games do too |
| Build props | `Directory.Build.props` sets `<Optimize>true</Optimize>` for every configuration | Editor and test runs otherwise measure unoptimized C# **[SH]** |
| Exports | `PublishReadyToRun` true in the game csproj | Avoids first-use JIT hitches on the main thread **[SH]** |
| Presentation | GDScript for scenes, UI and rendering glue | |
| Renderer | Forward+ on desktop | |
| Physics | Jolt where physics is needed. Threaded 3D physics off when systems raycast from `_process`; physics interpolation off when authored camera cuts must be exact **[PS]** | |
| Targets | Windows x64 and Linux x86_64 desktop | |
| Tooling | Python 3 for scripts, bash for CI and wrappers (`*.sh` always LF) | PowerShell twins only where a Windows box needs one |

## Ownership

- **One authoritative owner per system, one clock per system (E1).** A port
  or rewrite keeps the old implementation only as a reference that does not
  run in the same launch; once the new one matches a recorded golden run, the
  old one is deleted.
- **Presentation never decides (E2).** A GDScript file that decides legality,
  computes damage or edits authoritative state is a defect.
- **Cross-system signals go through one bus** (an `Events` autoload in
  GDScript games, ordered engine events in Qanat games). Systems do not hold
  hard references across each other.
- **Headless simulation (E3).** Audio and other autoloads are reached through
  null-safe wrappers so rules run under `--headless`.
- **One balance table (E4).** `Defs` (SHAHANSHAH) and `RulesConfig` (Galaxy
  Brain) hold every undecided number. If the engine embeds them, the export
  step that regenerates its data file is documented next to the table.

## Godot rules

- Add nodes to the tree before assigning global transforms or querying world
  state (E5).
- Validate retained `Node` references with `is_instance_valid()`; disconnect
  signals and clear references at teardown.
- `await signal`, never `await obj.connect()` (E7).
- Typed arrays and dictionaries need explicit casts at load and dynamic
  boundaries.
- A `class_name` script must import successfully before another script relies
  on its global type; after adding one, run `godot --headless --path .
  --import`.
- `res://` paths match tracked file names exactly, case included (E8).
- Effect visuals and their gameplay footprint share one shape function.
- Collision layers are documented once in the game's tech doc and never
  repurposed. Persian Strike's set is WORLD=1, HELI=2, ENEMY=4, DEBRIS=8,
  FRIENDLY=16.
- Things that cannot exist in the world are not drawn into it: no floating
  rings, bars, icons or labels in the default 3D view. Information lives in
  opt-in overlays or the 2D interface. **[SH]**
- Surface markings (emblems, decals, stencils) are part of the receiving
  surface (material, projected decal on the receiver's layer, or a modelled
  backed sign), never a hovering quad, sprite or label. **[PS]**

## C# rules

- Hot paths use interned `StringName`s, no `params` arrays, no closures, and
  few, batched crossings between C# and GDScript. **[SH]**
- Engine records cross into Godot as packed batches or snake_case
  dictionaries built in one adapter file, never as engine objects.
- No `Godot.*` reference anywhere under `engine/`.

## Saves

- Saves made before a change load after it (E9). A save carries a version and
  the loader migrates older ones.
- Deep-copy dictionaries and arrays at the save and load boundaries.
- Keep a backup of every save replaced, and open it if the newest is damaged.
  **[SH] [GB]** (SHAHANSHAH's `docs/SAVES.md`, Galaxy Brain's
  `profile_smoke.gd` are the references.)

## Interface

- Player-facing strings go through the translation tables from day one (E12).
- Every screen and popup fits inside the window at every supported size; a
  layout smoke enforces it. **[GB]**
- Say a thing once on screen: a title, name or number already visible is not
  repeated in the same view. **[SH]**
- Keyboard, mouse and controller prompts follow the active device; the
  in-game controls reference and the README controls table change together.

## Comments and code shape

- Comments state the current rule in the present tense: what the code does and
  why, the non-obvious constraint, the failure mode it guards (E10). No dates,
  ticket diaries, chat quotes or "used to".
- Keep licence notices and functional tool directives.
- Prefer one clear owner per rule and small files. Add abstraction only when a
  second real use appears. Split only at an ownership seam (E11).
- Linux paths are case-sensitive; Windows users must not commit CRLF churn
  ([GIT_AND_CI.md](GIT_AND_CI.md#line-endings)).

## Scale and units

One world scale reference per game, documented once (SHAHANSHAH's people are
1.72 m and doors clear a walker; Persian Strike flies at a fixed 20 m
terrain-relative plane). Every asset is checked against it.
