tool
extends VBoxContainer

var current_mod_path

func _ready():
	pass

func change_scene(nodeName):
	for node in get_children():
		if node.name == nodeName:
			node.visible = true
		else:
			node.visible = false
		
	
