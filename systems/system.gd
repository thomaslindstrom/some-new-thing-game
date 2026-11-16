extends Node
class_name System

var system_name: StringName = &""

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if system_name == &"": warnings.append("`system_name` cannot be empty.")
	return warnings

func _ready() -> void:
	Systems.register_system(system_name, self)
