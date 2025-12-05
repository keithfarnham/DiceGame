extends Button

class_name BoardSpace

enum State {empty, pending, landed, item}
signal spaceSelected(index)
signal spaceHovered(index)

@export var currentState := State.empty

var index : Vector2i

func set_state(newState : State):
	match newState:
		State.empty:
			var style = load("res://styleboxes/boardspaces/emptyboard_style.tres") as StyleBoxFlat
			add_theme_stylebox_override("normal", style)
		State.pending:
			var style = load("res://styleboxes/boardspaces/pendingboard_style.tres") as StyleBoxFlat
			add_theme_stylebox_override("normal", style)
		State.landed:
			var style = load("res://styleboxes/boardspaces/landedboard_style.tres") as StyleBoxFlat
			add_theme_stylebox_override("disabled", style)
			disabled = true
		State.item:
			var style = load("res://styleboxes/boardspaces/itemboard_style.tres") as StyleBoxFlat
			add_theme_stylebox_override("normal", style)

func _on_pressed():
	spaceSelected.emit(index)

func _on_mouse_entered():
	spaceHovered.emit(index)
