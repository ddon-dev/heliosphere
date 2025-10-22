extends OptionButton


const MODES = {
"Fullscreen": Window.MODE_FULLSCREEN,
"Windowed": Window.MODE_WINDOWED,
}
func _ready() -> void:
	item_selected.connect(on_screen_mode_selected)
	clear()
	for mode_name in MODES.keys():
		add_item(mode_name)
		if get_window().mode == MODES[mode_name]:
			selected = item_count - 1

func on_screen_mode_selected(index: int):
	match index:
		0:
			get_window().mode = Window.MODE_FULLSCREEN
			GameManager.game_settings.screen_mode = get_window().mode
		1:
			get_window().mode = Window.MODE_WINDOWED
			GameManager.game_settings.screen_mode = get_window().mode
