extends Node3D

@export var overlay_path: NodePath = NodePath("VFXLayer/DizzyVisionOverlay")
@export var camera_path: NodePath = NodePath("Camera3D")
@export var orbit_root_path: NodePath = NodePath("SceneContent/MotionProps")
@export var center_object_path: NodePath = NodePath("SceneContent/CenterObject")
@export var status_label_path: NodePath = NodePath("StatusLayer/StatusLabel")

@onready var _overlay: Node = get_node_or_null(overlay_path)
@onready var _camera: Camera3D = get_node_or_null(camera_path) as Camera3D
@onready var _orbit_root: Node3D = get_node_or_null(orbit_root_path) as Node3D
@onready var _center_object: Node3D = get_node_or_null(center_object_path) as Node3D
@onready var _status_label: Label = get_node_or_null(status_label_path) as Label

var _elapsed := 0.0
var _status_refresh_elapsed := 0.0
var _status_note := "Ready"
var _camera_base_position := Vector3.ZERO
var _motion_base_transforms: Dictionary = {}


func _ready() -> void:
	set_process(true)
	set_process_unhandled_input(true)

	if _camera != null:
		_camera_base_position = _camera.global_position

	if _overlay != null:
		if _overlay.has_method("refresh_shader_parameters"):
			_overlay.call("refresh_shader_parameters")
		if _overlay.has_signal("impact_pulse_finished"):
			_overlay.connect("impact_pulse_finished", Callable(self, "_on_impact_pulse_finished"))

	_cache_motion_transforms()
	_update_status()


func _process(delta: float) -> void:
	_elapsed += delta
	_status_refresh_elapsed += delta
	_animate_3d_content(delta)

	if _status_refresh_elapsed >= 0.1:
		_status_refresh_elapsed = 0.0
		_update_status()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return

	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return

	match key_event.physical_keycode:
		KEY_SPACE:
			if _overlay != null:
				_status_note = "Impact pulse"
				_overlay.call("play_impact_pulse")
				_update_status()
				get_viewport().set_input_as_handled()
		KEY_R:
			if _overlay != null:
				_status_note = "Looping"
				_overlay.call("set_effect_enabled", true)
				_overlay.call("set_intensity", 0.78)
				_overlay.call("set_pulse_strength", 0.0)
				_overlay.call("set_loop_enabled", true)
				_update_status()
				get_viewport().set_input_as_handled()
		KEY_F:
			if _overlay != null:
				var next_enabled := not bool(_overlay.call("is_effect_enabled"))
				_overlay.call("set_effect_enabled", next_enabled)
				_status_note = "Effect on" if next_enabled else "Effect off"
				_update_status()
				get_viewport().set_input_as_handled()


func _animate_3d_content(delta: float) -> void:
	if _camera != null:
		var camera_offset := Vector3(
			sin(_elapsed * 0.48) * 0.16,
			sin(_elapsed * 0.73) * 0.06,
			cos(_elapsed * 0.41) * 0.08
		)
		_camera.global_position = _camera_base_position + camera_offset
		_camera.look_at(Vector3(0.0, 0.7, -0.35), Vector3.UP)

	if _center_object != null:
		_center_object.rotation.y = sin(_elapsed * 0.68) * 0.12
		_center_object.position.y = 0.18 + sin(_elapsed * 1.1) * 0.035

	if _orbit_root == null:
		return

	_orbit_root.rotation.y += delta * 0.28
	var index := 0
	for child in _orbit_root.get_children():
		var item := child as Node3D
		if item == null:
			continue
		if not _motion_base_transforms.has(item):
			_motion_base_transforms[item] = item.transform

		var base: Transform3D = _motion_base_transforms[item]
		var phase := _elapsed * (0.74 + float(index) * 0.11) + float(index) * 1.47
		item.position = base.origin + Vector3(
			sin(phase) * (0.07 + float(index) * 0.01),
			cos(phase * 0.82) * (0.08 + float(index) * 0.012),
			sin(phase * 0.63) * 0.05
		)
		item.rotation = base.basis.get_euler() + Vector3(
			sin(phase * 0.9) * 0.12,
			cos(phase * 0.7) * 0.2,
			sin(phase * 1.2) * 0.16
		)
		index += 1


func _cache_motion_transforms() -> void:
	_motion_base_transforms.clear()
	if _orbit_root == null:
		return

	for child in _orbit_root.get_children():
		var item := child as Node3D
		if item != null:
			_motion_base_transforms[item] = item.transform


func _update_status() -> void:
	if _status_label == null:
		return

	var amount := 0.0
	var pulse := 0.0
	var enabled_text := "off"
	if _overlay != null:
		amount = float(_overlay.get("intensity"))
		pulse = float(_overlay.get("pulse_strength"))
		enabled_text = "on" if bool(_overlay.call("is_effect_enabled")) else "off"

	_status_label.text = "Dizzy vision 3D screen VFX\nIntensity: %.2f   Pulse: %.2f   Effect: %s   %s\nSpace: impact   R: restart loop   F: toggle" % [
		amount,
		pulse,
		enabled_text,
		_status_note,
	]


func _on_impact_pulse_finished() -> void:
	if _status_note == "Impact pulse":
		_status_note = "Pulse complete"
	_update_status()
