extends Area3D
class_name NPC

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		var objectsInRange = get_overlapping_areas()
		if objectsInRange == []:
			pass
		if objectsInRange != []:
			var objectInRange = objectsInRange[0]
			if objectInRange.get_parent_node_3d() is Player:
				if Input.is_action_pressed("activate"):
					$DialogueBox.start()
					
