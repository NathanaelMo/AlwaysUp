shader_type spatial;

uniform vec3 wood_color : source_color = vec3(0.6, 0.3, 0.1);
uniform float roughness : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    ALBEDO = wood_color;
    ROUGHNESS = roughness;
    SPECULAR = 0.0;
    METALLIC = 0.0;
}