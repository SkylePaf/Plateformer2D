extends Node2D

var lvl_type: String;

func _ready() -> void:
	lvl_type = get_meta("LVL_TYPE")
