tool
extends Resource
class_name RMSS2D_Material_Shape

"""
This material represents the set of edge materials used for a RMSmartShape2D
Each edge represents a set of textures used to render an edge
"""

# List of materials this shape can use
# Should be RMSS2D_Material_Edge_Metadata
export (Array, Resource) var _edge_materials: Array = [] setget set_edge_materials
export (Array, Texture) var fill_textures: Array = [] setget set_fill_textures
export (Array, Texture) var fill_texture_normals: Array = [] setget set_fill_texture_normals
export (int) var fill_texture_z_index: int = -10 setget set_fill_texture_z_index

# How much to offset all edges
export (float, -1.5, 1.5, 0.1) var render_offset: float = 0.0

# If edges should be welded to the edges surrounding it
export (bool) var weld_edges: bool = true setget set_weld_edges


# Get all valid edge materials for this normal
func get_edge_materials(normal: Vector2) -> Array:
	var materials = []
	for e in _edge_materials:
		if e == null:
			continue
		if e.normal_range.is_in_range(normal):
			materials.push_back(e)
	return materials


func get_all_edge_materials() -> Array:
	return _edge_materials


func add_edge_material(e: RMSS2D_Material_Edge_Metadata):
	var new_array = _edge_materials.duplicate()
	new_array.push_back(e)
	set_edge_materials(new_array)


func _on_edge_material_changed():
	emit_signal("changed")


func set_fill_textures(a: Array):
	fill_textures = a
	emit_signal("changed")


func set_fill_texture_normals(a: Array):
	fill_texture_normals = a
	emit_signal("changed")


func set_weld_edges(b: bool):
	weld_edges = b
	emit_signal("changed")


func set_fill_texture_z_index(i: int):
	fill_texture_z_index = i
	emit_signal("changed")


func set_edge_materials(a: Array):
	for e in _edge_materials:
		if e == null:
			continue
		if not a.has(e):
			e.disconnect("changed", self, "_on_edge_material_changed")

	for e in a:
		if e == null:
			continue
		if not e.is_connected("changed", self, "_on_edge_material_changed"):
			e.connect("changed", self, "_on_edge_material_changed")

	_edge_materials = a
	emit_signal("changed")
