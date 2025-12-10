extends Control

@onready var moveGrid = $MoveGrid as GridContainer

static var boardSpace = preload("res://scenes/BoardSpace.tscn")
static var itemSpace = preload("res://scenes/ItemSpace.tscn")

var gridSize := 8
var movesLeft := 6
var lastMoveIndex := Vector2i(-1, -1)
var pendingPath : Array[Vector2i] = []
var itemSpaces := {}
var numItems := 6

func _ready():
	moveGrid.columns = gridSize
	itemSpaces = setup_items(numItems)
	for column in gridSize:
		var row : Array[BoardSpace] = []
		for space in gridSize:
			var index = Vector2i(space, column)
			var spaceInstance
			var k = _key_of(index)
			if itemSpaces.has(k):
				var itemType = itemSpaces.get(k).type
				spaceInstance = itemSpace.instantiate() as ItemSpace
				spaceInstance.type = itemType
			else:
				spaceInstance = boardSpace.instantiate() as BoardSpace
			spaceInstance.index = index
			spaceInstance.spaceSelected.connect(space_pressed)
			spaceInstance.spaceHovered.connect(space_hovered)
			moveGrid.add_child(spaceInstance)
			row.append(spaceInstance)

func setup_items(numItems : int) -> Dictionary:
	var items := {}
	for i in numItems:
		var index = Vector2i(randi() % gridSize, randi() % gridSize)
		var type = ItemSpace.item_type.money #TODO setup random here
		if items.is_empty():
			var newItem = ItemSpace.new()
			newItem.initialize(index, type)
			items[_key_of(index)] = newItem
			continue
		var valid = false
		while !valid:
			valid = true
			if items.has(_key_of(index)):
				#if we already have the newly generate index in the list, regen and check again
				index = Vector2i(randi() % gridSize, randi() % gridSize)
				valid = false
				continue
		var newItem = ItemSpace.new()
		newItem.initialize(index, type)
		items[_key_of(index)] = newItem
	return items

func space_hovered(index : Vector2i):
	if movesLeft == 0:
		pendingPath = []
		return
		
	if !pendingPath.is_empty():
		for pos in pendingPath:
			var space = _space_at(pos)
			var state = BoardSpace.State.empty
			if itemSpaces.has(_key_of(pos)):
				state = BoardSpace.State.item
				#TODO prob need to set the item type here as well
			space.set_state(state)
		pendingPath = []
	
	#start is either lastMoveIndex or bottom of the column
	var start = lastMoveIndex
	if start == Vector2i(-1, -1):
		start = Vector2i(index.x, gridSize)

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
			if n.x < 0 or n.x >= gridSize or n.y < 0 or n.y >= gridSize:
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
	if movesLeft > 0:
		$MoveCount/MovesMinus.visible = true
		$MoveCount/MovesMinus/StepsNeeded.text = str(steps_needed)
		if movesLeft < steps_needed:
			$MoveCount/MovesMinus/Minus.add_theme_color_override("default_color", Color(1.0, 0.0, 0.0))
			$MoveCount/MovesMinus/StepsNeeded.add_theme_color_override("default_color", Color(1.0, 0.0, 0.0))
			return
			
		$MoveCount/MovesMinus/Minus.add_theme_color_override("default_color", Color(0.0, 0.0, 0.0))
		$MoveCount/MovesMinus/StepsNeeded.add_theme_color_override("default_color", Color(0.0, 0.0, 0.0))
	
	for pos in path:
		var node = _space_at(pos)
		node.set_state(BoardSpace.State.pending)
	pendingPath = path

func space_pressed(index : Vector2i):
	if movesLeft == 0:
		return
	#Apply movement: set each space along the path to landed and decrement movesLeft
	for pos in pendingPath:
		var node = _space_at(pos)
		node.set_state(BoardSpace.State.landed)
		movesLeft -= 1
	$MoveCount/MovesLeftValue.text = str(movesLeft)
	if movesLeft == 0:
		$MoveCount/MovesMinus.visible = false
	lastMoveIndex = index

func _key_of(v : Vector2i) -> String:
	return str(v.x) + ":" + str(v.y)

func _space_at(pos : Vector2i) -> BoardSpace:
	var child_idx = pos.y * gridSize + pos.x
	if child_idx < 0 or child_idx >= moveGrid.get_child_count():
		return null
	return moveGrid.get_child(child_idx) as BoardSpace
