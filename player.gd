extends CharacterBody2D

@export var max_speed = 600 # How fast the player will move (pixels/sec).
@export var gravity = 30
@export var jump_force = 625
@export var acceleration = 60 # how quickly player accelerates with horizontal movement
@export var jump_hover = 12 # Impact of holding space while jumping
@export var wall_friction = 20 # When you have wall jump you "cling" to walls

@export var double_jump = false
@export var wall_jump = false

var extra_jumps = 0

var respawn
@onready var wall_cast1 = $WallRayCast1.target_position
@onready var wall_cast2 = $WallRayCast2.target_position

func _ready():
	respawn = position # Save initial position as respawn position

func die():
	position = respawn

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var is_wall_climing = (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and ($WallRayCast1.is_colliding() or $WallRayCast2.is_colliding())
	
	if position.y > 2000 || Input.is_action_pressed("reset"):
		die() # Fell off the map
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	
	
	if is_on_floor():
		extra_jumps = 1
	
	
	if is_wall_climing and wall_jump:
		if velocity.y < 0:
			velocity.y += wall_friction
		else:
			velocity.y -= wall_friction
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		$AnimatedSprite2D.frame = 0
	elif Input.is_action_just_pressed("jump") and wall_jump and is_wall_climing:
		velocity.y = -jump_force
		$AnimatedSprite2D.frame = 0
	elif Input.is_action_just_pressed("jump") and double_jump and extra_jumps > 0:
		velocity.y = -jump_force
		$AnimatedSprite2D.frame = 0
		extra_jumps -= 1
	elif Input.is_action_pressed("jump"):
		if velocity.y < 0:
			velocity.y -= jump_hover
	
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, max_speed * horizontal_direction, acceleration)
	
	$AnimatedSprite2D.play()

	if is_wall_climing:
		$AnimatedSprite2D.animation = "wall"
		 # visually hug the wall
		if velocity.x > 0:
			$AnimatedSprite2D.offset = Vector2(5, 0)
		else:
			$AnimatedSprite2D.offset = Vector2(-5, 0)
	else:
		$AnimatedSprite2D.offset = Vector2(0, 0)
		if velocity.y != 0:
			play_jump_once()
		elif velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
		else:
			$AnimatedSprite2D.animation = "idle"
	
	# Don't change direction if velocity is 0, otherwise flip animation and wall climb raycasts
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$WallRayCast1.target_position = wall_cast1
		$WallRayCast2.target_position = wall_cast2
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$WallRayCast1.target_position = wall_cast1 * -1
		$WallRayCast2.target_position = wall_cast2 * -1
	
	move_and_slide()

func play_jump_once():
	$AnimatedSprite2D.animation = "up"
	print($AnimatedSprite2D.sprite_frames.get_frame_count("up"))
	print($AnimatedSprite2D.frame)
	if $AnimatedSprite2D.sprite_frames.get_frame_count("up") == $AnimatedSprite2D.frame + 1:
		$AnimatedSprite2D.pause()

func _on_double_jump_collected():
	double_jump = true


func _on_wall_jump_collected():
	wall_jump = true # Replace with function body.
