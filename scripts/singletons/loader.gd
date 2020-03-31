extends Node

# path to graphnode
var graph_node

var node_locations = {}

onready var node_tree_element: Tree = get_tree().current_scene.find_node('NodeTree', true, false)
onready var tree_item_script = load("res://scripts/settings/TreeItem.gd")

func init_scene(e, location):
	var path = loader_singleton.node_locations[e]
	var scene = load(path + e + "/node.tscn")
	var node = scene.instance()
	var offset = Vector2(location.x, location.y)
	
	get_node(graph_node).add_child(node)
	node.set_offset(offset)
	node.set_name(node.get_name().replace('@', ''))
	node.connect("gui_input", get_node(graph_node), "_on_Graph_click", [true])
	node.connect("close_request", get_node(graph_node), "_close_Request", [node])
	
	var tree_item = node_tree_element.create_item()
	tree_item.set_text(0, node.get_name())
	tree_item.set_script(tree_item_script)
	
	return node.name

func remove_node(name):
	var child = node_tree_element.get_root().get_children()
	while child != null:

		if child.get_text(0) == name:
			node_tree_element.get_root().remove_child(child)
			node_tree_element.update()
		
		child = child.get_next()

func update_name(node_name, new): 
	var child = node_tree_element.get_root().get_children()
	while child != null:
		if child.get_text(0) == node_name or child.node_name == node_name:
			child.node_name = node_name
			child.set_text(0, new)
			node_tree_element.update()
		
		child = child.get_next()
