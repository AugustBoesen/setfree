extends Area3D
class_name SpawnArea

@onready var activationnoise = $ActivationNoise
@onready var completionnoise = $CompletionNoise

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
				if activationnoise.playing == false:
					activationnoise.play()
				$CompleteParticles.emitting = true
				if Input.is_action_just_pressed("activate"):
					completionnoise.play()
					objectInRange.get_parent_node_3d().gravity += 80
					$CompleteParticles.gravity.y = 120
					$FaderTransition.fade_to_black()
		else:
			glow.emission_energy_multiplier = 0.1
			$CompleteParticles.emitting = false
			activationnoise.stop()
