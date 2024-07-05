shader_type canvas_item;

uniform sampler2D texture0;
uniform sampler2D texture1;

varying vec2 texCoord;

void main()
{
    vec4 color0 = texture(texture0, texCoord);
    vec4 color1 = texture(texture1, texCoord);

    color0 * color1; // 纹理颜色相乘
}

//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	vec4 color0 = texture(texture0, texCoord);
	vec4 color1 = texture(texture1, texCoord);

	COLOR = color0 + color1; // 纹理颜色相乘
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
