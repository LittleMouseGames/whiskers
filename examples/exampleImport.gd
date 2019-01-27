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
func _takeThings():
	lotsOfStuff = false

func _changeVar(name, value):
	var val = value
	if(val == "True") or (val == "true"):
		val = true
	if(val == "False") or (val == "false"):
		val = false
	set(name, val)

# `export` our functions and documentation about them! 
var functions = [
	'_takeThings()',
	'_changeVar(var, value)'
]

var functionDocs = [
	'Take the players stuff!',
	'Change the variable to a specified value'
]
