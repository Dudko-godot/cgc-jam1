class_name SetttingsUI extends Control


@export_group('Internal References')
@export_subgroup('Settings')
@export var locale_button : OptionButton
@export var fullscreen_checkbox : CheckBox
@export_subgroup('General Controls')
@export var button_discard : Button
@export var button_keep : Button

signal settings_closed

func _ready() -> void:
	button_discard.pressed.connect(_on_exit_requested.bind(false))
	button_keep.pressed.connect(_on_exit_requested.bind(true))
	
	locale_button.item_selected.connect(_on_locale_selected)
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	


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
	locale_button.select(SettingsManager.SUPPORTED_LOCALES.find(SettingsManager.locale))
	fullscreen_checkbox.button_pressed = SettingsManager.is_fullscreen


func _on_locale_selected(index_ : int = 0) -> void:
	SettingsManager.locale = SettingsManager.SUPPORTED_LOCALES[index_]


func _on_fullscreen_toggled(toggled_on_ : bool = false) -> void:
	SettingsManager.is_fullscreen = toggled_on_
