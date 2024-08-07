tool
extends Tabs

onready var YHMAGlobal = find_parent("YHMA")

var current_mod_path = null


func _ready():
	YHMAGlobal = find_parent("YHMA")
	if not YHMAGlobal == null:
		current_mod_path = YHMAGlobal.current_mod_path
		YHMAGlobal.connect("load_mod_info", self, "_load_mod_info_from_metadata")
	
	

func _on_ApplyMeta_pressed():
	YHMAGlobal = find_parent("YHMA")
	current_mod_path = YHMAGlobal.current_mod_path
	
	var meta_data_path = current_mod_path.plus_file("_metadata")
	
	var dir = Directory.new()
	var file = File.new()
	
	var required_mods = [""]
	
	for required in $"%Required".text.split(",", false):
		
		required = required.strip_edges()
		
		if required_mods[0] == "":
			required_mods.pop_front()
			required_mods.append(required)
			continue
		
		required_mods.append(required)
	
	var new_meta = {
		"friendly_name": $"%FriendlyName".text,
		"name": $"%Name".text,
		"description": $"%Description".text,
		"version": $"%Version".text,
		"author": $"%Author".text,
		"client_side": $"%Client Side".pressed,
		"overwrites": $"%Overwrites".pressed,
		"requires": required_mods,
		"priority": $"%Priority".value,
		"id": 12345,
		"link": "",
	}
	
	if dir.file_exists(meta_data_path):
		file.open(meta_data_path,File.READ)
		var contents = JSON.parse(file.get_as_text()).result
		file.close()
		
		contents.merge(new_meta, true)
		
		file.open(meta_data_path, File.WRITE)
		file.store_string(JSON.print(contents, "\t"))
		file.close()
		
		print("[YHMA] Metadata updated")
		
	else:
		print("[YHMA] Making new metadata")
		file.open(meta_data_path, File.WRITE)
		file.store_string(JSON.print(new_meta, "\t"))
		file.close()
	
	YHMAGlobal.emit_signal("load_mod_info", false)

func _load_mod_info_from_metadata(updateInfo):
	YHMAGlobal = find_parent("YHMA")
	current_mod_path = YHMAGlobal.current_mod_path
	
	if not updateInfo:
		return
	
	var meta_data_path = current_mod_path.plus_file("_metadata")
	
	var dir = Directory.new()
	var file = File.new()
	
	
	if dir.file_exists(meta_data_path):
		file.open(meta_data_path,File.READ)
		var contents = JSON.parse(file.get_as_text()).result
		file.close()
		
		
		$"%FriendlyName".text = contents.friendly_name if not null else ""
		$"%Name".text = contents.name if not null else ""
		$"%Description".text = contents.description if not null else ""
		$"%Version".text = contents.version if not null else ""
		$"%Author".text = contents.author if not null else ""
		$"%Required".text = PoolStringArray(contents.requires).join(', ') if not null else ""
		$"%Priority".value = contents.priority if not null else 0
		$"%Client Side".pressed = contents.client_side if not null else false
		$"%Overwrites".pressed = contents.overwrites if not null else false
	
		print("[YHMA] Loaded Meta Data")
	else:
		printerr("[YHMA] No Metadata to load from")


func _on_FriendlyName_text_changed(new_text):
	if new_text == "" or $"%Name".text == "":
		$"%ApplyMeta".disabled = true
		$"%InputModName".visible = true
	else:
		$"%ApplyMeta".disabled = false
		$"%InputModName".visible = false



func _on_Name_text_changed(new_text):
	if new_text == "" or $"%FriendlyName".text == "":
		$"%ApplyMeta".disabled = true
		$"%InputModName".visible = true
	else:
		$"%ApplyMeta".disabled = false
		$"%InputModName".visible = false
