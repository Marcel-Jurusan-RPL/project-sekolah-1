extends CharacterBody2D

@onready var pink_guy_animation: AnimatedSprite2D = $Pink_Guy_Animation
@onready var jump_sound: AudioStreamPlayer2D = $jump_sound
@onready var die_sound: AudioStreamPlayer2D = $die_sound

const SPEED = 300.0
const JUMP_VELOCITY = -850.0
const MAX_JUMPS = 2
const WALL_SLIDE_SPEED = 150.0
const WALL_JUMP_VELOCITY_X = 450.0 
const WALL_JUMP_VELOCITY_Y = -800.0

var is_wall_jumping = false
var is_wall_sliding = false
var jump_count = 0 
var alive = true
var can_move = true

var wall_jump_lock_timer = 0.0
const WALL_JUMP_LOCK_DURATION = 0.2 

func _physics_process(delta: float) -> void:

	if not alive:
		return
		
	var direction := Input.get_axis("left", "right")
	
	if wall_jump_lock_timer > 0.0:
		wall_jump_lock_timer -= delta

	if is_on_floor():
		is_wall_sliding = false
		is_wall_jumping = false
		wall_jump_lock_timer = 0.0 
		if velocity.x > 1 or velocity.x < -1:
			pink_guy_animation.animation = "run"
		else:
			pink_guy_animation.animation = "idle"
		jump_count = 0

	# Add Gravity / Logika Udara
	else:
		velocity += get_gravity() * delta
		if is_on_wall_only() and direction != 0:
			is_wall_sliding = true
			is_wall_jumping = false
			wall_jump_lock_timer = 0.0
			jump_count = 1 
			if velocity.y > WALL_SLIDE_SPEED:
				velocity.y = WALL_SLIDE_SPEED
			
			# SEKARANG DI SINI: Saat menempel dinding, mainkan animasi wall_jump
			pink_guy_animation.animation = "wall_jump" 
		
		else:
			is_wall_sliding = false
			
			if not is_wall_jumping:
				if jump_count == 2:
					pink_guy_animation.animation = "double_jump"
				elif velocity.y > 0:
					pink_guy_animation.animation = "fall"
				else:
					pink_guy_animation.animation = "jump"

	if can_move:
		if Input.is_action_just_pressed("jump"):
			if is_wall_sliding:
				var wall_normal = get_wall_normal() 
				velocity.x = wall_normal.x * WALL_JUMP_VELOCITY_X
				velocity.y = WALL_JUMP_VELOCITY_Y
				jump_sound.play()
				jump_count = 1
				is_wall_sliding = false
				
				is_wall_jumping = true
				wall_jump_lock_timer = WALL_JUMP_LOCK_DURATION
				
				# SEKARANG DI SINI: Saat terpental melompat, gunakan animasi jump biasa (atau fall)
				pink_guy_animation.play("jump") 
				
			elif is_on_floor() or jump_count < MAX_JUMPS:
				velocity.y = JUMP_VELOCITY
				jump_sound.play()
				jump_count += 1

	if wall_jump_lock_timer <= 0.0:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta * 2)

	move_and_slide()

	# Logika Membalik Sprite (Flip) yang Sudah Diperbaiki Total
	if not is_wall_sliding:
		# Jika dalam durasi terpental wall jump, ikuti arah velocity fisik
		if wall_jump_lock_timer > 0.0:
			if velocity.x > 0:
				pink_guy_animation.flip_h = false
			elif velocity.x < 0:
				pink_guy_animation.flip_h = true
		# Jika berjalan/melompat biasa di tanah/udara, ikuti input tombol
		else:
			if direction == 1.0:
				pink_guy_animation.flip_h = false
			elif direction == -1.0:
				pink_guy_animation.flip_h = true
	else:
		# Jika sedang merosot (sliding), ambil Vector2 utuh dari dinding
		var wall_normal := get_wall_normal()
		
		# Jika normal x positif berarti dinding ada di kiri, sprite menghadap kiri (true)
		if wall_normal.x > 0.0:
			pink_guy_animation.flip_h = true
		# Jika normal x negatif berarti dinding ada di kanan, sprite menghadap kanan (false)
		elif wall_normal.x < 0.0:
			pink_guy_animation.flip_h = false



func die() -> void:
	die_sound.play()
	pink_guy_animation.animation = "hit"
	alive = false

func _on_pink_guy_animation_animation_finished() -> void:
	if pink_guy_animation.animation == "double_jump":
		pink_guy_animation.animation = "fall"
