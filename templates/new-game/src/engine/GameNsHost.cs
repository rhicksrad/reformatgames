using System;
using Godot;
using GameNs.Engine;

namespace GameNs;

/// The only Godot boundary: submits commands, emits one signal per engine
/// event in order, and returns snapshots as dictionaries. It holds no rules.
[GlobalClass]
public partial class GameNsHost : Node
{
    [Signal] public delegate void EngineEventEventHandler(Godot.Collections.Dictionary ev);

    Game? _game;

    public void StartGame(int seed) => _game = new Game(seed);

    /// Returns "" when accepted, or the reject reason.
    public string SubmitSpend(int player, int amount) => Submit(new Spend(player, amount));

    public string SubmitEndTurn(int player) => Submit(new EndTurn(player));

    public Godot.Collections.Dictionary Snapshot(int viewer)
    {
        var s = Current().Snapshot(viewer);
        var funds = new Godot.Collections.Array();
        foreach (var f in s.Funds)
            funds.Add(f);
        return new Godot.Collections.Dictionary
        {
            ["turn"] = s.Turn,
            ["active_player"] = s.ActivePlayer,
            ["funds"] = funds,
        };
    }

    string Submit(Command command)
    {
        var reject = Current().Apply(command);
        foreach (var ev in Current().DrainEvents())
            EmitSignal(SignalName.EngineEvent, ToDictionary(ev));
        return reject == Reject.None ? "" : reject.ToString();
    }

    Game Current() => _game ?? throw new InvalidOperationException("StartGame first");

    static Godot.Collections.Dictionary ToDictionary(GameEvent ev) => ev switch
    {
        FundsSpent e => new() { ["kind"] = "funds_spent", ["player"] = e.Player, ["amount"] = e.Amount, ["left"] = e.Left },
        TurnStarted e => new() { ["kind"] = "turn_started", ["player"] = e.Player, ["turn"] = e.Turn },
        _ => new() { ["kind"] = "unknown" },
    };
}
