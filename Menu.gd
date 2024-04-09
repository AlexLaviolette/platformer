extends Control

signal start_game

var wind_target_volume = -50.0
@export var wind_volume_delta = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("enter"):
		_on_start_button_pressed()
	
	if Input.is_action_just_pressed("pause"):
		show()
		
	# Gradually change wind volume
	if $WindBackground.volume_db != wind_target_volume:
		$WindBackground.volume_db = move_toward($WindBackground.volume_db, wind_target_volume, wind_volume_delta)
		
	# Randomly pick wind volume target at random time intervals
	if $RandomizeWind.time_left <= 0:
		wind_target_volume = randf_range(-45.0, -65.0)
		$RandomizeWind.start(randf_range(1.0, 8.0))

func _on_start_button_pressed():
	hide()
	$MenuMusic.stop()
	$WindBackground.play()
	start_game.emit()
