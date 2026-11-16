@tool
extends Node

var systems: Dictionary[StringName, Node] = {}

func register_system(system_name: StringName, system: Node) -> void:
	systems.set(system_name, system)
	print("[Systems] `" + system_name + "` registered.")

func get_system(system_name: StringName) -> Node:
	if not systems.has(system_name):
		push_warning("[Systems] `" + system_name + "` not found.")
	return systems.get(system_name)
