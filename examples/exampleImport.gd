extends Node

var superMega = true
var lotsOfStuff = true
var playerName = "Steve"

# `export` our variables and quick documentation about them on hover
var variables = [
	'superMega',
	'lotsOfStuff',
	'playerName',
]
var varTooltips = [
	'Demo variable',
	'How many things? Too many things!',
	'Our player name!'
]

#====> FUNCTIONS
func take_things():
	lotsOfStuff = false

func change_var(name, value):
	var val = value
	if(val == "True") or (val == "true"):
		val = true
	if(val == "False") or (val == "false"):
		val = false
	set(name, val)

# `export` our functions and documentation about them! 
var functions = [
	'take_things()',
	'change_var("var", "value")'
]

var functionDocs = [
	'Take the players stuff!',
	'Change the variable to a specified value. `var` and `value` must be in quotes!'
]
