extends Node

var settings = [
	{
		"name": "Node Name",
		"placeholder": "Node Name",
		"value": "The entry point for the asset",
		"readonly": false
	},
	{
		"name": "Node Description",
		"placeholder": "Node Description",
		"value": "This node indicates the starting point for your dialogue asset",
		"readonly": false
	}
]

# Called when the node enters the scene tree for the first time.
func list_settings():
	var node_name = self.name
	settings_singleton.node_settings(settings, node_name)
