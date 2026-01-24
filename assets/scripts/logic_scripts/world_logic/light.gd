#    －＞  Ｈｅａｄｅｒ
extends Node
class_name SunLight

#            /$$$$$$  /$$   /$$ /$$   /$$ /$$       /$$$$$$  /$$$$$$  /$$   /$$ /$$$$$$$$
#           /$$__  $$| $$  | $$| $$$ | $$| $$      |_  $$_/ /$$__  $$| $$  | $$|__  $$__/
#          | $$  \__/| $$  | $$| $$$$| $$| $$        | $$  | $$  \__/| $$  | $$   | $$   
#          |  $$$$$$ | $$  | $$| $$ $$ $$| $$        | $$  | $$ /$$$$| $$$$$$$$   | $$   
#           \____  $$| $$  | $$| $$  $$$$| $$        | $$  | $$|_  $$| $$__  $$   | $$   
#           /$$  \ $$| $$  | $$| $$\  $$$| $$        | $$  | $$  \ $$| $$  | $$   | $$   
#          |  $$$$$$/|  $$$$$$/| $$ \  $$| $$$$$$$$ /$$$$$$|  $$$$$$/| $$  | $$   | $$   
#           \______/  \______/ |__/  \__/|________/|______/ \______/ |__/  |__/   |__/   
#                                                                                        
#                                                                                        
#                                                                                        
#                      ╻ ╻┏━┓╻  ╺┳┓┏━┓   ┏━┓╻ ╻┏┓╻╻  ╻┏━╸╻ ╻╺┳╸╻┏━┓   ┏━┓╻ ╻┏━┓╺┳╸┏━╸┏┳┓ 
#                ╺━╸   ┣━┫┃ ┃┃   ┃┃┗━┓   ┗━┓┃ ┃┃┗┫┃  ┃┃╺┓┣━┫ ┃  ┗━┓   ┗━┓┗┳┛┗━┓ ┃ ┣╸ ┃┃┃ 
#                      ╹ ╹┗━┛┗━╸╺┻┛┗━┛   ┗━┛┗━┛╹ ╹┗━╸╹┗━┛╹ ╹ ╹  ┗━┛   ┗━┛ ╹ ┗━┛ ╹ ┗━╸╹ ╹╹

#                                                                                 
#                                                                                 
#          ████▄  ▄▄▄▄▄  ▄▄▄▄ ▄▄     ▄▄▄  ▄▄▄▄   ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄  ▄▄▄▄ 
#    ▄▄▄   ██  ██ ██▄▄  ██▀▀▀ ██    ██▀██ ██▄█▄ ██▀██  ██   ██ ██▀██ ███▄██ ███▄▄ 
#          ████▀  ██▄▄▄ ▀████ ██▄▄▄ ██▀██ ██ ██ ██▀██  ██   ██ ▀███▀ ██ ▀██ ▄▄██▀ 
#                                                                                 

#region Declarations

#    －＞  Ｃｏｎｓｔａｎｔｓ
const PLAYER_NODE_NAME: String = "player"

#    －＞  Ｎｏｄｅｓ  Ｉｍｐｏｒｔｓ
@onready var player_controller: PlayerController = get_parent().find_child(PLAYER_NODE_NAME, false, true)
@onready var light_sun: PointLight2D = $SunLight
@onready var light_sun2: PointLight2D = $SunLight2
@onready var light_sun3: PointLight2D = $SunLight3
@onready var backShadow: PointLight2D = $backGroundShadow
@onready var snow: CPUParticles2D = $snow
@onready var magic: CPUParticles2D = $magic
@onready var all_lights: Array = [light_sun, light_sun2, light_sun3, snow, magic, backShadow]

@onready var lvl_type: String = get_parent().find_child("LVL_Type", false, true).get_meta("LVL_TYPE")


#    －＞  Ｃａｃｈｅ
var _player_position_x: float = 0.0
var _is_player_moving: bool = false
#endregion

#                                                                
#                                                                
#          ██     ▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄ ▄▄▄▄   ▄▄▄▄ 
#    ▄▄▄   ██     ██ ███▄▄   ██   ██▄▄  ███▄██ ██▄▄  ██▄█▄ ███▄▄ 
#          ██████ ██ ▄▄██▀   ██   ██▄▄▄ ██ ▀██ ██▄▄▄ ██ ██ ▄▄██▀ 
#                                                                

#region Listeners

func _ready() -> void:
	if lvl_type == "BLUE_ICED":
		snow.emitting = true
	elif lvl_type == "PURPLE_ICED":
		magic.emitting = true

#    －＞  Ｐｒｏｃｅｓｓ  Ｆｕｎｃｔｉｏｎ
func _process(delta: float) -> void:
	_cache_player_state()
	
	if _is_player_moving:
		_update_lights_position()
#endregion

#                                                                                                                                         
#                                                                                                                                         
#          █████▄ ▄▄     ▄▄▄  ▄▄ ▄▄ ▄▄▄▄▄ ▄▄▄▄    ▄█████ ▄▄▄▄▄▄ ▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄   ████▄  ▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄ 
#    ▄▄▄   ██▄▄█▀ ██    ██▀██ ▀███▀ ██▄▄  ██▄█▄   ▀▀▀▄▄▄   ██  ██▀██  ██   ██▄▄    ██  ██ ██▄▄    ██   ██▄▄  ██▀▀▀   ██   ██ ██▀██ ███▄██ 
#          ██     ██▄▄▄ ██▀██   █   ██▄▄▄ ██ ██   █████▀   ██  ██▀██  ██   ██▄▄▄   ████▀  ██▄▄▄   ██   ██▄▄▄ ▀████   ██   ██ ▀███▀ ██ ▀██ 
#                                                                                                                                         

#region Player State Detector

#    －＞  Ｐｌａｙｅｒ  Ｓｔａｔｅ  Ｄｅｔｅｃｔｏｒ
func _cache_player_state() -> void:
	_player_position_x = player_controller.position.x
	_is_player_moving = player_controller.velocity.x != 0.0
#endregion

#                                                                                                         
#                                                                                                         
#          ▄█████ ▄▄ ▄▄ ▄▄  ▄▄   ▄█████ ▄▄▄▄▄▄ ▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄   ▄████▄ ▄▄▄▄  ▄▄▄▄  ▄▄    ▄▄ ▄▄▄▄▄ ▄▄▄▄  
#    ▄▄▄   ▀▀▀▄▄▄ ██ ██ ███▄██   ▀▀▀▄▄▄   ██  ██▀██  ██   ██▄▄    ██▄▄██ ██▄█▀ ██▄█▀ ██    ██ ██▄▄  ██▄█▄ 
#          █████▀ ▀███▀ ██ ▀██   █████▀   ██  ██▀██  ██   ██▄▄▄   ██  ██ ██    ██    ██▄▄▄ ██ ██▄▄▄ ██ ██ 
#                                                                                                         

#region Sun State Applier

#    －＞  Ｍｏｖｅ  Ｓｕｎ
func _update_lights_position() -> void:
	for light in all_lights:
		light.position.x = _player_position_x
#endregion

#    ███████ ███    ██ ██████                                                                                                                              
#    ██      ████   ██ ██   ██                                                                                                                             
#    █████   ██ ██  ██ ██   ██     █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ 
#    ██      ██  ██ ██ ██   ██                                                                                                                             
#    ███████ ██   ████ ██████                                                                                                                              
#                                                                                                                                                          
#                                                                                                                                                          
