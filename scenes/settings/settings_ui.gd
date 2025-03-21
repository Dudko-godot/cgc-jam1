class_name SetttingsUI extends Control


@export_group('Internal References')
@export_subgroup('Settings')
@export var locale_button : OptionButton
@export var fullscreen_checkbox : CheckBox
@export var slider_volume_master : HSlider
@export var slider_volume_music : HSlider
@export var slider_volume_sound : HSlider
@export_subgroup('General Controls')
@export var button_discard : Button
@export var button_keep : Button

signal settings_closed

func _ready() -> void:
	button_discard.pressed.connect(_on_exit_requested.bind(false))
	button_keep.pressed.connect(_on_exit_requested.bind(true))
	
	locale_button.item_selected.connect(_on_locale_selected)
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	
	slider_volume_master.value_changed.connect(_on_volume_changed.bind(slider_volume_master))
	slider_volume_music.value_changed.connect(_on_volume_changed.bind(slider_volume_music))
	slider_volume_sound.value_changed.connect(_on_volume_changed.bind(slider_volume_sound))
	
	_setup_locales()


func _setup_locales() -> void:
	for locale_ : String in SettingsManager.supported_locales:
		locale_button.add_item(
			_get_native_language(TranslationServer.get_locale_name(locale_))
			)


func _on_exit_requested(were_changes_kept_ : bool = false) -> void:
	if were_changes_kept_:
		SettingsManager.save_local_values()
	else:
		SettingsManager.revert_to_original_values()
	_exit()


func enter() -> void:
	self.show()
	_set_visuals()


func _exit() -> void:
	settings_closed.emit()
	self.hide()


func _set_visuals() -> void:
	locale_button.select(SettingsManager.supported_locales.find(SettingsManager.locale))
	fullscreen_checkbox.button_pressed = SettingsManager.is_fullscreen
	
	slider_volume_master.value = SettingsManager.volume_master
	slider_volume_music.value = SettingsManager.volume_music
	slider_volume_sound.value = SettingsManager.volume_sound


func _on_locale_selected(index_ : int = 0) -> void:
	SettingsManager.locale = SettingsManager.supported_locales[index_]


func _on_fullscreen_toggled(toggled_on_ : bool = false) -> void:
	SettingsManager.is_fullscreen = toggled_on_


func _on_volume_changed(value_ : float, slider_ : HSlider) -> void:
	match slider_:
		slider_volume_master:
			SettingsManager.volume_master = value_
		slider_volume_music:
			SettingsManager.volume_music = value_
		slider_volume_sound:
			SettingsManager.volume_sound = value_


func _get_native_language(language_ : String) -> String:
	match language_:
		'English':
			return 'English'
		'German':
			return 'Deutsch'
		'Russian':
			return 'Русский'
		_:
			return language_
