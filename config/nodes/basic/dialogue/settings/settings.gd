extends Node

var settings = [
	{
		"name": "Name",
		"placeholder": "Node Name"
	},
	{
		"name": "Character",
		"type": "option",
		"character_select": true,
		"options": [
			'Test',
			'Test 2',
			'Test 3'
		]
	},
	{
		"name": "Dialogue",
		"placeholder": "...",
		"type": "text"
	},
	{
		"name": "Comment / Description",
		"placeholder": "...",
		"type": "text"
	}
]

# Called when the node enters the scene tree for the first time.
func list_settings():
	var node_name = self.name
	settings_singleton.node_settings(settings, node_name)
