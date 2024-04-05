extends Control

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("enter"):
		_on_start_button_pressed()
	
	if Input.is_action_just_pressed("pause"):
		show()

func _on_start_button_pressed():
	hide()
	start_game.emit()
