extends VBoxContainer

# set data being dragged
func get_drag_data(pos):
	var prev = TextureRect.new()
	prev.texture = load("res://Assets/Node Images/expIco.png")
	set_drag_preview(prev)
	return self.get_child(0).get_text()
