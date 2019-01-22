extends GraphNode

func _on_Dialogue_close_request():
	self.queue_free()
	print('removing node')

func _on_Dialogue_resize_request(new_minsize):
	self.rect_size = new_minsize

func _on_Dialogue_dragged(from, to):
	get_node('../').lastNodePosition = to

func _on_Option_dragged(from, to):
	get_node('../').lastNodePosition = to

func _on_Dialogue_resized():
	get_node("Lines").rect_min_size.y = self.get_rect().size.y - 45
