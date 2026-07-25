shader_type canvas_item;

uniform vec4 edge_color : source_color = vec4(1.0);
uniform float edge_width : hint_range(0.0, 0.5) = 0.25;
uniform float center_x : hint_range(0.0, 1.0) = 0.5;
uniform float glow_half_width : hint_range(0.0, 1.0) = 0.4;
uniform float strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	float vertical = 1.0 - smoothstep(0.0, edge_width, UV.y);
	float horizontal = 1.0 - smoothstep(0.0, glow_half_width, abs(UV.x - center_x));
	COLOR = vec4(edge_color.rgb, vertical * horizontal * edge_color.a * strength);
}