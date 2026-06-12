extends Control

@export var overlay_path: NodePath = NodePath("VFXLayer/DizzyVisionOverlay")
@export var target_path: NodePath = NodePath("SceneContent/CenterObject")
@export var debris_root_path: NodePath = NodePath("SceneContent/Debris")
@export var motion_samples_path: NodePath = NodePath("SceneContent/MotionSamples")
@export var status_label_path: NodePath = NodePath("StatusLayer/StatusLabel")

@onready var _overlay: Node = get_node_or_null(overlay_path)
@onready var _target := get_node_or_null(target_path) as Control
@onready var _debris_root := get_node_or_null(debris_root_path) as Control
@onready var _motion_samples_root := get_node_or_null(motion_samples_path) as Control
@onready var _status_label := get_node_or_null(status_label_path) as Label

var _elapsed := 0.0
var _status_refresh_elapsed := 0.0
var _status_note := "Ready"
var _motion_sample_base_positions: Dictionary = {}


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_process(true)
	set_process_unhandled_input(true)
	if _overlay != null:
		if _overlay.has_method("refresh_shader_parameters"):
			_overlay.call("refresh_shader_parameters")
		if _overlay.has_signal("impact_pulse_finished"):
			_overlay.connect("impact_pulse_finished", Callable(self, "_on_impact_pulse_finished"))
	_cache_motion_sample_positions()
	_update_status()


func _process(delta: float) -> void:
	_elapsed += delta
	_status_refresh_elapsed += delta
	_animate_scene_content()
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


func _animate_scene_content() -> void:
	var viewport_size := get_viewport_rect().size
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		viewport_size = Vector2(1920.0, 1080.0)

	if _target != null:
		var drift := Vector2(
			sin(_elapsed * 0.62) * viewport_size.x * 0.012,
			cos(_elapsed * 0.84) * viewport_size.y * 0.008
		)
		_target.position = viewport_size * Vector2(0.5, 0.62) + drift - _target.size * 0.5
		_target.pivot_offset = _target.size * 0.5
		_target.rotation = sin(_elapsed * 0.8) * 0.035

	if _debris_root != null:
		var index := 0
		for child in _debris_root.get_children():
			var item := child as Control
			if item == null:
				continue
			var phase := _elapsed * (0.55 + float(index) * 0.07) + float(index) * 1.9
			item.rotation = sin(phase) * 0.045
			item.scale = Vector2.ONE * (1.0 + sin(phase * 1.2) * 0.018)
			index += 1

	if _motion_samples_root != null:
		var sample_index := 0
		for child in _motion_samples_root.get_children():
			var item := child as Control
			if item == null:
				continue
			if not _motion_sample_base_positions.has(item):
				_motion_sample_base_positions[item] = item.position
			var base_position := _motion_sample_base_positions[item] as Vector2
			var sample_phase := _elapsed * (0.82 + float(sample_index) * 0.13) + float(sample_index) * 1.37
			item.position = base_position + Vector2(
				sin(sample_phase) * (10.0 + float(sample_index) * 2.5),
				cos(sample_phase * 0.84) * (7.0 + float(sample_index) * 1.8)
			)
			item.pivot_offset = item.size * 0.5
			item.rotation = sin(sample_phase * 1.18) * (0.05 + float(sample_index) * 0.008)
			item.scale = Vector2.ONE * (1.0 + sin(sample_phase * 1.6) * 0.025)
			sample_index += 1


func _cache_motion_sample_positions() -> void:
	_motion_sample_base_positions.clear()
	if _motion_samples_root == null:
		return

	for child in _motion_samples_root.get_children():
		var item := child as Control
		if item != null:
			_motion_sample_base_positions[item] = item.position


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

	_status_label.text = "Dizzy vision VFX test\nIntensity: %.2f   Pulse: %.2f   Effect: %s   %s\nSpace: impact   R: restart loop   F: toggle" % [
		amount,
		pulse,
		enabled_text,
		_status_note,
	]


func _on_impact_pulse_finished() -> void:
	if _status_note == "Impact pulse":
		_status_note = "Pulse complete"
	_update_status()
