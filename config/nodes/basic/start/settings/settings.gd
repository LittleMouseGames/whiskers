extends Node

var settings = {
	"Name": {
		"placeholder": "Name",
		"value": "The entry point for the asset",
		"readonly": true
	},
	"Description": {
		"placeholder": "Description",
		"value": "This node indicates the starting point for your dialogue asset",
		"readonly": true
	}
}

# Called on node load
func _ready():
	serializer_singleton.instantiate_node(self.name, settings)

# Called when node is selected
func list_settings():
	var node_name = self.name
	settings_singleton.node_settings(settings, node_name)
