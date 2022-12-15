tool
extends ScrollContainer

onready var main = get_parent()

onready var Export = get_node("VBoxContainer/Export")

signal modfldrPathUpdated

func _on_ModNameTB_text_changed(new_text):
	main.mod_name = new_text
	Export._update_auto_export()

func _on_MakeCFG_pressed():
	Export._create_cfg()

func _on_ClearExportFolderBtn_pressed():
	$"%ClearExportFolder".popup()

func _on_Update_pressed():
	var folderpath = ProjectSettings.globalize_path("res://addons/YHModAssistant")
#	var folderpath = "C:/Users/lucer/Downloads/YHModAssistant"
	var output = []
	OS.execute("cmd.exe", ['/c','cd "{path}" && git pull'.format({'path':folderpath})], true, output, true, true)
	OS.execute("cmd.exe", ['/c', 'cd "%s" && %s' % [OS.get_executable_path().get_base_dir(), OS.get_executable_path().get_file()]])
	OS.kill(OS.get_process_id())

func _on_OpenExportFolder_pressed():
	OS.shell_open(main.EXPORTPATH)


func _on_FolderBrowseButton_pressed():
	$"%ModFolderPath".popup()


func _on_Folderpth_text_changed(new_text):
	main.modfldrpth = new_text
	emit_signal("modfldrPathUpdated")
	Export._update_auto_export()





func _on_UI_modfldrPathUpdated():
	if main.modfldrpth == '':
		$"%MakeTemplate".visible = true
	else:
		$"%MakeTemplate".visible = false
