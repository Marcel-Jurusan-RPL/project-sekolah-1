extends CharacterBody2D
@onready var pink_guy_animation: AnimatedSprite2D = $Pink_Guy_Animation
@onready var jump_sound: AudioStreamPlayer2D = $jump_sound
@onready var die_sound: AudioStreamPlayer2D = $die_sound

const SPEED = 300.0
const JUMP_VELOCITY = -850.0
const MAX_JUMPS = 2

var jump_count = 0 
var alive = true

func _physics_process(delta: float) -> void:

	if !alive:
		return

	if is_on_floor():
		if velocity.x > 1 or velocity.x < -1:
			pink_guy_animation.animation = "run"
		else:
			pink_guy_animation.animation = "idle"
		jump_count = 0

	# Add Gravity
	else:
		velocity += get_gravity() * delta
		if jump_count == 2:
			pink_guy_animation.animation = "double_jump"
		elif velocity.y > 0:
			pink_guy_animation.animation = "fall"
		else:
			pink_guy_animation.animation = "jump"

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			jump_sound.play()
			jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction == 1.0:
		pink_guy_animation.flip_h = false
	elif direction == -1.0:
		pink_guy_animation.flip_h = true

func die() -> void:
	die_sound.play()
	pink_guy_animation.animation = "hit"
	alive = false

func _on_pink_guy_animation_animation_finished() -> void:
	if pink_guy_animation.animation == "double_jump":
		pink_guy_animation.animation = "fall" # <- DIGANTI: Mengubah pose menjadi jatuh, bukan menghapus diri
