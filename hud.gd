extends CanvasLayer

var deaths := 0
var time_elapsed := 0.001 # hack to make it so there are always 2 digits available
var started := false

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started: 
		time_elapsed += delta
	
	update_timer()

func update_timer():
	var ms =  str(time_elapsed).split(".")[1].left(2)
	var seconds = int(time_elapsed) % 60
	var minutes = int(time_elapsed/60) % 60
	var hours = int(time_elapsed/60)/60
	
	if hours > 0:
		$TimerLabel.text = "%02d:%02d:%02d.%s" % [hours, minutes, seconds, ms]
	elif minutes > 0:
		$TimerLabel.text = "%02d:%02d.%s" % [minutes, seconds, ms]
	else:
		$TimerLabel.text = "%02d.%s" % [seconds, ms]
	

func update_deaths():
	$DeathCounter/DeathLabel.text = str(deaths)


func _on_player_dead():
	deaths += 1
	update_deaths()

func _on_start_button_pressed():
	started = true
	start_game.emit()
