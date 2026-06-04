@tool
extends Node3D

@export var airflow_material: ShaderMaterial:
	set(value):
		airflow_material = value
		_refresh_airflow()

@export var uv_scale := Vector2(1.25, 3.6):
	set(value):
		uv_scale = value
		_sync_shader_parameters()

@export_range(0.0, 1.0, 0.01) var threshold := 0.58:
	set(value):
		threshold = value
		_sync_shader_parameters()

@export var s_ramp_texture: Texture2D:
	set(value):
		s_ramp_texture = value
		_sync_shader_parameters()

@export_range(0.0, 6.0, 0.01) var head_brightness := 2.4:
	set(value):
		head_brightness = value
		_sync_shader_parameters()

@export var s_min := 0.0:
	set(value):
		s_min = value
		_sync_shader_parameters()

@export var s_max := 0.0405:
	set(value):
		s_max = value
		_sync_shader_parameters()

@export var flip_s_ramp := false:
	set(value):
		flip_s_ramp = value
		_sync_shader_parameters()

@export var spin_speed := 0.18

func _ready() -> void:
	_refresh_airflow()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	rotate_y(delta * spin_speed)


func _refresh_airflow() -> void:
	if not is_inside_tree() or airflow_material == null:
		return

	_sync_shader_parameters()
	for child in find_children("*", "MeshInstance3D", true, false):
		var mesh_instance := child as MeshInstance3D
		mesh_instance.material_override = airflow_material
		mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _sync_shader_parameters() -> void:
	if airflow_material == null:
		return

	airflow_material.set_shader_parameter("uv_scale", uv_scale)
	airflow_material.set_shader_parameter("threshold", threshold)
	if s_ramp_texture != null:
		airflow_material.set_shader_parameter("s_ramp_texture", s_ramp_texture)
	airflow_material.set_shader_parameter("head_brightness", head_brightness)
	airflow_material.set_shader_parameter("s_min", s_min)
	airflow_material.set_shader_parameter("s_max", s_max)
	airflow_material.set_shader_parameter("flip_s_ramp", flip_s_ramp)
