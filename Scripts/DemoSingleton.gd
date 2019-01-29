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
func give_item():
	hasItem = true

func change_var(name, value):
	var val = value
	if(val == "True") or (val == "true"):
		val = true
	if(val == "False") or (val == "false"):
		val = false
	set(name, val)

# `export` our functions and documentation about them! 
var functions = [
	'give_item()',
	'change_var(var, value)'
]

var functionDocs = [
	'Give the player an item!',
	'Change the variable to a specified value'
]