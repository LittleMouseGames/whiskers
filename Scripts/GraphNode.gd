extends GraphNode

func _on_Node_close_request():
	self.queue_free()
	print('removing node')
	EditorSingleton.update_stats(self.name, '-1')
	EditorSingleton.add_history(get_type(self.name), self.name, self.get_offset(), get_text(self.name), get_node('../').get_connections(self.name), 'remove')

func _on_Node_resize_request(new_minsize):
	self.rect_size = new_minsize

func _on_Node_dragged(from, to):
	get_node('../').lastNodePosition = to
	EditorSingleton.add_history(get_type(self.name), self.name, to, get_text(self.name), get_node('../').get_connections(self.name), 'move')

func _on_Node_resized():
	get_node("Lines").rect_min_size.y = self.get_rect().size.y - 45

func _on_Node_text_changed():
	pass

func _on_Node_line_changed(text):
	var length = text.length()
	if length > 0 and text[length - 1] == ' ':
		EditorSingleton.add_history(get_type(self.name), self.name, self.get_offset(), text, get_node('../').get_connections(self.name), 'text')

func get_type(name):
	var nodes = EditorSingleton.node_names
	for i in range(0, nodes.size()):
		if name in nodes[i]:
			return nodes[i]

func get_text(name):
	if self.has_node('Lines'):
		return self.get_node('Lines').get_child(0).get_text()
	else:
		return ''

func _on_Node_raise_request():
	self.raise()
