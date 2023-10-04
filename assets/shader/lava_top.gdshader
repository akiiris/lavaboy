shader_type canvas_item;

uniform sampler2D noise_img;
uniform sampler2D texture_2;

uniform bool wavy;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv1 = vec2(fract(UV.x - TIME * 0.04), fract(UV.y - TIME * 0.02));
	vec2 uv2 = vec2(fract(UV.x - TIME * 0.1), fract(UV.y - TIME * 0.01));
	float texcol1 = texture(noise_img, uv1).r;
	float texcol2 = texture(texture_2, uv2).r;
	float energy = texcol1 * texcol2;
	energy = max(energy, 0.15);
	energy = pow(energy + 0.4, 3);
	COLOR = vec4(1.6*energy, pow(energy, 2) * 0.6, pow(energy, 2) * 0.2, texture(TEXTURE, UV).a);
	if (wavy && UV.y < 0.1) {
		COLOR.a = 0.0;
		float d = step(0.0, 3.0*(sin(TIME) + 1.0) * (sin(UV.y * 10.0)*6.0 - 2.0 + sin((UV.x + TIME * 0.1) * 6.0 * PI)));
		float a = step(0.0, 2.2*(cos((TIME + 1.0) * 3.0) + 1.0) * (sin(UV.y * 10.0)/0.2 - 1.2*abs(sin(TIME*0.1)) - 0.4 + cos((UV.x + -TIME * 0.12) * 4.0 * PI)));
		COLOR.a = step(0.3, d * a);
	}
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
