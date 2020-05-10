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

func instantiate_node(node_name, settings):
	node_name = node_name.replace('@', '')
	scene.nodes[node_name] = settings

func save_setting(text, setting: String, node_name: String) -> void:
	if !text:
		text = settings_singleton.get_value(setting)

#	print('Text: ', text)
#	print('Setting: ', setting)
#	print('Node: ', node_name)
#	print('----------')
	
	# TODO: Clean up
	if setting == 'Name':
		var node = get_node('/root/Window').find_node('GraphEdit').get_node(node_name)
		node.find_node('Label', true).set_text(text)
		loader_singleton.update_name(node_name, text, node.get_meta('type'))
	
	scene.nodes[node_name][setting]['value'] = text

func save_selection(id, setting, node_name):
	scene.nodes[node_name][setting]['value'] = id

func add_character(node_name):
	scene.characters[node_name] = {'name': ''}
	
func character_name_change(text, node_name):
	scene.characters[node_name].name = text

func remove_character(node):
	scene.characters.erase(node)

func get_characters():
	return scene.characters
