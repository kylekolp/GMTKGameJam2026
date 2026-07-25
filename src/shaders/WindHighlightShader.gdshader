shader_type canvas_item;

// Outline Uniforms
uniform bool show_outline = true;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 1.0;

// Wind Uniforms
uniform float wind_speed : hint_range(0.0, 10.0) = 2.0;
uniform float wind_strength : hint_range(0.0, 50.0) = 5.0;
uniform float height_multiplier : hint_range(0.0, 2.0) = 1.0;

void vertex() {
    // Use the vertex position Y (or UV.y mask) to restrict wind to the top/tips
    // Assuming mesh/sprite origin is at the bottom, VERTEX.y grows negative upwards or positive downwards depending on setup.
    // Let's use a simple height factor based on local position:
    float height_factor = clamp(1.0 - UV.y, 0.0, 1.0); // 0 at bottom, 1 at top
    
    // Apply sine wave motion offset based on TIME and vertex position
    float wind_offset = sin(TIME * wind_speed + VERTEX.x * 0.1) * wind_strength * height_factor * height_multiplier;
    
    // Shift vertex along X axis
    VERTEX.x += wind_offset;
}

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * outline_width;
    vec4 base_color = texture(TEXTURE, UV);
    
    if (show_outline && base_color.a == 0.0) {
        float alpha = 0.0;
        alpha += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
        alpha += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
        alpha += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
        alpha += texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
        
        if (alpha > 0.0) {
            COLOR = outline_color;
        } else {
            COLOR = base_color;
        }
    } else {
        COLOR = base_color;
    }
}