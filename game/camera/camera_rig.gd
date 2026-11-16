class_name CameraRig
extends Node3D

@export var camera: Camera3D
@export var subject_offset: Vector3 = Vector3.ZERO

var target_position: Vector3 = Vector3.ZERO
var target_movement_speed: float = 4.0
var movement_speed: float = 1.5
var movement_epsilon: float = 0.003

var rotation_tap_maximum_duration: float = 0.2
var rotation_pressed_duration: float = 0.0
var current_rotation: float = 0.0
var target_rotation: float = 0.0
var rotation_snap: float = 0.0
var rotation_speed: float = 2.0
var rotation_epsilon: float = PI / 2160.0

var subject: Node3D
func _ready() -> void:
	current_rotation = rotation.y
	target_rotation = current_rotation
	rotation_snap = current_rotation / 2.0
	
	var subjects: Array[Node] = get_tree().get_nodes_in_group(&"camera_subject")
	if subjects.size() == 0: return
	
	if subjects.size() > 1:
		push_warning("[CameraRig] `camera_subject` group is set on multiple nodes. Using latest.")
		return
	
	var current_subject: Node = subjects[0]
	if not current_subject is Node3D: return

	subject = current_subject

func _physics_process(delta: float) -> void:
	if subject: target_position = subject.global_position + subject_offset
	else:
		var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_down", "move_up")
		var yaw: Basis = Basis(basis.x, Vector3.UP, basis.z).orthonormalized()
		var movement_vector: Vector3 = yaw * Vector3(input_vector.x, 0, input_vector.y / sin(rotation.x))

		target_position += movement_vector * target_movement_speed * delta
		
	var distance_to_target: float = position.distance_to(target_position)
	var position_smoothing: float = 1.0 - 2.0 ** (-4.0 * delta * movement_speed)
	
	if is_zero_approx(distance_to_target): position = target_position
	else: position = position.lerp(target_position, position_smoothing)
	
	if Input.is_action_pressed(&"orbit_right"):
		target_rotation += rotation_speed * delta
		rotation_pressed_duration += delta

	if Input.is_action_pressed(&"orbit_left"):
		target_rotation -= rotation_speed * delta
		rotation_pressed_duration += delta

	if Input.is_action_just_released(&"orbit_right") or Input.is_action_just_released(&"orbit_left"):
		var rotation_direction: float = 0.0

		if Input.is_action_just_released(&"orbit_right"):
			rotation_direction = +1.0
		elif Input.is_action_just_released(&"orbit_left"):
			rotation_direction = -1.0
		
		if rotation_pressed_duration <= rotation_tap_maximum_duration:
			target_rotation += rotation_snap * rotation_direction

		target_rotation = snappedf(target_rotation, rotation_snap)
		rotation_pressed_duration = 0.0

	current_rotation = lerpf(current_rotation, target_rotation, 1.0 - 2.0 ** (-4.0 * delta * rotation_speed))

	if is_equal_approx(current_rotation, target_rotation):
		current_rotation = target_rotation
		rotation.y = target_rotation
	else: rotation.y = current_rotation
