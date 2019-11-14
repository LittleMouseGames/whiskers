extends Node

var settings = [
	{
		"name": "Node Name",
		"placeholder": "Node Name"
	},
	{
		"name": "Node Description",
		"placeholder": "Node Description",
		"type": "text"
	},
	{
		"name": "Node Dialogue",
		"placeholder": "Node Dialogue",
		"type": "text"
	}
]

# Called when the node enters the scene tree for the first time.
func list_settings():
	settings_singleton.node_settings(settings)
