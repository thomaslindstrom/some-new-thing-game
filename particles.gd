@tool
extends GPUParticles3D

@export_range(0.0, 2.0, 0.01) var speed_multiplier: float = 0.8

var initial_velocity: Vector2

func _ready() -> void:
	if not process_material is ParticleProcessMaterial: return
	var particle_process_material: ParticleProcessMaterial = process_material
	
	initial_velocity = particle_process_material.initial_velocity

func _process(delta: float) -> void:
	var wind_system: WindSystem = Systems.get_system(&"wind")
	if not wind_system or not process_material is ParticleProcessMaterial: return

	var particle_process_material: ParticleProcessMaterial = process_material
	var wind_direction: Vector3 = Vector3(wind_system.direction.x, 0.0, wind_system.direction.y)
	particle_process_material.direction = wind_direction
	particle_process_material.gravity = wind_direction * wind_system.speed * speed_multiplier

	if Engine.is_editor_hint(): return

	particle_process_material.initial_velocity = initial_velocity * wind_system.speed * speed_multiplier
