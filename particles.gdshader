shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_disabled, ambient_light_disabled;

uniform vec4 albedo : source_color;

void vertex() {
	float rotation = INSTANCE_CUSTOM.x;
	float cosine = cos(rotation);
	float sine = sin(rotation);

	mat4 world_matrix = mat4(
		normalize(INV_VIEW_MATRIX[0]),
		normalize(INV_VIEW_MATRIX[1]),
		normalize(INV_VIEW_MATRIX[2]),
		MODEL_MATRIX[3]
	);

	world_matrix = world_matrix * mat4(
		vec4(cosine, -sine, 0.0, 0.0),
		vec4(sine, cosine, 0.0, 0.0),
		vec4(0.0, 0.0, 1.0, 0.0),
		vec4(0.0, 0.0, 0.0, 1.0)
	);

	vec4 clip_space_center = PROJECTION_MATRIX * (VIEW_MATRIX * (world_matrix * vec4(0.0, 0.0, 0.0, 1.0)));
	vec2 pixel_size = 2.0 / VIEWPORT_SIZE;
	vec2 snapped_center = round((clip_space_center.xy / clip_space_center.w) / pixel_size) * pixel_size;

	vec4 clip_space_vertex = PROJECTION_MATRIX * (VIEW_MATRIX * (world_matrix * vec4(VERTEX, 1.0)));
	vec2 vertex_offset = (clip_space_vertex.xy / clip_space_vertex.w) - (clip_space_center.xy / clip_space_center.w);
	vec2 corner_sign = vec2(
		vertex_offset.x >= 0.0 ? 1.0 : -1.0,
		vertex_offset.y >= 0.0 ? 1.0 : -1.0
	);
	
	vec2 snapped_vertex = snapped_center + 0.5 * pixel_size * corner_sign;

	POSITION = vec4(snapped_vertex * clip_space_center.w, clip_space_vertex.z, clip_space_center.w);
}

void fragment() {
	ALBEDO = albedo.rgb;
	ALPHA = COLOR.a;
}

void light() {
	DIFFUSE_LIGHT += LIGHT_COLOR * ATTENUATION;
}