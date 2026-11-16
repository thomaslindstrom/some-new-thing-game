@tool
extends State

@export var wind_system: WindSystem
@export_range(0.01, 10.0, 0.01) var minimum_transition_speed: float = 1.5
@export_range(0.01, 10.0, 0.01) var maximum_transition_speed: float = 3.0
@export_range(0.01, 10.0, 0.01) var minimum_gust_speed: float = 1.5
@export_range(0.01, 10.0, 0.01) var maximum_gust_speed: float = 5.0

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not wind_system: warnings.append("`wind_system` must be set")
	return warnings

var previous_speed: float = 0.0
var previous_transition_speed: float = 0.0

var is_gusting: bool = true
var target_speed: float = 0.0

func enter() -> void:
	super.enter()
	previous_speed = wind_system.target_speed
	previous_transition_speed = wind_system.transition_speed
	
	var blend: float = pow(randf(), maxf(wind_system.attenuation, 0.001))
	wind_system.transition_speed = lerpf(minimum_transition_speed, maximum_transition_speed, blend)
	
	target_speed = lerpf(minimum_gust_speed, maximum_gust_speed, blend)
	wind_system.set_speed(target_speed)
	is_gusting = true

func physics_process(_delta: float) -> void:
	if is_gusting and is_equal_approx(wind_system.speed, target_speed):
		wind_system.set_speed(previous_speed)
		is_gusting = false
	elif not is_gusting and is_equal_approx(wind_system.speed, previous_speed):
		deactivate()

func exit() -> void:
	super.exit()
	wind_system.transition_speed = previous_transition_speed
	
