extends Node

#TODO set this up with all the data related to the MoveBoard to save and re-setup the board state

var areaNumber := 1

var gridSize := 8
var movesLeft := 6
var lastMoveIndex := Vector2i(-1, -1)
var pendingPath : Array[Vector2i] = []
var itemSpaces := {}
var landedSpaces := {} #might want to keep track of every gridSpace in a dictionary rather than just the ones landed on
var landedItems : Array[ItemSpace] = []
var landedItemGridNodeCopies = []
var numItems := 6
var savedState := false

func reset_moves_left():
	movesLeft = 6
	
func reset_landed_items():
	landedItems = []
	
func reset_mid_round_data():
	#this is to reset the moves left and items landed on a single round of moveboard
	#full reset is done with reset_board_data()
	reset_moves_left()
	reset_landed_items()

func reset_board_data():
	gridSize = 8
	movesLeft = 6
	lastMoveIndex = Vector2i(-1, -1)
	pendingPath = []
	itemSpaces = {}
	landedSpaces = {}
	landedItems = []
	landedItemGridNodeCopies = []
	numItems = 6
	savedState = false
