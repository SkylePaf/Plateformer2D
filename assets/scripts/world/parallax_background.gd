#    >>  Header
@tool
extends ParallaxBackground

#           /$$$$$$$   /$$$$$$  /$$$$$$$   /$$$$$$  /$$        /$$$$$$  /$$   /$$       /$$$$$$$   /$$$$$$ 
#          | $$__  $$ /$$__  $$| $$__  $$ /$$__  $$| $$       /$$__  $$| $$  / $$      | $$__  $$ /$$__  $$
#          | $$  \ $$| $$  \ $$| $$  \ $$| $$  \ $$| $$      | $$  \ $$|  $$/ $$/      | $$  \ $$| $$  \__/
#          | $$$$$$$/| $$$$$$$$| $$$$$$$/| $$$$$$$$| $$      | $$$$$$$$ \  $$$$/       | $$$$$$$ | $$ /$$$$
#          | $$____/ | $$__  $$| $$__  $$| $$__  $$| $$      | $$__  $$  >$$  $$       | $$__  $$| $$|_  $$
#          | $$      | $$  | $$| $$  \ $$| $$  | $$| $$      | $$  | $$ /$$/\  $$      | $$  \ $$| $$  \ $$
#          | $$      | $$  | $$| $$  | $$| $$  | $$| $$$$$$$$| $$  | $$| $$  \ $$      | $$$$$$$/|  $$$$$$/
#          |__/      |__/  |__/|__/  |__/|__/  |__/|________/|__/  |__/|__/  |__/      |_______/  \______/ 
#                                                                                                          																								   
#                                                                                                                                                                                          
#                                                                                 
#          ████▄  ▄▄▄▄▄  ▄▄▄▄ ▄▄     ▄▄▄  ▄▄▄▄   ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄  ▄▄▄▄ 
#    ▄▄▄   ██  ██ ██▄▄  ██▀▀▀ ██    ██▀██ ██▄█▄ ██▀██  ██   ██ ██▀██ ███▄██ ███▄▄ 
#          ████▀  ██▄▄▄ ▀████ ██▄▄▄ ██▀██ ██ ██ ██▀██  ██   ██ ▀███▀ ██ ▀██ ▄▄██▀ 
#                                                                                 

#region Declarations

#    >>  Constants
const LVL_TYPE_NODE_NAME: String = "LVL_Type"
const LVL_TYPE_META_KEY: String = "LVL_TYPE"
const PALETTE_SHADER_PARAM: String = "palette_out"

const PALETTE_PATHS: Dictionary = {
	"REGULAR_ICED": "res://assets/sprites/tiles_sets/color_palettes/REGULAR_BACKGROUND.png",
	"BLUE_ICED": "res://assets/sprites/tiles_sets/color_palettes/BLUE_BACKGROUND.png",
	"PURPLE_ICED": "res://assets/sprites/tiles_sets/color_palettes/PURPLE_BACKGROUND.png"
}

#    >>  Nodes Imports
@onready var layer0: Sprite2D = $"ParallaxLayer-1/Trees"
@onready var layer1: Sprite2D = $ParallaxLayer/Trees
@onready var layer2: Sprite2D = $ParallaxLayer2/Mountains
@onready var layer3: Sprite2D = $ParallaxLayer3/Clouds
@onready var layer4: Sprite2D = $ParallaxLayer4/Sky
@onready var layer4_1: Sprite2D = $ParallaxLayer4/TopLayerBackground

#    >>  Cache
var _palette_textures: Dictionary = {}
var _lvl_type: String = ""
#endregion

#                                                                
#          ██     ▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄ ▄▄▄▄   ▄▄▄▄ 
#    ▄▄▄   ██     ██ ███▄▄   ██   ██▄▄  ███▄██ ██▄▄  ██▄█▄ ███▄▄ 
#          ██████ ██ ▄▄███   ██   ██▄▄▄ ██ ▀██ ██▄▄▄ ██ ██ ▄▄███▀ 

#region Listeners

#    >>  Ready Function
func _ready() -> void:
	_preload_palette_textures()
	await get_tree().process_frame
	_initialize_background_layers()
#endregion

#                                                      
#                                                      
#    █████▄ █████▄  ██████ ██     ▄████▄ ▄████▄ ████▄  
#    ██▄▄█▀ ██▄▄██▄ ██▄▄   ██     ██  ██ ██▄▄██ ██  ██ 
#    ██     ██   ██ ██▄▄▄▄ ██████ ▀████▀ ██  ██ ████▀  
#                                                      

#region Palette Textures Preloading

#    >>  Preload All Palette Textures
func _preload_palette_textures() -> void:
	for palette_type: String in PALETTE_PATHS:
		_palette_textures[palette_type] = load(PALETTE_PATHS[palette_type]) as Texture2D
#endregion

#                                                                                                                                                               
#                                                                                                                                                               
#    █████▄ ▄████▄ ▄█████ ██ ▄█▀  ▄████  █████▄  ▄████▄ ██  ██ ███  ██ ████▄    ██ ███  ██ ██ ██████ ██ ▄████▄ ██     ██ ▄█████ ▄████▄ ██████ ██ ▄████▄ ███  ██ 
#    ██▄▄██ ██▄▄██ ██     ████   ██  ▄▄▄ ██▄▄██▄ ██  ██ ██  ██ ██ ▀▄██ ██  ██   ██ ██ ▀▄██ ██   ██   ██ ██▄▄██ ██     ██ ▀▀▀▄▄▄ ██▄▄██   ██   ██ ██  ██ ██ ▀▄██ 
#    ██▄▄█▀ ██  ██ ▀█████ ██ ▀█▄  ▀███▀  ██   ██ ▀████▀ ▀████▀ ██   ██ ████▀    ██ ██   ██ ██   ██   ██ ██  ██ ██████ ██ █████▀ ██  ██   ██   ██ ▀████▀ ██   ██ 
#                                                                                                                                                               

#region Background Initialization

#    >>  Get Level Type
func _get_level_type() -> String:
	var lvl_type_node: Node = get_parent().find_child(LVL_TYPE_NODE_NAME, false, true)
	
	if lvl_type_node == null:
		push_error("LVL_Type node not found in parent hierarchy")
		return ""
	
	if not lvl_type_node.has_meta(LVL_TYPE_META_KEY):
		push_error("LVL_TYPE metadata not found on LVL_Type node")
		return ""
	
	return lvl_type_node.get_meta(LVL_TYPE_META_KEY) as String

#    >>  Initialize Background Layers
func _initialize_background_layers() -> void:
	_lvl_type = _get_level_type()
	
	if _lvl_type.is_empty():
		return
	
	var palette_texture: Texture2D = _palette_textures.get(_lvl_type)
	
	if palette_texture == null:
		push_error("Palette texture not found for level type: " + _lvl_type)
		return
	
	_apply_palette_to_layers(palette_texture)

#    >>  Apply Palette to All Layers
func _apply_palette_to_layers(palette_texture: Texture2D) -> void:
	var all_backgrounds: Array[Sprite2D] = [
		layer0, layer1, layer2, layer3, layer4, layer4_1
	]
	
	for background: Sprite2D in all_backgrounds:
		if not _is_layer_valid(background):
			continue
		
		_apply_shader_palette(background, palette_texture)

#    >>  Validate Layer
func _is_layer_valid(layer: Sprite2D) -> bool:
	return layer != null and layer.material != null

#    >>  Apply Shader Palette to Layer
func _apply_shader_palette(layer: Sprite2D, palette_texture: Texture2D) -> void:
	layer.material = layer.material.duplicate()
	layer.material.set_shader_parameter(PALETTE_SHADER_PARAM, palette_texture)
#endregion

#    ███████ ███    ██ ██████                                                                                                                              
#    ██      ████   ██ ██   ██                                                                                                                             
#    █████   ██ ██  ██ ██   ██     █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ 
#    ██      ██  ██ ██ ██   ██                                                                                                                             
#    ███████ ██   ████ ██████
