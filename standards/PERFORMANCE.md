# Performance

The contract every system keeps and the way it is measured. Each game's own
`docs/PERFORMANCE.md` holds its gates, its perf tour and its one current
baseline per scenario. Policy IDs: P1–P6 in [POLICIES.md](POLICIES.md).
SHAHANSHAH's `docs/PERFORMANCE_LESSONS.md` is the long-form write-up of what
was measured on this stack; read it before performance work on a C# game.

## The system contract

Every persistent or mass-spawned system declares, in code (P1):

- a **cap** (how many at most);
- a **fade** by distance, zoom or visibility;
- a **cadence** or gate (how often it runs, and when it does not);
- a **cleanup** or time to live.

A system that cannot state all four is not merged.

## Gates

A game sets its gates on a named reference machine at its worst real hot
spot, from presented frames (one frame-pre-draw to the next) with vsync and
the frame cap off. SHAHANSHAH's table is the template:

| Tier | Preset, resolution | Average | 1% low | Stalls |
| --- | --- | ---: | ---: | --- |
| Reference | Ultra, 1440p | 50 target, 45 floor | 30 | none repeating over 50 ms |
| Low | Low, 1600x900 | 30 | 24 | none repeating over 100 ms |
| Medium | Medium, 1080p | 60 | 45 | none repeating over 50 ms |
| Ultra | Ultra, 1440p | 60 | 45 | none repeating over 50 ms |

Plus load ceilings (to the title, to the first playable frame) and a soak that
holds static memory flat. Every report gives the 1% low, p99, worst frame and
hitch counts beside the average, and any engine or script error fails the run
(P2).

## Measuring

- One perf tour per game: it boots the shipping scene like a player, builds
  the mature late-game state through player commands on a fixed seed, and
  records fixed camera segments. It writes a JSON summary, a per-frame CSV
  and a capture per segment, and ends `PERF TOUR PASS` or `PERF TOUR FAIL`.
- Like for like only (P3): same machine, preset, resolution, render scale,
  seed and maturity. A laptop number is never compared with a desktop number.
- Timing runs only on the designated perf machine, under the exclusive GPU
  lock, never while the owner plays on it (W10).
- Thermal drift on a laptop can exceed the pass bar: alternate the base and
  the change, twice, and judge the means. **[SH]**
- One attributable change at a time; before and after numbers go in the
  commit message. Per-change numbers do not go in docs.
- Count draws, primitives, surfaces, shadow casters and lights per owner
  before and after an art change. A lower draw count is not a win until frame
  time improves.

## Banned at runtime

Allowed once at load and cached, never per frame or per spawn (P4):

- GPU or render-server readbacks (`surface_get_arrays`, `get_faces`,
  `Mesh.duplicate`);
- `Shader.new()` per call; uncached material variants (prewarm them under the
  loading screen);
- per-item immediate drawing in HUD redraws;
- per-spawn batching walks and O(n²) spawn paths.

Runtime bakes are deferred with a per-frame budget (about 1 ms).

## Rendering rules

- Persistent lights distance-fade; transient effect lights and particle sheets
  cast no shadows, with fixed caps (P5). No visible pop at any distance or
  budget transition.
- Graphics presets (Low, Medium, Ultra, with render scale, FSR and a
  resolution picker) change GPU work only, never simulation (P6).
- LOD is render-only: visibility ranges, mesh LODs, impostors, fades. Gameplay
  agents never sleep by distance.
- Anything the fixed-rate tick moves is interpolated for display.
- Batch C#/GDScript crossings; intern `StringName`s in hot C#.
