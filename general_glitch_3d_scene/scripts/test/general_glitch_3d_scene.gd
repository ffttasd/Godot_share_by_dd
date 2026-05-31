extends Node3D

@export var orbit_root_path: NodePath = NodePath("OrbitingProps")
@export_range(0.0, 4.0, 0.01) var orbit_speed: float = 0.28

@onready var _orbit_root: Node3D = get_node_or_null(orbit_root_path) as Node3D


func _process(delta: float) -> void:
	if _orbit_root != null:
		_orbit_root.rotation.y += delta * orbit_speed
