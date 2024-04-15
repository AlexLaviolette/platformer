extends Node2D

signal collected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pickup_area_body_entered(body):
	if body.name == "Player":
		hide()
		collected.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$PickupArea/CollisionShape2D.set_deferred("disabled", true)
		$GlowSound.stop()
		$CollectSound.play()
		
		print("Collected " + name)
