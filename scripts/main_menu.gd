extends CanvasLayer
@onready var mainmenu_music = $MainMenuMusic


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Main Menu theme
	if mainmenu_music.playing == false:
		mainmenu_music.play()

# Currently loads level 0, implement level selection menu
func _on_start_btn_pressed():
	SceneManager.loadNewLevel("res://levels/Level0.5.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
