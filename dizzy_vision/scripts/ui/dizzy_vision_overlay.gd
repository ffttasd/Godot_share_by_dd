@tool
extends ColorRect
class_name DizzyVisionOverlay

signal impact_pulse_finished

const SHADER_PATH := "res://shaders/dizzy_vision_overlay.gdshader"

@export var effect_enabled := true:
	set(value):
		effect_enabled = value
		visible = value
		_push_dynamic_shader_params()
@export var loop_on_ready := false:
	set(value):
		loop_on_ready = value
		if not is_inside_tree():
			return
		if Engine.is_editor_hint():
			set_loop_enabled(false)
			_push_dynamic_shader_params()
		elif value:
			set_loop_enabled(true)
		else:
			set_loop_enabled(false)

@export_group("Runtime")
@export_range(0.0, 1.0, 0.01) var intensity: float = 0.78:
	set(value):
		intensity = clampf(value, 0.0, 1.0)
		_push_dynamic_shader_params()
@export_range(0.0, 1.0, 0.01) var pulse_strength: float = 0.0:
	set(value):
		pulse_strength = clampf(value, 0.0, 1.0)
		_push_dynamic_shader_params()
@export_range(0.1, 8.0, 0.01) var pulse_release_duration: float = 1.35

@export_group("Distortion")
@export_range(0.0, 80.0, 0.1) var distortion_strength_px: float = 30.0:
	set(value):
		distortion_strength_px = maxf(value, 0.0)
		_push_static_shader_params()
@export_range(0.0, 30.0, 0.1) var blur_strength_px: float = 7.0:
	set(value):
		blur_strength_px = maxf(value, 0.0)
		_push_static_shader_params()
@export_range(0.0, 80.0, 0.1) var sway_strength_px: float = 18.0:
	set(value):
		sway_strength_px = maxf(value, 0.0)
		_push_static_shader_params()

@export_group("Focus")
@export var focus_center: Vector2 = Vector2(0.5, 0.58):
	set(value):
		focus_center = value
		_push_static_shader_params()
@export_range(0.0, 0.8, 0.01) var focus_radius: float = 0.16:
	set(value):
		focus_radius = clampf(value, 0.0, 0.8)
		_push_static_shader_params()
@export_range(0.01, 0.8, 0.01) var focus_feather: float = 0.34:
	set(value):
		focus_feather = clampf(value, 0.01, 0.8)
		_push_static_shader_params()

@export_group("Grade")
@export_range(0.0, 1.0, 0.01) var vignette_strength: float = 0.46:
	set(value):
		vignette_strength = clampf(value, 0.0, 1.0)
		_push_static_shader_params()
@export var tint_color: Color = Color(0.46, 0.62, 0.88, 0.18):
	set(value):
		tint_color = value
		_push_static_shader_params()
@export_range(0.0, 1.0, 0.01) var desaturation: float = 0.36:
	set(value):
		desaturation = clampf(value, 0.0, 1.0)
		_push_static_shader_params()

var _shader_material: ShaderMaterial
var _loop_enabled := false
var _loop_tween: Tween
var _pulse_tween: Tween


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	offset_left = 0.0
	offset_top = 0.0
	offset_right = 0.0
	offset_bottom = 0.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	color = Color.WHITE
	_cache_material()
	_push_static_shader_params()
	_push_dynamic_shader_params()
	visible = effect_enabled
	if Engine.is_editor_hint():
		return
	if loop_on_ready:
		set_loop_enabled(true)


func _exit_tree() -> void:
	_kill_tween(_loop_tween)
	_kill_tween(_pulse_tween)


func set_intensity(value: float) -> void:
	intensity = value


func set_pulse_strength(value: float) -> void:
	pulse_strength = value


func refresh_shader_parameters() -> void:
	_cache_material()
	_push_static_shader_params()
	_push_dynamic_shader_params()


func set_effect_enabled(enabled: bool) -> void:
	effect_enabled = enabled
	if not enabled:
		_kill_tween(_pulse_tween)
		_pulse_tween = null
		set_pulse_strength(0.0)


func is_effect_enabled() -> bool:
	return effect_enabled


func play_impact_pulse() -> void:
	if Engine.is_editor_hint():
		set_pulse_strength(1.0)
		return
	set_effect_enabled(true)
	_kill_tween(_pulse_tween)
	_pulse_tween = create_tween()
	set_pulse_strength(1.0)
	_pulse_tween.tween_method(set_pulse_strength, 1.0, 0.0, pulse_release_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_pulse_tween.finished.connect(_on_impact_pulse_finished)


func stop_effect() -> void:
	set_loop_enabled(false)
	_kill_tween(_pulse_tween)
	_pulse_tween = null
	set_pulse_strength(0.0)
	set_intensity(0.0)
	set_effect_enabled(false)


func set_loop_enabled(enabled: bool) -> void:
	if Engine.is_editor_hint():
		_loop_enabled = false
		_kill_tween(_loop_tween)
		_loop_tween = null
		return

	if _loop_enabled == enabled and (not enabled or _loop_tween != null):
		return

	_loop_enabled = enabled
	if enabled:
		set_effect_enabled(true)
		_start_loop_tween()
	else:
		_kill_tween(_loop_tween)
		_loop_tween = null


func is_loop_enabled() -> bool:
	return _loop_enabled


func _cache_material() -> void:
	_shader_material = material as ShaderMaterial
	if _shader_material != null:
		return

	var shader := load(SHADER_PATH) as Shader
	if shader == null:
		push_warning("DizzyVisionOverlay could not load %s." % SHADER_PATH)
		return

	_shader_material = ShaderMaterial.new()
	_shader_material.resource_local_to_scene = true
	_shader_material.shader = shader
	material = _shader_material


func _push_static_shader_params() -> void:
	if _shader_material == null:
		_cache_material()
	if _shader_material == null:
		return

	_shader_material.set_shader_parameter(&"distortion_strength_px", distortion_strength_px)
	_shader_material.set_shader_parameter(&"blur_strength_px", blur_strength_px)
	_shader_material.set_shader_parameter(&"sway_strength_px", sway_strength_px)
	_shader_material.set_shader_parameter(&"focus_center", focus_center)
	_shader_material.set_shader_parameter(&"focus_radius", focus_radius)
	_shader_material.set_shader_parameter(&"focus_feather", focus_feather)
	_shader_material.set_shader_parameter(&"vignette_strength", vignette_strength)
	_shader_material.set_shader_parameter(&"tint_color", tint_color)
	_shader_material.set_shader_parameter(&"desaturation", desaturation)
	queue_redraw()


func _push_dynamic_shader_params() -> void:
	if _shader_material == null:
		_cache_material()
	if _shader_material == null:
		return

	var shader_intensity := intensity if effect_enabled else 0.0
	var shader_pulse := pulse_strength if effect_enabled else 0.0
	_shader_material.set_shader_parameter(&"intensity", shader_intensity)
	_shader_material.set_shader_parameter(&"pulse_strength", shader_pulse)
	queue_redraw()


func _start_loop_tween() -> void:
	_kill_tween(_loop_tween)
	_loop_tween = create_tween()
	_loop_tween.set_loops()
	_loop_tween.tween_method(set_intensity, 0.68, 0.96, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_loop_tween.tween_method(set_intensity, 0.96, 0.72, 1.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_loop_tween.tween_interval(0.25)


func _kill_tween(tween: Tween) -> void:
	if tween != null and tween.is_valid():
		tween.kill()


func _on_impact_pulse_finished() -> void:
	_pulse_tween = null
	impact_pulse_finished.emit()
