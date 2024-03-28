tool
extends "res://addons/YHMA/Menus/BaseMenu/BaseMenu.gd"

# signal LoadMod()

func _ready():
	_set_version_label()
	_check_for_last_opened_dir()
	YHAGlobal.connect("re_open_last", self, "_on_Continue_mod_pressed")

func _set_version_label():
	var dir = Directory.new()
	var plugin_config = ConfigFile.new()
	if plugin_config.load("res://addons/YHMA/plugin.cfg") != OK:
		printerr("Could not read config file -YH Mod Assistant")
	
	$"%AssistantVersionLabel".bbcode_text = "[center]YH Mod Assistant {version}[/center]".format(
		{"version": plugin_config.get_value("plugin", "version")}
		)

func _check_for_last_opened_dir():
	var cfg = ConfigFile.new()
	var dir = Directory.new()
	cfg.load("res://addons/YHMA/SaveData.cfg")
	var last_dir = cfg.get_value("Export", "LastOpenedDir", "")
	if last_dir:
		if dir.dir_exists(last_dir):
			$"%Continue_mod".visible = true
		else:
			printerr("Failed to load last opened mod dir. This can be because it was removed. (Ignore if you removed the mod on purpose) - YH Mod Assistant")
			cfg.set_value("Export", "LastOpenedDir", null)
			cfg.save("res://addons/YHMA/SaveData.cfg")

func _on_Create_Mod_pressed():
	YHAGlobal.change_scene("New Mod")

func _on_ChangeLog_pressed():
	YHAGlobal.change_scene("Assistant Info")

func _on_Settings_pressed():
	YHAGlobal.change_scene("Settings")

func _on_Select_Mod_pressed():
	$"%SelectFolder".popup()

func _on_Continue_mod_pressed():
	var cfg = ConfigFile.new()
	cfg.load("res://addons/YHMA/SaveData.cfg")
	
	if not is_valid_mod(cfg.get_value("Export", "LastOpenedDir", "")):
		printerr("Failed to load last opened mod dir. This can be because it was removed. (Ignore if you removed the mod on purpose) - YH Mod Assistant")
		$"%Continue_mod".visible = false
		return
	
	YHAGlobal.current_mod_path = cfg.get_value("Export", "LastOpenedDir", "")
	YHAGlobal.change_scene("Mod Editor")
	YHAGlobal.emit_signal("load_mod_info", true)

func _on_SelectFolder_dir_selected(dir):
	var cfg = ConfigFile.new()
	if not is_valid_mod(dir):
		printerr("This is not a mod folder or missing modmain.gd -YH Assistant")
		cfg.set_value("Export", "LastOpenedDir", null)
		cfg.save("res://addons/YHMA/SaveData.cfg")
		
		return
	
	YHAGlobal.current_mod_path = dir
	
	cfg.load("res://addons/YHMA/SaveData.cfg")
	cfg.set_value("Export", "LastOpenedDir", dir)
	cfg.save("res://addons/YHMA/SaveData.cfg")
	
	$"%Continue_mod".visible = true
	
	YHAGlobal.change_scene("Mod Editor")
	YHAGlobal.emit_signal("load_mod_info", true)
	
	



