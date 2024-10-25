shader_type spatial;

uniform vec3 path_color : source_color = vec3(0.75, 0.75, 0.75);
uniform vec3 path_color_2 : source_color = vec3(0.65, 0.65, 0.65);
uniform sampler2D noise_texture;

void vertex() {
    // Add subtle height variation to follow terrain
    vec2 noise_uv = UV * 10.0;
    float noise = texture(noise_texture, noise_uv).r * 0.1;
    VERTEX.y += noise * 0.1;
}

void fragment() {
    // Add variation to the path color
    float noise = texture(noise_texture, UV * 5.0).r;
    vec3 color = mix(path_color, path_color_2, noise);
    
    // Add some subtle texture and wear at the edges
    float edge_wear = 1.0 - smoothstep(0.2, 0.8, abs(UV.x - 0.5) * 2.0);
    color = mix(color * 0.9, color, edge_wear);
    
    // Add some darker spots for variation
    float spots = texture(noise_texture, UV * 20.0).r;
    color = mix(color * 0.9, color, spots);
    
    ALBEDO = color;
    ROUGHNESS = mix(0.9, 1.0, spots);
    SPECULAR = 0.1;
}