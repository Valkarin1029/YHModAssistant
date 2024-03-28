tool
extends VBoxContainer

signal load_mod_info(update_info_tab)
signal loaded_settings()
signal re_open_last()
signal settings_updated()

var current_mod_path

var settings = {
	"General": {
		"ReopenLast": false,
		"defualt_export_path": OS.get_executable_path().get_base_dir().plus_file("mods"),
		"RememberPreviousModName": true,
	},
	"Character Template": {
		"char_loader_Support": true,
	},
	"Overwrites Template": {
		"add_anim_folder_overwrites": true,
	},
	"Expermental": {
		"experimental": false
	}
}

func _enter_tree():
	_get_settings()

func _ready():
	
	
	#if _check_for_update():
	#	change_scene("RestartRequired")
	#	return
	
	change_scene("Home")
	_get_settings()
	
	if settings.General['ReopenLast']:
		emit_signal("re_open_last")

func _check_for_update():
	var output = []
	var git_path = "res://addons/YHMA/Extras/PortableGit/cmd"
	var assistant_path = "res://addons/YHMA"
	git_path = ProjectSettings.globalize_path(git_path)
	assistant_path = ProjectSettings.globalize_path(assistant_path)
	
	OS.execute("CMD.exe",
			["/C", 'cd addons/YHMA && git pull'.format(
				{
					"git_path":git_path,
					"assistant_path":assistant_path
				}
			)],
			true,
			output,
			true,
			false
			)
	
	
	if not output[0].match("*Already up to date*"):
		return true
#		print(output[0])
	else:
		return false

func change_scene(scene):
	if scene == null:
		printerr("[YHMA] Scene could not be loaded")
		return
	
	for node in get_children():
		if node.name == scene:
			node.visible = true
		else:
			node.visible = false
	

func _get_settings():
	var file = File.new()
	var dir = Directory.new()
	
	if not dir.file_exists("res://addons/YHMA/settings.json"):
		_create_settings_config()
	
	if not file.open("res://addons/YHMA/settings.json", File.READ) == OK:
		printerr("[YHMA] Could not open settings json file")
		return
	
	for sections in settings:
		var new_settings = JSON.parse(file.get_as_text()).result
#		print(new_settings[sections])
		settings[sections].merge(new_settings[sections], true)
	
#	print(settings)
	file.close()
	emit_signal("loaded_settings")
#	print(settings) 

func _create_settings_config():
#	var cfg = ConfigFile.new()
	var file = File.new()
	
	if not file.open("res://addons/YHMA/settings.json", File.WRITE) == OK:
		printerr("[YHMA] Unable to make settings config file")
		return
	print("[YHMA] Creating Settings File For First Launch")
	file.store_string(JSON.print(settings, "\t"))
	file.close()
	
	
	

