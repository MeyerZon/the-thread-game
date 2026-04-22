shader_type canvas_item;

uniform vec4 color_a : source_color = vec4(0.8, 0.8, 0.8, 1.0);  // Light gray
uniform vec4 color_b : source_color = vec4(0.6, 0.6, 0.6, 1.0);  // Darker gray
uniform int checker_size : hint_range(1, 128) = 8;

void fragment() {
    // Sample the provided texture
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Convert UV to pixel coordinates
    vec2 pixel_coord = floor(UV / TEXTURE_PIXEL_SIZE);
    
    // Get checker cell coordinates
    vec2 checker_coord = floor(pixel_coord / float(checker_size));
    
    // Alternating pattern via modulo
    float checker = mod(checker_coord.x + checker_coord.y, 2.0);
    
    // Build the checkered background
    vec4 background = mix(color_a, color_b, checker);
    
    // Composite texture on top of checker using its alpha channel
    COLOR = mix(background, tex_color, tex_color.a);
}