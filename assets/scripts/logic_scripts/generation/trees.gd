#    >>  Header
@tool
extends Node2D
class_name TreesGeneration

#          /$$    /$$ /$$$$$$ /$$   /$$ /$$$$$$$$  /$$$$$$        /$$$$$$  /$$$$$$$$ /$$   /$$ 
#         | $$   | $$|_  $$_/| $$$ | $$| $$_____/ /$$__  $$      /$$__  $$| $$_____/| $$$ | $$
#         | $$   | $$  | $$  | $$$$| $$| $$      | $$  \__/     | $$  \__/| $$      | $$$$| $$
#         |  $$ / $$/  | $$  | $$ $$ $$| $$$$$   |  $$$$$$      | $$ /$$$$| $$$$$   | $$ $$ $$
#          \  $$ $$/   | $$  | $$  $$$$| $$__/    \____  $$     | $$|_  $$| $$__/   | $$  $$$$
#           \  $$$/    | $$  | $$\  $$$| $$       /$$  \ $$     | $$  \ $$| $$      | $$\  $$$
#            \  $/    /$$$$$$| $$ \  $$| $$$$$$$$|  $$$$$$/     |  $$$$$$/| $$$$$$$$| $$ \  $$
#             \_/    |______/|__/  \__/|________/ \______/       \______/ |________/|__/  \__/

#                                                                                 
#                                                                                 
#          ████▄  ▄▄▄▄▄  ▄▄▄▄ ▄▄     ▄▄▄  ▄▄▄▄   ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄  ▄▄▄▄ 
#    ▄▄▄   ██  ██ ██▄▄  ██▀▀▀ ██    ██▀██ ██▄█▄ ██▀██  ██   ██ ██▀██ ███▄██ ███▄▄ 
#          ████▀  ██▄▄▄ ▀████ ██▄▄▄ ██▀██ ██ ██ ██▀██  ██   ██ ▀███▀ ██ ▀██ ▄▄██▀ 
#                                                                                 

#region Declarations

#    >>  Constants
const PLAYER_NODE_NAME: String = "player"
const LVL_TYPE_NODE_NAME: String = "LVL_Type"
const LVL_TYPE_META_KEY: String = "LVL_TYPE"
const DECELERATION_MULTIPLIER: float = 0.99
const ANIMATION_SPEED_NORMAL: float = 1.0
const ANIMATION_SPEED_EFFECT: float = 25.0

const LEAVES_ANIMATION_NAMES: Dictionary = {
	"MEDIUM": "medium_tree",
	"LARGE": "large_tree"
}

const LEAVES_DATAS: Dictionary = {
	"MEDIUM": {
		"QUANTITY": 2,
		"Y_OFFSET": 48.0,
		"PARTICLES": {
			"SHAPE_RECT": Vector2i(35, 20),
			"AMOUNT": 15,
			"ROOT": "res://assets/sprites/particles/leaves.png"
		},
		"REGULAR_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 0.0, 96.0, 80.0), Rect2(0.0, 80.0, 96.0, 80.0)
			],
			"COLOR": Color(0.545, 0.713, 0.466)
		},
		"BLUE_ICED": {
			"REGIONS_RECTS": [
				Rect2(96.0, 0.0, 96.0, 80.0), Rect2(96.0, 80.0, 96.0, 80.0)
			],
			"COLOR": Color(0.341, 0.464, 0.874)
		},
		"PURPLE_ICED": {
			"REGIONS_RECTS": [
				Rect2(192.0, 0.0, 96.0, 80.0), Rect2(192.0, 80.0, 96.0, 80.0)
			],
			"COLOR": Color(0.482, 0.345, 0.662)
		}
	},
	"LARGE": {
		"QUANTITY": 2,
		"Y_OFFSET": 32.0,
		"PARTICLES": {
			"SHAPE_RECT": Vector2i(20.0, 30.0),
			"AMOUNT": 15,
			"ROOT": "res://assets/sprites/particles/shard.png"
		},
		"REGULAR_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 272.0, 80.0, 80.0), Rect2(80.0, 272.0, 80.0, 80.0)
			],
			"COLOR": Color(0.545, 0.713, 0.466)
		},
		"BLUE_ICED": {
			"REGIONS_RECTS": [
				Rect2(160.0, 272.0, 80.0, 80.0), Rect2(240.0, 272.0, 80.0, 80.0)
			],
			"COLOR": Color(0.341, 0.464, 0.874)
		},
		"PURPLE_ICED": {
			"REGIONS_RECTS": [
				Rect2(320, 272.0, 80.0, 80.0), Rect2(400.0, 272.0, 80.0, 80.0)
			],
			"COLOR": Color(0.482, 0.345, 0.662)
		}
	}
}

const LOGS_DATAS: Dictionary = {
	"MEDIUM": {
		"CHANCE_OF_LEAVES_LESS": {
			"REGULAR_ICED": 15,
			"BLUE_ICED": 7,
			"PURPLE": 100
		},
		"QUANTITY": 2,
		"WITH_LEAVES": {	
			"Y_OFFSET": 24,
			"BLUE_ICED": [
				Rect2(64.0, 160.0, 32.0, 48.0), Rect2(96.0, 160.0, 32.0, 48.0)
			],
			"OTHERS": [
				Rect2(0.0, 160.0, 32.0, 48.0), Rect2(32.0, 160.0, 32.0, 48.0)
			]
		},
		"LEAVES_LESS": {
			"Y_OFFSET": 32,
			"BLUE_ICED": [
				Rect2(128.0, 208.0, 64.0, 64.0), Rect2(192.0, 208.0, 64.0, 64.0)
			],
			"OTHERS": [
				Rect2(0.0, 208.0, 64.0, 64.0), Rect2(64.0, 208.0, 64.0, 64.0)
			]
		}
	},
	"LARGE": {
		"QUANTITY": 2,
		"WITH_LEAVES": {
			"Y_OFFSET": 15,
			"BLUE_ICED": [
				Rect2(64.0, 352.0, 32.0, 32.0), Rect2(96.0, 352.0, 32.0, 32.0)
			],
			"OTHERS": [
				Rect2(0.0, 352.0, 32.0, 32.0), Rect2(32.0, 352.0, 32.0, 32.0)
			]
		},
	}
}

#    >>  Nodes Imports
@onready var animation_player: AnimationPlayer = $Animation/AnimationPlayer
@onready var leaves_sprite: Sprite2D = $Animation/leavesSprite
@onready var log_sprite: Sprite2D = $Log
@onready var leaves_collision: Area2D = $Animation/leavesSprite/LeavesCollision
@onready var particles_leaves: CPUParticles2D = $Animation/leavesSprite/ParticlesLeaves
@onready var particles_leaves_bis: CPUParticles2D = $Animation/leavesSprite/ParticlesLeavesBis

@onready var collision_polygons: Dictionary = {
	"MEDIUM": $Animation/leavesSprite/LeavesCollision/MEDIUM_collision_polygon,
	"LARGE": $Animation/leavesSprite/LeavesCollision/LARGE_collision_polygon
}

#    >>  Variables Exports
@export var tree_type: String = "MEDIUM"
@export var sub_tree_type: String = ""

#    >>  Variables
var _player_controller: PlayerController = null
var _lvl_type: String = ""
var _is_background: bool = false
var _is_effect_applied: bool = false
var _is_player_colliding: bool = false
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _all_particles: Array[CPUParticles2D] = []
var _leaves_data: Dictionary = {}
var _logs_data: Dictionary = {}

var _current_collision_polygon: CollisionPolygon2D = null
#endregion

#                                                                
#          ██     ▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄ ▄▄▄▄   ▄▄▄▄ 
#    ▄▄▄   ██     ██ ███▄▄   ██   ██▄▄  ███▄██ ██▄▄  ██▄█▄ ███▄▄ 
#          ██████ ██ ▄▄███   ██   ██▄▄▄ ██ ▀██ ██▄▄▄ ██ ██ ▄▄███▀ 

#region Listeners

#    >>  Ready Function
func _ready() -> void:
	_cache_references()
	_initialize_trees_system()

#    >>  Process Function
func _process(delta: float) -> void:
	if not _is_background:
		_handle_leaves_collision()
#endregion

#                                                                                          
#                                                                                          
#          ██ ███  ██ ██ ██████ ██ ▄████▄ ██     ██ ▄█████ ▄████▄ ██████ ██ ▄████▄ ███  ██ 
#    ▄▄▄   ██ ██ ▀▄██ ██   ██   ██ ██▄▄██ ██     ██ ▀▀▀▄▄▄ ██▄▄██   ██   ██ ██  ██ ██ ▀▄██ 
#          ██ ██   ██ ██   ██   ██ ██  ██ ██████ ██ █████▀ ██  ██   ██   ██ ▀████▀ ██   ██ 
#                                                                                          

#region System Initialization

#    >>  Cache All References
func _cache_references() -> void:
	_all_particles = [particles_leaves, particles_leaves_bis]
	
	var root_parent: Node = get_parent().get_parent().get_parent()
	_player_controller = root_parent.find_child(PLAYER_NODE_NAME, false, true) as PlayerController
	
	var lvl_type_node: Node = root_parent.find_child(LVL_TYPE_NODE_NAME, false, true)
	if lvl_type_node and lvl_type_node.has_meta(LVL_TYPE_META_KEY):
		_lvl_type = lvl_type_node.get_meta(LVL_TYPE_META_KEY) as String

#    >>  Initialize Trees System
func _initialize_trees_system() -> void:
	if not _validate_tree_type():
		return
	
	_check_if_background()
	_cache_tree_data()
	_setup_animation()
	_setup_collision_polygon()
	_setup_particles()
	_setup_light_mask()
	_generate_random_tree()

#    >>  Validate Tree Type
func _validate_tree_type() -> bool:
	if not LEAVES_DATAS.has(tree_type):
		push_error("Invalid tree_type: " + tree_type)
		return false
	return true

#    >>  Check If Background Layer
func _check_if_background() -> void:
	var parent = get_parent().get_parent()
	_is_background = (parent.z_index == -3)

#    >>  Cache Tree Data
func _cache_tree_data() -> void:
	_leaves_data = LEAVES_DATAS[tree_type]
	_logs_data = LOGS_DATAS[tree_type]
#endregion

#                                             
#                                             
#          ▄█████ ██████ ██████ ██  ██ █████▄ 
#    ▄▄▄   ▀▀▀▄▄▄ ██▄▄     ██   ██  ██ ██▄▄█▀ 
#          █████▀ ██▄▄▄▄   ██   ▀████▀ ██     
#                                             

#region Vines Properties Setup

#    >>  Setup Animation
func _setup_animation() -> void:
	var animation_name: String = LEAVES_ANIMATION_NAMES.get(tree_type, "")
	
	if animation_name.is_empty():
		push_error("No animation found for tree_type: " + tree_type)
		return
	
	animation_player.play(animation_name)

#    >>  Setup Collision Polygon
func _setup_collision_polygon() -> void:
	_current_collision_polygon = collision_polygons.get(tree_type) as CollisionPolygon2D
	
	if _current_collision_polygon == null:
		push_error("Collision polygon not found for tree_type: " + tree_type)
		return
	
	_current_collision_polygon.disabled = false

#    >>  Setup Particles Properties
func _setup_particles() -> void:
	var particle_data: Dictionary = _leaves_data.get("PARTICLES", {})
	var shape_rect: Vector2i = particle_data.get("SHAPE_RECT", Vector2i(5, 7))
	var amount: int = particle_data.get("AMOUNT", 2)
	var texture_root: String = particle_data.get("ROOT")
	
	for particle: CPUParticles2D in _all_particles:
		particle.emission_rect_extents = shape_rect
		particle.amount = amount
		particle.texture = load(texture_root)

#    >>  Setup Light Mask from Parent
func _setup_light_mask() -> void:
	var parent = get_parent().get_parent()
	leaves_sprite.set_light_mask(parent.get_light_mask())
	log_sprite.set_light_mask(parent.get_light_mask())
#endregion

#                                                                                                                  
#                                                                                                                  
#          ██  ██ ██ ███  ██ ██████ ▄█████    ▄████  ██████ ███  ██ ██████ █████▄  ▄████▄ ██████ ██ ▄████▄ ███  ██ 
#    ▄▄▄   ██▄▄██ ██ ██ ▀▄██ ██▄▄   ▀▀▀▄▄▄   ██  ▄▄▄ ██▄▄   ██ ▀▄██ ██▄▄   ██▄▄██▄ ██▄▄██   ██   ██ ██  ██ ██ ▀▄██ 
#           ▀██▀  ██ ██   ██ ██▄▄▄▄ █████▀    ▀███▀  ██▄▄▄▄ ██   ██ ██▄▄▄▄ ██   ██ ██  ██   ██   ██ ▀████▀ ██   ██ 
#                                                                                                                  

#region Vines Generation

#    >>  Generate Random Tree
func _generate_random_tree() -> void:
	var tree_regions: Array = _get_random_tree_region()
	_apply_tree_region(tree_regions)

#    >>  Get Random Tree Region
func _get_random_tree_region() -> Array[Rect2]:
	var direction: int = _rng.randi_range(0, 1)
	var lvl_leaves_data: Dictionary = _leaves_data.get(_lvl_type, {})
	
	var selected_leaves_region = Rect2()
	var selected_log_region = Rect2()
	
	if tree_type == "MEDIUM" and sub_tree_type.is_empty() and _rng.randi_range(0, _logs_data["CHANCE_OF_LEAVES_LESS"].get(_lvl_type, 0)) == 1:
		sub_tree_type = "LEAVES_LESS"
	elif tree_type == "LARGE" or sub_tree_type.is_empty() :
		sub_tree_type = "WITH_LEAVES"
		
	var lvl_log_data: Dictionary = _logs_data.get(sub_tree_type, {})
	
	if sub_tree_type == "WITH_LEAVES":
		var leaves_regions_rects: Array = lvl_leaves_data.get("REGIONS_RECTS", [])
	
		if leaves_regions_rects.is_empty():
			push_error("No leaves regions found for level type: " + _lvl_type)
			return [Rect2(), Rect2()]
	
		selected_leaves_region = leaves_regions_rects[direction] as Rect2
		
		var logs_regions_rects: Array = lvl_log_data.get(_lvl_type, []) if _lvl_type == "BLUE_ICED" else lvl_log_data.get("OTHERS", [])
		
		if logs_regions_rects.is_empty():
			push_error("No logs regions found for level type LEAVES : " + _lvl_type)
			return [selected_leaves_region, Rect2()]
	
		selected_log_region = logs_regions_rects[direction] as Rect2
	
	elif sub_tree_type == "LEAVES_LESS":
		selected_leaves_region = Rect2(0.0, 0.0, 0.0, 0.0)
		
		var logs_regions_rects: Array = lvl_log_data.get(_lvl_type, []) if _lvl_type == "BLUE_ICED" else lvl_log_data.get("OTHERS", [])
	
		if logs_regions_rects.is_empty():
			push_error("No logs regions found for level type LEAVES_LESS : " + _lvl_type)
			return [selected_leaves_region, Rect2()]
	
		selected_log_region = logs_regions_rects[direction] as Rect2
		
	else:
			push_error("Sub tree type incorrect: " + sub_tree_type)
			return [Rect2(), Rect2()]
		
	return [selected_leaves_region, selected_log_region]

#    >>  Apply Trees Region to Sprite
func _apply_tree_region(regions: Array) -> void:
	var y_offsets: Dictionary = {"LEAVES": _leaves_data.get("Y_OFFSET", 0.0), "LOG": -_logs_data[sub_tree_type].get("Y_OFFSET", 0.0)}
	leaves_sprite.position = Vector2(0, y_offsets["LEAVES"])
	leaves_sprite.set_region_rect(regions[0])
	leaves_sprite.visible = true
	
	log_sprite.position = Vector2(0, y_offsets["LOG"])
	log_sprite.set_region_rect(regions[1])
	log_sprite.visible = true
#endregion

#                                                                                                                   
#                                                                                                                   
#          █████▄ ██     ▄████▄ ██  ██ ██████ █████▄    ████▄  ██████ ██████ ██████ ▄█████ ██████ ██ ▄████▄ ███  ██ 
#    ▄▄▄   ██▄▄█▀ ██     ██▄▄██  ▀██▀  ██▄▄   ██▄▄██▄   ██  ██ ██▄▄     ██   ██▄▄   ██       ██   ██ ██  ██ ██ ▀▄██ 
#          ██     ██████ ██  ██   ██   ██▄▄▄▄ ██   ██   ████▀  ██▄▄▄▄   ██   ██▄▄▄▄ ▀█████   ██   ██ ▀████▀ ██   ██ 
#                                                                                                                   

#region Player Collision Detection

#    >>  Player Collision Detector
func _detect_player_collision() -> void:
	_is_player_colliding = false
	
	if not leaves_collision.has_overlapping_bodies():
		return
	
	for body: Node2D in leaves_collision.get_overlapping_bodies():
		if body.name == PLAYER_NODE_NAME:
			_is_player_colliding = true
			return

#    >>  Check If Player Is Moving
func _is_player_moving() -> bool:
	if _player_controller == null:
		return false
	
	return abs(_player_controller.velocity.x) > 0.0 or abs(_player_controller.velocity.y) > 0.0
#endregion

#                                                                                                              
#                                                                                                              
#          ▄█████ ▄████▄ ██     ██     ██ ▄█████ ██ ▄████▄ ███  ██   ██████ ██████ ██████ ██████ ▄█████ ██████ 
#    ▄▄▄   ██     ██  ██ ██     ██     ██ ▀▀▀▄▄▄ ██ ██  ██ ██ ▀▄██   ██▄▄   ██▄▄   ██▄▄   ██▄▄   ██       ██   
#          ▀█████ ▀████▀ ██████ ██████ ██ █████▀ ██ ▀████▀ ██   ██   ██▄▄▄▄ ██     ██     ██▄▄▄▄ ▀█████   ██   
#                                                                                                              

#region Vines Interaction Handler

#    >>  Leaves Collision Step Handler
func _handle_leaves_collision() -> void:
	_detect_player_collision()
	
	if _is_player_colliding and _is_player_moving():
		_apply_leaves_interaction()
	else:
		_reset_leaves_interaction()

#    >>  Apply Leaves Interaction Effects
func _apply_leaves_interaction() -> void:
	if _player_controller != null:
		_player_controller.collided = false
		_apply_player_deceleration()
	
	if not _is_effect_applied:
		_activate_visual_effects()

#    >>  Reset Leaves Interaction
func _reset_leaves_interaction() -> void:
	if _is_effect_applied:
		_deactivate_visual_effects()
#endregion

#                                                                                        
#                                                                                        
#            ██  ██ ██ ███  ██ ██████ ▄█████   ██████ ██████ ██████ ██████ ▄█████ ██████ 
#      ▄▄▄   ██▄▄██ ██ ██ ▀▄██ ██▄▄   ▀▀▀▄▄▄   ██▄▄   ██▄▄   ██▄▄   ██▄▄   ██       ██   
#             ▀██▀  ██ ██   ██ ██▄▄▄▄ █████▀   ██▄▄▄▄ ██     ██     ██▄▄▄▄ ▀█████   ██   
#                                                                                        

#region Vines Effects

#    >>  Apply Player Deceleration
func _apply_player_deceleration() -> void:
	if _player_controller == null:
		return
	
	_player_controller.velocity *= Vector2(DECELERATION_MULTIPLIER, DECELERATION_MULTIPLIER)

#    >>  Activate Visual Effects
func _activate_visual_effects() -> void:
	animation_player.speed_scale = ANIMATION_SPEED_EFFECT
	_emit_particles()
	_is_effect_applied = true

#    >>  Deactivate Visual Effects
func _deactivate_visual_effects() -> void:
	animation_player.speed_scale = ANIMATION_SPEED_NORMAL
	_stop_particles()
	_is_effect_applied = false

#    >>  Emit Particles
func _emit_particles() -> void:
	var lvl_leaves_data: Dictionary = _leaves_data.get(_lvl_type, {})
	var particle_color: Color = lvl_leaves_data.get("COLOR", Color.WHITE)
	
	for particle: CPUParticles2D in _all_particles:
		particle.color = particle_color
		particle.emitting = true

#    >>  Stop Particles
func _stop_particles() -> void:
	for particle: CPUParticles2D in _all_particles:
		particle.emitting = false
#endregion

#    ███████ ███    ██ ██████                                                                                                                              
#    ██      ████   ██ ██   ██                                                                                                                             
#    █████   ██ ██  ██ ██   ██     █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ 
#    ██      ██  ██ ██ ██   ██                                                                                                                             
#    ███████ ██   ████ ██████
