@tool
extends StateBehavior
## Behavior that immediately activates a state
class_name StateBehaviorActivate

@export var one_shot: bool = false

var has_activated: bool = false

func initialize() -> void:
	if has_activated and one_shot: return
	state.activate()

func validate() -> void:
	if has_activated and one_shot: return
	state.activate()

func enter() -> void:
	has_activated = true
