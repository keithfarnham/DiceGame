extends Node

var areaNumber := 1
var maxMoves := 4

var gridSize := 8
var movesLeft : int
var lastMoveIndex := Vector2i(-1, -1)
var pendingPath : Array[Vector2i] = []
var eventSpaces := {}
var landedSpaces := {} #might want to keep track of every gridSpace in a dictionary rather than just the ones landed on
var landedEvents : Array[EventSpace] = []
var numEvents := 6
var savedState := false
var bossRound := false
var rounds := 1

func reset_moves_left():
	movesLeft = maxMoves
	
func reset_landed_events():
	landedEvents = []
	
func reset_mid_round_data():
	#this is to reset the moves left and events landed on a single round of moveboard
	#full reset is done with reset_board_data()
	reset_moves_left()
	reset_landed_events()

func reset_board_data():
	gridSize = 8
	reset_moves_left()
	lastMoveIndex = Vector2i(-1, -1)
	pendingPath = []
	eventSpaces = {}
	landedSpaces = {}
	reset_landed_events()
	numEvents = 6
	savedState = false
	bossRound = false
