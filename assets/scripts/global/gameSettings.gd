class_name GameSettings
extends Resource

var current_screen = DisplayServer.window_get_current_screen()
var init_res = DisplayServer.screen_get_size(current_screen)
@export var master_volume: float
@export var music_volume: float
@export var sfx_volume: float
@export var resolution: Vector2i
@export var screen_mode: Window.Mode
