extends Label

var wind_system: WindSystem

func _ready() -> void:
	wind_system = Systems.get_system(&"wind")

func _physics_process(_delta: float) -> void:
	if not wind_system: return

	var wind_degrees: float = fmod(rad_to_deg(wind_system.direction.angle()) + 360.0, 360.0)
	var updated_text: String = "%3d° %1.1fs" % [wind_degrees, wind_system.speed]
	
	if updated_text == text: return
	text = updated_text
