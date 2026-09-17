extends Node2D

@onready var score_label: Label = $HUD/score_panel/score_label  # Sesuaikan jalur HUD Anda jika ada
@onready var fade: ColorRect = $HUD/Fade

@onready var game_over_panel: Panel = $HUD/game_over_panel
@onready var your_score_label: Label = $HUD/game_over_panel/your_score_label
@onready var best_score_label: Label = $HUD/game_over_panel/best_score_label
@onready var retry_button: Button = $HUD/game_over_panel/retry_button
@onready var quit_button: Button = $HUD/game_over_panel/quit_button

var score: int = 0
var best_score: int = 0
var level: int = 1
const MAX_LEVELS = 2 
var current_level_root: Node = null

func _ready() -> void:
	# Sembunyikan panel saat game dimulai
	if game_over_panel:
		game_over_panel.visible = false
		
	# --- MENGHUBUNGKAN FUNGSI TOMBOL ---
	retry_button.pressed.connect(_on_retry_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
		
	# Setup the level
	fade.modulate.a = 1.0
	current_level_root = get_node("levelroot")
	await _load_level(level, true, false)


#------------------------
# LEVEL MANAGEMENT
#------------------------

func _load_level(level_number: int, first_load: bool, reset_score : bool) -> void:
	# Fade Out
	if not first_load:
		await _fade(1.0)
	
	if reset_score:
		score = 0 
		score_label.text = "SCORE: 0"
		
	if current_level_root:
		current_level_root.queue_free()
		

	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	
	if not ResourceLoader.exists(level_path):
		print("Level file tidak ditemukan, me-looping kembali ke Level 1")
		level = 1
		level_path = "res://scenes/levels/level1.tscn"
		score = 0
		score_label.text = "SCORE: 0"
	
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "levelroot"
	_setup_level(current_level_root)
	
	if game_over_panel:
		game_over_panel.visible = false
	
	# Fade In
	await _fade(0.0)
	
func _setup_level(level_root: Node) -> void:
	# Connect Exit
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		if not exit.body_entered.is_connected(_on_exit_body_entered):
			exit.body_entered.connect(_on_exit_body_entered)

	# Connect Enemies
	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			if not enemy.player_died.is_connected(_on_player_died):
				enemy.player_died.connect(_on_player_died)

	# Connect Apples
	var apples = level_root.get_node_or_null("Apples")
	if apples:
		for apple in apples.get_children():
			if not apple.collected.is_connected(increase_score):
				apple.collected.connect(increase_score)

#------------------------
# SIGNAL HANDLERS
#------------------------
func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "player":
		level += 1
		body.can_move = false
		
		if level > 3: 
			level = 1
			
			await _load_level(level, false, false) 
		else:
			await _load_level(level, false, false)

func _on_player_died(body):
	body.die()
	

	if score > best_score:
		best_score = score
		

	if game_over_panel and your_score_label and best_score_label:
		your_score_label.text = "YOUR SCORE: %s" % score
		best_score_label.text = "BEST SCORE: %s" % best_score
		game_over_panel.visible = true

#------------------------
# SCORE
#------------------------

func increase_score() -> void:
	score += 1
	score_label.text = "SCORE: %s" % score

#------------------------
# FADE
#------------------------

func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished

#------------------------
# UI BUTTON HANDLERS
#------------------------

func _on_retry_button_pressed() -> void:
	game_over_panel.visible = false
	await _load_level(level, false, true)

func _on_quit_button_pressed() -> void:
	game_over_panel.visible = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn") 

func _on_close_button_pressed() -> void:
	game_over_panel.visible = false
