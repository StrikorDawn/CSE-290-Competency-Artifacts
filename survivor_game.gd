extends Node2D
@onready var end_text: Label = %EndText
@onready var score: Label = %Score
@onready var try_again: Button = $"GameOver/Try Again"
@onready var quit: Button = $GameOver/Quit


const MOB = preload("res://mob.tscn")
var points = 0
var mob_count = 0
var mob_max = 50

func _ready():
	# Set the game over menu to process even when the game is paused
	%GameOver.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	for child in %GameOver.get_children():
		child.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func spawn_mob():
	if mob_count <= mob_max:
		var new_mob = MOB.instantiate()
		%PathFollow2D.progress_ratio = randf()
		var size = randf_range(0.33, 1)  # Corrected function
		new_mob.scale = Vector2(size, size)
		new_mob.global_position = %PathFollow2D.global_position
		add_child(new_mob)
		# Connect the mob_killed signal
		new_mob.connect("mob_killed", Callable(self, "_on_mob_mob_killed"))
		mob_count += 1
		
func _on_timer_timeout() -> void:
	spawn_mob()
	

func _on_mob_mob_killed(mob_instance):
	mob_count -= 1
	var mob_scale = mob_instance.scale
	if mob_scale >= Vector2(0.75, 0.75):
		points += 3
	elif mob_scale > Vector2(0.65, 0.65):
		points += 2
	else:
		points += 1
	
	score.text = "Score: " + str(points)

func _on_player_health_depleted() -> void:
	$GameOver.visible = true
	get_tree().paused = true
	end_text.text = "GAME OVER!\n" + "Final Score: " + str(points) + "\nWould you like to play again?"

func _on_try_again_pressed() -> void:
	%GameOver.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().quit()
