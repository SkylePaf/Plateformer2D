extends Node

var current_area = 0
var areas_path = [
	"res://assets/scenes/LVLs/FirstTests/lvl-1.tscn",
	"res://assets/scenes/LVLs/FirstTests/lvl-2.tscn",
	"res://assets/scenes/LVLs/FirstTests/lvl-3.tscn"
]

func _next_lvl():
	current_area += 1
	var area = areas_path[current_area]
	get_tree().change_scene_to_file(area)
	print("CHANGE SCENE")
