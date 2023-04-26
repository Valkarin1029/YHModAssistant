tool
extends VBoxContainer

onready var YHGlobal = get_node("..")

export(PackedScene) var next_scene
export(PackedScene) var previous_scene

func _ready():
	while YHGlobal.name != "YH Mod Assistant":
		YHGlobal = YHGlobal.get_parant()
	
