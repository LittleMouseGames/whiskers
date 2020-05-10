extends Node

onready var settings_singleton = get_node("/root/settings_singleton")

# Supported types:
# line
#	single line
# text
#	multi-line
# checkbox
#	checkbox
var settings = {
	'Asset Name': {
		'placeholder': 'Dialogue asset name',
		'type': 'line'
	},
	'Asset Author': {
		'placeholder': 'Asset author',
		'type': 'line'
	},
	'Asset Description': {
		'placeholder': '...',
		'type': 'text'
	}
}

func _ready():
	settings_singleton.default(self.get_path(), settings)
	serializer_singleton.instantiate_node('editor', settings)
