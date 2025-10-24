extends Node

var difficulty : float = 1.0 # Decreases from 1 towards 0 over time
var time_elapsed : float = 0.0
var score := 0
const difficulty_ramp := 40 # The smaller this is, the faster the game gets harder

func _process(delta: float) -> void:
	time_elapsed += delta
	
	difficulty = 1 / (1 + time_elapsed / difficulty_ramp)
	# print(str(difficulty))
	
	# Score display
	if get_tree().has_group("score"):
		var scoreDisplay : RichTextLabel = get_tree().get_first_node_in_group("score")
		scoreDisplay.text = str(score)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func y(x):
	return -1 * x

func pause_game_for(duration: float) -> void:
	get_tree().paused = true
	await get_tree().create_timer(duration, Node.PROCESS_MODE_ALWAYS).timeout
	get_tree().paused = false
