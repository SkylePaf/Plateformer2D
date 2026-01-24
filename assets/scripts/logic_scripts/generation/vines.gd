#    >>  Header
@tool
extends Node2D
class_name VinesGeneration

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

const VINES_ANIMATION_NAMES: Dictionary = {
	"SMALL": "vines_small",
	"MEDIUM_SMALL": "vines_small",
	"LARGE_SMALL": "vines_small",
	"MEDIUM": "vines_medium",
	"LARGE": "vines_large"
}

const VINES_DATAS: Dictionary = {
	"SMALL": {
		"QUANTITY": 8,
		"Y_OFFSET": 16.0,
		"PARTICLES": {
			"SHAPE_RECT": Vector2i(5, 7),
			"AMOUNT": 2
		},
		"REGULAR_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 0.0, 16.0, 32.0), Rect2(16.0, 0.0, 16.0, 32.0),
				Rect2(32.0, 0.0, 16.0, 32.0), Rect2(48.0, 0.0, 16.0, 32.0),
				Rect2(64.0, 0.0, 16.0, 32.0), Rect2(80.0, 0.0, 16.0, 32.0),
				Rect2(96.0, 0.0, 16.0, 32.0), Rect2(112.0, 0.0, 16.0, 32.0)
			],
			"COLOR": Color(0.545, 0.713, 0.466)
		},
		"BLUE_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 112.0, 16.0, 32.0), Rect2(16.0, 112.0, 16.0, 32.0),
				Rect2(32.0, 112.0, 16.0, 32.0), Rect2(48.0, 112.0, 16.0, 32.0),
				Rect2(64.0, 112.0, 16.0, 32.0), Rect2(80.0, 112.0, 16.0, 32.0),
				Rect2(96.0, 112.0, 16.0, 32.0), Rect2(112.0, 112.0, 16.0, 32.0)
			],
			"COLOR": Color(0.341, 0.464, 0.874)
		},
		"PURPLE_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 224.0, 16.0, 32.0), Rect2(16.0, 224.0, 16.0, 32.0),
				Rect2(32.0, 224.0, 16.0, 32.0), Rect2(48.0, 224.0, 16.0, 32.0),
				Rect2(64.0, 224.0, 16.0, 32.0), Rect2(80.0, 224.0, 16.0, 32.0),
				Rect2(96.0, 224.0, 16.0, 32.0), Rect2(112.0, 224.0, 16.0, 32.0)
			],
			"COLOR": Color(0.482, 0.345, 0.662)
		}
	},
	"MEDIUM_SMALL": {
		"QUANTITY": 4,
		"Y_OFFSET": 16.0,
		"PARTICLES": {
			"SHAPE_RECT": Vector2i(15, 7),
			"AMOUNT": 4
		},
		"REGULAR_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 0.0, 32.0, 32.0), Rect2(32.0, 0.0, 32.0, 32.0),
				Rect2(64.0, 0.0, 32.0, 32.0), Rect2(96.0, 0.0, 32.0, 32.0)
			],
			"COLOR": Color(0.545, 0.713, 0.466)
		},
		"BLUE_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 112.0, 32.0, 32.0), Rect2(32.0, 112.0, 32.0, 32.0),
				Rect2(64.0, 112.0, 32.0, 32.0), Rect2(96.0, 112.0, 32.0, 32.0)
			],
			"COLOR": Color(0.341, 0.464, 0.874)
		},
		"PURPLE_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 224.0, 32.0, 32.0), Rect2(32.0, 224.0, 32.0, 32.0),
				Rect2(64.0, 224.0, 32.0, 32.0), Rect2(96.0, 224.0, 32.0, 32.0),
			],
			"COLOR": Color(0.482, 0.345, 0.662)
		}
	},
	"LARGE_SMALL": {
		"QUANTITY": 1,
		"Y_OFFSET": 16.0,
		"PARTICLES": {
			"SHAPE_RECT": Vector2i(30, 7),
			"AMOUNT": 6
		},
		"REGULAR_ICED": {
			"REGIONS_RECTS": [Rect2(144.0, 0.0, 80.0, 32.0)],
			"COLOR": Color(0.545, 0.713, 0.466)
		},
		"BLUE_ICED": {
			"REGIONS_RECTS": [Rect2(144.0, 112.0, 80.0, 32.0)],
			"COLOR": Color(0.341, 0.464, 0.874)
		},
		"PURPLE_ICED": {
			"REGIONS_RECTS": [Rect2(32.0, 224.0, 16.0, 16.0)],
			"COLOR": Color(0.482, 0.345, 0.662)
		}
	},
	"MEDIUM": {
		"QUANTITY": 4,
		"Y_OFFSET": 24.0,
		"PARTICLES": {
			"SHAPE_RECT": Vector2i(5, 15),
			"AMOUNT": 4
		},
		"REGULAR_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 64.0, 32.0, 48.0), Rect2(32.0, 64.0, 32.0, 48.0),
				Rect2(64.0, 64.0, 32.0, 48.0), Rect2(96.0, 64.0, 32.0, 48.0)
			],
			"COLOR": Color(0.545, 0.713, 0.466)
		},
		"BLUE_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 176.0, 32.0, 48.0), Rect2(32.0, 176.0, 32.0, 48.0),
				Rect2(64.0, 176.0, 32.0, 48.0), Rect2(96.0, 176.0, 32.0, 48.0)
				],
			"COLOR": Color(0.341, 0.464, 0.874)
		},
		"PURPLE_ICED": {
			"REGIONS_RECTS": [
				Rect2(0.0, 288.0, 32.0, 48.0), Rect2(32.0, 288.0, 32.0, 48.0),
				Rect2(64.0, 288.0, 32.0, 48.0), Rect2(96.0, 288.0, 32.0, 48.0)
			],
			"COLOR": Color(0.482, 0.345, 0.662)
		}
	},
	"LARGE": {
		"QUANTITY": 4,
		"Y_OFFSET": 32.0,
		"PARTICLES": {
			"SHAPE_RECT": Vector2i(5, 25),
			"AMOUNT": 6
		},
		"REGULAR_ICED": {
			"REGIONS_RECTS": [
				Rect2(128.0, 48.0, 48.0, 64.0), Rect2(176.0, 48.0, 48.0, 64.0),
				Rect2(224.0, 48.0, 48.0, 64.0), Rect2(272.0, 48.0, 48.0, 64.0)
			],
			"COLOR": Color(0.545, 0.713, 0.466)
		},
		"BLUE_ICED": {
			"REGIONS_RECTS": [
				Rect2(128.0, 160.0, 48.0, 64.0), Rect2(176.0, 160.0, 48.0, 64.0),
				Rect2(224.0, 160.0, 48.0, 64.0), Rect2(272.0, 160.0, 48.0, 64.0)
			],
			"COLOR": Color(0.341, 0.464, 0.874)
		},
		"PURPLE_ICED": {
			"REGIONS_RECTS": [
				Rect2(128.0, 272.0, 48.0, 64.0), Rect2(176.0, 272.0, 48.0, 64.0),
				Rect2(224.0, 272.0, 48.0, 64.0), Rect2(272.0, 272.0, 48.0, 64.0)
			],
			"COLOR": Color(0.482, 0.345, 0.662)
		}
	}
}

#    >>  Nodes Imports
@onready var animation_player: AnimationPlayer = $Animation/AnimationPlayer
@onready var vines_sprite: Sprite2D = $Animation/vinesSprite
@onready var vines_collision: Area2D = $Animation/vinesSprite/VinesCollision
@onready var particles_vines: CPUParticles2D = $Animation/vinesSprite/ParticlesVines
@onready var particles_vines_bis: CPUParticles2D = $Animation/vinesSprite/ParticlesVinesBis

@onready var collision_polygons: Dictionary = {
	"SMALL": $Animation/vinesSprite/VinesCollision/SMALL_collision_polygon,
	"MEDIUM_SMALL": $Animation/vinesSprite/VinesCollision/MEDIUM_SMALL_collision_polygon,
	"LARGE_SMALL": $Animation/vinesSprite/VinesCollision/LARGE_SMALL_collision_polygon,
	"MEDIUM": $Animation/vinesSprite/VinesCollision/MEDIUM_collision_polygon,
	"LARGE": $Animation/vinesSprite/VinesCollision/LARGE_collision_polygon
}

#    >>  Variables Exports
@export var vines_type: String = "SMALL"

#    >>  Variables
var _player_controller: PlayerController = null
var _lvl_type: String = ""
var _is_background: bool = false
var _is_effect_applied: bool = false
var _is_player_colliding: bool = false
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _all_particles: Array[CPUParticles2D] = []
var _vines_data: Dictionary = {}
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
	_initialize_vines_system()

#    >>  Process Function
func _process(delta: float) -> void:
	if not _is_background:
		_handle_vines_collision()
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
	_all_particles = [particles_vines, particles_vines_bis]
	
	var root_parent: Node = get_parent().get_parent().get_parent()
	_player_controller = root_parent.find_child(PLAYER_NODE_NAME, false, true) as PlayerController
	
	var lvl_type_node: Node = root_parent.find_child(LVL_TYPE_NODE_NAME, false, true)
	if lvl_type_node and lvl_type_node.has_meta(LVL_TYPE_META_KEY):
		_lvl_type = lvl_type_node.get_meta(LVL_TYPE_META_KEY) as String

#    >>  Initialize Vines System
func _initialize_vines_system() -> void:
	if not _validate_vines_type():
		return
	
	_check_if_background()
	_cache_vines_data()
	_setup_animation()
	_setup_collision_polygon()
	_setup_particles()
	_setup_light_mask()
	_generate_random_vines()

#    >>  Validate Vines Type
func _validate_vines_type() -> bool:
	if not VINES_DATAS.has(vines_type):
		push_error("Invalid vines_type: " + vines_type)
		return false
	return true

#    >>  Check If Background Layer
func _check_if_background() -> void:
	var parent = get_parent().get_parent()
	_is_background = (parent.z_index == -2)

#    >>  Cache Vines Data
func _cache_vines_data() -> void:
	_vines_data = VINES_DATAS[vines_type]
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
	var animation_name: String = VINES_ANIMATION_NAMES.get(vines_type, "")
	
	if animation_name.is_empty():
		push_error("No animation found for vines_type: " + vines_type)
		return
	
	animation_player.play(animation_name)

#    >>  Setup Collision Polygon
func _setup_collision_polygon() -> void:
	_current_collision_polygon = collision_polygons.get(vines_type) as CollisionPolygon2D
	
	if _current_collision_polygon == null:
		push_error("Collision polygon not found for vines_type: " + vines_type)
		return
	
	_current_collision_polygon.disabled = false

#    >>  Setup Particles Properties
func _setup_particles() -> void:
	var particle_data: Dictionary = _vines_data.get("PARTICLES", {})
	var shape_rect: Vector2i = particle_data.get("SHAPE_RECT", Vector2i(5, 7))
	var amount: int = particle_data.get("AMOUNT", 2)
	
	for particle: CPUParticles2D in _all_particles:
		particle.emission_rect_extents = shape_rect
		particle.amount = amount

#    >>  Setup Light Mask from Parent
func _setup_light_mask() -> void:
	var parent = get_parent().get_parent()
	vines_sprite.set_light_mask(parent.get_light_mask())
#endregion

#                                                                                                                  
#                                                                                                                  
#          ██  ██ ██ ███  ██ ██████ ▄█████    ▄████  ██████ ███  ██ ██████ █████▄  ▄████▄ ██████ ██ ▄████▄ ███  ██ 
#    ▄▄▄   ██▄▄██ ██ ██ ▀▄██ ██▄▄   ▀▀▀▄▄▄   ██  ▄▄▄ ██▄▄   ██ ▀▄██ ██▄▄   ██▄▄██▄ ██▄▄██   ██   ██ ██  ██ ██ ▀▄██ 
#           ▀██▀  ██ ██   ██ ██▄▄▄▄ █████▀    ▀███▀  ██▄▄▄▄ ██   ██ ██▄▄▄▄ ██   ██ ██  ██   ██   ██ ▀████▀ ██   ██ 
#                                                                                                                  

#region Vines Generation

#    >>  Generate Random Vines
func _generate_random_vines() -> void:
	var vines_region: Rect2 = _get_random_vines_region()
	_apply_vines_region(vines_region)

#    >>  Get Random Vines Region
func _get_random_vines_region() -> Rect2:
	var lvl_data: Dictionary = _vines_data.get(_lvl_type, {})
	var regions_rects: Array = lvl_data.get("REGIONS_RECTS", [])
	
	if regions_rects.is_empty():
		push_error("No regions found for level type: " + _lvl_type)
		return Rect2()
	
	var quantity: int = _vines_data.get("QUANTITY", 1)
	var random_index: int = _rng.randi_range(0, quantity - 1)
	random_index = clampi(random_index, 0, regions_rects.size() - 1)
	
	return regions_rects[random_index] as Rect2

#    >>  Apply Vines Region to Sprite
func _apply_vines_region(region: Rect2) -> void:
	var y_offset: float = _vines_data.get("Y_OFFSET", 16.0)
	vines_sprite.position = Vector2(0, y_offset)
	vines_sprite.set_region_rect(region)
	vines_sprite.visible = true
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
	
	if not vines_collision.has_overlapping_bodies():
		return
	
	for body: Node2D in vines_collision.get_overlapping_bodies():
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

#    >>  Vines Collision Step Handler
func _handle_vines_collision() -> void:
	_detect_player_collision()
	
	if _is_player_colliding and _is_player_moving():
		_apply_vines_interaction()
	else:
		_reset_vines_interaction()

#    >>  Apply Vines Interaction Effects
func _apply_vines_interaction() -> void:
	if _player_controller != null:
		_player_controller.collided = false
		_apply_player_deceleration()
	
	if not _is_effect_applied:
		_activate_visual_effects()

#    >>  Reset Vines Interaction
func _reset_vines_interaction() -> void:
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
	var lvl_data: Dictionary = _vines_data.get(_lvl_type, {})
	var particle_color: Color = lvl_data.get("COLOR", Color.WHITE)
	
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
