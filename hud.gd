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


func _on_player_complete():
	var run_time = time_elapsed
	var run_deaths = deaths
	
	deaths = 0
	time_elapsed = 0.001
	update_deaths()
	update_timer()
	
	# Show run time
	var ms =  str(run_time).split(".")[1].left(2)
	var seconds = int(run_time) % 60
	var minutes = int(run_time/60) % 60
	var hours = int(run_time/60)/60
	
	if hours > 0:
		$Victory/VictoryText/TimeLabel.text = "%02d:%02d:%02d.%s" % [hours, minutes, seconds, ms]
	elif minutes > 0:
		$Victory/VictoryText/TimeLabel.text = "%02d:%02d.%s" % [minutes, seconds, ms]
	else:
		$Victory/VictoryText/TimeLabel.text = "%02d.%s" % [seconds, ms]
	
	$Victory/VictoryText/DeathLabel.text = str(run_deaths)
	
	$Victory/VictoryText.show()
	$Victory/FlashTimer.start()
	$Victory/ShowTimer.start()


# Flash yellow and white
func _on_flash_timer_timeout():
	var yellow = Color(1.0,1.0,0.0,1.0)
	var white = Color(1.0,1.0,1.0,1.0)
	if $Victory/VictoryText/TimeLabel.get("theme_override_colors/font_color") == yellow:
		$Victory/VictoryText/TimeLabel.set("theme_override_colors/font_color", white)
	else:
		$Victory/VictoryText/TimeLabel.set("theme_override_colors/font_color", yellow)

func _on_show_timer_timeout():
	$Victory/VictoryText.hide()
	$Victory/FlashTimer.stop()
	$Victory/ShowTimer.stop()
