@tool
extends Node3D

const BLACK_WHITE_FLASH_SHADER := preload("res://test/black_white_flash_3d_screen.gdshader")
const BLACK_WHITE_FLASH_SPEED_NOISE := preload("res://sprite/FX/vfx_textures/energy_noise.png")
const PRE_FLASH_STAR_TEXTURE := preload("res://sprite/FX/vfx_textures/star_flash.png")
const SOFT_FLARE_TEXTURE := preload("res://sprite/FX/vfx_textures/soft_flare.jpg")
const YUAN_AIRFLOW_SCENE := preload("res://ve/test/yuan_airflow_test.tscn")

const PROP_HUIJU_SEQUENCE_PATH := "汇聚序列节点"
const PROP_CORE_VISUALS_PATH := "核心视觉节点"
const PROP_BURST_ROOT_PATH := "攻击爆发节点"
const PROP_AUTOPLAY := "自动播放"
const PROP_RESTART_ON_CLICK := "点击重播"
const PROP_HIDE_HUIJU_WHEN_BURST_STARTS := "爆发时隐藏汇聚模型"
const PROP_BURST_START_FRAME := "爆发开始帧"
const PROP_CORE_GROW_START_FRAME := "核心生长起始帧"
const PROP_CORE_GROW_END_FRAME := "核心生长结束帧"
const PROP_CORE_START_SCALE := "核心初始缩放"
const PROP_CORE_FULL_SCALE_MULTIPLIER := "核心完整缩放倍率"
const PROP_CORE_RELEASE_SCALE := "核心释放缩放"
const PROP_CORE_STEPPED_GROWTH_ENABLED := "阶段跳跃生长"
const PROP_CORE_GROWTH_STAGE_COUNT := "生长阶段数量"
const PROP_CORE_GROWTH_FIRST_JUMP_START := "第一跳开始位置"
const PROP_CORE_GROWTH_INTERVAL_ACCEL := "后续跳跃加速"
const PROP_CORE_GROWTH_HOLD_RATIO := "阶段停顿比例"
const PROP_CORE_GROWTH_SNAP_SHARPNESS := "阶段跳跃锐度"
const PROP_CORE_GROWTH_OVERSHOOT := "阶段过冲强度"
const PROP_CORE_HEARTBEAT_ENABLED := "心跳启用"
const PROP_CORE_HEARTBEAT_AMOUNT := "心跳幅度"
const PROP_CORE_HEARTBEAT_HZ := "心跳频率"
const PROP_CORE_HEARTBEAT_SECOND_BEAT_PHASE := "心跳第二跳位置"
const PROP_CORE_HEARTBEAT_SECOND_BEAT_STRENGTH := "心跳第二跳强度"
const PROP_CORE_HEARTBEAT_SHARPNESS := "心跳锐度"
const PROP_CORE_TENSION_WHITEN_ENABLED := "蓄力拉白启用"
const PROP_CORE_TENSION_WHITEN_AMOUNT := "蓄力拉白强度"
const PROP_CORE_TENSION_WHITEN_HEARTBEAT := "心跳拉白强度"
const PROP_CORE_TENSION_WHITEN_GAMMA := "蓄力拉白伽马"
const PROP_CORE_TENSION_WHITEN_OVERLAY_SIZE := "蓄力白光罩大小"
const PROP_CORE_INSTABILITY_ENABLED := "不稳定启用"
const PROP_CORE_INSTABILITY_SCALE := "乱流缩放幅度"
const PROP_CORE_INSTABILITY_FLICKER := "乱流闪烁强度"
const PROP_CORE_INSTABILITY_SPEED := "乱流速度"
const PROP_CORE_SPIKE_CHANCE := "尖峰概率"
const PROP_CORE_SPIKE_AMOUNT := "尖峰强度"
const PROP_CORE_SPIKE_DECAY := "尖峰衰减"
const PROP_BRIDGE_FLASH_START_FRAME := "桥接闪光起始帧"
const PROP_BRIDGE_FLASH_END_FRAME := "桥接闪光结束帧"
const PROP_BRIDGE_FLASH_COLOR := "桥接闪光颜色"
const PROP_BRIDGE_FLASH_WHITE := "桥接白闪颜色"
const PROP_BRIDGE_FLASH_PEAK_SECONDS := "白闪峰值秒数"
const PROP_BLACK_WHITE_FLASH_ENABLED := "黑白闪启用"
const PROP_BLACK_WHITE_FLASH_SECONDS := "黑白闪秒数"
const PROP_BLACK_WHITE_FLASH_STRENGTH := "黑白闪强度"
const PROP_BLACK_WHITE_FLASH_CENTER_RADIUS := "中心保留半径"
const PROP_BLACK_WHITE_FLASH_CENTER_FEATHER := "中心冲击范围"
const PROP_BLACK_WHITE_FLASH_LINE_STRENGTH := "速度线强度"
const PROP_BLACK_WHITE_FLASH_LINE_DISPLACEMENT := "速度线置换强度"
const PROP_BLACK_WHITE_FLASH_LINE_DENSITY := "速度线密度"
const PROP_BLACK_WHITE_FLASH_LINE_WIDTH := "速度线宽度"
const PROP_BLACK_WHITE_FLASH_LINE_SPEED := "速度线速度"
const PROP_PRE_FLASH_STAR_ENABLED := "预闪十字星启用"
const PROP_PRE_FLASH_STAR_SECONDS := "预闪十字星秒数"
const PROP_PRE_FLASH_STAR_COUNT := "预闪十字星数量"
const PROP_PRE_FLASH_STAR_RADIUS := "预闪分布半径"
const PROP_PRE_FLASH_STAR_SIZE := "预闪十字星大小"
const PROP_PRE_FLASH_STAR_FLASH_RATE := "预闪闪烁节奏"
const PROP_PRE_FLASH_STAR_PROGRESSIVE_POWER := "预闪递进强度"
const PROP_PRE_FLASH_STAR_COLOR := "预闪十字星颜色"
const PROP_PRE_FLASH_BIG_STAR_ENABLED := "主闪十字星启用"
const PROP_PRE_FLASH_BIG_STAR_COUNT := "主闪十字星数量"
const PROP_PRE_FLASH_BIG_STAR_SIZE := "主闪十字星大小"
const PROP_PRE_FLASH_BIG_STAR_SECONDS := "主闪瞬闪秒数"
const PROP_BURST_LOCAL_OFFSET := "爆发本地偏移"
const PROP_BURST_ROTATION := "爆发旋转"
const PROP_BURST_FULL_SCALE := "爆发完整缩放"
const PROP_BURST_EXTEND_SECONDS := "爆发伸展秒数"
const PROP_BURST_HOLD_SECONDS := "爆发保持秒数"
const PROP_BURST_RELEASE_SECONDS := "爆发释放秒数"
const PROP_BURST_MUZZLE_ENABLED := "光柱源头过渡启用"
const PROP_BURST_MUZZLE_SECONDS := "光柱源头过渡秒数"
const PROP_BURST_MUZZLE_SIZE := "光柱源头光晕大小"
const PROP_BURST_MUZZLE_LENGTH := "光柱源头发散长度"
const PROP_BURST_MUZZLE_WIDTH := "光柱源头发散宽度"
const PROP_BURST_MUZZLE_STRENGTH := "光柱源头过渡强度"
const PROP_BURST_MUZZLE_FLASH_RATE := "光柱源头闪烁频率"
const PROP_BURST_MUZZLE_FLASH_STRENGTH := "光柱源头闪烁强度"
const PROP_BURST_CORE_OVEREXPOSURE := "爆发核心过曝强度"
const PROP_BURST_CORE_GLOW_SIZE := "爆发核心白光大小"
const PROP_YUAN_AIRFLOW_ENABLED := "背后圆气流启用"
const PROP_YUAN_AIRFLOW_OFFSET := "背后圆气流偏移"
const PROP_YUAN_AIRFLOW_ROTATION := "背后圆气流旋转(度)"
const PROP_YUAN_AIRFLOW_SCALE := "背后圆气流缩放"
const PROP_YUAN_AIRFLOW_FLIP_S_RAMP := "背后圆气流翻转S轴"
const PROP_YUAN_AIRFLOW_S_MIN := "背后圆气流S最小"
const PROP_YUAN_AIRFLOW_S_MAX := "背后圆气流S最大"
const PROP_BURST_SOURCE_PARTICLES_ENABLED := "源头喷射粒子启用"
const PROP_BURST_SOURCE_PARTICLE_COUNT := "源头喷射粒子数量"
const PROP_BURST_SOURCE_PARTICLE_LIFETIME := "源头喷射粒子持续"
const PROP_BURST_SOURCE_PARTICLE_RANGE := "源头喷射粒子喷射距离"
const PROP_BURST_SOURCE_PARTICLE_SPEED := "源头喷射粒子速度"
const PROP_BURST_SOURCE_PARTICLE_SPREAD := "源头喷射粒子散射角度"
const PROP_BURST_SOURCE_PARTICLE_SIZE := "源头喷射粒子大小"
const PROP_CLOSE_TAIL_SECONDS := "收尾秒数"
const PROP_CLOSE_TAIL_COLOR := "收尾颜色"
const PROP_CLOSE_TAIL_START_RADIUS := "收尾起始半径"
const PROP_CLOSE_TAIL_END_RADIUS := "收尾结束半径"
const PROP_CLOSE_TAIL_PARTICLES_ENABLED := "收尾粒子启用"
const PROP_CLOSE_TAIL_PARTICLE_COUNT := "收尾粒子数量"
const PROP_CLOSE_TAIL_PARTICLE_RADIUS := "收尾粒子扩散半径"
const PROP_CLOSE_TAIL_PARTICLE_SIZE := "收尾粒子大小"

var huiju_sequence_path: NodePath = ^"HuijuSequence"
var core_visuals_path: NodePath = ^"CoreVisuals"
var burst_root_path: NodePath = ^"AttackBurst"
var autoplay: bool = true
var restart_on_click: bool = true
var hide_huiju_when_burst_starts: bool = true
var burst_start_frame: int = 60

var core_grow_start_frame: int = 1
var core_grow_end_frame: int = 30
var core_start_scale: float = 0.0
var core_full_scale_multiplier: float = 1.0
var core_release_scale: float = 0.0
var core_stepped_growth_enabled: bool = true
var core_growth_stage_count: int = 4
var core_growth_first_jump_start: float = 0.30
var core_growth_interval_accel: float = 0.75
var core_growth_hold_ratio: float = 0.68
var core_growth_snap_sharpness: float = 3.8
var core_growth_overshoot: float = 0.12
var core_heartbeat_enabled: bool = true
var core_heartbeat_amount: float = 0.08
var core_heartbeat_hz: float = 5.2
var core_heartbeat_second_beat_phase: float = 0.16
var core_heartbeat_second_beat_strength: float = 0.42
var core_heartbeat_sharpness: float = 10.0
var core_tension_whiten_enabled: bool = true
var core_tension_whiten_amount: float = 0.68
var core_tension_whiten_heartbeat: float = 0.55
var core_tension_whiten_gamma: float = 1.35
var core_tension_whiten_overlay_size: float = 1.15
var core_instability_enabled: bool = true
var core_instability_scale: float = 0.16
var core_instability_flicker: float = 0.28
var core_instability_speed: float = 12.0
var core_spike_chance: float = 0.32
var core_spike_amount: float = 0.34
var core_spike_decay: float = 8.5

var bridge_flash_start_frame: int = 38
var bridge_flash_end_frame: int = 45
var bridge_flash_color: Color = Color(1.0, 0.72, 1.0, 1.0)
var bridge_flash_white: Color = Color(1.0, 0.96, 1.0, 1.0)
var bridge_flash_peak_seconds: float = 0.12
var pre_flash_star_enabled: bool = true
var pre_flash_star_seconds: float = 1.0
var pre_flash_star_count: int = 22
var pre_flash_star_radius: float = 0.58
var pre_flash_star_size: float = 0.11
var pre_flash_star_flash_rate: float = 8.5
var pre_flash_star_progressive_power: float = 1.55
var pre_flash_star_color: Color = Color(1.0, 0.86, 1.0, 1.0)
var pre_flash_big_star_enabled: bool = true
var pre_flash_big_star_count: int = 3
var pre_flash_big_star_size: float = 1.16
var pre_flash_big_star_seconds: float = 0.055
var black_white_flash_enabled: bool = true
var black_white_flash_seconds: float = 0.14
var black_white_flash_strength: float = 1.0
var black_white_flash_center_radius: float = 0.0
var black_white_flash_center_feather: float = 0.01
var black_white_flash_line_strength: float = 2.25
var black_white_flash_line_displacement_px: float = 260.0
var black_white_flash_line_density: float = 19.7
var black_white_flash_line_width: float = 0.9
var black_white_flash_line_speed: float = 14.51

var burst_local_offset: Vector3 = Vector3.ZERO
var burst_rotation: Vector3 = Vector3(0.0, 0.0, -PI * 0.5)
var burst_full_scale: Vector3 = Vector3(1.0, 3.24, 1.0)
var burst_extend_seconds: float = 0.20
var burst_hold_seconds: float = 0.65
var burst_release_seconds: float = 0.10
var burst_muzzle_enabled: bool = true
var burst_muzzle_seconds: float = 0.28
var burst_muzzle_size: float = 0.42
var burst_muzzle_length: float = 0.72
var burst_muzzle_width: float = 0.46
var burst_muzzle_strength: float = 0.72
var burst_muzzle_flash_rate: float = 38.0
var burst_muzzle_flash_strength: float = 0.85
var burst_core_overexposure: float = 5.5
var burst_core_glow_size: float = 1.45
var yuan_airflow_enabled: bool = true
var yuan_airflow_offset: Vector3 = Vector3.ZERO
var yuan_airflow_rotation: Vector3 = Vector3.ZERO
var yuan_airflow_scale: float = 1.0
var yuan_airflow_flip_s_ramp: bool = false
var yuan_airflow_s_min: float = 0.0
var yuan_airflow_s_max: float = 0.0405
var burst_source_particles_enabled: bool = true
var burst_source_particle_count: int = 48
var burst_source_particle_lifetime: float = 0.52
var burst_source_particle_range: float = 2.3
var burst_source_particle_speed: float = 2.2
var burst_source_particle_spread: float = 22.0
var burst_source_particle_size: float = 0.13

var close_tail_seconds: float = 0.12
var close_tail_color: Color = Color(1.0, 0.62, 1.0, 1.0)
var close_tail_start_radius: float = 0.05
var close_tail_end_radius: float = 0.68
var close_tail_particles_enabled: bool = true
var close_tail_particle_count: int = 28
var close_tail_particle_radius: float = 0.82
var close_tail_particle_size: float = 0.055

var _huiju_sequence: AlembicObjSequencePlayer
var _core_visuals: Node3D
var _core_visuals_base_scale := Vector3.ONE
var _core_visuals_current_scale_multiplier := 1.0
var _core_release_start_scale_multiplier := 1.0
var _core_visuals_elapsed := 0.0
var _core_whiten_flare: MeshInstance3D
var _core_whiten_material: StandardMaterial3D
var _core_instability_noise := FastNoiseLite.new()
var _core_instability_rng := RandomNumberGenerator.new()
var _core_instability_spike := 0.0
var _camera: Camera3D
var _burst_root: Node3D
var _burst_active := false
var _burst_elapsed := 0.0
var _burst_started_for_run := false
var _black_white_flash_overlay: MeshInstance3D
var _black_white_flash_material: ShaderMaterial
var _black_white_flash_active := false
var _black_white_flash_elapsed := 0.0
var _black_white_flash_pending_burst := false
var _pre_flash_stars_active := false
var _pre_flash_stars_elapsed := 0.0
var _pre_flash_stars_pending_black_white := false
var _pre_flash_star_nodes: Array[MeshInstance3D] = []
var _pre_flash_star_materials: Array[StandardMaterial3D] = []
var _pre_flash_star_offsets: Array[Vector3] = []
var _pre_flash_star_phase_offsets: Array[float] = []
var _pre_flash_star_reveal_points: Array[float] = []
var _pre_flash_star_scale_multipliers: Array[float] = []
var _pre_flash_big_star_nodes: Array[MeshInstance3D] = []
var _pre_flash_big_star_materials: Array[StandardMaterial3D] = []
var _pre_flash_big_star_offsets: Array[Vector3] = []
var _pre_flash_big_star_reveal_points: Array[float] = []
var _pre_flash_big_star_phase_offsets: Array[float] = []
var _pre_flash_big_star_scale_multipliers: Array[float] = []
var _burst_release_started := false
var _bridge_active := false
var _bridge_elapsed := 0.0
var _tail_active := false
var _tail_elapsed := 0.0
var _vfx_overlay: Node3D
var _bridge_ring: MeshInstance3D
var _bridge_flash: MeshInstance3D
var _bridge_sparks: Array[MeshInstance3D] = []
var _bridge_ring_material: StandardMaterial3D
var _bridge_flash_material: StandardMaterial3D
var _bridge_spark_material: StandardMaterial3D
var _tail_ring: MeshInstance3D
var _tail_sparks: Array[MeshInstance3D] = []
var _tail_burst_particles: Array[MeshInstance3D] = []
var _tail_ring_material: StandardMaterial3D
var _tail_spark_material: StandardMaterial3D
var _tail_particle_material: StandardMaterial3D
var _tail_particle_directions: Array[Vector2] = []
var _tail_particle_start_radii: Array[float] = []
var _tail_particle_end_radii: Array[float] = []
var _tail_particle_scales: Array[float] = []
var _tail_particle_phase_offsets: Array[float] = []
var _burst_muzzle_flare: MeshInstance3D
var _burst_muzzle_fan: MeshInstance3D
var _burst_muzzle_flare_material: StandardMaterial3D
var _burst_muzzle_fan_material: StandardMaterial3D
var _burst_source_particles: GPUParticles3D
var _burst_source_particle_material: StandardMaterial3D
var _burst_source_particle_process: ParticleProcessMaterial
var _burst_source_particle_mesh_size := -1.0
var _yuan_airflow_vfx: Node3D


func _get_property_list() -> Array[Dictionary]:
	var properties := _get_storage_property_list()
	properties.append_array([
		_category_prop("基础参数"),
		_prop(PROP_AUTOPLAY, TYPE_BOOL),
		_prop(PROP_RESTART_ON_CLICK, TYPE_BOOL),
		_int_range_prop(PROP_BURST_START_FRAME, 1, 9999, 1, "or_greater"),
		_category_prop("整体观感"),
		_range_prop(PROP_CORE_FULL_SCALE_MULTIPLIER, 0.0, 2.0, 0.001, "or_greater"),
		_prop(PROP_BLACK_WHITE_FLASH_ENABLED, TYPE_BOOL),
		_range_prop(PROP_BLACK_WHITE_FLASH_SECONDS, 0.03, 0.5, 0.001),
		_range_prop(PROP_BLACK_WHITE_FLASH_STRENGTH, 0.0, 1.0, 0.01),
		_category_prop("爆发节奏"),
		_prop(PROP_BURST_LOCAL_OFFSET, TYPE_VECTOR3),
		_prop(PROP_BURST_ROTATION, TYPE_VECTOR3),
		_prop(PROP_BURST_FULL_SCALE, TYPE_VECTOR3),
		_range_prop(PROP_BURST_EXTEND_SECONDS, 0.02, 3.0, 0.01),
		_range_prop(PROP_BURST_HOLD_SECONDS, 0.0, 5.0, 0.01),
		_range_prop(PROP_BURST_RELEASE_SECONDS, 0.0, 2.0, 0.01),
		_category_prop("可选附加"),
		_int_range_prop(PROP_PRE_FLASH_STAR_COUNT, 1, 64, 1),
		_int_range_prop(PROP_PRE_FLASH_BIG_STAR_COUNT, 1, 8, 1),
		_prop(PROP_YUAN_AIRFLOW_ENABLED, TYPE_BOOL),
		_int_range_prop(PROP_BURST_SOURCE_PARTICLE_COUNT, 0, 128, 1),
		_int_range_prop(PROP_CLOSE_TAIL_PARTICLE_COUNT, 0, 96, 1),
	])
	return properties


func _get_storage_property_list() -> Array[Dictionary]:
	return [
		_storage_prop("huiju_sequence_path", TYPE_NODE_PATH),
		_storage_prop("core_visuals_path", TYPE_NODE_PATH),
		_storage_prop("burst_root_path", TYPE_NODE_PATH),
		_storage_prop("autoplay", TYPE_BOOL),
		_storage_prop("restart_on_click", TYPE_BOOL),
		_storage_prop("hide_huiju_when_burst_starts", TYPE_BOOL),
		_storage_prop("burst_start_frame", TYPE_INT),
		_storage_prop("core_grow_start_frame", TYPE_INT),
		_storage_prop("core_grow_end_frame", TYPE_INT),
		_storage_prop("core_start_scale", TYPE_FLOAT),
		_storage_prop("core_full_scale_multiplier", TYPE_FLOAT),
		_storage_prop("core_release_scale", TYPE_FLOAT),
		_storage_prop("core_stepped_growth_enabled", TYPE_BOOL),
		_storage_prop("core_growth_stage_count", TYPE_INT),
		_storage_prop("core_growth_first_jump_start", TYPE_FLOAT),
		_storage_prop("core_growth_interval_accel", TYPE_FLOAT),
		_storage_prop("core_growth_hold_ratio", TYPE_FLOAT),
		_storage_prop("core_growth_snap_sharpness", TYPE_FLOAT),
		_storage_prop("core_growth_overshoot", TYPE_FLOAT),
		_storage_prop("core_heartbeat_enabled", TYPE_BOOL),
		_storage_prop("core_heartbeat_amount", TYPE_FLOAT),
		_storage_prop("core_heartbeat_hz", TYPE_FLOAT),
		_storage_prop("core_heartbeat_second_beat_phase", TYPE_FLOAT),
		_storage_prop("core_heartbeat_second_beat_strength", TYPE_FLOAT),
		_storage_prop("core_heartbeat_sharpness", TYPE_FLOAT),
		_storage_prop("core_tension_whiten_enabled", TYPE_BOOL),
		_storage_prop("core_tension_whiten_amount", TYPE_FLOAT),
		_storage_prop("core_tension_whiten_heartbeat", TYPE_FLOAT),
		_storage_prop("core_tension_whiten_gamma", TYPE_FLOAT),
		_storage_prop("core_tension_whiten_overlay_size", TYPE_FLOAT),
		_storage_prop("core_instability_enabled", TYPE_BOOL),
		_storage_prop("core_instability_scale", TYPE_FLOAT),
		_storage_prop("core_instability_flicker", TYPE_FLOAT),
		_storage_prop("core_instability_speed", TYPE_FLOAT),
		_storage_prop("core_spike_chance", TYPE_FLOAT),
		_storage_prop("core_spike_amount", TYPE_FLOAT),
		_storage_prop("core_spike_decay", TYPE_FLOAT),
		_storage_prop("bridge_flash_start_frame", TYPE_INT),
		_storage_prop("bridge_flash_end_frame", TYPE_INT),
		_storage_prop("bridge_flash_color", TYPE_COLOR),
		_storage_prop("bridge_flash_white", TYPE_COLOR),
		_storage_prop("bridge_flash_peak_seconds", TYPE_FLOAT),
		_storage_prop("pre_flash_star_enabled", TYPE_BOOL),
		_storage_prop("pre_flash_star_seconds", TYPE_FLOAT),
		_storage_prop("pre_flash_star_count", TYPE_INT),
		_storage_prop("pre_flash_star_radius", TYPE_FLOAT),
		_storage_prop("pre_flash_star_size", TYPE_FLOAT),
		_storage_prop("pre_flash_star_flash_rate", TYPE_FLOAT),
		_storage_prop("pre_flash_star_progressive_power", TYPE_FLOAT),
		_storage_prop("pre_flash_star_color", TYPE_COLOR),
		_storage_prop("pre_flash_big_star_enabled", TYPE_BOOL),
		_storage_prop("pre_flash_big_star_count", TYPE_INT),
		_storage_prop("pre_flash_big_star_size", TYPE_FLOAT),
		_storage_prop("pre_flash_big_star_seconds", TYPE_FLOAT),
		_storage_prop("black_white_flash_enabled", TYPE_BOOL),
		_storage_prop("black_white_flash_seconds", TYPE_FLOAT),
		_storage_prop("black_white_flash_strength", TYPE_FLOAT),
		_storage_prop("black_white_flash_center_radius", TYPE_FLOAT),
		_storage_prop("black_white_flash_center_feather", TYPE_FLOAT),
		_storage_prop("black_white_flash_line_strength", TYPE_FLOAT),
		_storage_prop("black_white_flash_line_displacement_px", TYPE_FLOAT),
		_storage_prop("black_white_flash_line_density", TYPE_FLOAT),
		_storage_prop("black_white_flash_line_width", TYPE_FLOAT),
		_storage_prop("black_white_flash_line_speed", TYPE_FLOAT),
		_storage_prop("burst_local_offset", TYPE_VECTOR3),
		_storage_prop("burst_rotation", TYPE_VECTOR3),
		_storage_prop("burst_full_scale", TYPE_VECTOR3),
		_storage_prop("burst_extend_seconds", TYPE_FLOAT),
		_storage_prop("burst_hold_seconds", TYPE_FLOAT),
		_storage_prop("burst_release_seconds", TYPE_FLOAT),
		_storage_prop("burst_muzzle_enabled", TYPE_BOOL),
		_storage_prop("burst_muzzle_seconds", TYPE_FLOAT),
		_storage_prop("burst_muzzle_size", TYPE_FLOAT),
		_storage_prop("burst_muzzle_length", TYPE_FLOAT),
		_storage_prop("burst_muzzle_width", TYPE_FLOAT),
		_storage_prop("burst_muzzle_strength", TYPE_FLOAT),
		_storage_prop("burst_muzzle_flash_rate", TYPE_FLOAT),
		_storage_prop("burst_muzzle_flash_strength", TYPE_FLOAT),
		_storage_prop("burst_core_overexposure", TYPE_FLOAT),
		_storage_prop("burst_core_glow_size", TYPE_FLOAT),
		_storage_prop("yuan_airflow_enabled", TYPE_BOOL),
		_storage_prop("yuan_airflow_offset", TYPE_VECTOR3),
		_storage_prop("yuan_airflow_rotation", TYPE_VECTOR3),
		_storage_prop("yuan_airflow_scale", TYPE_FLOAT),
		_storage_prop("yuan_airflow_flip_s_ramp", TYPE_BOOL),
		_storage_prop("yuan_airflow_s_min", TYPE_FLOAT),
		_storage_prop("yuan_airflow_s_max", TYPE_FLOAT),
		_storage_prop("burst_source_particles_enabled", TYPE_BOOL),
		_storage_prop("burst_source_particle_count", TYPE_INT),
		_storage_prop("burst_source_particle_lifetime", TYPE_FLOAT),
		_storage_prop("burst_source_particle_range", TYPE_FLOAT),
		_storage_prop("burst_source_particle_speed", TYPE_FLOAT),
		_storage_prop("burst_source_particle_spread", TYPE_FLOAT),
		_storage_prop("burst_source_particle_size", TYPE_FLOAT),
		_storage_prop("close_tail_seconds", TYPE_FLOAT),
		_storage_prop("close_tail_color", TYPE_COLOR),
		_storage_prop("close_tail_start_radius", TYPE_FLOAT),
		_storage_prop("close_tail_end_radius", TYPE_FLOAT),
		_storage_prop("close_tail_particles_enabled", TYPE_BOOL),
		_storage_prop("close_tail_particle_count", TYPE_INT),
		_storage_prop("close_tail_particle_radius", TYPE_FLOAT),
		_storage_prop("close_tail_particle_size", TYPE_FLOAT),
	]


func _get(property: StringName) -> Variant:
	match String(property):
		PROP_HUIJU_SEQUENCE_PATH, "huiju_sequence_path":
			return huiju_sequence_path
		PROP_CORE_VISUALS_PATH, "core_visuals_path":
			return core_visuals_path
		PROP_BURST_ROOT_PATH, "burst_root_path":
			return burst_root_path
		PROP_AUTOPLAY, "autoplay":
			return autoplay
		PROP_RESTART_ON_CLICK, "restart_on_click":
			return restart_on_click
		PROP_HIDE_HUIJU_WHEN_BURST_STARTS, "hide_huiju_when_burst_starts":
			return hide_huiju_when_burst_starts
		PROP_BURST_START_FRAME, "burst_start_frame":
			return burst_start_frame
		PROP_CORE_GROW_START_FRAME, "core_grow_start_frame":
			return core_grow_start_frame
		PROP_CORE_GROW_END_FRAME, "core_grow_end_frame":
			return core_grow_end_frame
		PROP_CORE_START_SCALE, "core_start_scale":
			return core_start_scale
		PROP_CORE_FULL_SCALE_MULTIPLIER, "core_full_scale_multiplier":
			return core_full_scale_multiplier
		PROP_CORE_RELEASE_SCALE, "core_release_scale":
			return core_release_scale
		PROP_CORE_STEPPED_GROWTH_ENABLED, "core_stepped_growth_enabled":
			return core_stepped_growth_enabled
		PROP_CORE_GROWTH_STAGE_COUNT, "core_growth_stage_count":
			return core_growth_stage_count
		PROP_CORE_GROWTH_FIRST_JUMP_START, "core_growth_first_jump_start":
			return core_growth_first_jump_start
		PROP_CORE_GROWTH_INTERVAL_ACCEL, "core_growth_interval_accel":
			return core_growth_interval_accel
		PROP_CORE_GROWTH_HOLD_RATIO, "core_growth_hold_ratio":
			return core_growth_hold_ratio
		PROP_CORE_GROWTH_SNAP_SHARPNESS, "core_growth_snap_sharpness":
			return core_growth_snap_sharpness
		PROP_CORE_GROWTH_OVERSHOOT, "core_growth_overshoot":
			return core_growth_overshoot
		PROP_CORE_HEARTBEAT_ENABLED, "core_heartbeat_enabled":
			return core_heartbeat_enabled
		PROP_CORE_HEARTBEAT_AMOUNT, "core_heartbeat_amount":
			return core_heartbeat_amount
		PROP_CORE_HEARTBEAT_HZ, "core_heartbeat_hz":
			return core_heartbeat_hz
		PROP_CORE_HEARTBEAT_SECOND_BEAT_PHASE, "core_heartbeat_second_beat_phase":
			return core_heartbeat_second_beat_phase
		PROP_CORE_HEARTBEAT_SECOND_BEAT_STRENGTH, "core_heartbeat_second_beat_strength":
			return core_heartbeat_second_beat_strength
		PROP_CORE_HEARTBEAT_SHARPNESS, "core_heartbeat_sharpness":
			return core_heartbeat_sharpness
		PROP_CORE_TENSION_WHITEN_ENABLED, "core_tension_whiten_enabled":
			return core_tension_whiten_enabled
		PROP_CORE_TENSION_WHITEN_AMOUNT, "core_tension_whiten_amount":
			return core_tension_whiten_amount
		PROP_CORE_TENSION_WHITEN_HEARTBEAT, "core_tension_whiten_heartbeat":
			return core_tension_whiten_heartbeat
		PROP_CORE_TENSION_WHITEN_GAMMA, "core_tension_whiten_gamma":
			return core_tension_whiten_gamma
		PROP_CORE_TENSION_WHITEN_OVERLAY_SIZE, "core_tension_whiten_overlay_size":
			return core_tension_whiten_overlay_size
		PROP_CORE_INSTABILITY_ENABLED, "core_instability_enabled":
			return core_instability_enabled
		PROP_CORE_INSTABILITY_SCALE, "core_instability_scale":
			return core_instability_scale
		PROP_CORE_INSTABILITY_FLICKER, "core_instability_flicker":
			return core_instability_flicker
		PROP_CORE_INSTABILITY_SPEED, "core_instability_speed":
			return core_instability_speed
		PROP_CORE_SPIKE_CHANCE, "core_spike_chance":
			return core_spike_chance
		PROP_CORE_SPIKE_AMOUNT, "core_spike_amount":
			return core_spike_amount
		PROP_CORE_SPIKE_DECAY, "core_spike_decay":
			return core_spike_decay
		PROP_BRIDGE_FLASH_START_FRAME, "bridge_flash_start_frame":
			return bridge_flash_start_frame
		PROP_BRIDGE_FLASH_END_FRAME, "bridge_flash_end_frame":
			return bridge_flash_end_frame
		PROP_BRIDGE_FLASH_COLOR, "bridge_flash_color":
			return bridge_flash_color
		PROP_BRIDGE_FLASH_WHITE, "bridge_flash_white":
			return bridge_flash_white
		PROP_BRIDGE_FLASH_PEAK_SECONDS, "bridge_flash_peak_seconds":
			return bridge_flash_peak_seconds
		PROP_PRE_FLASH_STAR_ENABLED, "pre_flash_star_enabled":
			return pre_flash_star_enabled
		PROP_PRE_FLASH_STAR_SECONDS, "pre_flash_star_seconds":
			return pre_flash_star_seconds
		PROP_PRE_FLASH_STAR_COUNT, "pre_flash_star_count":
			return pre_flash_star_count
		PROP_PRE_FLASH_STAR_RADIUS, "pre_flash_star_radius":
			return pre_flash_star_radius
		PROP_PRE_FLASH_STAR_SIZE, "pre_flash_star_size":
			return pre_flash_star_size
		PROP_PRE_FLASH_STAR_FLASH_RATE, "pre_flash_star_flash_rate":
			return pre_flash_star_flash_rate
		PROP_PRE_FLASH_STAR_PROGRESSIVE_POWER, "pre_flash_star_progressive_power":
			return pre_flash_star_progressive_power
		PROP_PRE_FLASH_STAR_COLOR, "pre_flash_star_color":
			return pre_flash_star_color
		PROP_PRE_FLASH_BIG_STAR_ENABLED, "pre_flash_big_star_enabled":
			return pre_flash_big_star_enabled
		PROP_PRE_FLASH_BIG_STAR_COUNT, "pre_flash_big_star_count":
			return pre_flash_big_star_count
		PROP_PRE_FLASH_BIG_STAR_SIZE, "pre_flash_big_star_size":
			return pre_flash_big_star_size
		PROP_PRE_FLASH_BIG_STAR_SECONDS, "pre_flash_big_star_seconds":
			return pre_flash_big_star_seconds
		PROP_BLACK_WHITE_FLASH_ENABLED, "black_white_flash_enabled":
			return black_white_flash_enabled
		PROP_BLACK_WHITE_FLASH_SECONDS, "black_white_flash_seconds":
			return black_white_flash_seconds
		PROP_BLACK_WHITE_FLASH_STRENGTH, "black_white_flash_strength":
			return black_white_flash_strength
		PROP_BLACK_WHITE_FLASH_CENTER_RADIUS, "black_white_flash_center_radius":
			return black_white_flash_center_radius
		PROP_BLACK_WHITE_FLASH_CENTER_FEATHER, "black_white_flash_center_feather":
			return black_white_flash_center_feather
		PROP_BLACK_WHITE_FLASH_LINE_STRENGTH, "black_white_flash_line_strength":
			return black_white_flash_line_strength
		PROP_BLACK_WHITE_FLASH_LINE_DISPLACEMENT, "black_white_flash_line_displacement_px":
			return black_white_flash_line_displacement_px
		PROP_BLACK_WHITE_FLASH_LINE_DENSITY, "black_white_flash_line_density":
			return black_white_flash_line_density
		PROP_BLACK_WHITE_FLASH_LINE_WIDTH, "black_white_flash_line_width":
			return black_white_flash_line_width
		PROP_BLACK_WHITE_FLASH_LINE_SPEED, "black_white_flash_line_speed":
			return black_white_flash_line_speed
		PROP_BURST_LOCAL_OFFSET, "burst_local_offset":
			return burst_local_offset
		PROP_BURST_ROTATION, "burst_rotation":
			return burst_rotation
		PROP_BURST_FULL_SCALE, "burst_full_scale":
			return burst_full_scale
		PROP_BURST_EXTEND_SECONDS, "burst_extend_seconds":
			return burst_extend_seconds
		PROP_BURST_HOLD_SECONDS, "burst_hold_seconds":
			return burst_hold_seconds
		PROP_BURST_RELEASE_SECONDS, "burst_release_seconds":
			return burst_release_seconds
		PROP_BURST_MUZZLE_ENABLED, "burst_muzzle_enabled":
			return burst_muzzle_enabled
		PROP_BURST_MUZZLE_SECONDS, "burst_muzzle_seconds":
			return burst_muzzle_seconds
		PROP_BURST_MUZZLE_SIZE, "burst_muzzle_size":
			return burst_muzzle_size
		PROP_BURST_MUZZLE_LENGTH, "burst_muzzle_length":
			return burst_muzzle_length
		PROP_BURST_MUZZLE_WIDTH, "burst_muzzle_width":
			return burst_muzzle_width
		PROP_BURST_MUZZLE_STRENGTH, "burst_muzzle_strength":
			return burst_muzzle_strength
		PROP_BURST_MUZZLE_FLASH_RATE, "burst_muzzle_flash_rate":
			return burst_muzzle_flash_rate
		PROP_BURST_MUZZLE_FLASH_STRENGTH, "burst_muzzle_flash_strength":
			return burst_muzzle_flash_strength
		PROP_BURST_CORE_OVEREXPOSURE, "burst_core_overexposure":
			return burst_core_overexposure
		PROP_BURST_CORE_GLOW_SIZE, "burst_core_glow_size":
			return burst_core_glow_size
		PROP_YUAN_AIRFLOW_ENABLED, "yuan_airflow_enabled":
			return yuan_airflow_enabled
		PROP_YUAN_AIRFLOW_OFFSET, "yuan_airflow_offset":
			return yuan_airflow_offset
		PROP_YUAN_AIRFLOW_ROTATION, "yuan_airflow_rotation":
			return yuan_airflow_rotation
		PROP_YUAN_AIRFLOW_SCALE, "yuan_airflow_scale":
			return yuan_airflow_scale
		PROP_YUAN_AIRFLOW_FLIP_S_RAMP, "yuan_airflow_flip_s_ramp":
			return yuan_airflow_flip_s_ramp
		PROP_YUAN_AIRFLOW_S_MIN, "yuan_airflow_s_min":
			return yuan_airflow_s_min
		PROP_YUAN_AIRFLOW_S_MAX, "yuan_airflow_s_max":
			return yuan_airflow_s_max
		PROP_BURST_SOURCE_PARTICLES_ENABLED, "burst_source_particles_enabled":
			return burst_source_particles_enabled
		PROP_BURST_SOURCE_PARTICLE_COUNT, "burst_source_particle_count":
			return burst_source_particle_count
		PROP_BURST_SOURCE_PARTICLE_LIFETIME, "burst_source_particle_lifetime":
			return burst_source_particle_lifetime
		PROP_BURST_SOURCE_PARTICLE_RANGE, "burst_source_particle_range":
			return burst_source_particle_range
		PROP_BURST_SOURCE_PARTICLE_SPEED, "burst_source_particle_speed":
			return burst_source_particle_speed
		PROP_BURST_SOURCE_PARTICLE_SPREAD, "burst_source_particle_spread":
			return burst_source_particle_spread
		PROP_BURST_SOURCE_PARTICLE_SIZE, "burst_source_particle_size":
			return burst_source_particle_size
		PROP_CLOSE_TAIL_SECONDS, "close_tail_seconds":
			return close_tail_seconds
		PROP_CLOSE_TAIL_COLOR, "close_tail_color":
			return close_tail_color
		PROP_CLOSE_TAIL_START_RADIUS, "close_tail_start_radius":
			return close_tail_start_radius
		PROP_CLOSE_TAIL_END_RADIUS, "close_tail_end_radius":
			return close_tail_end_radius
		PROP_CLOSE_TAIL_PARTICLES_ENABLED, "close_tail_particles_enabled":
			return close_tail_particles_enabled
		PROP_CLOSE_TAIL_PARTICLE_COUNT, "close_tail_particle_count":
			return close_tail_particle_count
		PROP_CLOSE_TAIL_PARTICLE_RADIUS, "close_tail_particle_radius":
			return close_tail_particle_radius
		PROP_CLOSE_TAIL_PARTICLE_SIZE, "close_tail_particle_size":
			return close_tail_particle_size
	return null


func _set(property: StringName, value: Variant) -> bool:
	match String(property):
		PROP_HUIJU_SEQUENCE_PATH, "huiju_sequence_path":
			huiju_sequence_path = value
		PROP_CORE_VISUALS_PATH, "core_visuals_path":
			core_visuals_path = value
		PROP_BURST_ROOT_PATH, "burst_root_path":
			burst_root_path = value
		PROP_AUTOPLAY, "autoplay":
			autoplay = bool(value)
		PROP_RESTART_ON_CLICK, "restart_on_click":
			restart_on_click = bool(value)
		PROP_HIDE_HUIJU_WHEN_BURST_STARTS, "hide_huiju_when_burst_starts":
			hide_huiju_when_burst_starts = bool(value)
		PROP_BURST_START_FRAME, "burst_start_frame":
			burst_start_frame = maxi(int(value), 1)
		PROP_CORE_GROW_START_FRAME, "core_grow_start_frame":
			core_grow_start_frame = maxi(int(value), 1)
		PROP_CORE_GROW_END_FRAME, "core_grow_end_frame":
			core_grow_end_frame = maxi(int(value), 1)
		PROP_CORE_START_SCALE, "core_start_scale":
			core_start_scale = clampf(float(value), 0.0, 1.0)
		PROP_CORE_FULL_SCALE_MULTIPLIER, "core_full_scale_multiplier":
			core_full_scale_multiplier = maxf(float(value), 0.0)
		PROP_CORE_RELEASE_SCALE, "core_release_scale":
			core_release_scale = clampf(float(value), 0.0, 1.0)
		PROP_CORE_STEPPED_GROWTH_ENABLED, "core_stepped_growth_enabled":
			core_stepped_growth_enabled = bool(value)
		PROP_CORE_GROWTH_STAGE_COUNT, "core_growth_stage_count":
			core_growth_stage_count = clampi(int(value), 1, 8)
		PROP_CORE_GROWTH_FIRST_JUMP_START, "core_growth_first_jump_start":
			core_growth_first_jump_start = clampf(float(value), 0.0, 0.8)
		PROP_CORE_GROWTH_INTERVAL_ACCEL, "core_growth_interval_accel":
			core_growth_interval_accel = clampf(float(value), 0.0, 0.9)
		PROP_CORE_GROWTH_HOLD_RATIO, "core_growth_hold_ratio":
			core_growth_hold_ratio = clampf(float(value), 0.0, 0.9)
		PROP_CORE_GROWTH_SNAP_SHARPNESS, "core_growth_snap_sharpness":
			core_growth_snap_sharpness = clampf(float(value), 0.5, 8.0)
		PROP_CORE_GROWTH_OVERSHOOT, "core_growth_overshoot":
			core_growth_overshoot = clampf(float(value), 0.0, 0.35)
		PROP_CORE_HEARTBEAT_ENABLED, "core_heartbeat_enabled":
			core_heartbeat_enabled = bool(value)
		PROP_CORE_HEARTBEAT_AMOUNT, "core_heartbeat_amount":
			core_heartbeat_amount = clampf(float(value), 0.0, 0.5)
		PROP_CORE_HEARTBEAT_HZ, "core_heartbeat_hz":
			core_heartbeat_hz = clampf(float(value), 0.2, 12.0)
		PROP_CORE_HEARTBEAT_SECOND_BEAT_PHASE, "core_heartbeat_second_beat_phase":
			core_heartbeat_second_beat_phase = clampf(float(value), 0.05, 0.45)
		PROP_CORE_HEARTBEAT_SECOND_BEAT_STRENGTH, "core_heartbeat_second_beat_strength":
			core_heartbeat_second_beat_strength = clampf(float(value), 0.0, 1.0)
		PROP_CORE_HEARTBEAT_SHARPNESS, "core_heartbeat_sharpness":
			core_heartbeat_sharpness = clampf(float(value), 2.0, 16.0)
		PROP_CORE_TENSION_WHITEN_ENABLED, "core_tension_whiten_enabled":
			core_tension_whiten_enabled = bool(value)
		PROP_CORE_TENSION_WHITEN_AMOUNT, "core_tension_whiten_amount":
			core_tension_whiten_amount = clampf(float(value), 0.0, 8.0)
		PROP_CORE_TENSION_WHITEN_HEARTBEAT, "core_tension_whiten_heartbeat":
			core_tension_whiten_heartbeat = clampf(float(value), 0.0, 8.0)
		PROP_CORE_TENSION_WHITEN_GAMMA, "core_tension_whiten_gamma":
			core_tension_whiten_gamma = clampf(float(value), 0.05, 8.0)
		PROP_CORE_TENSION_WHITEN_OVERLAY_SIZE, "core_tension_whiten_overlay_size":
			core_tension_whiten_overlay_size = clampf(float(value), 0.1, 3.0)
		PROP_CORE_INSTABILITY_ENABLED, "core_instability_enabled":
			core_instability_enabled = bool(value)
		PROP_CORE_INSTABILITY_SCALE, "core_instability_scale":
			core_instability_scale = clampf(float(value), 0.0, 0.45)
		PROP_CORE_INSTABILITY_FLICKER, "core_instability_flicker":
			core_instability_flicker = clampf(float(value), 0.0, 0.75)
		PROP_CORE_INSTABILITY_SPEED, "core_instability_speed":
			core_instability_speed = clampf(float(value), 0.5, 30.0)
		PROP_CORE_SPIKE_CHANCE, "core_spike_chance":
			core_spike_chance = clampf(float(value), 0.0, 2.0)
		PROP_CORE_SPIKE_AMOUNT, "core_spike_amount":
			core_spike_amount = clampf(float(value), 0.0, 0.8)
		PROP_CORE_SPIKE_DECAY, "core_spike_decay":
			core_spike_decay = clampf(float(value), 1.0, 24.0)
		PROP_BRIDGE_FLASH_START_FRAME, "bridge_flash_start_frame":
			bridge_flash_start_frame = maxi(int(value), 1)
		PROP_BRIDGE_FLASH_END_FRAME, "bridge_flash_end_frame":
			bridge_flash_end_frame = maxi(int(value), 1)
		PROP_BRIDGE_FLASH_COLOR, "bridge_flash_color":
			bridge_flash_color = value
		PROP_BRIDGE_FLASH_WHITE, "bridge_flash_white":
			bridge_flash_white = value
		PROP_BRIDGE_FLASH_PEAK_SECONDS, "bridge_flash_peak_seconds":
			bridge_flash_peak_seconds = clampf(float(value), 0.02, 0.5)
		PROP_PRE_FLASH_STAR_ENABLED, "pre_flash_star_enabled":
			pre_flash_star_enabled = bool(value)
		PROP_PRE_FLASH_STAR_SECONDS, "pre_flash_star_seconds":
			pre_flash_star_seconds = clampf(float(value), 0.05, 2.0)
		PROP_PRE_FLASH_STAR_COUNT, "pre_flash_star_count":
			pre_flash_star_count = clampi(int(value), 1, 64)
		PROP_PRE_FLASH_STAR_RADIUS, "pre_flash_star_radius":
			pre_flash_star_radius = clampf(float(value), 0.05, 2.0)
		PROP_PRE_FLASH_STAR_SIZE, "pre_flash_star_size":
			pre_flash_star_size = clampf(float(value), 0.01, 0.6)
		PROP_PRE_FLASH_STAR_FLASH_RATE, "pre_flash_star_flash_rate":
			pre_flash_star_flash_rate = clampf(float(value), 0.5, 24.0)
		PROP_PRE_FLASH_STAR_PROGRESSIVE_POWER, "pre_flash_star_progressive_power":
			pre_flash_star_progressive_power = clampf(float(value), 0.2, 4.0)
		PROP_PRE_FLASH_STAR_COLOR, "pre_flash_star_color":
			pre_flash_star_color = value
		PROP_PRE_FLASH_BIG_STAR_ENABLED, "pre_flash_big_star_enabled":
			pre_flash_big_star_enabled = bool(value)
		PROP_PRE_FLASH_BIG_STAR_COUNT, "pre_flash_big_star_count":
			pre_flash_big_star_count = clampi(int(value), 1, 8)
		PROP_PRE_FLASH_BIG_STAR_SIZE, "pre_flash_big_star_size":
			pre_flash_big_star_size = clampf(float(value), 0.1, 1.5)
		PROP_PRE_FLASH_BIG_STAR_SECONDS, "pre_flash_big_star_seconds":
			pre_flash_big_star_seconds = clampf(float(value), 0.016, 0.2)
		PROP_BLACK_WHITE_FLASH_ENABLED, "black_white_flash_enabled":
			black_white_flash_enabled = bool(value)
		PROP_BLACK_WHITE_FLASH_SECONDS, "black_white_flash_seconds":
			black_white_flash_seconds = clampf(float(value), 0.03, 0.5)
		PROP_BLACK_WHITE_FLASH_STRENGTH, "black_white_flash_strength":
			black_white_flash_strength = clampf(float(value), 0.0, 1.0)
		PROP_BLACK_WHITE_FLASH_CENTER_RADIUS, "black_white_flash_center_radius":
			black_white_flash_center_radius = clampf(float(value), 0.0, 1.5)
		PROP_BLACK_WHITE_FLASH_CENTER_FEATHER, "black_white_flash_center_feather":
			black_white_flash_center_feather = clampf(float(value), 0.01, 2.0)
		PROP_BLACK_WHITE_FLASH_LINE_STRENGTH, "black_white_flash_line_strength":
			black_white_flash_line_strength = clampf(float(value), 0.0, 3.0)
		PROP_BLACK_WHITE_FLASH_LINE_DISPLACEMENT, "black_white_flash_line_displacement_px":
			black_white_flash_line_displacement_px = clampf(float(value), 0.0, 260.0)
		PROP_BLACK_WHITE_FLASH_LINE_DENSITY, "black_white_flash_line_density":
			black_white_flash_line_density = clampf(float(value), 1.0, 180.0)
		PROP_BLACK_WHITE_FLASH_LINE_WIDTH, "black_white_flash_line_width":
			black_white_flash_line_width = clampf(float(value), 0.01, 0.9)
		PROP_BLACK_WHITE_FLASH_LINE_SPEED, "black_white_flash_line_speed":
			black_white_flash_line_speed = clampf(float(value), -30.0, 30.0)
		PROP_BURST_LOCAL_OFFSET, "burst_local_offset":
			burst_local_offset = value
		PROP_BURST_ROTATION, "burst_rotation":
			burst_rotation = value
		PROP_BURST_FULL_SCALE, "burst_full_scale":
			burst_full_scale = value
		PROP_BURST_EXTEND_SECONDS, "burst_extend_seconds":
			burst_extend_seconds = clampf(float(value), 0.02, 3.0)
		PROP_BURST_HOLD_SECONDS, "burst_hold_seconds":
			burst_hold_seconds = clampf(float(value), 0.0, 5.0)
		PROP_BURST_RELEASE_SECONDS, "burst_release_seconds":
			burst_release_seconds = clampf(float(value), 0.0, 2.0)
		PROP_BURST_MUZZLE_ENABLED, "burst_muzzle_enabled":
			burst_muzzle_enabled = bool(value)
		PROP_BURST_MUZZLE_SECONDS, "burst_muzzle_seconds":
			burst_muzzle_seconds = clampf(float(value), 0.03, 1.0)
		PROP_BURST_MUZZLE_SIZE, "burst_muzzle_size":
			burst_muzzle_size = clampf(float(value), 0.05, 2.0)
		PROP_BURST_MUZZLE_LENGTH, "burst_muzzle_length":
			burst_muzzle_length = clampf(float(value), 0.05, 2.5)
		PROP_BURST_MUZZLE_WIDTH, "burst_muzzle_width":
			burst_muzzle_width = clampf(float(value), 0.05, 2.0)
		PROP_BURST_MUZZLE_STRENGTH, "burst_muzzle_strength":
			burst_muzzle_strength = clampf(float(value), 0.0, 3.0)
		PROP_BURST_MUZZLE_FLASH_RATE, "burst_muzzle_flash_rate":
			burst_muzzle_flash_rate = clampf(float(value), 0.0, 80.0)
		PROP_BURST_MUZZLE_FLASH_STRENGTH, "burst_muzzle_flash_strength":
			burst_muzzle_flash_strength = clampf(float(value), 0.0, 2.0)
		PROP_BURST_CORE_OVEREXPOSURE, "burst_core_overexposure":
			burst_core_overexposure = clampf(float(value), 0.0, 12.0)
		PROP_BURST_CORE_GLOW_SIZE, "burst_core_glow_size":
			burst_core_glow_size = clampf(float(value), 0.0, 4.0)
		PROP_YUAN_AIRFLOW_ENABLED, "yuan_airflow_enabled":
			yuan_airflow_enabled = bool(value)
		PROP_YUAN_AIRFLOW_OFFSET, "yuan_airflow_offset":
			yuan_airflow_offset = value
		PROP_YUAN_AIRFLOW_ROTATION, "yuan_airflow_rotation":
			yuan_airflow_rotation = value
		PROP_YUAN_AIRFLOW_SCALE, "yuan_airflow_scale":
			yuan_airflow_scale = clampf(float(value), 0.0, 4.0)
		PROP_YUAN_AIRFLOW_FLIP_S_RAMP, "yuan_airflow_flip_s_ramp":
			yuan_airflow_flip_s_ramp = bool(value)
		PROP_YUAN_AIRFLOW_S_MIN, "yuan_airflow_s_min":
			yuan_airflow_s_min = clampf(float(value), -1.0, 1.0)
		PROP_YUAN_AIRFLOW_S_MAX, "yuan_airflow_s_max":
			yuan_airflow_s_max = clampf(float(value), -1.0, 1.0)
		PROP_BURST_SOURCE_PARTICLES_ENABLED, "burst_source_particles_enabled":
			burst_source_particles_enabled = bool(value)
		PROP_BURST_SOURCE_PARTICLE_COUNT, "burst_source_particle_count":
			burst_source_particle_count = clampi(int(value), 0, 128)
		PROP_BURST_SOURCE_PARTICLE_LIFETIME, "burst_source_particle_lifetime":
			burst_source_particle_lifetime = clampf(float(value), 0.05, 2.0)
		PROP_BURST_SOURCE_PARTICLE_RANGE, "burst_source_particle_range":
			burst_source_particle_range = clampf(float(value), 0.1, 8.0)
		PROP_BURST_SOURCE_PARTICLE_SPEED, "burst_source_particle_speed":
			burst_source_particle_speed = clampf(float(value), 0.1, 8.0)
		PROP_BURST_SOURCE_PARTICLE_SPREAD, "burst_source_particle_spread":
			burst_source_particle_spread = clampf(float(value), 0.0, 60.0)
		PROP_BURST_SOURCE_PARTICLE_SIZE, "burst_source_particle_size":
			burst_source_particle_size = clampf(float(value), 0.01, 0.4)
		PROP_CLOSE_TAIL_SECONDS, "close_tail_seconds":
			close_tail_seconds = clampf(float(value), 0.04, 1.0)
		PROP_CLOSE_TAIL_COLOR, "close_tail_color":
			close_tail_color = value
		PROP_CLOSE_TAIL_START_RADIUS, "close_tail_start_radius":
			close_tail_start_radius = clampf(float(value), 0.05, 2.0)
		PROP_CLOSE_TAIL_END_RADIUS, "close_tail_end_radius":
			close_tail_end_radius = clampf(float(value), 0.0, 1.0)
		PROP_CLOSE_TAIL_PARTICLES_ENABLED, "close_tail_particles_enabled":
			close_tail_particles_enabled = bool(value)
		PROP_CLOSE_TAIL_PARTICLE_COUNT, "close_tail_particle_count":
			close_tail_particle_count = clampi(int(value), 0, 96)
		PROP_CLOSE_TAIL_PARTICLE_RADIUS, "close_tail_particle_radius":
			close_tail_particle_radius = clampf(float(value), 0.05, 2.0)
		PROP_CLOSE_TAIL_PARTICLE_SIZE, "close_tail_particle_size":
			close_tail_particle_size = clampf(float(value), 0.005, 0.25)
		_:
			return false

	if is_inside_tree():
		_ensure_scene_refs_for_editor()
		_prepare_core_whiten_overlay()
		_apply_core_visuals_transform()
		_sync_editor_preview()
		_update_processing_state()
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


func _ensure_scene_refs_for_editor() -> void:
	if _core_visuals == null:
		_core_visuals = get_node_or_null(core_visuals_path) as Node3D
		if _core_visuals != null:
			_core_visuals_base_scale = _core_visuals.scale
	if _burst_root == null:
		_burst_root = get_node_or_null(burst_root_path) as Node3D
	if _camera == null:
		_camera = get_node_or_null(^"Camera3D") as Camera3D


func _ready() -> void:
	if Engine.is_editor_hint():
		_ensure_scene_refs_for_editor()
		_prepare_core_visuals(_core_visuals)
		_sync_editor_preview()
		return

	_core_instability_noise.seed = 91357
	_core_instability_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_core_instability_noise.frequency = 0.9
	_core_instability_rng.randomize()

	_camera = get_node_or_null(^"Camera3D") as Camera3D
	_huiju_sequence = get_node_or_null(huiju_sequence_path) as AlembicObjSequencePlayer
	_core_visuals = get_node_or_null(core_visuals_path) as Node3D
	if _core_visuals != null:
		_core_visuals_base_scale = _core_visuals.scale
	_burst_root = get_node_or_null(burst_root_path) as Node3D

	if _huiju_sequence != null:
		_huiju_sequence.autoplay = false
		_huiju_sequence.loop = false
		if not _huiju_sequence.frame_changed.is_connected(_on_huiju_frame_changed):
			_huiju_sequence.frame_changed.connect(_on_huiju_frame_changed)
		if not _huiju_sequence.playback_finished.is_connected(_on_huiju_sequence_finished):
			_huiju_sequence.playback_finished.connect(_on_huiju_sequence_finished)

	_prepare_core_visuals(_core_visuals)
	_prepare_core_whiten_overlay()
	_apply_core_visuals_progress(0.0)
	_prepare_burst_tree(_burst_root)
	_prepare_aux_vfx()
	_stop_burst()
	_clear_bridge_flash()
	_clear_pre_flash_stars()
	_clear_close_tail()

	if autoplay:
		call_deferred("play_sequence")


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if _should_process_core_energy():
		_core_visuals_elapsed += delta
		_update_core_instability(delta)
		_apply_core_visuals_transform()
	if _pre_flash_stars_active:
		_update_pre_flash_stars(delta)
	if _black_white_flash_active:
		_update_black_white_flash(delta)
	if _bridge_active:
		_update_bridge_peak(delta)
	if _burst_active:
		_update_burst(delta)
	if _tail_active:
		_update_close_tail(delta)


func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return

	if not restart_on_click:
		return

	var mouse_event := event as InputEventMouseButton
	if mouse_event != null and mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
		play_sequence()
		get_viewport().set_input_as_handled()
		return

	var key_event := event as InputEventKey
	if key_event != null and key_event.pressed and not key_event.echo:
		if key_event.keycode == KEY_SPACE or key_event.keycode == KEY_ENTER:
			play_sequence()
			get_viewport().set_input_as_handled()


func play_sequence() -> void:
	_burst_started_for_run = false
	_core_visuals_elapsed = 0.0
	_core_instability_spike = 0.0
	_clear_pre_flash_stars()
	_clear_black_white_flash()
	_clear_bridge_flash()
	_clear_close_tail()
	_stop_burst()
	_prepare_core_visuals(_core_visuals)
	_prepare_core_whiten_overlay()
	_apply_core_visuals_progress(0.0)
	if _huiju_sequence == null:
		_start_burst()
		return

	_huiju_sequence.visible = true
	_huiju_sequence.loop = false
	_huiju_sequence.restart()


func _on_huiju_frame_changed(frame_index: int) -> void:
	if _burst_started_for_run:
		return
	_apply_core_visuals_progress(_get_core_progress_for_frame(frame_index + 1))
	if frame_index + 1 >= burst_start_frame:
		_start_burst()


func _on_huiju_sequence_finished() -> void:
	if not _burst_started_for_run:
		_start_burst()


func _start_burst() -> void:
	if _burst_started_for_run:
		return
	_burst_started_for_run = true
	_core_release_start_scale_multiplier = _core_visuals_current_scale_multiplier
	if _huiju_sequence != null and hide_huiju_when_burst_starts:
		_huiju_sequence.stop()
		_huiju_sequence.visible = false
	_clear_bridge_flash()
	if _start_pre_flash_stars():
		_pre_flash_stars_pending_black_white = true
		return
	if _start_black_white_flash():
		_black_white_flash_pending_burst = true
		return
	_begin_attack_burst()


func _begin_attack_burst() -> void:
	if _burst_root == null:
		return

	_burst_elapsed = 0.0
	_burst_release_started = false
	_burst_active = true
	_position_burst()
	_set_burst_scale(0.0, 1.0)
	_start_burst_muzzle()
	_start_yuan_airflow_vfx()
	_burst_root.visible = true
	_restart_burst_animations(_burst_root)
	_update_processing_state()


func _update_burst(delta: float) -> void:
	_burst_elapsed += delta
	_position_burst()

	var extend_seconds := maxf(burst_extend_seconds, 0.001)
	var hold_seconds := maxf(burst_hold_seconds, 0.0)
	var release_seconds := maxf(burst_release_seconds, 0.001)
	var release_start := extend_seconds + hold_seconds
	var extend_progress := _ease_out(clampf(_burst_elapsed / extend_seconds, 0.0, 1.0))
	var release_progress := clampf((_burst_elapsed - release_start) / release_seconds, 0.0, 1.0)
	var collapse_progress := 1.0 - pow(1.0 - release_progress, 4.0)
	var width_scale := 1.0 - collapse_progress
	_set_burst_scale(extend_progress, width_scale)
	_apply_core_visuals_release_progress(collapse_progress)
	_update_burst_muzzle(extend_progress, release_progress)
	_update_yuan_airflow_vfx(extend_progress, release_progress)

	if release_progress > 0.0 and not _burst_release_started:
		_burst_release_started = true
		_start_close_tail()

	if _burst_elapsed >= _get_burst_total_seconds():
		_apply_core_visuals_release_progress(1.0)
		_stop_burst()


func _stop_burst() -> void:
	_burst_active = false
	_burst_elapsed = 0.0
	_burst_release_started = false
	if _burst_root != null:
		_burst_root.visible = false
		_position_burst()
		_set_burst_scale(0.0, 1.0)
	_clear_burst_muzzle()
	_clear_yuan_airflow_vfx()
	_update_processing_state()


func _start_pre_flash_stars() -> bool:
	if not pre_flash_star_enabled or pre_flash_star_seconds <= 0.0 or pre_flash_star_count <= 0:
		return false
	if _vfx_overlay == null:
		_prepare_aux_vfx()
	if _vfx_overlay == null:
		return false

	_prepare_pre_flash_stars()
	if _pre_flash_star_nodes.is_empty():
		return false

	_pre_flash_stars_elapsed = 0.0
	_pre_flash_stars_active = true
	_position_aux_vfx()
	_set_pre_flash_star_progress(0.0, 0.0)
	_update_processing_state()
	return true


func _update_pre_flash_stars(delta: float) -> void:
	_pre_flash_stars_elapsed += delta
	var duration := maxf(pre_flash_star_seconds, 0.001)
	var progress := clampf(_pre_flash_stars_elapsed / duration, 0.0, 1.0)
	_position_aux_vfx()
	_set_pre_flash_star_progress(progress, _pre_flash_stars_elapsed)
	if progress < 1.0:
		return

	var should_start_black_white := _pre_flash_stars_pending_black_white
	_clear_pre_flash_stars(false)
	_pre_flash_stars_pending_black_white = false
	if should_start_black_white:
		if _start_black_white_flash():
			_black_white_flash_pending_burst = true
		else:
			_begin_attack_burst()


func _clear_pre_flash_stars(reset_pending: bool = true) -> void:
	_pre_flash_stars_active = false
	_pre_flash_stars_elapsed = 0.0
	if reset_pending:
		_pre_flash_stars_pending_black_white = false
	for star in _pre_flash_star_nodes:
		if is_instance_valid(star):
			star.visible = false
	for star in _pre_flash_big_star_nodes:
		if is_instance_valid(star):
			star.visible = false
	_update_processing_state()


func _prepare_pre_flash_stars() -> void:
	if _vfx_overlay == null:
		return

	var star_count := clampi(pre_flash_star_count, 1, 64)
	var big_star_count := clampi(pre_flash_big_star_count, 1, 8) if pre_flash_big_star_enabled else 0
	if (
		_pre_flash_star_nodes.size() == star_count
		and _pre_flash_star_materials.size() == star_count
		and _pre_flash_big_star_nodes.size() == big_star_count
		and _pre_flash_big_star_materials.size() == big_star_count
	):
		return

	_free_pre_flash_star_nodes()

	var base_material := _create_additive_material(pre_flash_star_color, 6.5)
	base_material.albedo_texture = PRE_FLASH_STAR_TEXTURE
	base_material.render_priority = 64

	var star_mesh := QuadMesh.new()
	star_mesh.size = Vector2.ONE

	var rng := RandomNumberGenerator.new()
	rng.seed = 40841
	for index in star_count:
		var star := MeshInstance3D.new()
		star.name = "PreFlashCrossStar%02d" % [index + 1]
		star.mesh = star_mesh
		star.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		star.visible = false

		var material := base_material.duplicate() as StandardMaterial3D
		star.material_override = material
		_pre_flash_star_materials.append(material)

		var angle := rng.randf_range(0.0, TAU)
		var radius := pre_flash_star_radius * sqrt(rng.randf_range(0.03, 1.0))
		_pre_flash_star_offsets.append(Vector3(cos(angle) * radius, sin(angle) * radius * 0.74, rng.randf_range(-0.035, 0.035)))
		_pre_flash_star_phase_offsets.append(rng.randf())
		_pre_flash_star_reveal_points.append(clampf(float(index) / float(star_count) * 0.72 + rng.randf_range(-0.055, 0.055), 0.0, 0.82))
		_pre_flash_star_scale_multipliers.append(rng.randf_range(0.72, 1.28))

		_pre_flash_star_nodes.append(star)
		_vfx_overlay.add_child(star)

	var big_material := _create_additive_material(pre_flash_star_color.lerp(bridge_flash_white, 0.35), 28.5)
	big_material.albedo_texture = PRE_FLASH_STAR_TEXTURE
	big_material.render_priority = 72
	for index in big_star_count:
		var big_star := MeshInstance3D.new()
		big_star.name = "PreFlashMainCrossStar%02d" % [index + 1]
		big_star.mesh = star_mesh
		big_star.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		big_star.visible = false

		var material := big_material.duplicate() as StandardMaterial3D
		big_star.material_override = material
		_pre_flash_big_star_materials.append(material)

		var angle := rng.randf_range(0.0, TAU)
		var radius := pre_flash_star_radius * rng.randf_range(0.18, 0.62)
		var reveal_ratio := 0.0 if big_star_count <= 1 else float(index) / float(big_star_count - 1)
		_pre_flash_big_star_offsets.append(Vector3(cos(angle) * radius, sin(angle) * radius * 0.68, rng.randf_range(-0.02, 0.055)))
		_pre_flash_big_star_reveal_points.append(lerpf(0.58, 0.94, reveal_ratio))
		_pre_flash_big_star_phase_offsets.append(rng.randf())
		_pre_flash_big_star_scale_multipliers.append(rng.randf_range(0.82, 1.22))

		_pre_flash_big_star_nodes.append(big_star)
		_vfx_overlay.add_child(big_star)


func _free_pre_flash_star_nodes() -> void:
	for star in _pre_flash_star_nodes:
		if is_instance_valid(star):
			var parent := star.get_parent()
			if parent != null:
				parent.remove_child(star)
			star.queue_free()
	_pre_flash_star_nodes.clear()
	_pre_flash_star_materials.clear()
	_pre_flash_star_offsets.clear()
	_pre_flash_star_phase_offsets.clear()
	_pre_flash_star_reveal_points.clear()
	_pre_flash_star_scale_multipliers.clear()
	for star in _pre_flash_big_star_nodes:
		if is_instance_valid(star):
			var parent := star.get_parent()
			if parent != null:
				parent.remove_child(star)
			star.queue_free()
	_pre_flash_big_star_nodes.clear()
	_pre_flash_big_star_materials.clear()
	_pre_flash_big_star_offsets.clear()
	_pre_flash_big_star_reveal_points.clear()
	_pre_flash_big_star_phase_offsets.clear()
	_pre_flash_big_star_scale_multipliers.clear()


func _set_pre_flash_star_progress(progress: float, elapsed: float) -> void:
	var star_count := _pre_flash_star_nodes.size()
	if star_count <= 0:
		return

	var t := clampf(progress, 0.0, 1.0)
	var progressive := pow(t, maxf(pre_flash_star_progressive_power, 0.001))
	var rhythm := maxf(pre_flash_star_flash_rate, 0.001) * lerpf(0.55, 2.25, progressive)
	for index in star_count:
		var star := _pre_flash_star_nodes[index]
		if not is_instance_valid(star):
			continue

		var reveal := _pre_flash_star_reveal_points[index]
		var local_progress := clampf((t - reveal) / maxf(1.0 - reveal, 0.001), 0.0, 1.0)
		var phase := _pre_flash_star_phase_offsets[index]
		var pulse_a := pow(clampf(0.5 + 0.5 * sin((elapsed * rhythm + phase) * TAU), 0.0, 1.0), lerpf(13.0, 5.5, progressive))
		var pulse_b := pow(clampf(0.5 + 0.5 * sin((elapsed * rhythm * 1.73 + phase * 2.61) * TAU), 0.0, 1.0), 18.0)
		var pulse := maxf(pulse_a, pulse_b * 0.82)
		var alpha := pulse * local_progress * lerpf(0.25, 1.0, progressive)

		star.visible = alpha > 0.025
		star.position = _pre_flash_star_offsets[index]
		star.rotation.z = phase * TAU + elapsed * lerpf(1.5, 9.5, progressive)
		star.scale = Vector3.ONE * pre_flash_star_size * _pre_flash_star_scale_multipliers[index] * lerpf(0.25, 1.35, pulse) * maxf(local_progress, 0.001)
		_set_material_color(_pre_flash_star_materials[index], pre_flash_star_color.lerp(bridge_flash_white, pulse * 0.45), alpha)
	_set_pre_flash_big_star_progress(t, elapsed)


func _set_pre_flash_big_star_progress(progress: float, elapsed: float) -> void:
	var star_count := _pre_flash_big_star_nodes.size()
	if star_count <= 0:
		return

	var duration := maxf(pre_flash_star_seconds, 0.001)
	var flash_window := clampf(pre_flash_big_star_seconds / duration, 0.006, 0.18)
	for index in star_count:
		var star := _pre_flash_big_star_nodes[index]
		if not is_instance_valid(star):
			continue

		var reveal := _pre_flash_big_star_reveal_points[index]
		var flash_progress := (progress - reveal) / maxf(flash_window, 0.001)
		if flash_progress < 0.0 or flash_progress > 1.0:
			star.visible = false
			continue

		var pulse := pow(sin(clampf(flash_progress, 0.0, 1.0) * PI), 1.65)
		var phase := _pre_flash_big_star_phase_offsets[index]
		var scale_value := pre_flash_big_star_size * _pre_flash_big_star_scale_multipliers[index] * lerpf(0.45, 1.36, pulse)
		star.visible = pulse > 0.035
		star.position = _pre_flash_big_star_offsets[index]
		star.rotation.z = phase * TAU + elapsed * 7.0
		star.scale = Vector3.ONE * scale_value
		_set_material_color(_pre_flash_big_star_materials[index], pre_flash_star_color.lerp(bridge_flash_white, 0.75), pulse)


func _start_black_white_flash() -> bool:
	if not black_white_flash_enabled or black_white_flash_seconds <= 0.0:
		return false
	if _black_white_flash_overlay == null or _black_white_flash_material == null:
		_prepare_black_white_flash_overlay()
	if _black_white_flash_overlay == null or _black_white_flash_material == null:
		return false

	_black_white_flash_elapsed = 0.0
	_black_white_flash_active = true
	_black_white_flash_overlay.visible = true
	_push_black_white_flash_params(black_white_flash_strength, 0.0)
	_update_processing_state()
	return true


func _update_black_white_flash(delta: float) -> void:
	_black_white_flash_elapsed += delta
	var duration := maxf(black_white_flash_seconds, 0.001)
	var phase := clampf(_black_white_flash_elapsed / duration, 0.0, 1.0)
	_push_black_white_flash_params(black_white_flash_strength, phase)
	if phase < 1.0:
		return

	var should_start_burst := _black_white_flash_pending_burst
	_clear_black_white_flash(false)
	_black_white_flash_pending_burst = false
	if should_start_burst:
		_begin_attack_burst()


func _clear_black_white_flash(reset_pending: bool = true) -> void:
	_black_white_flash_active = false
	_black_white_flash_elapsed = 0.0
	if reset_pending:
		_black_white_flash_pending_burst = false
	_push_black_white_flash_params(0.0, 1.0)
	if _black_white_flash_overlay != null:
		_black_white_flash_overlay.visible = false
	_update_processing_state()


func _prepare_black_white_flash_overlay() -> void:
	if _vfx_overlay == null:
		return
	if _black_white_flash_overlay != null and _black_white_flash_material != null:
		return

	var quad_mesh := QuadMesh.new()
	quad_mesh.flip_faces = true
	quad_mesh.size = Vector2(2.0, 2.0)

	_black_white_flash_material = ShaderMaterial.new()
	_black_white_flash_material.resource_local_to_scene = true
	_black_white_flash_material.render_priority = 127
	_black_white_flash_material.shader = BLACK_WHITE_FLASH_SHADER

	_black_white_flash_overlay = MeshInstance3D.new()
	_black_white_flash_overlay.name = "BlackWhiteFlashOverlay3D"
	_black_white_flash_overlay.mesh = quad_mesh
	_black_white_flash_overlay.material_override = _black_white_flash_material
	_black_white_flash_overlay.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_black_white_flash_overlay.extra_cull_margin = 16384.0
	_black_white_flash_overlay.visible = false
	_vfx_overlay.add_child(_black_white_flash_overlay)
	_push_black_white_flash_params(0.0, 1.0)


func _push_black_white_flash_params(runtime_strength: float, runtime_phase: float) -> void:
	if _black_white_flash_material == null:
		return

	_black_white_flash_material.set_shader_parameter(&"effect_enabled", black_white_flash_enabled)
	_black_white_flash_material.set_shader_parameter(&"effect_strength", clampf(runtime_strength if black_white_flash_enabled else 0.0, 0.0, 1.0))
	_black_white_flash_material.set_shader_parameter(&"impact_phase", clampf(runtime_phase, 0.0, 1.0))
	_black_white_flash_material.set_shader_parameter(&"flash_center", _get_black_white_flash_center())
	_black_white_flash_material.set_shader_parameter(&"effect_uv_rect", Vector4(0.0, 0.0, 1.0, 1.0))
	_black_white_flash_material.set_shader_parameter(&"center_radius", black_white_flash_center_radius)
	_black_white_flash_material.set_shader_parameter(&"center_feather", black_white_flash_center_feather)
	_black_white_flash_material.set_shader_parameter(&"invert_effect_strength", 1.0)
	_black_white_flash_material.set_shader_parameter(&"invert_amount", 1.0)
	_black_white_flash_material.set_shader_parameter(&"filter_luma_start", 0.5)
	_black_white_flash_material.set_shader_parameter(&"filter_luma_range", 0.035)
	_black_white_flash_material.set_shader_parameter(&"bright_flash_color", Color.WHITE)
	_black_white_flash_material.set_shader_parameter(&"dark_flash_color", Color.BLACK)
	_black_white_flash_material.set_shader_parameter(&"flash_contrast", 9.0)
	_black_white_flash_material.set_shader_parameter(&"speed_line_noise", BLACK_WHITE_FLASH_SPEED_NOISE)
	_black_white_flash_material.set_shader_parameter(&"speed_line_strength", black_white_flash_line_strength)
	_black_white_flash_material.set_shader_parameter(&"speed_line_displacement_px", black_white_flash_line_displacement_px)
	_black_white_flash_material.set_shader_parameter(&"speed_line_density", black_white_flash_line_density)
	_black_white_flash_material.set_shader_parameter(&"speed_line_y_stretch", 21.7)
	_black_white_flash_material.set_shader_parameter(&"speed_line_width", black_white_flash_line_width)
	_black_white_flash_material.set_shader_parameter(&"speed_line_speed", black_white_flash_line_speed)
	_black_white_flash_material.set_shader_parameter(&"speed_line_warp", 4.57)
	_black_white_flash_material.set_shader_parameter(&"speed_line_center_fade", 0.0)
	_black_white_flash_material.set_shader_parameter(&"speed_line_edge_fade", 2.0)


func _get_black_white_flash_center() -> Vector2:
	if _camera == null:
		return Vector2(0.565, 0.54)
	var world_position := global_position + burst_local_offset
	if _core_visuals != null:
		world_position = _core_visuals.global_position
	if _camera.is_position_behind(world_position):
		return Vector2(0.565, 0.54)

	var viewport_size := get_viewport().get_visible_rect().size
	if viewport_size.x <= 1.0 or viewport_size.y <= 1.0:
		return Vector2(0.565, 0.54)

	var screen_position := _camera.unproject_position(world_position)
	return Vector2(
		clampf(screen_position.x / viewport_size.x, 0.0, 1.0),
		clampf(screen_position.y / viewport_size.y, 0.0, 1.0)
	)


func _prepare_core_visuals(node: Node) -> void:
	if node == null:
		return
	if node is Node3D:
		var root := node as Node3D
		root.visible = true
	if node is SpriteBase3D:
		var sprite_base := node as SpriteBase3D
		sprite_base.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
		sprite_base.render_priority = max(sprite_base.render_priority, 16)
		sprite_base.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if node is AnimatedSprite3D:
		var sprite := node as AnimatedSprite3D
		if sprite.sprite_frames != null and sprite.sprite_frames.has_animation(&"default"):
			sprite.visible = true
			sprite.play(&"default")
	for child in node.get_children():
		_prepare_core_visuals(child)


func _get_core_progress_for_frame(frame_number: int) -> float:
	var start_frame := core_grow_start_frame
	var end_frame := maxi(core_grow_end_frame, start_frame + 1)
	var raw_progress := clampf(
		float(frame_number - start_frame) / float(end_frame - start_frame),
		0.0,
		1.0
	)
	if not core_stepped_growth_enabled:
		return _ease_in_out(raw_progress)
	return _get_stepped_growth_progress(raw_progress)


func _get_stepped_growth_progress(raw_progress: float) -> float:
	var stage_count := maxi(core_growth_stage_count, 1)
	if raw_progress >= 1.0:
		return 1.0

	var first_jump_start := clampf(core_growth_first_jump_start, 0.0, 0.8)
	if raw_progress < first_jump_start:
		return 0.0

	var available := maxf(1.0 - first_jump_start, 0.001)
	var interval_weights: Array[float] = []
	var weight_total := 0.0
	for index in stage_count:
		var ratio := 0.0 if stage_count <= 1 else float(index) / float(stage_count - 1)
		var weight := maxf(1.0 - core_growth_interval_accel * ratio, 0.12)
		interval_weights.append(weight)
		weight_total += weight

	var stage_start := first_jump_start
	var previous_level := 0.0
	for stage_index in stage_count:
		var interval := available * interval_weights[stage_index] / maxf(weight_total, 0.001)
		var jump_duration := maxf(interval * clampf(1.0 - core_growth_hold_ratio, 0.06, 1.0), 0.001)
		var next_level := float(stage_index + 1) / float(stage_count)

		if raw_progress < stage_start:
			return previous_level
		if raw_progress < stage_start + jump_duration:
			var jump_progress := clampf((raw_progress - stage_start) / jump_duration, 0.0, 1.0)
			var snapped := 1.0 - pow(1.0 - jump_progress, core_growth_snap_sharpness)
			var overshoot := sin(jump_progress * PI) * core_growth_overshoot / float(stage_count)
			return clampf(lerpf(previous_level, next_level, snapped) + overshoot, 0.0, 1.0)

		previous_level = next_level
		stage_start += interval

	return 1.0


func _apply_core_visuals_progress(progress: float) -> void:
	if _core_visuals == null:
		return
	var scale_factor := lerpf(
		core_start_scale,
		core_full_scale_multiplier,
		clampf(progress, 0.0, 1.0)
	)
	_core_visuals_current_scale_multiplier = maxf(scale_factor, 0.0)
	_apply_core_visuals_transform()
	_update_processing_state()


func _apply_core_visuals_release_progress(progress: float) -> void:
	if _core_visuals == null:
		return
	var scale_factor := lerpf(
		_core_release_start_scale_multiplier,
		core_release_scale,
		_ease_in_out(clampf(progress, 0.0, 1.0))
	)
	_core_visuals_current_scale_multiplier = maxf(scale_factor, 0.0)
	_apply_core_visuals_transform()
	_update_processing_state()


func _apply_core_visuals_transform() -> void:
	if _core_visuals == null:
		return
	var energy := _get_core_energy_multiplier()
	_core_visuals.scale = _core_visuals_base_scale * _core_visuals_current_scale_multiplier * energy.x
	_apply_core_visuals_flicker(_core_visuals, energy.y, energy.z)
	_update_core_whiten_overlay(energy.z)


func _update_core_instability(delta: float) -> void:
	if not core_instability_enabled:
		_core_instability_spike = 0.0
		return

	_core_instability_spike = maxf(_core_instability_spike - delta * core_spike_decay, 0.0)
	if core_spike_chance > 0.0 and _core_instability_rng.randf() < delta * core_spike_chance:
		_core_instability_spike = maxf(_core_instability_spike, _core_instability_rng.randf_range(0.45, 1.0))


func _get_core_energy_multiplier() -> Vector3:
	var scale_multiplier := _get_core_heartbeat_multiplier()
	var flicker_multiplier := 1.0
	if core_instability_enabled:
		var t := _core_visuals_elapsed * maxf(core_instability_speed, 0.001)
		var slow_noise := _core_instability_noise.get_noise_1d(t)
		var fast_noise := _core_instability_noise.get_noise_1d(t * 2.73 + 41.0)
		var snap_noise := signf(sin(t * 5.13 + fast_noise * 3.0)) * absf(fast_noise)
		var unstable := clampf(slow_noise * 0.65 + snap_noise * 0.35, -1.0, 1.0)
		var spike := _core_instability_spike * core_spike_amount
		scale_multiplier += unstable * core_instability_scale + spike
		flicker_multiplier += maxf(unstable, -0.35) * core_instability_flicker + spike * 1.25
	var whiten_multiplier := _get_core_tension_whiten()
	return Vector3(maxf(scale_multiplier, 0.05), clampf(flicker_multiplier, 0.35, 2.2), whiten_multiplier)


func _get_core_heartbeat_multiplier() -> float:
	if not core_heartbeat_enabled or core_heartbeat_amount <= 0.0:
		return 1.0

	return 1.0 + _get_core_heartbeat_beat_strength() * core_heartbeat_amount


func _get_core_heartbeat_beat_strength() -> float:
	if not core_heartbeat_enabled:
		return 0.0

	var phase := fposmod(_core_visuals_elapsed * maxf(core_heartbeat_hz, 0.001), 1.0)
	var primary := _get_heartbeat_lobe(phase, 0.0, 0.18)
	var secondary := (
		_get_heartbeat_lobe(phase, clampf(core_heartbeat_second_beat_phase, 0.0, 1.0), 0.14)
		* core_heartbeat_second_beat_strength
	)
	var beat := clampf(primary + secondary, 0.0, 1.0)
	var scale_reference := maxf(core_full_scale_multiplier, 0.001)
	var intensity := clampf(_core_visuals_current_scale_multiplier / scale_reference, 0.0, 1.0)
	var envelope := lerpf(0.25, 1.0, intensity)
	return beat * envelope


func _get_heartbeat_lobe(phase: float, center: float, width: float) -> float:
	var distance := absf(phase - center)
	distance = minf(distance, 1.0 - distance)
	var lobe := 1.0 - clampf(distance / maxf(width, 0.001), 0.0, 1.0)
	return pow(lobe, core_heartbeat_sharpness)


func _get_core_tension_whiten() -> float:
	if not core_tension_whiten_enabled:
		return 0.0

	var scale_reference := maxf(core_full_scale_multiplier, 0.001)
	var grow_tension := clampf(_core_visuals_current_scale_multiplier / scale_reference, 0.0, 1.0)
	var pre_flash_tension := 0.0
	if _pre_flash_stars_active:
		pre_flash_tension = clampf(_pre_flash_stars_elapsed / maxf(pre_flash_star_seconds, 0.001), 0.0, 1.0)

	var tension := maxf(pow(grow_tension, 1.25) * 0.55, pre_flash_tension)
	var gamma_pull := pow(clampf(tension, 0.0, 1.0), maxf(core_tension_whiten_gamma, 0.001))
	var heartbeat_pull := _get_core_heartbeat_beat_strength() * core_tension_whiten_heartbeat * lerpf(0.35, 1.0, gamma_pull)
	return clampf(gamma_pull * core_tension_whiten_amount + heartbeat_pull + _get_burst_core_overexposure(), 0.0, 12.0)


func _get_burst_core_overexposure() -> float:
	if not _burst_active or burst_core_overexposure <= 0.0:
		return 0.0

	var open_seconds := maxf(minf(burst_muzzle_seconds * 0.38, burst_extend_seconds * 0.8), 0.016)
	var release_start := maxf(burst_extend_seconds, 0.001) + maxf(burst_hold_seconds, 0.0)
	var release_seconds := maxf(burst_release_seconds, 0.001)
	var open := _ease_out(clampf(_burst_elapsed / open_seconds, 0.0, 1.0))
	var release_progress := clampf((_burst_elapsed - release_start) / release_seconds, 0.0, 1.0)
	var release_fade := 1.0 - release_progress
	var flash := _get_burst_muzzle_flash_pulse()
	return burst_core_overexposure * open * release_fade * lerpf(0.68, 1.25, flash)


func _get_burst_muzzle_flash_pulse() -> float:
	if burst_muzzle_flash_rate <= 0.0 or burst_muzzle_flash_strength <= 0.0:
		return 0.0

	var flash_index := floorf(_burst_elapsed * burst_muzzle_flash_rate)
	var local_phase := fposmod(_burst_elapsed * burst_muzzle_flash_rate, 1.0)
	var random_a := fposmod(sin(flash_index * 12.9898 + 78.233) * 43758.5453, 1.0)
	var random_b := fposmod(sin((flash_index + 17.0) * 39.3467 + 11.135) * 24634.6345, 1.0)
	var gate := 1.0 if local_phase < lerpf(0.18, 0.48, random_b) else 0.0
	var pulse := gate * lerpf(0.42, 1.0, random_a)
	return clampf(pulse * burst_muzzle_flash_strength, 0.0, 2.0)


func _get_burst_muzzle_flash_jitter(flash_pulse: float) -> Vector3:
	if flash_pulse <= 0.0:
		return Vector3.ZERO

	var flash_index := floorf(_burst_elapsed * maxf(burst_muzzle_flash_rate, 0.001))
	var offset_x := fposmod(sin((flash_index + 3.0) * 19.19) * 9137.13, 1.0) * 2.0 - 1.0
	var offset_y := fposmod(sin((flash_index + 9.0) * 27.71) * 6211.91, 1.0) * 2.0 - 1.0
	var jitter_amount := burst_muzzle_size * 0.028 * clampf(flash_pulse, 0.0, 1.0)
	return Vector3(offset_x, offset_y, 0.0) * jitter_amount


func _apply_core_visuals_flicker(node: Node, flicker_multiplier: float, whiten_multiplier: float) -> void:
	if node == null:
		return
	if node is SpriteBase3D:
		var sprite_base := node as SpriteBase3D
		var brightness := clampf(flicker_multiplier, 0.35, 2.2)
		var whiten := clampf(whiten_multiplier, 0.0, 1.0)
		var alpha := clampf(0.78 + brightness * 0.22 + whiten * 0.18, 0.35, 1.0)
		var base_color := Color(brightness, brightness * 0.92, brightness * 1.08, alpha)
		var white_energy := 1.0 + maxf(whiten_multiplier, 0.0) * 2.4
		sprite_base.modulate = base_color.lerp(Color(white_energy, white_energy, white_energy, alpha), whiten)
	for child in node.get_children():
		_apply_core_visuals_flicker(child, flicker_multiplier, whiten_multiplier)


func _prepare_core_whiten_overlay() -> void:
	if _core_visuals == null:
		return
	if _core_whiten_flare != null and is_instance_valid(_core_whiten_flare):
		return

	_core_whiten_material = _create_additive_material(Color.WHITE, 8.0)
	_core_whiten_material.albedo_texture = SOFT_FLARE_TEXTURE
	_core_whiten_material.render_priority = 26

	var quad_mesh := QuadMesh.new()
	quad_mesh.size = Vector2.ONE
	_core_whiten_flare = MeshInstance3D.new()
	_core_whiten_flare.name = "GeneratedCoreTensionWhite"
	_core_whiten_flare.mesh = quad_mesh
	_core_whiten_flare.material_override = _core_whiten_material
	_core_whiten_flare.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_core_whiten_flare.visible = false
	_core_visuals.add_child(_core_whiten_flare)


func _update_core_whiten_overlay(whiten_multiplier: float) -> void:
	if _core_whiten_flare == null or _core_whiten_material == null:
		_prepare_core_whiten_overlay()
	if _core_whiten_flare == null or _core_whiten_material == null:
		return

	var strength := maxf(whiten_multiplier, 0.0)
	if not core_tension_whiten_enabled or strength <= 0.006 or _core_visuals_current_scale_multiplier <= 0.001:
		_core_whiten_flare.visible = false
		return

	var visible_strength := clampf(strength, 0.0, 12.0)
	var heartbeat := _get_core_heartbeat_beat_strength()
	var burst_glow := clampf(_get_burst_core_overexposure() / maxf(burst_core_overexposure, 0.001), 0.0, 1.0) if _burst_active else 0.0
	var alpha := clampf(visible_strength * 0.22 + burst_glow * 0.18, 0.0, 1.0)
	var scale_value := core_tension_whiten_overlay_size * lerpf(0.72, 1.38 + burst_core_glow_size * burst_glow, clampf(visible_strength * 0.18 + heartbeat * 0.45 + burst_glow * 0.75, 0.0, 1.0))
	_core_whiten_flare.visible = true
	_core_whiten_flare.position = Vector3(0.0, 0.0, 0.04)
	_core_whiten_flare.rotation = Vector3.ZERO
	_core_whiten_flare.scale = Vector3.ONE * maxf(scale_value, 0.001)
	_set_material_color(_core_whiten_material, Color.WHITE, alpha)
	_core_whiten_material.emission_energy_multiplier = 6.0 + visible_strength * 10.0


func _position_burst() -> void:
	if _burst_root == null:
		return
	_burst_root.position = burst_local_offset
	_burst_root.rotation = burst_rotation


func _set_burst_scale(length_scale: float, width_scale: float) -> void:
	if _burst_root == null:
		return
	_burst_root.scale = Vector3(
		burst_full_scale.x * clampf(width_scale, 0.0, 1.0),
		burst_full_scale.y * clampf(length_scale, 0.0, 1.0),
		burst_full_scale.z
	)


func _get_burst_total_seconds() -> float:
	return maxf(burst_extend_seconds, 0.001) + maxf(burst_hold_seconds, 0.0) + maxf(burst_release_seconds, 0.0)


func _prepare_burst_tree(node: Node) -> void:
	if node == null:
		return
	if node is WorldEnvironment:
		var world_environment := node as WorldEnvironment
		world_environment.environment = null
	elif node is Camera3D:
		var camera := node as Camera3D
		camera.current = false
		camera.visible = false
	elif node is Light3D:
		var light := node as Light3D
		light.visible = false
	elif node is GeometryInstance3D:
		var geometry := node as GeometryInstance3D
		geometry.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	if node is SpriteBase3D:
		var sprite_base := node as SpriteBase3D
		sprite_base.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
		sprite_base.render_priority = max(sprite_base.render_priority, 18)
	for child in node.get_children():
		_prepare_burst_tree(child)


func _restart_burst_animations(node: Node) -> void:
	if node is AnimatedSprite3D:
		var sprite := node as AnimatedSprite3D
		if sprite.sprite_frames != null and sprite.sprite_frames.has_animation(&"default"):
			sprite.frame = 0
			sprite.frame_progress = 0.0
			sprite.play(&"default")
	for child in node.get_children():
		_restart_burst_animations(child)


func _start_yuan_airflow_vfx() -> void:
	if not yuan_airflow_enabled:
		_clear_yuan_airflow_vfx()
		return

	if _yuan_airflow_vfx == null or not is_instance_valid(_yuan_airflow_vfx):
		var instance := YUAN_AIRFLOW_SCENE.instantiate() as Node3D
		if instance == null:
			return
		instance.name = "GeneratedYuanAirflowBehindCore"
		add_child(instance)
		_yuan_airflow_vfx = instance
		_prepare_yuan_airflow_tree(_yuan_airflow_vfx)

	_sync_yuan_airflow_parameters()
	_yuan_airflow_vfx.visible = true
	_position_yuan_airflow_vfx(0.0, 0.0)


func _update_yuan_airflow_vfx(extend_progress: float, release_progress: float) -> void:
	if _yuan_airflow_vfx == null or not is_instance_valid(_yuan_airflow_vfx):
		return
	if not yuan_airflow_enabled:
		_yuan_airflow_vfx.visible = false
		return
	_sync_yuan_airflow_parameters()
	_yuan_airflow_vfx.visible = release_progress < 1.0
	if not _yuan_airflow_vfx.visible:
		return
	_position_yuan_airflow_vfx(extend_progress, release_progress)


func _clear_yuan_airflow_vfx() -> void:
	if _yuan_airflow_vfx != null and is_instance_valid(_yuan_airflow_vfx):
		_yuan_airflow_vfx.visible = false


func _position_yuan_airflow_vfx(extend_progress: float, release_progress: float) -> void:
	if _yuan_airflow_vfx == null or not is_instance_valid(_yuan_airflow_vfx):
		return

	var release_fade := 1.0 - clampf(release_progress, 0.0, 1.0)
	_yuan_airflow_vfx.position = yuan_airflow_offset
	_yuan_airflow_vfx.rotation = Vector3(
		deg_to_rad(yuan_airflow_rotation.x),
		deg_to_rad(yuan_airflow_rotation.y),
		deg_to_rad(yuan_airflow_rotation.z)
	)
	_yuan_airflow_vfx.scale = Vector3.ONE * yuan_airflow_scale * lerpf(0.82, 1.0, clampf(extend_progress, 0.0, 1.0)) * maxf(release_fade, 0.001)


func _sync_editor_preview() -> void:
	if not Engine.is_editor_hint():
		return

	if yuan_airflow_enabled:
		_start_yuan_airflow_vfx()
		if _yuan_airflow_vfx != null and is_instance_valid(_yuan_airflow_vfx):
			_sync_yuan_airflow_parameters()
			_yuan_airflow_vfx.visible = true
			_position_yuan_airflow_vfx(1.0, 0.0)
	else:
		_clear_yuan_airflow_vfx()


func _sync_yuan_airflow_parameters() -> void:
	if _yuan_airflow_vfx == null or not is_instance_valid(_yuan_airflow_vfx):
		return

	for child in _yuan_airflow_vfx.find_children("*", "Node", true, false):
		if child.get("spin_speed") != null:
			child.set("spin_speed", 0.0)
			if child is Node3D:
				var child_node_3d := child as Node3D
				child_node_3d.rotation = Vector3.ZERO
			child.set_process(false)
		if child.get("flip_s_ramp") != null:
			child.set("flip_s_ramp", yuan_airflow_flip_s_ramp)
		if child.get("s_min") != null:
			child.set("s_min", yuan_airflow_s_min)
		if child.get("s_max") != null:
			child.set("s_max", yuan_airflow_s_max)


func _prepare_yuan_airflow_tree(node: Node) -> void:
	if node == null:
		return

	if node is WorldEnvironment:
		var world_environment := node as WorldEnvironment
		world_environment.environment = null
	elif node is Camera3D:
		var camera := node as Camera3D
		camera.current = false
		camera.visible = false
	elif node is Light3D:
		var light := node as Light3D
		light.visible = false
	elif node.name == "Floor" and node is VisualInstance3D:
		var visual := node as VisualInstance3D
		visual.visible = false

	if node is GeometryInstance3D:
		var geometry := node as GeometryInstance3D
		geometry.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	for child in node.get_children():
		_prepare_yuan_airflow_tree(child)


func _prepare_aux_vfx() -> void:
	if _vfx_overlay != null:
		return

	_vfx_overlay = Node3D.new()
	_vfx_overlay.name = "GeneratedTimingVfx"
	add_child(_vfx_overlay)

	_bridge_ring_material = _create_additive_material(bridge_flash_color, 4.0)
	_bridge_flash_material = _create_additive_material(bridge_flash_white, 5.5)
	_bridge_spark_material = _create_additive_material(bridge_flash_white, 4.5)
	_tail_ring_material = _create_additive_material(close_tail_color, 4.0)
	_tail_spark_material = _create_additive_material(close_tail_color, 5.0)
	_tail_particle_material = _create_additive_material(close_tail_color, 7.0)
	_tail_particle_material.render_priority = 70
	_burst_muzzle_flare_material = _create_additive_material(bridge_flash_white, 8.0)
	_burst_muzzle_flare_material.albedo_texture = SOFT_FLARE_TEXTURE
	_burst_muzzle_flare_material.render_priority = 62
	_burst_muzzle_fan_material = _create_additive_material(close_tail_color.lerp(bridge_flash_white, 0.48), 7.0)
	_burst_muzzle_fan_material.albedo_texture = SOFT_FLARE_TEXTURE
	_burst_muzzle_fan_material.render_priority = 61
	_burst_source_particle_material = _create_additive_material(bridge_flash_white.lerp(close_tail_color, 0.18), 6.5)
	_burst_source_particle_material.render_priority = 63

	_bridge_ring = _create_ring_node("BridgeConvergeRing", _bridge_ring_material)
	_bridge_flash = _create_quad_node("BridgeWhiteFlash", _bridge_flash_material, 1.0)
	_tail_ring = _create_ring_node("CloseTailRing", _tail_ring_material)
	_burst_muzzle_flare = _create_quad_node("BurstMuzzleSoftFlare", _burst_muzzle_flare_material, 1.0)
	_burst_muzzle_fan = MeshInstance3D.new()
	_burst_muzzle_fan.name = "BurstMuzzleFan"
	_burst_muzzle_fan.mesh = _create_muzzle_fan_mesh()
	_burst_muzzle_fan.material_override = _burst_muzzle_fan_material
	_burst_muzzle_fan.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_burst_muzzle_fan.visible = false
	_burst_source_particles = _create_burst_source_particles()

	_vfx_overlay.add_child(_bridge_ring)
	_vfx_overlay.add_child(_bridge_flash)
	_vfx_overlay.add_child(_tail_ring)
	_vfx_overlay.add_child(_burst_muzzle_fan)
	_vfx_overlay.add_child(_burst_muzzle_flare)
	_vfx_overlay.add_child(_burst_source_particles)

	_bridge_sparks = _create_spark_nodes("BridgeSpark", 10, _bridge_spark_material)
	for spark in _bridge_sparks:
		_vfx_overlay.add_child(spark)
	_prepare_tail_burst_particles()
	_prepare_pre_flash_stars()
	_prepare_black_white_flash_overlay()


func _update_bridge_charge_for_frame(frame_number: int) -> void:
	var start_frame := mini(bridge_flash_start_frame, bridge_flash_end_frame)
	var end_frame := maxi(bridge_flash_end_frame, start_frame + 1)
	if frame_number < start_frame or frame_number > end_frame:
		if not _bridge_active:
			_clear_bridge_flash()
		return

	var progress := clampf(float(frame_number - start_frame) / float(end_frame - start_frame), 0.0, 1.0)
	_set_bridge_charge_progress(progress)


func _set_bridge_charge_progress(progress: float) -> void:
	if _vfx_overlay == null:
		return

	var t := clampf(progress, 0.0, 1.0)
	var eased := _ease_in(t)
	var pulse := sin(t * PI)
	_position_aux_vfx()
	_set_aux_node_visible(_bridge_ring, true)
	_set_aux_node_visible(_bridge_flash, true)
	_bridge_ring.scale = Vector3.ONE * lerpf(1.38, 0.18, eased)
	_bridge_flash.scale = Vector3.ONE * (0.56 + pulse * 0.52 + eased * 0.22)
	_bridge_ring.rotation.z = lerpf(0.0, PI * 0.55, t)
	_bridge_flash.rotation.z = lerpf(PI * 0.25, PI * 0.75, t)
	_set_material_color(_bridge_ring_material, bridge_flash_color.lerp(bridge_flash_white, t), lerpf(0.42, 1.0, eased))
	_set_material_color(_bridge_flash_material, bridge_flash_white, 0.34 + pulse * 0.56)
	_set_sparks_converge(_bridge_sparks, lerpf(0.72, 0.04, eased), lerpf(0.45, 1.0, eased), lerpf(0.86, 0.34, t), PI * 0.3 * t)
	_set_material_color(_bridge_spark_material, bridge_flash_white, lerpf(0.44, 1.0, eased))


func _start_bridge_peak() -> void:
	_bridge_active = true
	_bridge_elapsed = 0.0
	_set_bridge_charge_progress(1.0)
	_update_processing_state()


func _update_bridge_peak(delta: float) -> void:
	_bridge_elapsed += delta
	var duration := maxf(bridge_flash_peak_seconds, 0.01)
	var progress := clampf(_bridge_elapsed / duration, 0.0, 1.0)
	var inverse := 1.0 - progress
	var eased := _ease_out(progress)

	_position_aux_vfx()
	_set_aux_node_visible(_bridge_ring, true)
	_set_aux_node_visible(_bridge_flash, true)
	_bridge_ring.scale = Vector3.ONE * lerpf(0.22, 0.04, eased)
	_bridge_flash.scale = Vector3.ONE * lerpf(0.68, 0.98, eased)
	_bridge_ring.rotation.z += delta * 9.0
	_bridge_flash.rotation.z -= delta * 13.0
	_set_material_color(_bridge_ring_material, bridge_flash_white, inverse * 0.95)
	_set_material_color(_bridge_flash_material, bridge_flash_white, inverse * 0.82)
	_set_sparks_converge(_bridge_sparks, lerpf(0.04, 0.0, eased), inverse, lerpf(0.34, 0.08, eased), -PI * 0.3 * progress)
	_set_material_color(_bridge_spark_material, bridge_flash_white, inverse)

	if progress >= 1.0:
		_clear_bridge_flash()


func _clear_bridge_flash() -> void:
	_bridge_active = false
	_bridge_elapsed = 0.0
	_set_aux_node_visible(_bridge_ring, false)
	_set_aux_node_visible(_bridge_flash, false)
	for spark in _bridge_sparks:
		_set_aux_node_visible(spark, false)
	_update_processing_state()


func _start_close_tail() -> void:
	_prepare_tail_burst_particles()
	_tail_active = true
	_tail_elapsed = 0.0
	_set_close_tail_progress(0.0)
	_update_processing_state()


func _update_close_tail(delta: float) -> void:
	_tail_elapsed += delta
	var duration := maxf(close_tail_seconds, 0.01)
	var progress := clampf(_tail_elapsed / duration, 0.0, 1.0)
	_set_close_tail_progress(progress)
	if progress >= 1.0:
		_clear_close_tail()


func _set_close_tail_progress(progress: float) -> void:
	if _vfx_overlay == null:
		return

	var t := clampf(progress, 0.0, 1.0)
	var eased := _ease_out(t)
	var inverse := 1.0 - t
	var radius := lerpf(close_tail_start_radius, close_tail_end_radius, eased)
	var alpha := pow(inverse, 1.35)
	_position_aux_vfx()
	_set_aux_node_visible(_tail_ring, true)
	_tail_ring.scale = Vector3.ONE * maxf(radius * 2.0, 0.001)
	_tail_ring.rotation.z = -PI * 0.45 * eased
	_set_material_color(_tail_ring_material, close_tail_color.lerp(bridge_flash_white, 0.35 * inverse), alpha * 0.9)
	for spark in _tail_sparks:
		_set_aux_node_visible(spark, false)
	_set_tail_burst_particles_progress(t, alpha)


func _clear_close_tail() -> void:
	_tail_active = false
	_tail_elapsed = 0.0
	_set_aux_node_visible(_tail_ring, false)
	for spark in _tail_sparks:
		_set_aux_node_visible(spark, false)
	for particle in _tail_burst_particles:
		_set_aux_node_visible(particle, false)
	_update_processing_state()


func _position_aux_vfx() -> void:
	if _vfx_overlay == null:
		return
	_vfx_overlay.position = burst_local_offset
	_vfx_overlay.rotation = Vector3.ZERO


func _start_burst_muzzle() -> void:
	if not burst_muzzle_enabled:
		_clear_burst_muzzle()
		return
	if _vfx_overlay == null:
		_prepare_aux_vfx()
	_update_burst_muzzle(0.0, 0.0)


func _update_burst_muzzle(extend_progress: float, release_progress: float) -> void:
	if not burst_muzzle_enabled or _burst_muzzle_flare == null or _burst_muzzle_fan == null:
		_clear_burst_muzzle()
		return

	var open_seconds := maxf(minf(burst_muzzle_seconds * 0.38, burst_extend_seconds * 0.8), 0.016)
	var open := _ease_out(clampf(_burst_elapsed / open_seconds, 0.0, 1.0))
	var settle := lerpf(1.0, 0.34, clampf(_burst_elapsed / maxf(burst_muzzle_seconds, 0.001), 0.0, 1.0))
	var release_fade := 1.0 - clampf(release_progress, 0.0, 1.0)
	var strength := clampf(open * settle * release_fade * burst_muzzle_strength, 0.0, 3.0)
	if strength <= 0.004:
		_clear_burst_muzzle()
		return

	_position_aux_vfx()
	var flash_pulse := _get_burst_muzzle_flash_pulse()
	var flash_lift := lerpf(0.36, 1.0 + burst_muzzle_flash_strength * 1.8, flash_pulse)
	var flash_alpha := clampf(strength * lerpf(0.12, 1.0, flash_pulse), 0.0, 1.0)
	_burst_muzzle_flare.visible = true
	_burst_muzzle_flare.position = Vector3(0.0, 0.0, 0.06) + _get_burst_muzzle_flash_jitter(flash_pulse)
	_burst_muzzle_flare.rotation = burst_rotation
	_burst_muzzle_flare.scale = Vector3.ONE * burst_muzzle_size * lerpf(0.72, 1.18, clampf(extend_progress, 0.0, 1.0)) * lerpf(0.88, 1.22, flash_pulse)
	_set_material_color(_burst_muzzle_flare_material, bridge_flash_white, flash_alpha)
	_burst_muzzle_flare_material.emission_energy_multiplier = (7.0 + strength * 18.0) * flash_lift

	_burst_muzzle_fan.visible = true
	_burst_muzzle_fan.position = Vector3(0.0, 0.0, 0.045)
	_burst_muzzle_fan.rotation = burst_rotation
	_burst_muzzle_fan.scale = Vector3(
		burst_muzzle_width * lerpf(0.62, 1.08, clampf(extend_progress, 0.0, 1.0)),
		burst_muzzle_length,
		1.0
	)
	_set_material_color(_burst_muzzle_fan_material, close_tail_color.lerp(bridge_flash_white, lerpf(0.55, 0.9, flash_pulse)), clampf(strength * lerpf(0.28, 0.74, flash_pulse), 0.0, 0.95))
	_burst_muzzle_fan_material.emission_energy_multiplier = (5.0 + strength * 10.0) * lerpf(0.8, 1.75, flash_pulse)
	_update_burst_source_particles(strength, extend_progress, release_progress)


func _clear_burst_muzzle() -> void:
	_set_aux_node_visible(_burst_muzzle_flare, false)
	_set_aux_node_visible(_burst_muzzle_fan, false)
	if _burst_source_particles != null:
		_burst_source_particles.emitting = false
		_burst_source_particles.visible = false


func _prepare_tail_burst_particles() -> void:
	if _vfx_overlay == null:
		return

	var particle_count := clampi(close_tail_particle_count, 0, 96) if close_tail_particles_enabled else 0
	if _tail_burst_particles.size() == particle_count and _tail_particle_directions.size() == particle_count:
		return

	_free_tail_burst_particles()
	if particle_count <= 0:
		return

	var particle_mesh := _create_filled_circle_mesh(0.5, 24)
	var rng := RandomNumberGenerator.new()
	rng.seed = 73531
	for index in particle_count:
		var particle := MeshInstance3D.new()
		particle.name = "CloseTailBurstParticle%02d" % [index + 1]
		particle.mesh = particle_mesh
		particle.material_override = _tail_particle_material
		particle.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		particle.visible = false

		var angle := rng.randf_range(0.0, TAU)
		_tail_particle_directions.append(Vector2(cos(angle), sin(angle)))
		_tail_particle_start_radii.append(rng.randf_range(0.0, close_tail_start_radius * 0.65))
		_tail_particle_end_radii.append(close_tail_particle_radius * rng.randf_range(0.58, 1.18))
		_tail_particle_scales.append(rng.randf_range(0.55, 1.45))
		_tail_particle_phase_offsets.append(rng.randf())

		_tail_burst_particles.append(particle)
		_vfx_overlay.add_child(particle)


func _free_tail_burst_particles() -> void:
	for particle in _tail_burst_particles:
		if is_instance_valid(particle):
			var parent := particle.get_parent()
			if parent != null:
				parent.remove_child(particle)
			particle.queue_free()
	_tail_burst_particles.clear()
	_tail_particle_directions.clear()
	_tail_particle_start_radii.clear()
	_tail_particle_end_radii.clear()
	_tail_particle_scales.clear()
	_tail_particle_phase_offsets.clear()


func _set_tail_burst_particles_progress(progress: float, base_alpha: float) -> void:
	var particle_count := _tail_burst_particles.size()
	if particle_count <= 0 or _tail_particle_material == null:
		return

	var t := clampf(progress, 0.0, 1.0)
	var travel := _ease_out(t)
	var particle_alpha := clampf(base_alpha * lerpf(1.25, 0.35, t), 0.0, 1.0)
	_set_material_color(_tail_particle_material, close_tail_color.lerp(bridge_flash_white, 0.5 * (1.0 - t)), particle_alpha)
	for index in particle_count:
		var particle := _tail_burst_particles[index]
		if not is_instance_valid(particle):
			continue

		var direction := _tail_particle_directions[index]
		var radius := lerpf(_tail_particle_start_radii[index], _tail_particle_end_radii[index], travel)
		var phase := _tail_particle_phase_offsets[index]
		var size_pulse := 1.0 + sin((t * 4.0 + phase) * TAU) * 0.08
		particle.visible = particle_alpha > 0.018
		particle.position = Vector3(direction.x * radius, direction.y * radius, phase * 0.075 - 0.035)
		particle.rotation.z = phase * TAU + t * TAU * lerpf(0.6, 2.8, phase)
		particle.scale = Vector3.ONE * close_tail_particle_size * _tail_particle_scales[index] * lerpf(1.7, 0.25, t) * size_pulse


func _set_sparks_converge(sparks: Array[MeshInstance3D], radius: float, alpha: float, scale_value: float, angle_offset: float) -> void:
	if sparks.is_empty():
		return
	for index in sparks.size():
		var spark := sparks[index]
		var angle := TAU * float(index) / float(sparks.size()) + angle_offset
		spark.visible = alpha > 0.001
		spark.position = Vector3(cos(angle) * radius, sin(angle) * radius, 0.015 * float(index % 3))
		spark.scale = Vector3.ONE * maxf(scale_value, 0.001)
		spark.rotation.z = angle + PI * 0.25


func _create_spark_nodes(prefix: String, count: int, material: Material) -> Array[MeshInstance3D]:
	var sparks: Array[MeshInstance3D] = []
	var spark_mesh := QuadMesh.new()
	spark_mesh.size = Vector2(0.055, 0.055)
	for index in count:
		var spark := MeshInstance3D.new()
		spark.name = "%s%02d" % [prefix, index + 1]
		spark.mesh = spark_mesh
		spark.material_override = material
		spark.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		spark.visible = false
		sparks.append(spark)
	return sparks


func _create_quad_node(node_name: String, material: Material, size: float) -> MeshInstance3D:
	var quad_mesh := QuadMesh.new()
	quad_mesh.size = Vector2(size, size)
	var node := MeshInstance3D.new()
	node.name = node_name
	node.mesh = quad_mesh
	node.material_override = material
	node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	node.visible = false
	return node


func _create_ring_node(node_name: String, material: Material) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = node_name
	node.mesh = _create_ring_mesh(0.38, 0.5, 72)
	node.material_override = material
	node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	node.visible = false
	return node


func _create_ring_mesh(inner_radius: float, outer_radius: float, segments: int) -> ArrayMesh:
	var vertices := PackedVector3Array()
	var normals := PackedVector3Array()
	var uvs := PackedVector2Array()
	var indices := PackedInt32Array()
	var safe_segments := maxi(segments, 3)

	for index in safe_segments:
		var angle := TAU * float(index) / float(safe_segments)
		var direction := Vector2(cos(angle), sin(angle))
		vertices.append(Vector3(direction.x * outer_radius, direction.y * outer_radius, 0.0))
		vertices.append(Vector3(direction.x * inner_radius, direction.y * inner_radius, 0.0))
		normals.append(Vector3.FORWARD)
		normals.append(Vector3.FORWARD)
		uvs.append(Vector2(1.0, 0.0))
		uvs.append(Vector2(0.0, 1.0))

	for index in safe_segments:
		var next_index := (index + 1) % safe_segments
		var outer_a := index * 2
		var inner_a := outer_a + 1
		var outer_b := next_index * 2
		var inner_b := outer_b + 1
		indices.append_array([outer_a, outer_b, inner_b, outer_a, inner_b, inner_a])

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices

	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh


func _create_filled_circle_mesh(radius: float, segments: int) -> ArrayMesh:
	var vertices := PackedVector3Array()
	var normals := PackedVector3Array()
	var uvs := PackedVector2Array()
	var indices := PackedInt32Array()
	var safe_segments := maxi(segments, 3)

	vertices.append(Vector3.ZERO)
	normals.append(Vector3.FORWARD)
	uvs.append(Vector2(0.5, 0.5))
	for index in safe_segments:
		var angle := TAU * float(index) / float(safe_segments)
		var direction := Vector2(cos(angle), sin(angle))
		vertices.append(Vector3(direction.x * radius, direction.y * radius, 0.0))
		normals.append(Vector3.FORWARD)
		uvs.append(Vector2(direction.x * 0.5 + 0.5, direction.y * 0.5 + 0.5))

	for index in safe_segments:
		var next_index := 1 + ((index + 1) % safe_segments)
		indices.append_array([0, index + 1, next_index])

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices

	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh


func _create_muzzle_fan_mesh() -> ArrayMesh:
	var vertices := PackedVector3Array([
		Vector3(-0.16, 0.0, 0.0),
		Vector3(0.16, 0.0, 0.0),
		Vector3(0.5, 1.0, 0.0),
		Vector3(-0.5, 1.0, 0.0),
	])
	var normals := PackedVector3Array([
		Vector3.FORWARD,
		Vector3.FORWARD,
		Vector3.FORWARD,
		Vector3.FORWARD,
	])
	var uvs := PackedVector2Array([
		Vector2(0.34, 1.0),
		Vector2(0.66, 1.0),
		Vector2(1.0, 0.0),
		Vector2(0.0, 0.0),
	])
	var indices := PackedInt32Array([0, 1, 2, 0, 2, 3])

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices

	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh


func _create_burst_source_particles() -> GPUParticles3D:
	var particles := GPUParticles3D.new()
	particles.name = "BurstSourceParticles"
	particles.one_shot = false
	particles.emitting = false
	particles.local_coords = true
	particles.amount = burst_source_particle_count
	particles.lifetime = burst_source_particle_lifetime
	particles.preprocess = 0.0
	particles.randomness = 0.35
	particles.draw_order = GPUParticles3D.DRAW_ORDER_LIFETIME
	particles.transform_align = GPUParticles3D.TRANSFORM_ALIGN_Z_BILLBOARD
	particles.visibility_aabb = AABB(Vector3(-2.4, -0.4, -0.8), Vector3(4.8, 6.4, 1.6))
	particles.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	_set_burst_source_particle_mesh_size(burst_source_particle_size, particles)

	var process := ParticleProcessMaterial.new()
	process.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_RING
	process.emission_ring_axis = Vector3.UP
	process.emission_ring_radius = 0.42
	process.emission_ring_inner_radius = 0.24
	process.emission_ring_height = 0.08
	process.direction = Vector3.UP
	process.spread = burst_source_particle_spread
	process.gravity = Vector3.ZERO
	process.initial_velocity_min = burst_source_particle_range * burst_source_particle_speed * 1.8
	process.initial_velocity_max = burst_source_particle_range * burst_source_particle_speed * 2.8
	process.angular_velocity_min = -2.4
	process.angular_velocity_max = 2.4
	process.damping_min = 0.35
	process.damping_max = 0.75
	process.scale_min = 0.75
	process.scale_max = 1.45
	process.lifetime_randomness = 0.22
	process.color = Color.WHITE
	process.scale_curve = _create_burst_source_particle_scale_curve()
	particles.process_material = process

	_burst_source_particle_process = process
	particles.visible = false
	return particles


func _set_burst_source_particle_mesh_size(size: float, particles: GPUParticles3D = null) -> void:
	var target_particles := particles if particles != null else _burst_source_particles
	if target_particles == null:
		return

	var clamped_size := maxf(size, 0.001)
	if is_equal_approx(_burst_source_particle_mesh_size, clamped_size) and target_particles.draw_pass_1 != null:
		return

	var circle_mesh := _create_filled_circle_mesh(clamped_size * 0.5, 18)
	circle_mesh.surface_set_material(0, _burst_source_particle_material)
	target_particles.draw_pass_1 = circle_mesh
	_burst_source_particle_mesh_size = clamped_size


func _create_burst_source_particle_scale_curve() -> CurveTexture:
	var curve := Curve.new()
	curve.add_point(Vector2(0.0, 1.0))
	curve.add_point(Vector2(0.18, 0.92))
	curve.add_point(Vector2(0.72, 0.42))
	curve.add_point(Vector2(1.0, 0.08))

	var texture := CurveTexture.new()
	texture.curve = curve
	return texture


func _update_burst_source_particles(strength: float, extend_progress: float, release_progress: float) -> void:
	if _burst_source_particles == null or _burst_source_particle_process == null or _burst_source_particle_material == null:
		return

	if not burst_source_particles_enabled or burst_source_particle_count <= 0:
		_burst_source_particles.emitting = false
		_burst_source_particles.visible = false
		return

	var release_fade := 1.0 - clampf(release_progress, 0.0, 1.0)
	var live_strength := clampf(strength * release_fade, 0.0, 3.0)
	if live_strength <= 0.01:
		_burst_source_particles.emitting = false
		_burst_source_particles.visible = false
		return

	_burst_source_particles.visible = true
	_burst_source_particles.emitting = true
	_burst_source_particles.rotation = burst_rotation
	_burst_source_particles.amount = burst_source_particle_count
	_burst_source_particles.amount_ratio = clampf(0.35 + live_strength * 0.28, 0.0, 1.0)
	_burst_source_particles.lifetime = lerpf(
		burst_source_particle_lifetime,
		maxf(burst_source_particle_lifetime * 0.52, 0.05),
		clampf(_burst_elapsed / maxf(burst_muzzle_seconds, 0.001), 0.0, 1.0)
	)

	var open_scale := lerpf(0.82, 1.28, clampf(extend_progress, 0.0, 1.0))
	var core_scale := _core_visuals.scale if _core_visuals != null else Vector3.ONE * burst_muzzle_size
	var core_radius := maxf(maxf(core_scale.x, core_scale.y), core_scale.z) * 0.58
	var emitter_radius := maxf(core_radius * 0.72, burst_muzzle_size * 0.55) * lerpf(0.92, 1.08, clampf(extend_progress, 0.0, 1.0))
	var burst_basis := Basis.from_euler(burst_rotation)
	_burst_source_particles.position = burst_basis * Vector3.UP * maxf(emitter_radius * 0.12, 0.025)
	_burst_source_particles.scale = Vector3.ONE

	_set_burst_source_particle_mesh_size(burst_source_particle_size, _burst_source_particles)

	_burst_source_particle_process.emission_ring_radius = emitter_radius
	_burst_source_particle_process.emission_ring_inner_radius = emitter_radius * 0.62
	_burst_source_particle_process.emission_ring_height = maxf(emitter_radius * 0.22, 0.035)

	_burst_source_particle_process.initial_velocity_min = burst_muzzle_length * burst_source_particle_range * burst_source_particle_speed * lerpf(1.8, 2.9, live_strength / 3.0)
	_burst_source_particle_process.initial_velocity_max = burst_muzzle_length * burst_source_particle_range * burst_source_particle_speed * lerpf(2.6, 4.2, live_strength / 3.0)
	_burst_source_particle_process.scale_min = lerpf(0.95, 1.45, live_strength / 3.0)
	_burst_source_particle_process.scale_max = lerpf(1.45, 2.3, live_strength / 3.0)
	_burst_source_particle_process.spread = burst_source_particle_spread * lerpf(0.72, 1.18, clampf(burst_muzzle_width, 0.0, 1.0))

	_set_material_color(_burst_source_particle_material, bridge_flash_white.lerp(close_tail_color, 0.24), 1.0)
	_burst_source_particle_material.emission_energy_multiplier = 5.5 + live_strength * 8.5


func _create_additive_material(color: Color, energy: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.no_depth_test = true
	material.albedo_color = color
	material.emission_enabled = true
	material.emission = Color(color.r, color.g, color.b)
	material.emission_energy_multiplier = energy
	return material


func _set_material_color(material: StandardMaterial3D, color: Color, alpha: float) -> void:
	if material == null:
		return
	var output := color
	output.a = clampf(alpha, 0.0, 1.0)
	material.albedo_color = output
	material.emission = Color(output.r, output.g, output.b)


func _set_aux_node_visible(node: Node3D, is_visible: bool) -> void:
	if node != null:
		node.visible = is_visible


func _update_processing_state() -> void:
	set_process(_pre_flash_stars_active or _black_white_flash_active or _bridge_active or _burst_active or _tail_active or _should_process_core_energy())


func _should_process_core_energy() -> bool:
	if _core_visuals == null:
		return false
	if not core_heartbeat_enabled and not core_instability_enabled and not core_tension_whiten_enabled:
		return false
	return _core_visuals.visible and _core_visuals_current_scale_multiplier > 0.001


func _ease_in_out(value: float) -> float:
	var t := clampf(value, 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)


func _ease_in(value: float) -> float:
	var t := clampf(value, 0.0, 1.0)
	return t * t * t


func _ease_out(value: float) -> float:
	var t := clampf(value, 0.0, 1.0)
	return 1.0 - pow(1.0 - t, 3.0)
