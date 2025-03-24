extends Node

var initial_time: float = 60.0  
var time_left: float = 60.0
var running: bool = true  

func _ready():
	time_left = initial_time  
	print("[TimerManager] Timer Started! Initial Time:", time_left)  

func _process(delta):
	if running:
		time_left -= delta  
		print("[TimerManager] Time Left:", time_left)  

		if time_left <= 0:
			time_left = 0
			running = false
			store_final_time()  # ✅ Save the time BEFORE ending
			on_timer_end()

func add_time(amount: float):
	time_left += amount  
	print("[TimerManager] Time Added! New Time Left:", time_left)  

func store_final_time():
	GlobalVars.final_time = initial_time - time_left  
	print("[TimerManager] Final Time Stored:", GlobalVars.final_time)  

func on_timer_end():
	print("[TimerManager] Final Time Before Scene Change:", GlobalVars.final_time)  
	
	# Wait before changing scene
	get_tree().paused = true
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	
	# Print again before changing scene
	print("[TimerManager] Changing to ending screen... Final Time:", GlobalVars.final_time)
	
	get_tree().change_scene_to_file("res://Scenes/ending_screen.tscn")
