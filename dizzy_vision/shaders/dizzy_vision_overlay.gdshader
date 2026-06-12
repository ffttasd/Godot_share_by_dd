shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform float intensity : hint_range(0.0, 1.0) = 0.78;
uniform float distortion_strength_px : hint_range(0.0, 80.0) = 30.0;
uniform float blur_strength_px : hint_range(0.0, 30.0) = 7.0;
uniform float sway_strength_px : hint_range(0.0, 80.0) = 18.0;
uniform float pulse_strength : hint_range(0.0, 1.0) = 0.0;
uniform vec2 focus_center = vec2(0.5, 0.58);
uniform float focus_radius : hint_range(0.0, 0.8) = 0.16;
uniform float focus_feather : hint_range(0.01, 0.8) = 0.34;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.46;
uniform vec4 tint_color : source_color = vec4(0.46, 0.62, 0.88, 0.18);
uniform float desaturation : hint_range(0.0, 1.0) = 0.36;

vec2 screen_pixel_size() {
	return 1.0 / vec2(textureSize(screen_texture, 0));
}

vec3 sample_screen_rgb(vec2 uv, float lod) {
	return textureLod(screen_texture, clamp(uv, vec2(0.001), vec2(0.999)), lod).rgb;
}

float luminance(vec3 color) {
	return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

float hash12(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

float noise12(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash12(i);
	float b = hash12(i + vec2(1.0, 0.0));
	float c = hash12(i + vec2(0.0, 1.0));
	float d = hash12(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
	float value = 0.0;
	float amplitude = 0.5;
	for (int i = 0; i < 4; i++) {
		value += noise12(p) * amplitude;
		p = p * 2.03 + vec2(7.7, 3.1);
		amplitude *= 0.5;
	}
	return value;
}

float focus_edge_mask(vec2 uv) {
	vec2 size = vec2(textureSize(screen_texture, 0));
	float aspect = size.x / max(size.y, 1.0);
	vec2 focus_delta = (uv - focus_center) * vec2(aspect, 1.0);
	float focus_distance = length(focus_delta);
	float away_from_focus = smoothstep(focus_radius, focus_radius + focus_feather, focus_distance);
	vec2 centered = uv * 2.0 - 1.0;
	float border = smoothstep(0.34, 1.0, max(abs(centered.x), abs(centered.y)));
	return clamp(max(away_from_focus, border * 0.72), 0.0, 1.0);
}

vec2 distortion_offset_uv(vec2 uv, float edge, float total_intensity) {
	float t = TIME;
	vec2 px = screen_pixel_size();
	float macro_noise = fbm(uv * 3.1 + vec2(t * 0.52, -t * 0.37)) - 0.5;
	float fine_noise = fbm(uv * 10.5 + vec2(-t * 0.95, t * 0.71)) - 0.5;
	float wave_x = sin(uv.y * 15.0 + t * 5.2 + sin(uv.x * 7.0 - t * 2.1));
	float wave_y = sin(uv.x * 12.0 - t * 4.4 + cos(uv.y * 8.0 + t * 2.7));
	vec2 local_warp = vec2(
		wave_x * 0.62 + macro_noise * 1.35 + fine_noise * 0.36,
		wave_y * 0.52 - macro_noise * 0.74 + fine_noise * 0.58
	);
	vec2 sway = vec2(
		sin(t * 1.7 + uv.y * 3.4) + sin(t * 3.1 + uv.x * 1.8) * 0.35,
		cos(t * 1.35 + uv.x * 2.6) + sin(t * 2.6 + uv.y * 1.7) * 0.28
	);
	float pulse_gain = 1.0 + pulse_strength * 1.55;
	float center_protection = mix(0.22, 1.0, edge);
	vec2 offset_px = local_warp * distortion_strength_px + sway * sway_strength_px * (0.42 + edge * 0.78);
	offset_px *= total_intensity * pulse_gain * center_protection;
	return offset_px * px;
}

vec3 blurred_color(vec2 uv, vec3 base, float edge, float total_intensity) {
	float blur_px = blur_strength_px * total_intensity * (0.42 + edge * 0.9) * (1.0 + pulse_strength * 0.65);
	if (blur_px <= 0.001) {
		return base;
	}

	vec2 px = screen_pixel_size() * blur_px;
	float lod = clamp(blur_px * 0.095, 0.0, 4.0);
	vec3 color = base * 0.24;
	color += sample_screen_rgb(uv + vec2(px.x, 0.0), lod) * 0.12;
	color += sample_screen_rgb(uv - vec2(px.x, 0.0), lod) * 0.12;
	color += sample_screen_rgb(uv + vec2(0.0, px.y), lod) * 0.12;
	color += sample_screen_rgb(uv - vec2(0.0, px.y), lod) * 0.12;
	color += sample_screen_rgb(uv + px, lod) * 0.07;
	color += sample_screen_rgb(uv - px, lod) * 0.07;
	color += sample_screen_rgb(uv + vec2(px.x, -px.y), lod) * 0.07;
	color += sample_screen_rgb(uv + vec2(-px.x, px.y), lod) * 0.07;
	return color;
}

vec3 apply_chromatic(vec2 uv, vec3 color, float edge, float total_intensity) {
	vec2 size = vec2(textureSize(screen_texture, 0));
	float aspect = size.x / max(size.y, 1.0);
	vec2 direction = (uv - focus_center) * vec2(aspect, 1.0);
	if (length(direction) <= 0.0001) {
		return color;
	}

	vec2 chroma_uv = normalize(direction) * screen_pixel_size() * (2.0 + pulse_strength * 5.0) * edge * total_intensity;
	float red = sample_screen_rgb(uv + chroma_uv, 0.0).r;
	float blue = sample_screen_rgb(uv - chroma_uv, 0.0).b;
	return vec3(red, color.g, blue);
}

vec3 apply_grade(vec2 uv, vec3 color, float edge, float total_intensity) {
	float gray = luminance(color);
	float desat_amount = clamp(desaturation * total_intensity * (0.55 + edge * 0.45), 0.0, 1.0);
	color = mix(color, vec3(gray), desat_amount);
	color = mix(color, tint_color.rgb, clamp(tint_color.a * total_intensity * (0.72 + pulse_strength * 0.34), 0.0, 1.0));

	vec2 centered = uv * 2.0 - 1.0;
	float vignette = smoothstep(0.28, 1.08, max(abs(centered.x), abs(centered.y)));
	float darken = clamp(vignette * vignette_strength * total_intensity, 0.0, 0.72);
	color = mix(color, vec3(0.006, 0.009, 0.014), darken);
	return color;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	float total_intensity = clamp(max(intensity, pulse_strength), 0.0, 1.0);
	vec3 original = sample_screen_rgb(uv, 0.0);
	vec3 output_color = original;

	if (total_intensity > 0.001) {
		float edge = focus_edge_mask(uv);
		vec2 warped_uv = clamp(uv + distortion_offset_uv(uv, edge, total_intensity), vec2(0.001), vec2(0.999));
		vec3 base = sample_screen_rgb(warped_uv, 0.0);
		vec3 color = blurred_color(warped_uv, base, edge, total_intensity);
		color = apply_chromatic(warped_uv, color, edge, total_intensity);
		color = apply_grade(uv, color, edge, total_intensity);
		output_color = mix(original, color, total_intensity);
	}

	COLOR = vec4(output_color, 1.0);
}
