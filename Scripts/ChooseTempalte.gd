tool
extends ScrollContainer

onready var makeNewMod = $"%MakeNewMod"

func _on_BlankTemplate_pressed():
	makeNewMod.mod_type = "blank"
	$"../MakeNewMod/VBoxContainer/TemplateLbl".bbcode_text = "[b][center]Making {Template} Mod[/center][/b]".format({"Template":makeNewMod.mod_type})
	self.visible = false
	makeNewMod.visible = true


func _on_CharacterTemplate_pressed():
	makeNewMod.mod_type = "character"
	$"../MakeNewMod/VBoxContainer/TemplateLbl".bbcode_text = "[b][center]Making {Template} Mod[/center][/b]".format({"Template":makeNewMod.mod_type})
	self.visible = false
	makeNewMod.visible = true


func _on_OverwritesTemplate_pressed():
	makeNewMod.mod_type = "overwrite"
	$"../MakeNewMod/VBoxContainer/TemplateLbl".bbcode_text = "[b][center]Making {Template} Mod[/center][/b]".format({"Template":makeNewMod.mod_type})
	self.visible = false
	makeNewMod.visible = true


func _on_Back_pressed():
	self.visible = false
	$"%Menu".visible = true
