@tool
extends System
class_name TimeSystem

## In seconds, how long is one full day?
@export var day_duration: float = 24.0 * 60.0
@export var is_active: bool = true

func _init() -> void: system_name = &"time"

## The current time value between 0.0 and 1.0 where 0.5 is midday and 0.0 is midnight
var time: float = 0.0

func _ready() -> void:
	super._ready()
	time = (8 * 60.0) / day_duration # start day at 8:00

func _process(delta: float) -> void:
	if not is_active: return
	var progress: float = delta / day_duration
	time = fmod(time + progress, 1.0)
