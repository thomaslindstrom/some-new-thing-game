@tool
extends System
class_name WindSystem

## For certain weather types, this control can be used to create more calm or extreme conditions
@export_range(0.0, 5.0, 0.01) var attenuation: float = 1.0

func get_random_direction() -> Vector2:
	return Vector2.from_angle(randf() * TAU)

var transition_speed: float = 0.01
var direction: Vector2 = get_random_direction()
var speed: float = randf_range(0.8, 1.2)

func _init() -> void: system_name = &"wind"

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = super._get_configuration_warnings()

	if get_child_count() == 0 or not get_child(0) is StateMachine:
		warnings.append("`WindSystem` must be a packed scene")

	var global_shader_parameters: Array[StringName] = RenderingServer.global_shader_parameter_get_list()

	if not global_shader_parameters.has(&"wind_direction"):
		warnings.append("`WindSystem` requires `wind_direction` shader global of type `Vector2`")
		
	if not global_shader_parameters.has(&"wind_speed"):
		warnings.append("`WindSystem` requires `wind_speed` shader global of type `float`")
		
	return warnings

var target_direction: Vector2 = direction
func set_direction(input_direction: Vector2 = get_random_direction()) -> void:
	target_direction = input_direction
	
var target_speed: float = speed
func set_speed(input_speed: float = 1.0) -> void:
	target_speed = input_speed
	
signal on_direction_changed(direction: Vector2)
signal on_speed_changed(speed: float)

func _ready() -> void:
	super._ready()
	RenderingServer.global_shader_parameter_set(&"wind_direction", direction)
	RenderingServer.global_shader_parameter_set(&"wind_speed", speed)

func _physics_process(delta: float) -> void:
	var tick: float = transition_speed * delta
	
	if not direction.is_equal_approx(target_direction):
		var angle: float = lerp_angle(direction.angle(), target_direction.angle(), tick)
		direction = Vector2.from_angle(angle)
		RenderingServer.global_shader_parameter_set(&"wind_direction", direction)
		on_direction_changed.emit(direction)
		
	if not is_equal_approx(speed, target_speed):
		speed = lerpf(speed, target_speed, tick)
		RenderingServer.global_shader_parameter_set(&"wind_speed", speed)
		on_speed_changed.emit(speed)
