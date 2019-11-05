extends Node

onready var settings_singleton = get_node("/root/settings_singleton")

func _ready():
	settings_singleton.save_path(self.get_path())
