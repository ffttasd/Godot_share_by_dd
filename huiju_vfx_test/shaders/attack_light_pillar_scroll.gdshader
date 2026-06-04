shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_disabled, unshaded, fog_disabled;

uniform sampler2D noise_texture : repeat_enable, filter_linear;
uniform vec4 base_color : source_color = vec4(0.42, 0.78, 1.0, 0.42);
uniform vec4 hot_color : source_color = vec4(0.84, 0.96, 1.35, 0.85);
uniform float scroll_speed : hint_range(0.0, 12.0, 0.01) = 5.2;
uniform float uv_tiling_y : hint_range(0.25, 12.0, 0.01) = 3.6;
uniform float uv_tiling_x : hint_range(0.25, 8.0, 0.01) = 1.0;
uniform float emission_strength : hint_range(0.0, 64.0, 0.01) = 6.8;
uniform float opacity : hint_range(0.0, 1.0, 0.01) = 0.62;
uniform float contrast : hint_range(0.2, 4.0, 0.01) = 1.65;
uniform float soft_edge_width : hint_range(0.0, 0.5, 0.01) = 0.28;
uniform float end_fade_width : hint_range(0.0, 0.5, 0.01) = 0.12;
uniform float surface_brightness : hint_range(0.0, 5.0, 0.01) = 1.0;
uniform float alpha_boost : hint_range(0.0, 4.0, 0.01) = 1.0;
uniform float emission_boost : hint_range(0.0, 8.0, 0.01) = 1.0;
uniform bool stylized_ramp = false;
uniform vec4 ramp_edge_color : source_color = vec4(0.22, 0.02, 0.52, 0.45);
uniform vec4 ramp_mid_color : source_color = vec4(0.70, 0.18, 1.0, 0.72);
uniform vec4 ramp_core_color : source_color = vec4(1.25, 0.82, 1.45, 0.92);
uniform float ramp_mid_threshold : hint_range(0.0, 1.0, 0.01) = 0.34;
uniform float ramp_core_threshold : hint_range(0.0, 1.0, 0.01) = 0.68;
uniform float ramp_center_weight : hint_range(0.0, 1.0, 0.01) = 0.68;

void fragment() {
	vec2 scrolled_uv = vec2(UV.x * uv_tiling_x, UV.y * uv_tiling_y - TIME * scroll_speed);
	float noise_value = texture(noise_texture, scrolled_uv).r;
	float energy = pow(noise_value, contrast);

	float side_fade = smoothstep(0.0, soft_edge_width, UV.x) * smoothstep(1.0, 1.0 - soft_edge_width, UV.x);
	float bottom_fade = smoothstep(0.0, end_fade_width, UV.y);
	float top_fade = smoothstep(1.0, 1.0 - end_fade_width, UV.y);
	float alpha = energy * side_fade * bottom_fade * top_fade * opacity;

	vec3 color = mix(base_color.rgb, hot_color.rgb, energy);
	float emission_energy = energy;

	if (stylized_ramp) {
		float center = 1.0 - clamp(abs(UV.x - 0.5) * 2.0, 0.0, 1.0);
		float ramp_source = clamp(mix(energy, pow(center, 1.15), ramp_center_weight), 0.0, 1.0);

		color = ramp_edge_color.rgb;
		float ramp_alpha = ramp_edge_color.a;
		float ramp_emission = 0.45;

		if (ramp_source >= ramp_mid_threshold) {
			color = ramp_mid_color.rgb;
			ramp_alpha = ramp_mid_color.a;
			ramp_emission = 0.72;
		}

		if (ramp_source >= ramp_core_threshold) {
			color = ramp_core_color.rgb;
			ramp_alpha = ramp_core_color.a;
			ramp_emission = 1.0;
		}

		alpha *= ramp_alpha;
		emission_energy = ramp_emission;
	}

	ALBEDO = color * surface_brightness;
	EMISSION = color * emission_strength * emission_energy * emission_boost;
	ALPHA = clamp(alpha * alpha_boost, 0.0, 1.0);
}
