extends VBoxContainer

@onready var vol_mas: HSlider = %vol_mas
@onready var vol_mus: HSlider = %vol_mus
@onready var vol_sfx: HSlider = %vol_sfx
@export var sfx_pressed: AudioStreamPlayer


enum AUDIOBUS {
	master = 0,
	music = 1,
	sfx = 2,
}


func _ready() -> void:
	vol_mas.value_changed.connect(on_vol_mas_changed)
	vol_mas.value = AudioServer.get_bus_volume_linear(AUDIOBUS.master)
	vol_mas.drag_started.connect(sfx_play)
	vol_mus.value_changed.connect(on_vol_mus_changed)
	vol_mus.value = AudioServer.get_bus_volume_linear(AUDIOBUS.music)
	vol_mus.drag_started.connect(sfx_play)
	vol_sfx.value_changed.connect(on_vol_sfx_changed)
	vol_sfx.value = AudioServer.get_bus_volume_linear(AUDIOBUS.sfx)
	vol_sfx.drag_started.connect(sfx_play)

func on_vol_mas_changed(new_value):
	AudioServer.set_bus_volume_linear(AUDIOBUS.master, new_value)
	GameManager.game_settings.master_volume = new_value
	
func on_vol_mus_changed(new_value):
	AudioServer.set_bus_volume_linear(AUDIOBUS.music, new_value)
	GameManager.game_settings.music_volume = new_value
	
func on_vol_sfx_changed(new_value):
	AudioServer.set_bus_volume_linear(AUDIOBUS.sfx, new_value)
	GameManager.game_settings.sfx_volume = new_value
	
func sfx_play():
	sfx_pressed.play()
