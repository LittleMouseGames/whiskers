extends Node

# Most of these variables are intended for use in other scripts,

# warning-ignore:unused_class_variable
var littleMouse = 'awesome'
# warning-ignore:unused_class_variable
var exampleVar = true
var hasItem = false

# `export` our variables and quick documentation about them on hover
# Used in DocVarspopulate_vars
# warning-ignore:unused_class_variable
var variables = [
	'littleMouse',
	'exampleVar',
	'hasItem',
]

# Used in DocVars.populate_vars
# warning-ignore:unused_class_variable
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
	elif(val == "False") or (val == "false"):
		val = false
	set(name, val)

# `export` our functions and documentation about them!
# Used in DocFuncs.populate_funcs
# warning-ignore:unused_class_variable
var functions = [
	'give_item()',
	'change_var("var", "value")'
]

# Used in DocFuncs.populate_funcs
# warning-ignore:unused_class_variable
var functionDocs = [
	'Give the player an item!',
	'Change the variable to a specified value'
]