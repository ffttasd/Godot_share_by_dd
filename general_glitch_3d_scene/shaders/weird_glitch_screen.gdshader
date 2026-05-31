shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform float intensity : hint_range(0.0, 1.0) = 0.82;
uniform vec4 tint_color : source_color = vec4(0.9, 0.98, 1.0, 1.0);

const float GLITCH_CHANCE = 1.0;
const float GLITCH_SPEED = 18.0;
const float SLICE_DENSITY = 32.0;
const float SLICE_STRENGTH = 0.58;
const float SHAKE_STRENGTH = 0.038;
const float CHROMA_OFFSET = 0.03;
const float NOISE_STRENGTH = 0.34;
const float COLOR_FLASH_STRENGTH = 0.5;
const float SCANLINE_STRENGTH = 0.3;
const float LOCAL_WARP_STRENGTH = 0.2;
const float FLIP_CHANCE = 0.24;


float rand(float x) {
	return fract(sin(x * 143758.5453) * 43758.5453);
}


float rand2(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}


vec3 sample_screen_rgb(vec2 uv) {
	return texture(screen_texture, clamp(uv, vec2(0.0), vec2(1.0))).rgb;
}


void fragment() {
	vec2 original_uv = SCREEN_UV;
	vec3 original = sample_screen_rgb(original_uv);
	float amount = clamp(intensity, 0.0, 1.0);

	if (amount <= 0.001) {
		COLOR = vec4(original, 1.0);
	} else {
		vec2 uv = original_uv;
		float time_step = floor(TIME * GLITCH_SPEED);
		float glitch = step(1.0 - GLITCH_CHANCE, rand(time_step));
		float active = glitch * amount;

		float slice_id = floor(uv.y * SLICE_DENSITY + rand(floor(TIME)));
		float slice_rand = rand(slice_id + time_step);
		float slice_mask = step(0.5, slice_rand) * active;

		if (rand(slice_id * max(TIME, 0.01)) < FLIP_CHANCE * active) {
			uv.x = 1.0 - uv.x;
		}

		uv.x += (slice_rand - 0.5) * SLICE_STRENGTH * slice_mask;

		float jitter = step(0.85, rand(TIME * 12.0)) * active;
		uv.x += (rand(TIME * 3.0) - 0.5) * 0.08 * jitter;

		float warp_zone = step(0.65, rand2(vec2(slice_id, TIME)));
		uv += (vec2(rand2(uv + TIME), rand2(uv - TIME)) - 0.5) * LOCAL_WARP_STRENGTH * warp_zone * active;

		uv += vec2(rand(TIME * 1.3) - 0.5, rand(TIME * 1.7) - 0.5) * SHAKE_STRENGTH * active;

		vec3 base = sample_screen_rgb(uv);
		float red = sample_screen_rgb(uv + vec2(CHROMA_OFFSET * active, 0.0)).r;
		float blue = sample_screen_rgb(uv - vec2(CHROMA_OFFSET * active, 0.0)).b;
		vec3 color = vec3(red, base.g, blue) * tint_color.rgb;

		color += (rand2(uv * max(TIME, 0.01) * 1.5) - 0.5) * NOISE_STRENGTH * active;

		float scan = step(0.9, rand(uv.y * 100.0 + TIME * 10.0));
		color *= 1.0 - scan * SCANLINE_STRENGTH * active;

		vec3 flash_color = vec3(
			step(0.5, rand(TIME + 0.1)),
			step(0.5, rand(TIME + 3.1)),
			step(0.5, rand(TIME + 6.1))
		);
		color = mix(color, flash_color, rand(TIME * 4.0) * COLOR_FLASH_STRENGTH * active);
		color = clamp(color, vec3(0.0), vec3(1.0));

		COLOR = vec4(mix(original, color, amount), 1.0);
	}
}
