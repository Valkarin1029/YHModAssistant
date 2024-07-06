tool
extends "res://addons/YHMA/Menus/BaseMenu/BaseMenu.gd"

# signal LoadMod()

func _ready():
	$VBoxContainer/NewRelease.visible = false
	_set_version_label()
	_check_for_last_opened_dir()
	if YHMAGlobal != null:
		YHMAGlobal.connect("re_open_last", self, "_on_Continue_mod_pressed")
		YHMAGlobal.connect("new_update", self, "_new_update")

func _new_update(prerelease):
	$VBoxContainer/NewRelease.visible = true
	if prerelease:
		$VBoxContainer/NewRelease.text = "New Prerelease Available"

func _set_version_label():
	if YHMAGlobal != null:
		$"%AssistantVersionLabel".bbcode_text = "[center]YH Mod Assistant {version}[/center]".format(
			{"version": YHMAGlobal.PLUGIN_VERSION}
			)

func _check_for_last_opened_dir():
	$"%Continue_mod".visible = false
	var cfg = ConfigFile.new()
	var dir = Directory.new()
	cfg.load(YHMAGlobal.tempDirPath+"/SavaData.cfg")
	var last_dir = cfg.get_value("Export", "LastOpenedDir", "")
	if last_dir:
		if dir.dir_exists(last_dir):
			$"%Continue_mod".visible = true
		else:
			printerr("[YHMA] Failed to load last opened mod dir. This can be because it was removed. (Ignore if you removed the mod on purpose)")
			$"%Continue_mod".visible = false
			cfg.set_value("Export", "LastOpenedDir", null)
			cfg.save(YHMAGlobal.tempDirPath+"/SavaData.cfg")

func _on_Create_Mod_pressed():
	YHMAGlobal.change_scene("New Mod")

func _on_ChangeLog_pressed():
	YHMAGlobal.change_scene("Assistant Info")

func _on_Settings_pressed():
	YHMAGlobal.change_scene("Settings")

func _on_Select_Mod_pressed():
	$"%SelectFolder".popup()

func _on_Continue_mod_pressed():
	var cfg = ConfigFile.new()
	cfg.load(YHMAGlobal.tempDirPath+"/SavaData.cfg")
	
	if not is_valid_mod(cfg.get_value("Export", "LastOpenedDir", "")):
		printerr("[YHMA] Failed to load last opened mod dir. This can be because it was removed. (Ignore if you removed the mod on purpose)")
		$"%Continue_mod".visible = false
		return
	
	YHMAGlobal.current_mod_path = cfg.get_value("Export", "LastOpenedDir", "")
	YHMAGlobal.change_scene("Mod Editor")
	YHMAGlobal.emit_signal("load_mod_info", true)

func _on_SelectFolder_dir_selected(dir):
	var cfg = ConfigFile.new()
	if not is_valid_mod(dir):
		printerr("[YHMA] This is not a mod folder or missing modmain.gd")
		cfg.set_value("Export", "LastOpenedDir", null)
		cfg.save(YHMAGlobal.tempDirPath+"/SavaData.cfg")
		
		return
	
	YHMAGlobal.current_mod_path = dir
	
	cfg.load(YHMAGlobal.tempDirPath+"/SavaData.cfg")
	cfg.set_value("Export", "LastOpenedDir", dir)
	cfg.save(YHMAGlobal.tempDirPath+"/SavaData.cfg")
	
	$"%Continue_mod".visible = true
	
	YHMAGlobal.change_scene("Mod Editor")
	YHMAGlobal.emit_signal("load_mod_info", true)
	
	





func _on_NewRelease_pressed():
	OS.shell_open("https://github.com/Valkarin1029/YHModAssistant/releases/latest")
	pass # Replace with function body.
