#extends Control
#
##@onready var addDie = $DebugUI/AddDie as Button
#@onready var numFaces = $DebugUI/NumFaces as HSlider
#@onready var diceBag = $"../DiceBag" as DiceBag
#@onready var diceBagGrid = $"../DiceGrid" as GridContainer
#@onready var faceToModifyButton = $DebugUI/FaceDebugGrid/FaceToModify as OptionButton
#@onready var faceTypeButton = $DebugUI/FaceDebugGrid/FaceType as OptionButton
#@onready var faceValueSlider = $DebugUI/FaceDebugGrid/FaceValue as HSlider
#@onready var faceValueText = $DebugUI/FaceDebugGrid/ValueNum as RichTextLabel
#@onready var hideDebugUIButton = $HideDebugUI as Button
#@onready var debugUI = $DebugUI as Control
#@onready var clearAllDiceButton = $DebugUI/ClearAllDice as Button
#@onready var deleteSelectedDieButton = $DebugUI/DeleteSelectedDie as Button
#@onready var dieToModify = $DebugUI/DieToModify as OptionButton
#
#var createdDie : DieData
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	##default face count
	##numFaces.value = 6
	##faceNum.text = str(6)
	##numFaces.drag_ended.connect(set_faces_debug)
	##numFaces.value_changed.connect(update_faces_debug)
	#faceValueSlider.drag_ended.connect(set_value_debug)
	#faceValueSlider.value_changed.connect(update_value_debug)
	#faceTypeButton.item_selected.connect(set_face_type)
	#faceToModifyButton.item_selected.connect (set_face_to_modify)
	#clearAllDiceButton.pressed.connect(clear_all_debug)
	#deleteSelectedDieButton.pressed.connect(delete_selected_die_debug)
	#dieToModify.item_selected.connect(update_die_to_modify)
	#set_faces_debug(false)
	#
#func update_die_to_modify():
	#print("update select4ed " + str(dieToModify.selected))
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	##disable buttons after they are pressed until next frame to prevent spam
	##if addDie.disabled:
		##addDie.disabled = false
	#if hideDebugUIButton.disabled:
		#hideDebugUIButton.disabled = false
	##if addDie.button_pressed:
		##add_die()
	#if hideDebugUIButton.button_pressed:
		#hide_ui()
#
#func hide_ui():
	#hideDebugUIButton.disabled = true
	#debugUI.visible = !debugUI.visible
	#hideDebugUIButton.text = "Hide Debug" if debugUI.visible else "Show Debug"
#
##func add_die():
	##addDie.disabled = true
	##print("trying to add die with " + str(createdDie.faces.size()) + " faces")
	##diceBag.add_die(createdDie)
#
#func set_face_type(index):
	#createdDie.faces[faceToModifyButton.selected].type = index as DieFace.FaceType
#
#func set_face_to_modify(index):
	#faceValueText.text = str(createdDie.faces[index].value)
	#faceTypeButton.selected = createdDie.faces[index].type
#
#func update_value_debug(value_changed):
	#faceValueText.text = str(faceValueSlider.value)
	#
#func set_value_debug(value_changed):
	#createdDie.set_face(faceToModifyButton.selected, faceValueSlider.value, faceTypeButton.selected as DieFace.FaceType)
#
##func update_faces_debug(value_changed):
	##faceNum.text = str(numFaces.value)
#
#func clear_all_debug():
	#diceBag.remove_all_dice()
	#pass
#
#func delete_selected_die_debug():
	#diceBag.remove_selected_die()
	#pass
#
#func set_faces_debug(value_changed):
	##clear the option buttons, then repopulate
	#faceToModifyButton.clear()
	#faceTypeButton.clear()
	#
	#var dieFaces : Array[DieFace]
	#for val in numFaces.value:
		#dieFaces.append(DieFace.new(val + 1))
		#createdDie = DieData.new(dieFaces)
		#faceToModifyButton.add_item(str(val + 1))
	#for type in DieFace.FaceType:
		#faceTypeButton.add_item(str(type))
