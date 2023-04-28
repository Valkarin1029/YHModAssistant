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
	var autoExport = dock.find_node("AutoExport")
	var Export = dock.find("Export")
	var exportSuccess = false
	
	if autoExport == null:
		printerr("Auto Export Button not found -YH Assistant")
		return false
	
	if autoExport.pressed:
		exportSuccess = Export.exportZip()
	else:
		exportSuccess = true
	
	return exportSuccess
