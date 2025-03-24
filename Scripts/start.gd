extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.stop_music()  


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	MusicManager.play_music()  # Start game music
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")
