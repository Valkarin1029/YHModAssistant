tool
extends VBoxContainer

signal load_mod_info(update_info_tab)
signal loaded_settings()
signal re_open_last()
signal settings_updated()
signal new_update(prerelease)

var PLUGIN_VERSION

var current_mod_path

var settings = {
	"General": {
		"NotifyOfUpdate": true,
		"NotifyOfPreRelease": false,
		"ReopenLast": false,
		"defualt_export_path": OS.get_executable_path().get_base_dir().plus_file("mods"),
		"RememberPreviousModName": true,
	},
	"Character Template": {
	},
	"Overwrites Template": {
		"add_anim_folder_overwrites": true,
	},
	"Developer": {
		"Debug": false
	},
	"Expermental": {
		"experimental": false
	}
}

func _enter_tree():
	_get_settings()
	var plugin_config = ConfigFile.new()
	if plugin_config.load("res://addons/YHMA/plugin.cfg") != OK:
		printerr("[YHMA] Could not read plugin config file")
	
	PLUGIN_VERSION = plugin_config.get_value("plugin", "version", "0.0.0")

func _ready():
	if settings["General"]["NotifyOfUpdate"]:
		_check_for_update()
	
	change_scene("Home")
	_get_settings()
	
	if settings.General['ReopenLast']:
		emit_signal("re_open_last")

func _check_for_update():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_request_completed")
	var err = http_request.request(
		"https://api.github.com/repos/{owner}/{repo}/releases/latest".format({
		"owner":"Valkarin1029",
		"repo":"YHModAssistant"
	}))
	if err != OK:
		push_warning("[YHMA] Unable to check for latest version")
	

func _request_completed(result, response_code, headers, body):
	if response_code != 200:
		push_warning("[YHMA] Failed to contact github")
		return
	
	var response = parse_json(body.get_string_from_utf8())
	
	if response["tag_name"] != PLUGIN_VERSION:
		if response["prerelease"] and not settings["General"]["NotifyOfPreRelease"]:
			return
		var cur_version = PLUGIN_VERSION.split(".", false)
		var check = response["tag_name"].split(".", false)
		
		var new_update = false
		
		for x in range(0,3):
			if int(check[x]) > int(cur_version[x]):
				new_update = true
				print("New Update")
				emit_signal("new_update", response["prerelease"])
				break
			
	
	pass


func change_scene(scene):
	if scene == null:
		printerr("[YHMA] Scene could not be loaded")
		return
	
	for node in get_children():
		if node is HTTPRequest:
			continue
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
		settings[sections].merge(new_settings[sections], true)
	
	file.close()
	emit_signal("loaded_settings")

func _create_settings_config():
	var file = File.new()
	
	if not file.open("res://addons/YHMA/settings.json", File.WRITE) == OK:
		printerr("[YHMA] Unable to make settings config file")
		return
	print("[YHMA] Creating Settings File For First Launch")
	file.store_string(JSON.print(settings, "\t"))
	file.close()
	
	
	

