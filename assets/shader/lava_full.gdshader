shader_type canvas_item;

uniform sampler2D noise_img;
uniform sampler2D texture_2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv1 = vec2(fract(UV.x + TIME * 0.05), fract(UV.y + TIME * 0.05));
	vec2 uv2 = vec2(fract(UV.x + TIME * 0.1), fract(UV.y + TIME * 0.1));
	float texcol1 = texture(noise_img, uv1).r;
	float texcol2 = texture(texture_2, uv2).r;
	float energy = texcol1 * texcol2;
	energy = max(energy, 0.15);
	energy = energy + 0.4;
	energy = pow(energy, 3);
	COLOR = vec4(energy, pow(energy, 2) * 0.6, pow(energy, 2) * 0.2, texture(TEXTURE, UV).a);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
