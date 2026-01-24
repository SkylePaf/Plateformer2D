shader_type canvas_item;
uniform sampler2D palette_in : filter_nearest;
uniform sampler2D palette_out : filter_nearest;
uniform int palette_size = 5;
uniform float tolerance_percent : hint_range(0.0, 100.0) = 5.0;
uniform vec4 modulation : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);
	vec4 final_color = current_color;
	float threshold = tolerance_percent / 100.0;

	if (current_color.a > 0.0) {
		for (int i = 0; i < palette_size; i++) {
			float x_uv = (float(i) + 0.5) / float(palette_size);
			vec4 color_to_match = texture(palette_in, vec2(x_uv, 0.5));

			if (distance(current_color.rgb, color_to_match.rgb) <= threshold) {
				vec4 new_color = texture(palette_out, vec2(x_uv, 0.5));
				final_color.rgb = new_color.rgb;
				break;
			}
		}
	}

	COLOR = final_color * modulation;
}