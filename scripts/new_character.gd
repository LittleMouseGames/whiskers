extends Button

func _on_Button_pressed():
	var container = self.get_parent().get_parent().get_node("Container")
	var node = container.get_child(0).duplicate()
	node.set('custom_constants/margin_top', 0)
	node.get_child(0).get_child(1).text = ''
	
	container.add_child(node)
	
