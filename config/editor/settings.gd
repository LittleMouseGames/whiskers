extends Node

onready var settings_singleton = get_node("/root/settings_singleton")

# Supported types:
# text
#	single line
# text_long
#	multi-line
# checkbox
#	checkbox
var settings = [
	{
		'name': 'Asset Name',
		'placeholder': 'Dialogue asset name',
		'type': 'line'
	},
	{
		'name': 'Asset Author',
		'placeholder': 'Asset author',
		'type': 'line'
	},
	{
		'name': 'Asset Description',
		'placeholder': 'Description of asset',
		'type': 'text'
	}
]

func _ready():
	settings_singleton.default(self.get_path(), settings)
