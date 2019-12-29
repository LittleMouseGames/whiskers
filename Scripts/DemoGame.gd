extends Panel

export var speed = 1
onready var player = get_node("PlayField/Player")
var currentTab
var buttonAct

func _physics_process(_delta):
	if(currentTab == 1):
		if Input.is_action_pressed("player_right") or buttonAct == 'right':
			player.set_global_position(Vector2(player.get_global_position().x + speed, player.get_global_position().y))
		if Input.is_action_pressed("player_left") or buttonAct == 'left':
			player.set_global_position(Vector2(player.get_global_position().x - speed, player.get_global_position().y))
		if Input.is_action_pressed("player_up") or buttonAct == 'up':
			player.set_global_position(Vector2(player.get_global_position().x, player.get_global_position().y - speed))
		if Input.is_action_pressed("player_down") or buttonAct == 'down':
			player.set_global_position(Vector2(player.get_global_position().x, player.get_global_position().y + speed))
		if Input.is_action_pressed("player_action") or buttonAct == 'action':
			if(get_node("PlayField/Player/E").is_visible()):
				# we should hide the movement buttons and our action button
				get_node("Keys").hide()
				get_node("PlayField/Player/E").hide()
				# we should show our Dialogue Window!
				get_node("Dialogue").show()
				get_node("Dialogue").init()


func _on_Area2D2_area_entered(_area):
	get_node("PlayField/Player/E").show()


func _on_Area2D2_area_exited(_area):
	get_node("PlayField/Player/E").hide()
	get_node("Keys").show()
	get_node("Dialogue").hide()
	get_node("Dialogue").reset()


func _on_Graph_tab_selected(tab):
	currentTab = tab

func _on_D_button_down():
	buttonAct = 'right'

func _on_S_button_down():
	buttonAct = 'down'

func _on_W_button_down():
	buttonAct = 'up'

func _on_A_button_down():
	buttonAct = 'left'

func _on_D_button_up():
	buttonAct = ''

func _on_S_button_up():
	buttonAct = ''

func _on_W_button_up():
	buttonAct = ''

func _on_A_button_up():
	buttonAct = ''

func _on_E_button_down():
	buttonAct = 'left'

func _on_E_button_up():
	buttonAct = ''
