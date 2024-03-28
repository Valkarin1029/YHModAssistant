tool
extends Control

onready var YHAGlobal = find_parent("YHMA")

func _ready():
	YHAGlobal = find_parent("YHMA")
	pass
	

func is_valid_mod(dir):
	var d = Directory.new()
	d.open(dir)
	
	if not d.list_dir_begin(true) == OK:
		printerr("[YHMA] Folder Empty")
		return
	
	while true:
		var file = d.get_next()
		
		file = file.to_lower()
		
		if file == "":
			return false
		
		if file == "modmain.gd":
			return true
		
	
