namespace GameNs.Engine;

// The engine owns every rule, every random draw and all match state. Godot
// submits commands and draws what the events and snapshots say
// (Reformat Games standards, ENGINE.md). Replace this starter rule with the
// game's own; keep the shape: Validate, Apply, ordered events, snapshots.

/// Undecided design numbers. Never inline them in rule code.
public sealed record RulesConfig(int StartingFunds = 100, int MaxSpend = 50);

public abstract record Command(int Player);
public sealed record Spend(int Player, int Amount) : Command(Player);
public sealed record EndTurn(int Player) : Command(Player);

public enum Reject { None, NotYourTurn, BadAmount, NotEnoughFunds, GameOver }

public abstract record GameEvent;
public sealed record FundsSpent(int Player, int Amount, int Left) : GameEvent;
public sealed record TurnStarted(int Player, int Turn) : GameEvent;

/// Full state as one viewer may see it; holds no engine objects.
public sealed record Snapshot(int Turn, int ActivePlayer, IReadOnlyList<int> Funds);

public sealed class Game
{
    readonly RulesConfig _rules;
    readonly int[] _funds;
    readonly List<GameEvent> _pending = new();
    int _turn = 1;
    int _active;

    public Rng Random { get; }

    public Game(int seed, RulesConfig? rules = null, int players = 2)
    {
        _rules = rules ?? new RulesConfig();
        _funds = Enumerable.Repeat(_rules.StartingFunds, players).ToArray();
        Random = new Rng((ulong)seed);
    }

    public Reject Validate(Command command) => command switch
    {
        _ when command.Player != _active => Reject.NotYourTurn,
        Spend s when s.Amount <= 0 || s.Amount > _rules.MaxSpend => Reject.BadAmount,
        Spend s when s.Amount > _funds[s.Player] => Reject.NotEnoughFunds,
        _ => Reject.None,
    };

    /// Applies a legal command. A rejected one changes nothing.
    public Reject Apply(Command command)
    {
        var reject = Validate(command);
        if (reject != Reject.None)
            return reject;
        switch (command)
        {
            case Spend s:
                _funds[s.Player] -= s.Amount;
                _pending.Add(new FundsSpent(s.Player, s.Amount, _funds[s.Player]));
                break;
            case EndTurn:
                _active = (_active + 1) % _funds.Length;
                _turn++;
                _pending.Add(new TurnStarted(_active, _turn));
                break;
        }
        return Reject.None;
    }

    /// The events since the last drain, in order.
    public IReadOnlyList<GameEvent> DrainEvents()
    {
        var events = _pending.ToArray();
        _pending.Clear();
        return events;
    }

    public Snapshot Snapshot(int viewer) => new(_turn, _active, _funds.ToArray());
}

/// The engine's only source of randomness: PCG32, deterministic per seed.
public sealed class Rng
{
    ulong _state;
    const ulong Inc = 1442695040888963407UL;

    public Rng(ulong seed)
    {
        _state = 0;
        Next();
        _state += seed;
        Next();
    }

    public uint Next()
    {
        ulong old = _state;
        _state = unchecked(old * 6364136223846793005UL + Inc);
        uint xorshifted = (uint)(((old >> 18) ^ old) >> 27);
        int rot = (int)(old >> 59);
        return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
    }

    /// A value in [0, max).
    public int Below(int max) => (int)(Next() % (uint)max);
}
