extends Node

# path to graphnode
var graph_node

var node_locations = {}

onready var node_tree_element: Tree = get_tree().current_scene.find_node('NodeTree', true, false)
onready var footer_node_count = get_tree().current_scene.find_node('FooterNodes', true, false)

func init_scene(e, location):
	var path = loader_singleton.node_locations[e]
	var scene = load(path + e + "/node.tscn")
	var node = scene.instance()
	var offset = Vector2(location.x, location.y)
	
	get_node(graph_node).add_child(node)
	node.set_offset(offset)
	node.set_name(node.get_name().replace('@', ''))
	node.set_meta('type', node.name)
	node.connect("gui_input", get_node(graph_node), "_on_Graph_click", [true])
	node.connect("close_request", get_node(graph_node), "_close_Request", [node])
	
	if e == 'dialogue':
		var dialogue_node = footer_node_count.get_node('Dialogue').get_node('Count')
		dialogue_node.set_text(String(int(dialogue_node.get_text()) + 1))
		
		node_tree_element.add_to_tree(e, node.get_name())
	
	return node.name

func remove_node(name):
	if 'Dialogue' in name:
		var dialogue_node = footer_node_count.get_node('Dialogue').get_node('Count')
		dialogue_node.set_text(String(int(dialogue_node.get_text()) - 1))
		
		node_tree_element.remove_from_tree('dialogue', name)

func update_name(node_name, new, node_type):
	if 'Dialogue' in node_type:
		node_tree_element.update_name(node_name, new, node_type)
