extends ColorRect

@export_range(0.0, 1.0, 0.01) var intensity: float = 0.82:
	set(value):
		intensity = clampf(value, 0.0, 1.0)
		_push_shader_params()

@export var tint_color: Color = Color(0.9, 0.98, 1.0, 1.0):
	set(value):
		tint_color = value
		_push_shader_params()

@export_range(0.05, 1.0, 0.01) var flash_duration: float = 0.24

var _shader_material: ShaderMaterial
var _flash_elapsed := 0.0
var _flash_active := false


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	offset_left = 0.0
	offset_top = 0.0
	offset_right = 0.0
	offset_bottom = 0.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	color = Color.WHITE
	_shader_material = material as ShaderMaterial
	visible = false
	_push_shader_params()
	set_process(true)
	set_process_input(true)


func _process(delta: float) -> void:
	if not _flash_active:
		return

	_flash_elapsed += delta
	if _flash_elapsed >= flash_duration:
		_flash_active = false
		visible = false


func _input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return

	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return

	if key_event.physical_keycode == KEY_SPACE:
		trigger_glitch_flash()
		get_viewport().set_input_as_handled()


func trigger_glitch_flash() -> void:
	_flash_active = true
	_flash_elapsed = 0.0
	visible = true
	_push_shader_params()


func _push_shader_params() -> void:
	if _shader_material == null:
		_shader_material = material as ShaderMaterial
	if _shader_material == null:
		return

	_shader_material.set_shader_parameter("intensity", intensity)
	_shader_material.set_shader_parameter("tint_color", tint_color)
