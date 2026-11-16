@tool
extends StateBehavior
## Behavior that randomly activates the state at a given `chance` percentage that is calculated on every `validate`. Can reactivate when deactivating at `reactivate_chance`
class_name StateBehaviorRandom

## The chance to activate this state at every `validate`
@export_range(0.0, 1.0, 0.001) var chance: float = 0.01
## The chance to immediately reactivate this state again when it deactivates
@export_range(0.0, 1.0, 0.001) var reactivate_chance: float = 0.0

func validate() -> bool:
	if randf() < chance: return true
	return false

func reactivate() -> bool:
	if randf() < reactivate_chance: return true
	return false
