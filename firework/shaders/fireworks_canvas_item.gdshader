shader_type canvas_item;
render_mode unshaded, blend_add;

const float FULL_TURN = 6.28318530718;
const int MAX_BURSTS = 6;
const int MAX_PARTICLES = 24;
const int MAX_TRAIL_SEGMENTS = 8;
const vec3 HASH_SCALE = vec3(0.1031, 0.11369, 0.13787);

uniform int burst_count = 5;
uniform int particle_count = 22;
uniform float cycle_speed : hint_range(0.05, 1.0) = 0.24;
uniform float launch_fraction : hint_range(0.15, 0.6) = 0.34;
uniform float horizontal_span : hint_range(0.5, 2.5) = 1.45;
uniform float quad_aspect : hint_range(0.5, 3.0) = 1.3333334;
uniform float visible_half_width : hint_range(1.0, 4.0) = 2.25;
uniform float visible_bottom : hint_range(-0.6, 0.1) = -0.45;
uniform float visible_top : hint_range(1.0, 3.0) = 1.9;
uniform float min_burst_height : hint_range(0.2, 1.2) = 0.62;
uniform float max_burst_height : hint_range(0.2, 1.4) = 0.98;
uniform float max_horizontal_spread : hint_range(0.1, 1.4) = 0.92;
uniform float trail_radius : hint_range(0.002, 0.08) = 0.009;
uniform float trail_visible_length : hint_range(0.03, 0.4) = 0.11;
uniform float trail_fade_length : hint_range(0.01, 0.2) = 0.05;
uniform float particle_radius : hint_range(0.002, 0.08) = 0.018;
uniform float burst_scale : hint_range(0.3, 2.5) = 1.0;
uniform float brightness : hint_range(0.25, 4.0) = 1.45;
uniform vec4 launch_base_color : source_color = vec4(1.0, 0.38, 0.12, 1.0);
uniform vec4 launch_tip_color : source_color = vec4(1.0, 0.92, 0.62, 1.0);

vec3 hash31(float p) {
	vec3 p3 = fract(vec3(p) * HASH_SCALE);
	p3 += dot(p3, p3.yzx + 19.19);
	return fract(vec3(
		(p3.x + p3.y) * p3.z,
		(p3.x + p3.z) * p3.y,
		(p3.y + p3.z) * p3.x
	));
}

float hash11(float p) {
	return hash31(p).x;
}

vec2 segment_info(vec2 p, vec2 a, vec2 b) {
	vec2 pa = p - a;
	vec2 ba = b - a;
	float denom = max(dot(ba, ba), 0.00001);
	float h = clamp(dot(pa, ba) / denom, 0.0, 1.0);
	return vec2(length(pa - ba * h), h);
}

float glow(vec2 p, vec2 center, float radius) {
	vec2 delta = p - center;
	return radius * radius / max(dot(delta, delta), 0.00002);
}

float max3(vec3 value) {
	return max(value.x, max(value.y, value.z));
}

vec3 burst_palette(float seed) {
	float pick = hash11(seed * 2.73);
	vec3 color = vec3(1.0, 0.52, 0.18);

	if (pick > 0.75) {
		color = vec3(0.45, 0.82, 1.0);
	} else if (pick > 0.5) {
		color = vec3(1.0, 0.42, 0.74);
	} else if (pick > 0.25) {
		color = vec3(1.0, 0.86, 0.38);
	}

	return color * mix(0.92, 1.15, hash11(seed + 4.7));
}

vec2 launch_curve(vec2 burst, float sway, float t) {
	float clamped_t = clamp(t, 0.0, 1.0);
	float horizontal_t = mix(clamped_t, sqrt(clamped_t), 0.18);
	float x = burst.x * horizontal_t;
	x += sin(clamped_t * PI) * sway * (1.0 - clamped_t * 0.55);
	float y = burst.y * (2.0 * clamped_t - clamped_t * clamped_t);
	return vec2(x, y);
}

vec2 closest_trail_sample(vec2 point, vec2 burst, float sway, float launch_t) {
	float start_t = max(launch_t - trail_visible_length - trail_fade_length, 0.0);
	vec2 previous_point = launch_curve(burst, sway, start_t);
	float previous_t = start_t;
	float min_distance = 10000.0;
	float nearest_t = launch_t;

	for (int segment_index = 1; segment_index <= MAX_TRAIL_SEGMENTS; segment_index++) {
		float sample_t = mix(start_t, launch_t, float(segment_index) / float(MAX_TRAIL_SEGMENTS));
		vec2 current_point = launch_curve(burst, sway, sample_t);
		vec2 info = segment_info(point, previous_point, current_point);

		if (info.x < min_distance) {
			min_distance = info.x;
			nearest_t = mix(previous_t, sample_t, info.y);
		}

		previous_point = current_point;
		previous_t = sample_t;
	}

	return vec2(min_distance, nearest_t);
}

vec2 burst_motion(vec2 burst, vec2 direction, float speed, float gravity, float drag, float t) {
	float clamped_t = clamp(t, 0.0, 1.0);
	float travel = speed * clamped_t * (1.0 - drag * clamped_t);
	vec2 position = burst + direction * travel;
	position.y -= clamped_t * clamped_t * gravity;
	return position;
}

vec3 render_firework(vec2 point, float event_seed, float phase) {
	vec3 random = hash31(event_seed);
	vec2 origin = vec2(0.0, 0.0);
	vec2 burst = vec2(
		mix(-max_horizontal_spread, max_horizontal_spread, random.x),
		mix(min_burst_height, max_burst_height, random.y)
	);
	float sway = (random.z - 0.5) * 0.22;
	vec3 burst_color = burst_palette(event_seed);
	vec3 color = vec3(0.0);

	float launch_t = clamp(phase / max(launch_fraction, 0.001), 0.0, 1.0);
	float burst_t = clamp((phase - launch_fraction) / max(1.0 - launch_fraction, 0.001), 0.0, 1.0);

	if (phase < launch_fraction) {
		vec2 rocket = launch_curve(burst, sway, launch_t);

		vec2 trail_sample = closest_trail_sample(point, burst, sway, launch_t);
		float age = launch_t - trail_sample.y;
		float short_tail = 1.0 - smoothstep(trail_visible_length, trail_visible_length + trail_fade_length, age);
		float head_focus = pow(clamp(1.0 - age / max(trail_visible_length, 0.001), 0.0, 1.0), 1.35);
		float trail = 1.0 - smoothstep(trail_radius * 0.25, trail_radius * 1.45, trail_sample.x);
		trail *= short_tail;
		trail *= mix(0.08, 1.0, head_focus);

		vec3 trail_color = mix(launch_base_color.rgb, launch_tip_color.rgb, clamp(head_focus * 1.2, 0.0, 1.0));
		float flicker = 0.82 + 0.18 * sin(TIME * 17.0 + event_seed * 2.4);

		color += trail_color * trail * flicker * 1.18;
		color += launch_tip_color.rgb * glow(point, rocket, trail_radius * 1.1) * 0.055;
		color += launch_base_color.rgb * glow(point, origin, trail_radius * 1.6) * 0.01 * (1.0 - launch_t);
	} else {
		float fade = 1.0 - smoothstep(0.65, 1.0, burst_t);
		float flash = 1.0 - smoothstep(0.0, 0.14, burst_t);

		color += vec3(1.0, 0.96, 0.86) * glow(point, burst, mix(0.09, 0.03, burst_t)) * 0.055 * flash;

		for (int particle_index = 0; particle_index < MAX_PARTICLES; particle_index++) {
			if (particle_index >= particle_count) {
				continue;
			}

			vec3 particle_random = hash31(event_seed * 13.17 + float(particle_index) * 1.937);
			float angle = particle_random.x * FULL_TURN;
			float speed = mix(0.24, 0.76, particle_random.y) * burst_scale;
			float gravity = mix(0.06, 0.34, particle_random.z);
			float drag = mix(0.08, 0.3, hash11(event_seed + float(particle_index) * 0.73));
			vec2 direction = normalize(vec2(cos(angle), sin(angle) * mix(0.92, 1.18, hash11(event_seed + float(particle_index) * 1.19))));
			vec2 spark_position = burst_motion(burst, direction, speed, gravity, drag, burst_t);
			float previous_t = max(burst_t - 0.055, 0.0);
			vec2 previous_position = burst_motion(burst, direction, speed, gravity, drag, previous_t);

			float radius = mix(particle_radius * 1.4, particle_radius * 0.22, burst_t);
			radius *= mix(0.85, 1.55, particle_random.z);
			float trail_radius_local = radius * mix(0.8, 1.35, particle_random.y);

			float twinkle = 0.5 + 0.5 * sin(
				TIME * mix(11.0, 23.0, particle_random.x) +
				float(particle_index) * 3.7 +
				event_seed
			);
			twinkle = pow(clamp(twinkle, 0.0, 1.0), mix(1.4, 5.2, particle_random.y));

			vec2 spark_trail = segment_info(point, previous_position, spark_position);
			float streak = 1.0 - smoothstep(trail_radius_local * 0.45, trail_radius_local * 1.8, spark_trail.x);
			streak *= mix(0.35, 1.0, twinkle) * fade;
			float spark = glow(point, spark_position, radius);
			spark *= mix(0.25, 1.0, particle_random.y) * fade * (0.55 + twinkle);

			color += burst_color * streak * 0.072;
			color += burst_color * spark * 0.05;
			color += vec3(1.0, 0.96, 0.86) * spark * 0.012 * flash;

			float ember_t = clamp((burst_t - 0.08) / 0.92, 0.0, 1.0);
			vec2 ember_position = burst_motion(burst, direction, speed * 0.58, gravity + 0.08, drag * 0.65, ember_t);
			float ember_radius = radius * mix(0.32, 0.58, particle_random.x);
			float ember = glow(point, ember_position, ember_radius);
			ember *= (1.0 - smoothstep(0.45, 1.0, burst_t)) * (0.45 + 0.4 * (1.0 - particle_random.y));
			color += mix(burst_color, vec3(1.0, 0.48, 0.18), 0.6) * ember * 0.018;
		}
	}

	return color;
}

void fragment() {
	vec2 quad_uv = vec2(UV.x, 1.0 - UV.y);
	vec2 point = vec2(
		mix(-visible_half_width, visible_half_width, quad_uv.x),
		mix(visible_bottom, visible_top, quad_uv.y)
	);
	vec3 color = vec3(0.0);
	float timeline = TIME * cycle_speed;

	for (int burst_index = 0; burst_index < MAX_BURSTS; burst_index++) {
		if (burst_index >= burst_count) {
			continue;
		}

		float slot_time = timeline + float(burst_index) * 0.237;
		float cycle_id = floor(slot_time);
		float phase = fract(slot_time);
		float event_seed = cycle_id * 37.0 + float(burst_index) * 17.0 + 11.3;

		color += render_firework(point, event_seed, phase);
	}

	color *= brightness;

	float alpha = clamp(max3(color) * 0.42, 0.0, 1.0);
	COLOR = vec4(color, alpha);
}
