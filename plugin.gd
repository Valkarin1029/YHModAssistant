tool
extends EditorPlugin

var dock = preload("res://addons/YHModAssistant/main.tscn").instance()

const AUTOLOAD_NAME = "ExportOnRun"

func _enter_tree():
	
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, dock)

	pass


func _exit_tree():
	
	remove_control_from_docks(dock)
	
	dock.free()
	
	pass


func build():
	var autoExport = dock.get_node_or_null("ScrollContainer/VBoxContainer/Export/AutoExport")
	var exportSuccess = true
	
	if autoExport != null and autoExport.pressed:
		exportSuccess = dock.exportZip()
	
	return exportSuccess
