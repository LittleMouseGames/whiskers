extends LineEdit

func _ready():
	self.name = String(randi() % 999999999 + 999999)
	serializer_singleton.add_character(self.name)

func _on_LineEdit_text_changed(new_text):
	serializer_singleton.character_name_change(new_text, self.name)
