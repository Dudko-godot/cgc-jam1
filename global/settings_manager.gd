extends Node

const PATH : String = 'user://settings.cfg'

var config : ConfigFile = ConfigFile.new()

## Changing any of these values immediately applies the setting
## See setters for more info
var is_fullscreen : bool = false : set = _set_fullscreen
var locale : String : set = _set_locale

var volume_master : float = 1.0 : set = _set_volume_master
var volume_music : float = 1.0 : set = _set_volume_music
var volume_sound : float = 1.0 : set = _set_volume_sound

## Yes, fetching locales isn't automated, get fucked.
var supported_locales : PackedStringArray = ['en']

func _ready():
	supported_locales = TranslationServer.get_loaded_locales()
	var error = config.load(PATH)
	
	if error != OK:
		config = create_fresh_config()
		#config.load(PATH)
		
	for _section in config.get_sections():
		for _key in config.get_section_keys(_section):
			#print('Section {section}, key {key}'.format(
				#{
					#'section' : _section,
					#'key' : _key
				#}
			#))
			self.set(_key, config.get_value(_section, _key))


func create_fresh_config() -> ConfigFile:
	print('Creating fresh config...')
	var _config = ConfigFile.new()
	
	_config.set_value('Game', 'locale', _try_to_match_locale())
	_config.set_value('Graphics', 'is_fullscreen', false)
	_config.set_value('Sound', 'volume_master', 0.5)
	_config.set_value('Sound', 'volume_music', 0.5)
	_config.set_value('Sound', 'volume_sound', 0.5)
	
	_config.save(PATH)
	return _config


func _set_locale(value_ : String) -> void:
	locale = value_
	TranslationServer.set_locale(value_)
	get_window().title = tr('GAME_TITLE')


func _set_fullscreen(value : bool) -> void:
	if value == is_fullscreen:
		return
	is_fullscreen = value
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		

func _set_volume_master(value_ : float):
	volume_master = clamp(value_, 0.0, 1.0)  # Ensure volume stays within the range
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Master'), linear_to_db(volume_master))


func _set_volume_music(value_ : float):
	volume_music = clamp(value_, 0.0, 1.0)  # Ensure volume stays within the range
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'), linear_to_db(volume_music))


func _set_volume_sound(value_ : float):
	volume_sound = clamp(value_, 0.0, 1.0)  # Ensure volume stays within the range
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Sound'), linear_to_db(volume_sound))

func save_local_values() -> void:
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			config.set_value(section, key, self.get(key))
			
	config.save(PATH)


func revert_to_original_values() -> void:
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			self.set(key, config.get_value(section, key))
	
	
func _try_to_match_locale(fallback_index_ : int = 0) -> String:
	if supported_locales.has(OS.get_locale()) : return OS.get_locale()
	return supported_locales[fallback_index_]
