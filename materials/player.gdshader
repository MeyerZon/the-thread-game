shader_type canvas_item;

uniform float hue : hint_range(0.0, 1.0) = 0.0;
uniform float saturation : hint_range(0.0, 1.0) = 0.8;
uniform float contour_threshold : hint_range(0.0, 0.3) = 0.15;

vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + vec3(1.0, 2.0/3.0, 1.0/3.0)) * 6.0 - 3.0);
    return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float value = tex.r;
    
    float sat = (value < contour_threshold) ? 0.0 : saturation;
    vec3 color = hsv2rgb(vec3(hue, sat, value));
    
    COLOR = vec4(color, tex.a);
}