extends OptionButton

const RESOLUTIONS = {
	"3840x2160": Vector2i(3840,2160),
	"2560x1440": Vector2i(2560,1440),
	"1920x1080": Vector2i(1920,1080),
	"1600x900": Vector2i(1600,900),
	"1280x720": Vector2i(1280,720),
	"1152x648": Vector2i(1152,648),
	"1024x768": Vector2i(1024,768),
	"800x600": Vector2i(800,600),
	"640x480": Vector2i(640,480)
}


func _ready() -> void:
	clear()
	for resolution_name in RESOLUTIONS.keys():
		add_item(resolution_name)
		if get_window().size == RESOLUTIONS[resolution_name]:
			selected = item_count - 1
	item_selected.connect(on_resolution_item_selected)
	
	
func on_resolution_item_selected(index: int):
	var window_size: Vector2i = RESOLUTIONS[get_item_text(index)]
	get_window().size = window_size
	get_window().move_to_center()
	GameManager.game_settings.resolution = window_size
