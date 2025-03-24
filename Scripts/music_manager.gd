extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var game_music: AudioStream = load("res://Assets/sound/Three Red Hearts - Deep Blue.ogg")  # Change this to your actual music file

func _ready():
	music_player.stream = game_music
	music_player.volume_db = -20
	music_player.bus = "Music"  # Assign to "Music" bus
	music_player.finished.connect(_on_music_finished)
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS  # 🚀 Music keeps playing when paused!
	add_child(music_player)

func play_music():
	if not music_player.playing:
		music_player.play()

func stop_music():
	music_player.stop()

func _on_music_finished():
	music_player.play()  # Loops music automatically
