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
		'name': 'Character Name',
		'placeholder': 'Characters name',
		'type': 'text'
	},
	{
		'name': 'Asset Name',
		'placeholder': 'Dialogue asset name',
		'type': 'text'
	},
	{
		'name': 'Asset Description',
		'placeholder': 'Description of asset',
		'type': 'text_long'
	},
	{
		'name': 'Asset Author',
		'placeholder': 'Asset author',
		'type': 'text'
	}
]

func _ready():
	settings_singleton.save_path(self.get_path(), settings)
