class_name WhiskersParser

var data : Dictionary
var current_block : Dictionary
var format_dictionary : Dictionary = {} setget set_format_dictionary
var default_base_instance : Object # Default base instance defined at _init method
var base_instance : Object # Object used as a base instance when running expressions

func _init(base_instance : Object = null):
	default_base_instance = base_instance
	
	if not base_instance:
		print("[WARN]: no base_instance for calling expressions.")

static func open_whiskers(file_path : String) -> Dictionary:
	var file = File.new()
	
	var error = file.open(file_path, File.READ)
	if error:
		print("[ERROR]: couldn't open file at %s. Error number %s." % [file_path, error])
		return {}
	
	var dialogue_data = parse_json(file.get_as_text())
	file.close()
	
	if not dialogue_data is Dictionary:
		print("[ERROR]: failed to parse whiskers file. Is it a valid exported whiskers file?")
		return {}
	
	return dialogue_data

static func parse_whiskers(data : Dictionary) -> Dictionary:
	return data

func start_dialogue(dialogue_data : Dictionary, custom_base_instance : Object = null) -> Dictionary:
	if not dialogue_data.has("Start"):
		print("[ERROR]: not a valid whiskers data, it has not the key Start.")
		return {}
	
	base_instance = custom_base_instance if custom_base_instance else default_base_instance
	data = dialogue_data
	current_block = generate_block(data.Start.connects_to.front())
	
	return current_block

func end_dialogue() -> void:
	data = {}
	current_block = {}
	base_instance = default_base_instance

func next(selected_option_key : String = "") -> Dictionary:
	if not data:
		print("[WARN]: trying to call next() on a finalized dialogue.")
		return {}
	
	if current_block.is_final:
		# It is a final block, but it could be connected to more than an END node, we have to process them
		process_block(current_block)
		end_dialogue()
		return {}
	
	var next_block = {}
	
	handle_expressions(current_block.expressions)
	
	# DEALING WITH OPTIONS
	if selected_option_key:
		# Generate a block containing all the nodes that this options is connected with
		var option_block = generate_block(selected_option_key)
		if option_block.empty(): return {}
		
		next_block = process_block(option_block)
		
	elif not current_block.options.empty():
		print("[WARN]: no option was passed as argument, but there was options available. This could cause an infinite loop. Use wisely.")
	
	else:
		next_block = process_block(current_block)
	
	current_block = next_block
	
	return current_block

func process_block(block : Dictionary) -> Dictionary:
	var next_block = {}
	
	handle_expressions(block.expressions)
	
	if not block.dialogue.empty():
		next_block = generate_block(block.dialogue.key)
	elif not block.jump.empty():
		next_block = handle_jump(block.jump)
	elif not block.condition.empty():
		next_block = handle_condition(block.condition)
	
	return next_block

func handle_expressions(expressions_array : Array) -> Array:
	if expressions_array.empty(): return []
	
	var results = []
	var expression = Expression.new()
	
	for dic in expressions_array:
		results.append(execute_expression(dic.logic))
	
	return results

func handle_condition(condition : Dictionary) -> Dictionary:
	var result = execute_expression(condition.logic)
	var next_block = {}
	
	if not result is bool:
		print("[ERROR]: the expression used as input for a condition node should return a boolean, but it is returning %s instead." % result)
		return {}
	
	if result:
		if not "End" in condition.goes_to_key.if_true: # If a condition node goest to an end node, then we have to end the dialogue
			next_block = generate_block(condition.goes_to_key.if_true)
	else:
		if not "End" in condition.goes_to_key.if_false:
			next_block = generate_block(condition.goes_to_key.if_false)
	
	return next_block

func handle_jump(jump) -> Dictionary:
	# Get the matching node to wich we are going
	var jumped_to = generate_block(jump.goes_to_key)
	var next_block = {}
	
	# If this node has expressions that it is connected to, than we want to execute them
	handle_expressions(jumped_to.expressions)
	
	if not jumped_to.dialogue.empty():
		next_block = generate_block(jumped_to.dialogue.key)
	elif not jumped_to.jump.empty():
		next_block = handle_jump(jumped_to.jump)
	elif not jumped_to.condition.empty():
		next_block = handle_condition(jumped_to.condition)
	elif not jumped_to.options.empty():
		next_block = jumped_to
	
	return next_block

func execute_expression(expression_text : String):
	var expression = Expression.new()
	var result = null
	
	var error = expression.parse(expression_text)
	if error:
		print("[ERROR]: unable to parse expression %s. Error: %s." % [expression_text, error])
	else:
		result = expression.execute([], base_instance, true)
		if expression.has_execute_failed():
			print("[ERROR]: unable to execute expression %s." % expression_text)
	
	return result

# A block is a Dictionary containing a node and every node it is connected to, by type and it's informations.
func generate_block(node_key : String) -> Dictionary:
	if not data.has(node_key):
		print("[ERROR]: trying to create block from inexisting node %s. Aborting.", node_key)
		return {}
		
	# Block template
	var block = {
			key = node_key,
			options = [], # key, text
			expressions = [], # key, logic
			dialogue = {}, # key, text
			condition = {}, # key, logic, goes_to_key["true"], goes_to_key["false"]
			jump = {}, # key, id, goes_to_key
			is_final = false
			}
	
	if "Dialogue" in node_key:
		block.text = data[node_key].text.format(format_dictionary)
	
	if "Jump" in node_key:
		for key in data:
			if "Jump" in key and data[node_key].text == data[key].text and node_key != key:
				block = generate_block(data[key].connects_to[0])
				break
	
	if "Condition" in node_key: # this isn't very DRY
		block.condition = process_condition(node_key)
		block = process_block(block)
	
	# For each key of the connected nodes we put it on the block
	for connected_node_key in data[node_key].connects_to:
		if "Dialogue" in connected_node_key:
			if not block.dialogue.empty(): # It doesn't make sense to connect two dialogue nodes
				print("[WARN]: more than one Dialogue node connected. Defaulting to the first, key: %s, text: %s." % [block.dialogue.key, block.text])
				continue
			
			var dialogue = {
					key = connected_node_key,
					}
			block.dialogue = dialogue
			
		elif "Option" in connected_node_key:
			var option = {
					key = connected_node_key,
					text = data[connected_node_key].text,
					}
			block.options.append(option)
			
		elif "Expression" in connected_node_key:
			var expression = {
					key = connected_node_key,
					logic = data[connected_node_key].logic
					}
			block.expressions.append(expression)
			
		elif "Condition" in connected_node_key:
			if not block.condition.empty(): # It also doesn't make sense to connect two Condition nodes
				print("[WARN]: more than one Condition node connected. Defaulting to the first, key: %s." % block.condition.key)
				continue
			
			block.condition = process_condition(connected_node_key)
			
			var parse_condition = handle_condition(block.condition)
			
			if 'Option' in parse_condition.key:
				var option = {
						key = parse_condition.key,
						text = data[parse_condition.key].text,
					}
				block.options.append(option)
		
		elif "Jump" in connected_node_key:
			if not block.jump.empty():
				print("[WARN]: more than one Jump node connected. Defaulting to the first, key: %s, id: %d." % [connected_node_key, block.jump.id])
				continue
			
			# Just like with the Expression node a linear search is needed to find the matching jump node.
			var match_key : String
			for key in data:
				if "Jump" in key and data[connected_node_key].text == data[key].text and connected_node_key != key:
					match_key = key
					break
			
			if not match_key:
				print("[ERROR]: no other node with the id %s was found. Aborting." % data[connected_node_key].text)
				return {}
				
			var jump = {
					key = connected_node_key,
					id = data[connected_node_key].text,
					goes_to_key = match_key
					}
			block.jump = jump
			
			var jump_options = handle_jump(block.jump)
			if not jump_options.options.empty():
				for option in jump_options.options:
					block.options.append(option)
			
		elif "End" in connected_node_key and not "Jump" in node_key:
			block.is_final = true
	
	current_block = block
	return current_block

func process_condition(passed_key : String) -> Dictionary:
	# Sadly the only way to find the Expression node that serves as input is to make a linear search
	var input_logic : String
	for key in data:
		if "Expression" in key and data[key].connects_to.front() == passed_key:
			input_logic = data[key].logic
			break
	
	if not input_logic:
		print("[ERROR]: no input for the condition node %s was found." % passed_key)
		return {}
	
	var condition = {
			key = passed_key,
			logic = input_logic,
			goes_to_key = {
					if_true = data[passed_key].conditions["true"],
					if_false = data[passed_key].conditions["false"]
					}
			}
	
	return condition

func set_format_dictionary(value : Dictionary) -> void:
	format_dictionary = value
