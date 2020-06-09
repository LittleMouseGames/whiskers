extends ItemList

# we don't want to list these
var ignore = ['graph_node.gd', 'start', 'default']

# path to our nodes
var node_path = "res://config/nodes/"

# our node folders
var node_folders = ['basic', 'advanced', 'other']

# Called when the node enters the scene tree for the first time.
func _ready():
	for folder in node_folders:
		print(get_nodes(node_path + folder + "/"))

func get_nodes(path):
	var dir: Directory = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, true)
	
	if dir.dir_exists(path):
		while true:
			var file = dir.get_next()
			if file == "":
				break
			elif not file in ignore:
				var list_name = file + ' ' + 'node'
				
				# store our nodes direct path
				loader_singleton.node_locations[file] = path
				
				# does the node have a screenshot?
				var screenshot = File.new()
				if screenshot.file_exists(path + file + '/media/screenshot.png'):
					self.add_item(list_name.capitalize(), load(path + file + '/media/screenshot.png'))
				else:
					self.add_item(list_name.capitalize())

	dir.list_dir_end()

func get_drag_data(pos):
	var selected: Array = get_selected_items()
	var prev: TextureRect = TextureRect.new()
	
	if selected.size() > 0:
		prev.texture = get_item_icon(selected[0])
		set_drag_preview(prev)
	
		return get_item_text(selected[0])
