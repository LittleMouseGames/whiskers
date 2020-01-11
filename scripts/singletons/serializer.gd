extends Node

# This will store all scene information
# We will later export a stripped down version
var scene = {
	'name': '',
	'author': '',
	'description': '',
	'characters': [],
	'nodes': []
}

var visual = {
	'dialogue8736': {
		'node_name': 'value'
	}
}

func save_setting(text: String, setting: String, node_name: String) -> void:
	print('Text: ', text)
	print('Setting: ', setting)
	print('Node: ', node_name)
	print('----------')
	
	if scene.nodes.has(node_name):
		if scene.nodes.node_name.has(setting): 
			# update it
			pass
		else:
			# add it
			pass
	else:
		#add it
		pass
