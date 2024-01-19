@tool
extends MeshInstance3D

@export var xSize = 20
@export var zSize = 20

@export var update = false
@export var clear_vert_vis = false

func _ready():
	generate_terrain()

func generate_terrain():
	var a_mesh:ArrayMesh
	var surftool = SurfaceTool.new()
	var n = FastNoiseLite.new()
	n.noise_type = FastNoiseLite.TYPE_PERLIN
	n.frequency = 0.1
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(zSize+1):
		for x in range(xSize+1):
			var y = n.get_noise_2d(x,z) * 5
			
			surftool.add_vertex(Vector3(x, y, z))
			draw_sphere(Vector3(x, y, z))
	
	var vert = 0
	for z in zSize:
		for x in xSize:
			surftool.add_index(vert+0)
			surftool.add_index(vert+1)
			surftool.add_index(vert+xSize+1)
			surftool.add_index(vert+xSize+1)
			surftool.add_index(vert+1)
			surftool.add_index(vert+xSize+2)
			vert+=1
		vert+=1
	surftool.generate_normals()
	a_mesh = surftool.commit()
	
	mesh = a_mesh
	
func draw_sphere(pos:Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height = 0.2
	ins.mesh = sphere
	
func _process(delta):
	if update:
		generate_terrain()
		update = false
	
	if clear_vert_vis:
		for i in get_children():
			i.free()
