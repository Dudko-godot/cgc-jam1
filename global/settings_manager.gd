extends Node

const PATH : String = 'user://settings.cfg'
const DEFAULT_ANIMATION_DURATION : float = 0.5

var config : ConfigFile = ConfigFile.new()

var is_fullscreen : bool = false : set = _set_fullscreen
var locale : String : set = _set_locale


const SUPPORTED_LOCALES : PackedStringArray = [
	'en', 'ru', 'de'
]

func _ready():
	var error = config.load(PATH)
	
	if error != OK:
		create_fresh_config()
		config.load(PATH)
		
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			self.set(key, config.get_value(section, key))


func create_fresh_config() -> void:
	var _config = ConfigFile.new()
	_config.set_value('Game', 'locale', try_to_match_locale())
	_config.set_value('Graphics', 'is_fullscreen', false)
	_config.set_value('Sound', 'volume', 0.0)
	_config.set_value('Sound', 'volume_music', 0.0)
	_config.set_value('Sound', 'volume_sfx', 0.0)
	
	config.save(PATH)
	


func _set_locale(value : String) -> void:
	locale = value
	TranslationServer.set_locale(value)
	DisplayServer.window_set_title(tr('GAME_TITLE'))
	

func _set_fullscreen(value : bool) -> void:
	if value == is_fullscreen:
		return
	is_fullscreen = value
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func save_local_values() -> void:
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			config.set_value(section, key, self.get(key))
			
	config.save(PATH)


func revert_to_original_values() -> void:
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			self.set(key, config.get_value(section, key))
	
	
func try_to_match_locale(fallback_index_ : int = 0) -> String:
	if SUPPORTED_LOCALES.has(OS.get_locale()) : return OS.get_locale()
	return SUPPORTED_LOCALES[fallback_index_]
