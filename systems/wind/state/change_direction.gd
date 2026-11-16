@tool
extends State

@export var wind_system: WindSystem

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not wind_system: warnings.append("`wind_system` must be set")
	return warnings

func enter() -> void:
	super.enter()
	var new_direction: Vector2 = Vector2.from_angle(randf() * TAU)
	wind_system.set_direction(new_direction.normalized())
	deactivate()
