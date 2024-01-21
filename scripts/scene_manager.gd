extends Node

var loaded_level
var current_level
	
func loadNewLevel(newlevel):
	get_tree().change_scene_to_file(newlevel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
