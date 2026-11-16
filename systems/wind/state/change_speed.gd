@tool
extends State

@export var wind_system: WindSystem
@export_range(0.1, 1.0, 0.01) var minimum_wind_speed: float = 0.5
@export_range(0.5, 3.5, 0.01) var maximum_wind_speed: float = 3.5

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not wind_system: warnings.append("`wind_system` must be set")
	return warnings

func enter() -> void:
	super.enter()
	var blend: float = pow(randf(), 1.0 / maxf(wind_system.attenuation, 0.001))
	wind_system.set_speed(lerpf(minimum_wind_speed, maximum_wind_speed, blend))
	deactivate()
