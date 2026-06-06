@tool
extends MeshInstance3D

@export var follow_camera: bool = true:
	set(value):
		follow_camera = value
		set_process(follow_camera)
@export var update_in_editor: bool = true
@export var yaw_only: bool = true


func _ready() -> void:
	set_process(follow_camera)
	_update_facing()


func _process(_delta: float) -> void:
	if not follow_camera:
		return
	if Engine.is_editor_hint() and not update_in_editor:
		return

	_update_facing()


func _update_facing() -> void:
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return

	var target := camera.global_position
	if yaw_only:
		target.y = global_position.y

	if global_position.distance_squared_to(target) <= 0.000001:
		return

	var preserved_scale := scale
	look_at(target, Vector3.UP, true)
	rotate_y(PI)
	scale = preserved_scale
