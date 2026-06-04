shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_disabled, unshaded, fog_disabled;

varying vec3 local_position;

uniform sampler2D flow_texture : repeat_enable, filter_linear_mipmap;
uniform sampler2D s_ramp_texture : repeat_disable, filter_linear;
uniform vec4 flow_color : source_color = vec4(0.52, 0.9, 1.0, 0.62);
uniform vec2 uv_scale = vec2(1.25, 3.6);
uniform vec2 flow_direction = vec2(0.0, -1.0);
uniform float flow_speed : hint_range(0.0, 4.0, 0.01) = 0.72;
uniform float secondary_speed : hint_range(0.0, 4.0, 0.01) = 0.28;
uniform float threshold : hint_range(0.0, 1.0, 0.01) = 0.58;
uniform float alpha_strength : hint_range(0.0, 2.0, 0.01) = 0.72;
uniform float emission_strength : hint_range(0.0, 6.0, 0.01) = 1.55;
uniform float head_brightness : hint_range(0.0, 6.0, 0.01) = 2.4;
uniform float s_min = 0.0;
uniform float s_max = 0.0405;
uniform bool flip_s_ramp = false;

void vertex() {
	local_position = VERTEX;
}

void fragment() {
	vec2 dir = normalize(flow_direction);
	vec2 side_dir = vec2(-dir.y, dir.x);
	vec2 flow_uv = UV * uv_scale + dir * TIME * flow_speed;
	vec2 cross_uv = UV * (uv_scale * vec2(0.72, 1.9)) + side_dir * TIME * secondary_speed - dir * TIME * 0.12;

	float main_noise = texture(flow_texture, flow_uv).r;
	float cross_noise = texture(flow_texture, cross_uv).g;
	float shaped_noise = clamp(main_noise * 0.78 + cross_noise * 0.34, 0.0, 1.0);
	float hard_streak = step(threshold, shaped_noise);
	float ramp_s = clamp((local_position.x - s_min) / max(s_max - s_min, 0.0001), 0.0, 1.0);
	ramp_s = flip_s_ramp ? 1.0 - ramp_s : ramp_s;
	vec4 s_ramp = texture(s_ramp_texture, vec2(ramp_s, 0.5));

	float alpha_mask = hard_streak * s_ramp.a;
	float brightness_mask = mix(1.0, head_brightness, s_ramp.r);

	ALBEDO = flow_color.rgb * brightness_mask;
	EMISSION = flow_color.rgb * alpha_mask * brightness_mask * emission_strength;
	ALPHA = clamp(alpha_mask * alpha_strength * flow_color.a, 0.0, 1.0);
}
