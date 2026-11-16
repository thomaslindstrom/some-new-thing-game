@tool
extends StateBehavior
## Behavior that starts an animation in an animation player, and deactivates the state once the animation is finished.
class_name StateBehaviorAnimate

@export var animation_player: AnimationPlayer:
	set(value):
		animation_player = value
		notify_property_list_changed()
@export var animation: String

func _validate_property(property: Dictionary) -> void:
	if property.name != &"animation": return
	if not animation_player:
		property.usage |= PROPERTY_USAGE_READ_ONLY
		return
	
	property.hint = PROPERTY_HINT_ENUM
	property.hint_string = ",".join(animation_player.get_animation_list())

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not animation_player: warnings.append("`animation_player` must be set")
	if not animation: warnings.append("`animation` must be set")
	return warnings

func enter() -> void:
	animation_player.play(animation)
	
	var finished_animation_name: StringName = await animation_player.animation_finished

	if not state.is_active: return
	if finished_animation_name != StringName(animation): return

	state.deactivate()
