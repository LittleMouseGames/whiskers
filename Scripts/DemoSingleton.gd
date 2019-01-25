extends Node

var littleMouse = 'awesome'
var exampleVar = true
var hasItem = false

# `export` our variables and quick documentation about them on hover
var variables = [
	'littleMouse',
	'exampleVar',
	'hasItem',
]
var varTooltips = [
	'What is littleMouse',
	'An example var!',
	'Does the user have the item?'
]

#====> FUNCTIONS
func _giveItem():
	hasItem = true

func _changeVar(name, value):
	var val = value
	if(val == "True") or (val == "true"):
		val = true
	if(val == "False") or (val == "false"):
		val = false
	set(name, val)

# `export` our functions and documentation about them! 
var functions = [
	'_giveItem()',
	'_changeVar(var, value)'
]

var functionDocs = [
	'Give the player an item!',
	'Change the variable to a specified value'
]