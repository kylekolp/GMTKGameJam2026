shader_type canvas_item;

uniform vec4 edge_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float edge_width : hint_range(0.0, 0.5) = 0.2;
uniform float strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	float edge_x = min(UV.x, 1.0 - UV.x);
	float edge_y = min(UV.y, 1.0 - UV.y);
	float edge_dist = min(edge_x, edge_y);
	float glow = 1.0 - smoothstep(0.0, edge_width, edge_dist);
	COLOR = vec4(edge_color.rgb, glow * edge_color.a * strength);
}
