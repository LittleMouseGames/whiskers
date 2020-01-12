extends Node

# This will store all scene information
# We will later export a stripped down version
var scene = {
	'name': '',
	'author': '',
	'description': '',
	'characters': {},
	'nodes': {}
}

var visual = {
	'dialogue8736': {
		'node_name': 'value'
	}
}

func save_setting(text, setting: String, node_name: String) -> void:
	print('Text: ', text)
	print('Setting: ', setting)
	print('Node: ', node_name)
	print('----------')
	
	var node = get_node('/root/Window').find_node('GraphEdit').get_children()
	print(node)
#	for c in node.get_children():
#		if c in Label:
#			c.set_text(text)
	
	scene.nodes[node_name] = {
			setting: text
		}
