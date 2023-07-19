tool
extends "res://addons/YHModAssistant/Menus/BaseMenu/BaseMenu.gd"



func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)
