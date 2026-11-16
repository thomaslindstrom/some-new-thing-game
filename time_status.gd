extends Label

var time_system: TimeSystem

func _ready() -> void:
	time_system = Systems.get_system(&"time")

func _physics_process(_delta: float) -> void:
	if not time_system: return
	
	var hours: int = floor(time_system.time * 24)
	var minutes: int = floor(fmod(time_system.time * 24 * 60, 60))
	var updated_text: String = "%02d:%02d" % [hours, minutes]
	
	if updated_text == text: return
	text = updated_text
