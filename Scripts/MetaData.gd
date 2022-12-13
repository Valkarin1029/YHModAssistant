tool
extends VBoxContainer




onready var metaEdit = $"%metadataEditor"

func editMetaData():
	pass


func _on_EditmetaDataBtn_pressed():
	var editor = $"%metadataEditor".get_node("TextEdit")
	
	var file = File.new()
	
	var pth = $"../../..".modfldrpth
	
	
	print(pth)
	
	file.open(pth+"/_metadata", File.READ)
	
	var contents = file.get_as_text()
	
	file.close()
	
	editor.text = contents
	
	$"%metadataEditor".popup()
	



func _on_CreatemetaDataBtn_pressed():
	var file = File.new()
	var pth = $"../../..".modfldrpth
	
	var _name = "Name that others write if it's a depency" if $"../../..".mod_name == '' else $"../../..".mod_name
	
	file.open(pth+"/_metadata", file.WRITE)
	
	file.store_string("""{
	"name": "{mod_name}",
	"friendly_name": "Name that shows in modlist",
	"description": "Put your description here",
	"author": "PlaceHolder",
	"version": "0.0.0",
	"link": "",
	"id": "00001",
	"requires": [""],
	"overwrites": false,
	"client_side": false,
	"priority": 0,
}""".format({"mod_name": _name}))
	
	file.close()
	
	_on_EditmetaDataBtn_pressed()
	$"../../..".checkFormetaData()


func _on_save_pressed():
	var editor = $"%metadataEditor".get_node("TextEdit")
	var file = File.new()
	var pth = $"../../..".modfldrpth
	file.open(pth+"/_metadata", file.WRITE)
	
	file.store_string(editor.text)
	
	file.close()
	
	metaEdit.hide()


func _on_cancel_pressed():
	metaEdit.hide()






