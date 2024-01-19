extends Area3D
class_name SpawnArea

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		var objectsInRange = get_overlapping_areas()
		var glow = $SpawnCircle.get_surface_override_material(0)
		if objectsInRange == []:
			pass
		if objectsInRange != []:
			var objectInRange = objectsInRange[0]
			if objectInRange.get_parent_node_3d() is Player and objectInRange.get_parent_node_3d().get("crystalsCollected") != 0:
				glow.emission_energy_multiplier = 13
				$CompleteParticles.emitting = true
				if Input.is_action_just_pressed("activate"):
					objectInRange.get_parent_node_3d().gravity += 80
					$CompleteParticles.gravity.y = 120
					$FaderTransition.fade_to_black()
		else:
			glow.emission_energy_multiplier = 0.1
			$CompleteParticles.emitting = false
