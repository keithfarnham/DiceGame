extends Control

@onready var moveGrid = $Board/MoveGrid as GridContainer
@onready var eventText = $EventText as RichTextLabel
@onready var rewardHandlerUI = $RewardHandlerUI
@onready var diceGrid = $RewardHandlerUI/DiceGrid as DiceGrid

static var boardSpace = preload("res://scenes/BoardSpace.tscn")
static var eventSpace = preload("res://scenes/EventSpace.tscn")

func _ready():
	#DEBUG ONLY TODO REMOVE EVENTUALLY
	if PlayerDice.ScoreDice.is_empty():
		DiceData.generate_starting_dice()
	
	board_setup()

func board_setup():
	$Board/Area/AreaValue.text = str(BoardData.areaNumber)
	$Board/MoveCount/MovesLeftValue.text = str(BoardData.movesLeft)
	moveGrid.columns = BoardData.gridSize
	if !BoardData.savedState:
		BoardData.eventSpaces = setup_events(BoardData.numEvents)
	for column in BoardData.gridSize:
		var row : Array[BoardSpace] = []
		for space in BoardData.gridSize:
			var index = Vector2i(space, column)
			var spaceInstance
			var k = _key_of(index)
			if BoardData.eventSpaces.has(k):
				var event = BoardData.eventSpaces.get(k) as EventSpace
				var eventType = event.type
				spaceInstance = eventSpace.instantiate() as EventSpace
				spaceInstance.set_type(eventType)
			else:
				spaceInstance = boardSpace.instantiate() as BoardSpace
			if BoardData.landedSpaces.has(k):
				spaceInstance.set_state(BoardSpace.State.landed)
			spaceInstance.index = index
			spaceInstance.spaceSelected.connect(space_pressed)
			spaceInstance.spaceHovered.connect(space_hovered)
			moveGrid.add_child(spaceInstance)
			row.append(spaceInstance)

func setup_events(numEvents : int) -> Dictionary:
	var events := {}
	
	#first add the 1 guaranteed shop event space
	var shopIndex = Vector2i(randi() % BoardData.gridSize, randi() % BoardData.gridSize)
	var shopEvent = EventSpace.new()
	shopEvent.initialize(shopIndex, EventSpace.event_type.shop)
	events[_key_of(shopIndex)] = shopEvent
	
	for i in numEvents:
		var index = Vector2i(randi() % BoardData.gridSize, randi() % BoardData.gridSize)
		var type = randi_range(1, EventSpace.event_type.size() - 1) as EventSpace.event_type
		var valid = false
		while !valid:
			valid = true
			if events.has(_key_of(index)):
				#if we already have the newly generate index in the list, regen and check again
				index = Vector2i(randi() % BoardData.gridSize, randi() % BoardData.gridSize)
				valid = false
				continue
		var newEvent = EventSpace.new()
		newEvent.initialize(index, type)
		events[_key_of(index)] = newEvent
	return events

func space_hovered(index : Vector2i):
	print("hovering over space at index " + str(index) + " in state " + str(BoardSpace.State.keys()[_space_at(index).currentState]) + " is goal? " + str(_is_space_goal(index)))
	if BoardData.movesLeft == 0:
		BoardData.pendingPath = []
		return
		
	if !BoardData.pendingPath.is_empty():
		for pos in BoardData.pendingPath:
			var space = _space_at(pos)
			var state = BoardSpace.State.empty
			if BoardData.eventSpaces.has(_key_of(pos)):
				state = BoardSpace.State.event
				space.set_event_name_visible(true)
			space.set_state(state)
		BoardData.pendingPath = []
	
	#start is either lastMoveIndex or bottom of the column
	var start = BoardData.lastMoveIndex
	if start == Vector2i(-1, -1):
		start = Vector2i(index.x, BoardData.gridSize)

	if start == index:
		return

	var target_node = _space_at(index)
	if target_node == null:
		push_error("[MoveBoard] target node is null")
		return
	if target_node.currentState == BoardSpace.State.landed:
		print("[MoveBoard] target is already landed; no movement")
		return

	#BFS to find shortest path avoiding landed spaces
	var frontier := []
	var came_from := {}
	frontier.append(start)
	came_from[_key_of(start)] = null

	var found := false
	while frontier.size() > 0:
		var current : Vector2i = frontier.pop_front()
		if current == index:
			found = true
			break
		#neighbors: right, left, down, up
		var neighbors = [Vector2i(current.x + 1, current.y), Vector2i(current.x - 1, current.y), Vector2i(current.x, current.y + 1), Vector2i(current.x, current.y - 1)]
		for n in neighbors:
			if n.x < 0 or n.x >= BoardData.gridSize or n.y < 0 or n.y >= BoardData.gridSize:
				continue
			var k = _key_of(n)
			if came_from.has(k):
				continue
			var node = _space_at(n)
			if node == null:
				continue
			#Avoid landed spaces
			if node.currentState == BoardSpace.State.landed:
				continue
			came_from[k] = current
			frontier.append(n)

	if not found:
		print("[MoveBoard] no path to target")
		return

	#Reconstruct path (excluding start, including target)
	var path : Array[Vector2i] = []
	var cur = index
	while cur != start:
		path.insert(0, cur)
		cur = came_from[_key_of(cur)]

	var steps_needed = path.size()
	if BoardData.movesLeft > 0:
		$Board/MoveCount/MovesMinus.visible = true
		$Board/MoveCount/MovesMinus/StepsNeeded.text = str(steps_needed)
		if BoardData.movesLeft < steps_needed:
			$Board/MoveCount/MovesMinus/Minus.add_theme_color_override("default_color", Color(1.0, 0.0, 0.0))
			$Board/MoveCount/MovesMinus/StepsNeeded.add_theme_color_override("default_color", Color(1.0, 0.0, 0.0))
			return
			
		$Board/MoveCount/MovesMinus/Minus.add_theme_color_override("default_color", Color(0.0, 0.0, 0.0))
		$Board/MoveCount/MovesMinus/StepsNeeded.add_theme_color_override("default_color", Color(0.0, 0.0, 0.0))
	
	for pos in path:
		var node = _space_at(pos)
		node.set_state(BoardSpace.State.pending)
	BoardData.pendingPath = path

func space_pressed(index : Vector2i):
	if BoardData.movesLeft == 0 or BoardData.pendingPath.is_empty():
		return
	#Apply movement: set each space along the path to landed and decrement movesLeft
	for pos in BoardData.pendingPath:
		var node = _space_at(pos)
		var posKey = _key_of(pos)
		if BoardData.eventSpaces.has(posKey):
			BoardData.landedEvents.push_back(BoardData.eventSpaces.get(posKey))
			var eventSpaceCopy = _space_at(pos).duplicate()
			BoardData.landedEventGridNodeCopies.append(eventSpaceCopy)
			$LandedEvents.add_child(eventSpaceCopy)
		node.set_state(BoardSpace.State.landed)
		BoardData.landedSpaces[_key_of(pos)] = pos #don't need to cache off the node necessarily, just need to know the position of the landed spaces so the key is enough really
		BoardData.movesLeft -= 1
	$Board/MoveCount/MovesLeftValue.text = str(BoardData.movesLeft)
	BoardData.lastMoveIndex = index
	
	if BoardData.movesLeft == 0:
		$Board/MoveCount/MovesMinus.visible = false
		#after all moves are used handle the events that were landed on
		if !BoardData.landedEvents.is_empty():
			$Board.visible = false
			$EventsCollectedLabel.set_position(Vector2(64.0, 448.0))
			$LandedEvents.set_position(Vector2(64.0, 472.0))
			event_queue()
		elif !_is_space_goal(BoardData.lastMoveIndex):
			$Continue.visible = true
	
	elif _is_space_goal(BoardData.lastMoveIndex):
		$ToBoss.visible = true
	else:
		$ToBoss.visible = false

func event_queue():
	event_handler(BoardData.landedEvents.pop_front())

func event_handler(event : EventSpace):
	rewardHandlerUI.diceGrid.clear_grids()
	match event.type:
		EventSpace.event_type.money:
			var amount = randi() % 20 + 1
			eventText.text = "Someone dropped $" + str(amount) + " that you grab off the ground."
			PlayerDice.Money += amount
			$EventText.visible = true
			$Continue.visible = true
		EventSpace.event_type.addDie:
			var newDie = DiceData.make_a_die(6)
			PlayerDice.add_die(newDie)
			eventText.text = "You found a D6 on the floor and added it to your dice bag."
			$EventText.visible = true
			$Continue.visible = true
		EventSpace.event_type.addRemoveFace:
			$Continue.visible = false
			eventText.text = "You found a tool allowing you to duplicate or remove a die face."
			rewardHandlerUI.visible = true
			$RewardHandlerUI/addRemoveFace.visible = true
			diceGrid.visible = true
			diceGrid.set_type(DiceGrid.GridType.allDiceFaceChoice)

func _key_of(v : Vector2i) -> String:
	return str(v.x) + ":" + str(v.y)

func _space_at(pos : Vector2i) -> BoardSpace:
	var child_idx = pos.y * BoardData.gridSize + pos.x
	if child_idx < 0 or child_idx >= moveGrid.get_child_count():
		return null
	return moveGrid.get_child(child_idx)

func _is_space_goal(pos : Vector2i) -> bool:
	if pos.y == 0:
		return true
	return false

func _on_event_continue_pressed():
	rewardHandlerUI.visible = false
	if !BoardData.landedEvents.is_empty():
		var eventNode = BoardData.landedEventGridNodeCopies.pop_front()
		assert(eventNode != null, "ERROR - [MoveBoard] Popped event node copy is null")
		$LandedEvents.remove_child(eventNode)
		diceGrid.selectedDie = -1
		diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED
		diceGrid.mouse_filter = Control.MOUSE_FILTER_STOP
		event_queue()
	elif _is_space_goal(BoardData.lastMoveIndex):
		$Board.visible = false
		$ToBoss.visible = true
		$Continue.visible = false
		$EventsCollectedLabel.visible = false
	elif BoardData.movesLeft == 0:
		#once events are handled and player has no more moves go to roll scene
		BoardData.reset_mid_round_data()
		BoardData.savedState = true
		get_tree().change_scene_to_file("res://scenes/RollScore.tscn")

func _on_to_boss_pressed():
	if !BoardData.landedEvents.is_empty():
		$ToBoss.visible = false
		$Board.visible = false
		$EventsCollectedLabel.set_position(Vector2(64.0, 448.0))
		$LandedEvents.set_position(Vector2(64.0, 472.0))
		event_queue()
		return
	BoardData.reset_board_data()
	BoardData.areaNumber += 1
	BoardData.bossRound = true
	get_tree().change_scene_to_file("res://scenes/RollScore.tscn")
