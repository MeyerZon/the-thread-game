shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float swirl_speed : hint_range(0.1, 5.0) = 1.0;
uniform float swirl_strength : hint_range(0.0, 0.2) = 0.05;

void vertex() {
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float darkness = 1.0 - tex.r;

	vec2 centered = UV - vec2(0.5);
	float angle = darkness * swirl_strength * sin(TIME * swirl_speed + length(centered) * 20.0);

	float s = sin(angle);
	float c = cos(angle);
	vec2 swirled_uv = vec2(
		centered.x * c - centered.y * s,
		centered.x * s + centered.y * c
	) + vec2(0.5);

	// Clamp so we never sample outside the frame
	swirled_uv = clamp(swirled_uv, vec2(0.01), vec2(0.99));

	vec4 swirled_tex = texture(TEXTURE, swirled_uv);

	// Use the ORIGINAL alpha so no new pixels appear outside the sprite
	COLOR = vec4(tint_color.rgb * swirled_tex.r, tex.a);
}

//void light() {
//}