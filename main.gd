extends Node2D
@onready var score_label: Label = $HUD/score_panel/score_label

var score:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
# Connect Enemies
func _setup_level() -> void:
	var enemies = $levelroot.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies .get_children():
			enemy.player_died.connect(_on_player_died)
			
# Connect Apples
	var apples = $levelroot.get_node_or_null("Apples")
	if apples:
		for apple in apples .get_children():
			apple.collected.connect(increase_score)
#------------------------
# SIGNAL HANDLERS
#------------------------
func _on_player_died(body):
	body.die()
	print ("Player Killed")

#------------------------
# SCORE
#------------------------

func increase_score() -> void:
	score += 1
	score_label.text = "SCORE: %s" % score
