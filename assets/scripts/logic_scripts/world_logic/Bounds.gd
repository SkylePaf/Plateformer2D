#    －＞  Ｈｅａｄｅｒ
extends Area2D
class_name BoundsHandler

#           /$$$$$$$   /$$$$$$  /$$   /$$ /$$   /$$ /$$$$$$$   /$$$$$$ 
#          | $$__  $$ /$$__  $$| $$  | $$| $$$ | $$| $$__  $$ /$$__  $$
#          | $$  \ $$| $$  \ $$| $$  | $$| $$$$| $$| $$  \ $$| $$  \__/
#          | $$$$$$$ | $$  | $$| $$  | $$| $$ $$ $$| $$  | $$|  $$$$$$ 
#          | $$__  $$| $$  | $$| $$  | $$| $$  $$$$| $$  | $$ \____  $$
#          | $$  \ $$| $$  | $$| $$  | $$| $$\  $$$| $$  | $$ /$$  \ $$
#          | $$$$$$$/|  $$$$$$/|  $$$$$$/| $$ \  $$| $$$$$$$/|  $$$$$$/
#          |_______/  \______/  \______/ |__/  \__/|_______/  \______/ 
#                                                                      
#                                                                      
#                                                                      
#                      ╻ ╻┏━┓╻  ╺┳┓┏━┓   ┏┓ ┏━┓╻ ╻┏┓╻╺┳┓╻┏━┓   ╻┏┓╻╻ ╻╻┏━┓╻┏┓ ╻  ┏━╸   ╺┳╸┏━┓╻┏━╸┏━╸┏━╸┏━┓   ┏━┓╻ ╻┏━┓╺┳╸┏━╸┏┳┓ 
#                ╺━╸   ┣━┫┃ ┃┃   ┃┃┗━┓   ┣┻┓┃ ┃┃ ┃┃┗┫ ┃┃ ┗━┓   ┃┃┗┫┃┏┛┃┗━┓┃┣┻┓┃  ┣╸     ┃ ┣┳┛┃┃╺┓┃╺┓┣╸ ┣┳┛   ┗━┓┗┳┛┗━┓ ┃ ┣╸ ┃┃┃ 
#                      ╹ ╹┗━┛┗━╸╺┻┛┗━┛   ┗━┛┗━┛┗━┛╹ ╹╺┻┛ ┗━┛   ╹╹ ╹┗┛ ╹┗━┛╹┗━┛┗━╸┗━╸    ╹ ╹┗╸╹┗━┛┗━┛┗━╸╹┗╸   ┗━┛ ╹ ┗━┛ ╹ ┗━╸╹ ╹╹

#                                                                                 
#                                                                                 
#          ████▄  ▄▄▄▄▄  ▄▄▄▄ ▄▄     ▄▄▄  ▄▄▄▄   ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄  ▄▄▄▄ 
#    ▄▄▄   ██  ██ ██▄▄  ██▀▀▀ ██    ██▀██ ██▄█▄ ██▀██  ██   ██ ██▀██ ███▄██ ███▄▄ 
#          ████▀  ██▄▄▄ ▀████ ██▄▄▄ ██▀██ ██ ██ ██▀██  ██   ██ ▀███▀ ██ ▀██ ▄▄██▀ 
#                                                                                 

#region Declarations

#    －＞  Ｃｏｎｓｔａｎｔｓ
const PLAYER_NODE_NAME: String = "player"
const OPPOSITE_VELOCITY: float = 150
const BOUNCE_Y_VELOCITY: float = 50.0

#    －＞  Ｎｏｄｅｓ  Ｉｍｐｏｒｔｓ
@onready var player_controller: PlayerController = get_parent().find_child(PLAYER_NODE_NAME, false, true)

#    －＞  Ｖａｒｉａｂｌｅｓ
var has_bounced: bool = false
#endregion

#                                                                
#                                                                
#          ██     ▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄ ▄▄▄▄   ▄▄▄▄ 
#    ▄▄▄   ██     ██ ███▄▄   ██   ██▄▄  ███▄██ ██▄▄  ██▄█▄ ███▄▄ 
#          ██████ ██ ▄▄██▀   ██   ██▄▄▄ ██ ▀██ ██▄▄▄ ██ ██ ▄▄██▀ 
#                                                                

#region Listeners

#    －＞  Ｐｒｏｃｅｓｓ  Ｆｕｎｃｔｉｏｎ
func _process(delta: float) -> void:
	_handle_player_collision()
#endregion

#                                                                                                                                         
#                                                                                                                                         
#          █████▄ ▄▄     ▄▄▄  ▄▄ ▄▄ ▄▄▄▄▄ ▄▄▄▄    ████▄  ▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄ 
#    ▄▄▄   ██▄▄█▀ ██    ██▀██ ▀███▀ ██▄▄  ██▄█▄   ██  ██ ██▄▄    ██   ██▄▄  ██▀▀▀   ██   ██ ██▀██ ███▄██ 
#          ██     ██▄▄▄ ██▀██   █   ██▄▄▄ ██ ██   ████▀  ██▄▄▄   ██   ██▄▄▄ ▀████   ██   ██ ▀███▀ ██ ▀██ 
#                                                                                                                                         

#region Player Detection

#    －＞  Ｐｌａｙｅｒ  Ｄｅｔｅｃｔｏｒ
func _handle_player_collision() -> void:
	if _player_detector() and not has_bounced:
		has_bounced = true
		_apply_bounce()
		print("HUIUBBU")
		return 
	elif not _player_detector() and has_bounced:
		print("DQDQU")
		has_bounced = false
		return
#endregion

#                                                                                                
#                                                                                                
#       ▄     █████▄  ▄▄▄  ▄▄ ▄▄ ▄▄  ▄▄ ▄▄▄▄   ▄▄▄▄   ██████ ▄▄▄▄▄ ▄▄▄▄▄ ▄▄▄▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄ 
#    ▄▄▄ ▀▄   ██▄▄██ ██▀██ ██ ██ ███▄██ ██▀██ ███▄▄   ██▄▄   ██▄▄  ██▄▄  ██▄▄  ██▀▀▀   ██  ███▄▄ 
#       ▄▀    ██▄▄█▀ ▀███▀ ▀███▀ ██ ▀██ ████▀ ▄▄██▀   ██▄▄▄▄ ██    ██    ██▄▄▄ ▀████   ██  ▄▄██▀ 
#                                                                                                

#region Bounds Effect

func _player_detector() -> bool:
	for overlapped_body in get_overlapping_bodies():
		if overlapped_body.name == PLAYER_NODE_NAME:
			return true
	return false

#    －＞  Ｐｌａｙｅｒ  Ｐｕｓｈｅｒ
func _apply_bounce() -> void:
	player_controller.velocity.x = ( player_controller.lastest_x_velocity / -player_controller.lastest_x_velocity ) * OPPOSITE_VELOCITY * -1
	player_controller.velocity.y = BOUNCE_Y_VELOCITY
#endregion

#    ███████ ███    ██ ██████                                                                                                                              
#    ██      ████   ██ ██   ██                                                                                                                             
#    █████   ██ ██  ██ ██   ██     █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ 
#    ██      ██  ██ ██ ██   ██                                                                                                                             
#    ███████ ██   ████ ██████                                                                                                                              
#                                                                                                                                                          
#                                                                                                                                                          
