extends Node

var settings ={
	"Name": {
		"placeholder": "Node Name"
	},
	"Character": {
		"type": "option",
		"character_select": true,
		"options": [
			'Test',
			'Test 2',
			'Test 3'
		]
	},
	"Dialogue": {
		"placeholder": "...",
		"type": "text"
	},
	"Comment or Description": {
		"placeholder": "...",
		"type": "text"
	}
}

# Called on node load
func _ready():
	serializer_singleton.instantiate_node(self.name, settings)

# Called when node is selected
func list_settings():
	var node_name = self.name
	settings_singleton.node_settings(settings, node_name)
