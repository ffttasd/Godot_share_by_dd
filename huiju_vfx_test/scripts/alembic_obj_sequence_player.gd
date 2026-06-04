@tool
extends MeshInstance3D
class_name AlembicObjSequencePlayer

signal playback_finished
signal frame_changed(frame_index: int)

const PROP_MANIFEST_PATH := "清单文件"
const PROP_AUTOPLAY := "自动播放"
const PROP_LOOP := "循环播放"
const PROP_CLEAR_MESH_WHEN_FINISHED := "结束时清空网格"
const PROP_BLANK_VERTEX_COUNT_THRESHOLD := "空白帧顶点阈值"
const PROP_PREVIEW_IN_EDITOR := "在编辑器预览"
const PROP_CURRENT_FRAME := "当前帧"
const PROP_FPS_OVERRIDE := "帧率覆盖"
const PROP_SPEED_SCALE := "速度倍率"
const PROP_START_FRAME := "起始帧"
const PROP_DISABLE_SHADOWS := "禁用阴影"

var manifest_path: String = ""
var autoplay: bool = true
var loop: bool = true
var clear_mesh_when_finished: bool = true
var blank_vertex_count_threshold: int = 0
var preview_in_editor: bool = false
var current_frame: int = 0
var fps_override: float = 0.0
var speed_scale: float = 1.0
var start_frame: int = 0
var disable_shadows: bool = true

var _frames: Array[Mesh] = []
var _frame_vertex_counts := PackedInt32Array()
var _playback_fps: float = 24.0
var _elapsed: float = 0.0
var _frame_index: int = 0
var _playing: bool = false
var _finished_emitted: bool = false


func _get_property_list() -> Array[Dictionary]:
	return [
		_storage_prop("manifest_path", TYPE_STRING),
		_storage_prop("autoplay", TYPE_BOOL),
		_storage_prop("loop", TYPE_BOOL),
		_storage_prop("clear_mesh_when_finished", TYPE_BOOL),
		_storage_prop("blank_vertex_count_threshold", TYPE_INT),
		_storage_prop("preview_in_editor", TYPE_BOOL),
		_storage_prop("current_frame", TYPE_INT),
		_storage_prop("fps_override", TYPE_FLOAT),
		_storage_prop("speed_scale", TYPE_FLOAT),
		_storage_prop("start_frame", TYPE_INT),
		_storage_prop("disable_shadows", TYPE_BOOL),
		_category_prop("序列资源"),
		_file_prop(PROP_MANIFEST_PATH, "*.json"),
		_prop(PROP_AUTOPLAY, TYPE_BOOL),
		_prop(PROP_LOOP, TYPE_BOOL),
		_prop(PROP_CLEAR_MESH_WHEN_FINISHED, TYPE_BOOL),
		_int_range_prop(PROP_BLANK_VERTEX_COUNT_THRESHOLD, 0, 999999, 1, "or_greater"),
		_category_prop("编辑器预览"),
		_prop(PROP_PREVIEW_IN_EDITOR, TYPE_BOOL),
		_int_range_prop(PROP_CURRENT_FRAME, 0, 9999, 1, "or_greater"),
		_category_prop("播放控制"),
		_range_prop(PROP_FPS_OVERRIDE, 0.0, 120.0, 0.01, "or_greater"),
		_range_prop(PROP_SPEED_SCALE, 0.01, 8.0, 0.01, "or_greater"),
		_int_range_prop(PROP_START_FRAME, 0, 9999, 1, "or_greater"),
		_prop(PROP_DISABLE_SHADOWS, TYPE_BOOL),
	]


func _get(property: StringName) -> Variant:
	match String(property):
		PROP_MANIFEST_PATH, "manifest_path":
			return manifest_path
		PROP_AUTOPLAY, "autoplay":
			return autoplay
		PROP_LOOP, "loop":
			return loop
		PROP_CLEAR_MESH_WHEN_FINISHED, "clear_mesh_when_finished":
			return clear_mesh_when_finished
		PROP_BLANK_VERTEX_COUNT_THRESHOLD, "blank_vertex_count_threshold":
			return blank_vertex_count_threshold
		PROP_PREVIEW_IN_EDITOR, "preview_in_editor":
			return preview_in_editor
		PROP_CURRENT_FRAME, "current_frame":
			return current_frame
		PROP_FPS_OVERRIDE, "fps_override":
			return fps_override
		PROP_SPEED_SCALE, "speed_scale":
			return speed_scale
		PROP_START_FRAME, "start_frame":
			return start_frame
		PROP_DISABLE_SHADOWS, "disable_shadows":
			return disable_shadows
	return null


func _set(property: StringName, value: Variant) -> bool:
	match String(property):
		PROP_MANIFEST_PATH, "manifest_path":
			manifest_path = String(value)
			if is_inside_tree():
				call_deferred("_reload_sequence")
		PROP_AUTOPLAY, "autoplay":
			autoplay = bool(value)
		PROP_LOOP, "loop":
			loop = bool(value)
		PROP_CLEAR_MESH_WHEN_FINISHED, "clear_mesh_when_finished":
			clear_mesh_when_finished = bool(value)
		PROP_BLANK_VERTEX_COUNT_THRESHOLD, "blank_vertex_count_threshold":
			blank_vertex_count_threshold = maxi(int(value), 0)
		PROP_PREVIEW_IN_EDITOR, "preview_in_editor":
			preview_in_editor = bool(value)
			if Engine.is_editor_hint() and not preview_in_editor:
				_apply_current_frame()
			_update_processing()
		PROP_CURRENT_FRAME, "current_frame":
			current_frame = maxi(int(value), 0)
			if not _frames.is_empty() and (Engine.is_editor_hint() or not _playing):
				_apply_current_frame()
		PROP_FPS_OVERRIDE, "fps_override":
			fps_override = maxf(float(value), 0.0)
		PROP_SPEED_SCALE, "speed_scale":
			speed_scale = maxf(float(value), 0.01)
		PROP_START_FRAME, "start_frame":
			start_frame = maxi(int(value), 0)
		PROP_DISABLE_SHADOWS, "disable_shadows":
			disable_shadows = bool(value)
			cast_shadow = (
				GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
				if disable_shadows
				else GeometryInstance3D.SHADOW_CASTING_SETTING_ON
			)
		_:
			return false
	return true


func _category_prop(prop_name: String) -> Dictionary:
	return {
		"name": prop_name,
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_CATEGORY,
	}


func _storage_prop(prop_name: String, prop_type: int) -> Dictionary:
	return {
		"name": prop_name,
		"type": prop_type,
		"usage": PROPERTY_USAGE_STORAGE,
	}


func _prop(prop_name: String, prop_type: int) -> Dictionary:
	return {
		"name": prop_name,
		"type": prop_type,
		"usage": PROPERTY_USAGE_EDITOR,
	}


func _file_prop(prop_name: String, filters: String) -> Dictionary:
	return {
		"name": prop_name,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE,
		"hint_string": filters,
		"usage": PROPERTY_USAGE_EDITOR,
	}


func _range_prop(prop_name: String, min_value: float, max_value: float, step: float, extra: String = "") -> Dictionary:
	var hint_string := "%s,%s,%s" % [min_value, max_value, step]
	if not extra.is_empty():
		hint_string += ",%s" % extra
	return {
		"name": prop_name,
		"type": TYPE_FLOAT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": hint_string,
		"usage": PROPERTY_USAGE_EDITOR,
	}


func _int_range_prop(prop_name: String, min_value: int, max_value: int, step: int, extra: String = "") -> Dictionary:
	var hint_string := "%d,%d,%d" % [min_value, max_value, step]
	if not extra.is_empty():
		hint_string += ",%s" % extra
	return {
		"name": prop_name,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": hint_string,
		"usage": PROPERTY_USAGE_EDITOR,
	}


func _ready() -> void:
	if disable_shadows:
		cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	if not manifest_path.is_empty():
		_reload_sequence()
	_playing = autoplay
	_update_processing()


func _process(delta: float) -> void:
	if _frames.is_empty():
		return
	if Engine.is_editor_hint() and not preview_in_editor:
		return
	if not _playing:
		return

	var playback_fps := fps_override if fps_override > 0.0 else _playback_fps
	if playback_fps <= 0.0:
		return

	_elapsed += delta * speed_scale
	var next_frame := start_frame + int(floor(_elapsed * playback_fps))
	if loop:
		next_frame = posmod(next_frame, _frames.size())
	elif next_frame >= _frames.size():
		_playing = false
		_update_processing()
		if clear_mesh_when_finished:
			_set_blank_frame()
		else:
			next_frame = _frames.size() - 1
			if next_frame != _frame_index:
				_set_frame(next_frame)
		_emit_finished_once()
		return
	if next_frame != _frame_index:
		_set_frame(next_frame)


func play() -> void:
	_playing = true
	_finished_emitted = false
	_update_processing()


func stop() -> void:
	_playing = false
	_update_processing()


func restart() -> void:
	_elapsed = 0.0
	_finished_emitted = false
	_set_frame(posmod(start_frame, max(1, _frames.size())))
	play()


func set_frame_index(frame_index: int) -> void:
	_playing = false
	_elapsed = 0.0
	_finished_emitted = false
	if clear_mesh_when_finished and frame_index >= _frames.size():
		_set_blank_frame()
	else:
		_set_frame(frame_index)
	_update_processing()


func _reload_sequence() -> void:
	_frames.clear()
	_frame_vertex_counts.clear()
	_elapsed = 0.0
	_frame_index = 0
	_finished_emitted = false

	var manifest := _read_manifest()
	if manifest.is_empty():
		mesh = null
		return

	_playback_fps = float(manifest.get("playback_fps", 24.0))
	var manifest_dir := manifest_path.get_base_dir()
	var frame_entries: Array = manifest.get("frames", [])
	for entry in frame_entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var relative_path := String(entry.get("path", ""))
		if relative_path.is_empty():
			continue
		var frame_path := manifest_dir.path_join(relative_path)
		var frame_mesh := load(frame_path) as Mesh
		if frame_mesh != null:
			_frames.append(frame_mesh)
			_frame_vertex_counts.append(_get_mesh_vertex_count(frame_mesh))
		else:
			push_warning("Failed to load Alembic OBJ frame: %s" % frame_path)

	if _frames.is_empty():
		mesh = null
		push_warning("No OBJ frames loaded for Alembic sequence: %s" % manifest_path)
		return

	if Engine.is_editor_hint() and not preview_in_editor:
		_apply_current_frame()
	else:
		_set_frame(posmod(start_frame, _frames.size()))
	_update_processing()


func _read_manifest() -> Dictionary:
	if manifest_path.is_empty():
		return {}
	var file := FileAccess.open(manifest_path, FileAccess.READ)
	if file == null:
		push_warning("Failed to open Alembic sequence manifest: %s" % manifest_path)
		return {}

	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Invalid Alembic sequence manifest JSON: %s" % manifest_path)
		return {}
	return parsed


func _set_frame(frame_index: int) -> void:
	if _frames.is_empty():
		return
	_frame_index = clampi(frame_index, 0, _frames.size() - 1)
	if _should_blank_frame(_frame_index):
		mesh = null
	else:
		mesh = _frames[_frame_index]
	frame_changed.emit(_frame_index)


func _apply_current_frame() -> void:
	if _frames.is_empty():
		return
	if clear_mesh_when_finished and current_frame >= _frames.size():
		_set_blank_frame()
		return
	_set_frame(posmod(current_frame, _frames.size()))


func _update_processing() -> void:
	var should_process := _playing and (not Engine.is_editor_hint() or preview_in_editor)
	set_process(should_process)


func _set_blank_frame() -> void:
	_frame_index = _frames.size()
	mesh = null
	frame_changed.emit(_frame_index)


func _should_blank_frame(frame_index: int) -> bool:
	if blank_vertex_count_threshold <= 0:
		return false
	if frame_index < 0 or frame_index >= _frame_vertex_counts.size():
		return false
	return _frame_vertex_counts[frame_index] <= blank_vertex_count_threshold


func _get_mesh_vertex_count(frame_mesh: Mesh) -> int:
	var array_mesh := frame_mesh as ArrayMesh
	if array_mesh == null:
		return frame_mesh.get_faces().size()

	var vertex_count := 0
	for surface_index in array_mesh.get_surface_count():
		var arrays := array_mesh.surface_get_arrays(surface_index)
		var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
		vertex_count += vertices.size()
	return vertex_count


func get_frame_count() -> int:
	return _frames.size()


func get_frame_index() -> int:
	return _frame_index


func get_playback_fps() -> float:
	return fps_override if fps_override > 0.0 else _playback_fps


func get_duration_seconds() -> float:
	var safe_fps := maxf(get_playback_fps() * speed_scale, 0.001)
	return float(_frames.size()) / safe_fps


func _emit_finished_once() -> void:
	if _finished_emitted:
		return
	_finished_emitted = true
	playback_finished.emit()
