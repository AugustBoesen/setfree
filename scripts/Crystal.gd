extends Area3D
class_name CrystalActivate

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		var objectsInRange = get_overlapping_areas()
		var glow = get_parent_node_3d().get_surface_override_material(1)
		if objectsInRange == []:
			pass
		if objectsInRange != []:
			var objectInRange = objectsInRange[0]
			if objectInRange.get_parent_node_3d() is Player:
				
				glow.emission_energy_multiplier = 13
		else:
			glow.emission_energy_multiplier = 1
