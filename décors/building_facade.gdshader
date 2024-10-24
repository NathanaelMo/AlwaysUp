shader_type spatial;

uniform vec3 base_color : source_color = vec3(0.85, 0.82, 0.78);
uniform vec3 dark_color : source_color = vec3(0.65, 0.62, 0.58); // Couleur plus sombre
uniform float roughness : hint_range(0.0, 1.0) = 0.8; // Rugosité augmentée

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float plaster_pattern(vec2 uv) {
    float n = 0.0;
    float amplitude = 1.5; // Amplitude augmentée
    float frequency = 2.0; // Fréquence augmentée
    
    for(int i = 0; i < 5; i++) { // Une itération de plus
        n += noise(uv * frequency) * amplitude;
        frequency *= 2.5; // Multiplication plus importante
        amplitude *= 0.6; // Réduction plus lente
    }
    
    return n;
}

void fragment() {
    vec2 scaled_uv = UV * 30.0; // Échelle augmentée
    float pattern = plaster_pattern(scaled_uv);
    vec3 color = mix(dark_color, base_color, pattern);
    float small_detail = noise(scaled_uv * 80.0) * 0.2; // Plus de détails
    color += vec3(small_detail);
    
    ALBEDO = color;
    ROUGHNESS = roughness + small_detail * 0.2; // Plus de variation de rugosité
    NORMAL = normalize(vec3(pattern * 0.4, pattern * 0.4, 1.0)); // Relief plus prononcé
}