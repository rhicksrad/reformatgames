using GameNs.Engine;

// Rules tests with no test framework: each check prints PASS or FAIL, and
// any failure exits 1.
//   dotnet run --project engine/GameNs.Engine.Tests -c Release

int checks = 0;
int failures = 0;

void Check(bool ok, string label)
{
    checks++;
    if (!ok)
        failures++;
    Console.WriteLine($"{(ok ? "PASS" : "FAIL")}  {label}");
}

var game = new Game(seed: 530);
Check(game.Apply(new Spend(0, 30)) == Reject.None, "a legal spend applies");
Check(game.Snapshot(0).Funds[0] == 70, "the spend leaves 70");
Check(game.Apply(new Spend(1, 10)) == Reject.NotYourTurn, "the other player cannot act");
Check(game.Apply(new Spend(0, 0)) == Reject.BadAmount, "a zero spend is refused");
Check(game.Snapshot(0).Funds[0] == 70, "a refused command changes nothing");

var events = game.DrainEvents();
Check(events.Count == 1 && events[0] is FundsSpent { Left: 70 }, "one ordered event per accepted command");
Check(game.DrainEvents().Count == 0, "draining empties the queue");

game.Apply(new EndTurn(0));
Check(game.Snapshot(0) is { ActivePlayer: 1, Turn: 2 }, "ending a turn passes priority");

var a = new Game(seed: 7);
var b = new Game(seed: 7);
bool same = true;
for (int i = 0; i < 1000; i++)
    same &= a.Random.Next() == b.Random.Next();
Check(same, "the same seed gives the same draws");

Console.WriteLine($"{(failures == 0 ? "ENGINE TESTS PASS" : "ENGINE TESTS FAIL")}: {checks} checks, {failures} failures");
return failures == 0 ? 0 : 1;
