#    >>  Header
@tool
extends Node2D

#           /$$$$$$$$ /$$$$$$ /$$       /$$$$$$$$ /$$      /$$  /$$$$$$  /$$$$$$$ 
#          |__  $$__/|_  $$_/| $$      | $$_____/| $$$    /$$$ /$$__  $$| $$__  $$
#             | $$     | $$  | $$      | $$      | $$$$  /$$$$| $$  \ $$| $$  \ $$
#             | $$     | $$  | $$      | $$$$$   | $$ $$/$$ $$| $$$$$$$$| $$$$$$$/
#             | $$     | $$  | $$      | $$__/   | $$  $$$| $$| $$__  $$| $$____/ 
#             | $$     | $$  | $$      | $$      | $$\  $ | $$| $$  | $$| $$      
#             | $$    /$$$$$$| $$$$$$$$| $$$$$$$$| $$ \/  | $$| $$  | $$| $$      
#             |__/   |______/|________/|________/|__/     |__/|__/  |__/|__/      

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
	"REGULAR_ICED": "res://assets/sprites/tiles_sets/color_palettes/REGULAR_TILESET.png",
	"BLUE_ICED": "res://assets/sprites/tiles_sets/color_palettes/BLUE_TILESET.png",
	"PURPLE_ICED": "res://assets/sprites/tiles_sets/color_palettes/PURPLE_TILESET.png"
}

#    >>  Nodes Imports
@onready var foreground: TileMapLayer = $custom_ground
@onready var midground: TileMapLayer = $custom_ground
@onready var background: TileMapLayer = $custom_ground_layer_3
#@onready var decorations: TileMapLayer = $decorations

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
	_initialize_tilemap_layers()
#endregion

#                                                            
#                                                            
#          █████▄ █████▄  ██████ ██     ▄████▄ ▄████▄ ████▄  
#    ▄▄▄   ██▄▄█▀ ██▄▄██▄ ██▄▄   ██     ██  ██ ██▄▄██ ██  ██ 
#          ██     ██   ██ ██▄▄▄▄ ██████ ▀████▀ ██  ██ ████▀  
#                                                            

#region Palette Textures Preloading

#    >>  Preload All Palette Textures
func _preload_palette_textures() -> void:
	for palette_type: String in PALETTE_PATHS:
		_palette_textures[palette_type] = load(PALETTE_PATHS[palette_type]) as Texture2D
#endregion

#                                                                                                                                           
#                                                                                                                                           
#          ██████ ██ ██     ██████ ██▄  ▄██ ▄████▄ █████▄   ██ ███  ██ ██ ██████ ██ ▄████▄ ██     ██ ▄█████ ▄████▄ ██████ ██ ▄████▄ ███  ██ 
#    ▄▄▄     ██   ██ ██     ██▄▄   ██ ▀▀ ██ ██▄▄██ ██▄▄█▀   ██ ██ ▀▄██ ██   ██   ██ ██▄▄██ ██     ██ ▀▀▀▄▄▄ ██▄▄██   ██   ██ ██  ██ ██ ▀▄██ 
#            ██   ██ ██████ ██▄▄▄▄ ██    ██ ██  ██ ██       ██ ██   ██ ██   ██   ██ ██  ██ ██████ ██ █████▀ ██  ██   ██   ██ ▀████▀ ██   ██ 
#                                                                                                                                           

#region Tilemap Initialization

#    >>  Get Level Type
func _get_level_type() -> String:
	var parent_root: Node = get_parent().get_parent()
	
	if parent_root == null:
		push_error("Parent root not found")
		return ""
	
	var lvl_type_node: Node = parent_root.find_child(LVL_TYPE_NODE_NAME, false, true)
	
	if lvl_type_node == null:
		push_error("LVL_Type node not found")
		return ""
	
	if not lvl_type_node.has_meta(LVL_TYPE_META_KEY):
		push_error("LVL_TYPE metadata not found")
		return ""
	
	return lvl_type_node.get_meta(LVL_TYPE_META_KEY) as String

#    >>  Initialize Tilemap Layers
func _initialize_tilemap_layers() -> void:
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
	var all_layers: Array[TileMapLayer] = [background, foreground, midground]
	
	for layer: TileMapLayer in all_layers:
		if not _is_layer_valid(layer):
			continue
		
		_apply_shader_palette(layer, palette_texture)

#    >>  Validate Layer
func _is_layer_valid(layer: TileMapLayer) -> bool:
	return layer != null and layer.material != null

#    >>  Apply Shader Palette to Layer
func _apply_shader_palette(layer: TileMapLayer, palette_texture: Texture2D) -> void:
	layer.material.set_shader_parameter(PALETTE_SHADER_PARAM, palette_texture)
#endregion

#    ███████ ███    ██ ██████                                                                                                                              
#    ██      ████   ██ ██   ██                                                                                                                             
#    █████   ██ ██  ██ ██   ██     █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ 
#    ██      ██  ██ ██ ██   ██                                                                                                                             
#    ███████ ██   ████ ██████
