shader_type canvas_item;

uniform float offset = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_enable, filter_nearest;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float wrap_y = mod(SCREEN_UV.y+offset,0.48);
	COLOR = texture(screen_texture,vec2(SCREEN_UV.x,wrap_y));
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
