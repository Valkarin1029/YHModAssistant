tool
extends VBoxContainer

signal load_mod_info(update_info_tab)

var current_mod_path

func _ready():
	var output = []
	OS.execute("CMD.exe",
	["/C", "cd addons/YHModAssistant && git pull"],
	true,
	output
	)
	
	
	if not output[0].match("*Already up to date*"):
		change_scene("RestartRequired")
		pass

func change_scene(scene):
	if scene == null:
		printerr("Scene could not be loaded -YH Assistant")
		return
	
	for node in get_children():
		if node.name == scene:
			node.visible = true
		else:
			node.visible = false
	


