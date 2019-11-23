extends Node

# path to graphnode
var graph_node

func init_scene(e, location):
	var scene = load("res://config/nodes/" + e + "/node.tscn")
	var node = scene.instance()
	var offset = Vector2(location.x, location.y)
	
	get_node(graph_node).add_child(node)
	node.set_offset(offset)
	node.set_name(node.get_name().replace('@', ''))
	node.connect("gui_input", get_node(graph_node), "_on_Graph_click", [true])
	node.connect("close_request", get_node(graph_node), "_close_Request", [node])
	
	return node.name
