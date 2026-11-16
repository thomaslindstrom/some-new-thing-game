@tool
@abstract
@icon("res://modules/state/icons/inverse-atom.svg")
class_name StateBehavior
extends Node

var state: State

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not get_parent() is State: warnings.append("`StateBehavior` parent must be a `State`")
	return warnings
