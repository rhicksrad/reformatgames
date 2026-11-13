# GAME_NAME engine

**The engine decides; Godot presents.** `GameNs.Engine` is plain C# (.NET 10,
no Godot reference). It owns every rule, every random draw and all game
state. Godot sends commands and animates what comes back. The studio's
pattern: <https://github.com/rhicksrad/reformatgames/blob/main/standards/ENGINE.md>.

## Pipe

```
GDScript ──Submit(command)──▶ GameNsHost (C#, Godot node) ──▶ Game (engine)
    ▲                                                          │
    └──── EngineEvent(dict) × N, Snapshot(viewer) → dict ◀─────┘
```

## Commands

| Command | Rejects |
| --- | --- |
| `Spend(player, amount)` | `NotYourTurn`, `BadAmount`, `NotEnoughFunds` |
| `EndTurn(player)` | `NotYourTurn` |

## Events

| Event | Fields |
| --- | --- |
| `funds_spent` | `player`, `amount`, `left` |
| `turn_started` | `player`, `turn` |

## Determinism

One `Rng` (PCG32) seeded per game is the only randomness the rules use.

## Rule interpretations

<Rulings the design leaves open, as the engine implements them.>
