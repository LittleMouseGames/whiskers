extends ItemList

# set data being dragged, in this case "good stuff"
func get_drag_data(_pos):
	var selected = get_selected_items()
	var prev = TextureRect.new()
	prev.texture = get_item_icon(selected[0])
	set_drag_preview(prev)
	return get_item_text(selected[0])