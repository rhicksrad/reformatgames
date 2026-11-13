extends SceneTree
## Headless boot smoke: the C# host loads, a command round-trips through the
## engine, and events arrive as signals. Ends SMOKE PASS or SMOKE FAIL.
##   godot --headless --path . --script res://src/dev/boot_smoke.gd

var _events: Array[Dictionary] = []
var _failures := 0


func _initialize() -> void:
	var host: Node = load("res://src/engine/GameNsHost.cs").new()
	root.add_child(host)
	host.connect("EngineEvent", func(ev: Dictionary) -> void: _events.append(ev))
	host.call("StartGame", 530)
	_check(host.call("SubmitSpend", 0, 30) == "", "a legal command is accepted")
	_check(_events.size() == 1 and _events[0].get("kind") == "funds_spent", "its event arrives")
	_check(host.call("SubmitSpend", 1, 10) == "NotYourTurn", "an illegal command is refused")
	var snap: Dictionary = host.call("Snapshot", 0)
	_check(int(snap["funds"][0]) == 70, "the snapshot shows the engine's state")
	print("SMOKE PASS: 0 failures" if _failures == 0 else "SMOKE FAIL: %d failures" % _failures)
	quit(0 if _failures == 0 else 1)


func _check(ok: bool, label: String) -> void:
	print(("PASS  " if ok else "FAIL  ") + label)
	if not ok:
		_failures += 1
