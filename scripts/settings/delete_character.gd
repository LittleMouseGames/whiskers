extends MarginContainer

func _on_FontAwesome_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if self.get_parent().get_child_count() > 1:
				if self.get_parent().get_child(0).name == self.name:
					self.get_parent().get_child(1).set('custom_constants/margin_top', 8)
				self.queue_free()
