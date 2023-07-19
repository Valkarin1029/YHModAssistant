tool
extends Tabs

func _ready():
	$VBoxContainer/VBoxContainer/Button.connect("pressed", self, "open_menu")
	

func open_menu():
	$FileDialog.popup()
	



func _on_FileDialog_files_selected(paths):
	var i = 0
	for file in paths:
		var img = Image.new()
		var img_texture = ImageTexture.new()
		
		if not img.load(file) == OK: continue
		img_texture.create_from_image(img)
		
		
		
		var sprite_holder = load("res://addons/YHModAssistant/Menus/Mod Editor/Tabs/Overwrites/SpriteHolder.tscn").instance()
		var sprite = sprite_holder.get_child(0)
		
		sprite.texture = img_texture
		sprite.frame = i
		
		$VBoxContainer/VBoxContainer/HFlowContainer.add_child(sprite_holder)
		i += 1
	
	pass # Replace with function body.
