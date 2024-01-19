extends CanvasLayer

signal transition_finished

func _ready():
	fade_to_normal()


func fade_to_black():
	$AnimationPlayer.play("fade_to_black")

func fade_to_normal():
	$AnimationPlayer.play("fade_to_normal")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("transition_finished")
		print("Changing Scene")
		get_tree().change_scene_to_file("res://levels/TEST.tscn")
