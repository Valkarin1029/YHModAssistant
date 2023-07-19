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
		print(output[0])
	else:
		change_scene("Home")

func change_scene(scene):
	if scene == null:
		printerr("Scene could not be loaded -YH Assistant")
		return
	
	for node in get_children():
		if node.name == scene:
			node.visible = true
		else:
			node.visible = false
	


