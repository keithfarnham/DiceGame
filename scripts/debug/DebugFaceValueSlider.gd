extends HSlider

@onready var valueNum = $"../ValueNum" as RichTextLabel
@onready var dieToModify = $"../../DieToModify" as OptionButton
@onready var faceToModify = $"../FaceToModify" as OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _value_changed(new_value):
	valueNum.text = str(new_value)
	if faceToModify.selected < PlayerDice.DebugDie.faces.size():
		PlayerDice.DebugDie.faces[faceToModify.selected].value = new_value
