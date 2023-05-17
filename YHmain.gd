tool
extends VBoxContainer

signal load_mod_info(update_info_tab)

var current_mod_path

func _ready():
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
	

	
