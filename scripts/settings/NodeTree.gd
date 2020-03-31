extends Tree

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	# add the root scene node
	self.create_item(self).set_text(0, "Scene")

