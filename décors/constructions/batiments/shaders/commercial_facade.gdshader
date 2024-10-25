shader_type spatial;

uniform vec3 base_color : source_color = vec3(0.9, 0.88, 0.85);
uniform vec3 accent_color : source_color = vec3(0.82, 0.80, 0.75);
uniform float roughness : hint_range(0.0, 1.0) = 0.6;

// Fonction pour créer des motifs en grille
float grid_pattern(vec2 uv, float size) {
    vec2 grid = fract(uv * size);
    return step(0.05, grid.x) * step(0.05, grid.y);
}

// Fonction de bruit modifiée pour des motifs plus réguliers
float modern_noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    vec2 s = smoothstep(0.0, 1.0, f);
    
    float a = fract(sin(dot(i, vec2(12.9898, 78.233))) * 43758.5453);
    float b = fract(sin(dot(i + vec2(1.0, 0.0), vec2(12.9898, 78.233))) * 43758.5453);
    float c = fract(sin(dot(i + vec2(0.0, 1.0), vec2(12.9898, 78.233))) * 43758.5453);
    float d = fract(sin(dot(i + vec2(1.0, 1.0), vec2(12.9898, 78.233))) * 43758.5453);
    
    return mix(mix(a, b, s.x), mix(c, d, s.x), s.y);
}

float commercial_pattern(vec2 uv) {
    float pattern = 0.0;
    
    // Motif de base avec des lignes horizontales plus prononcées
    pattern += modern_noise(uv * 15.0) * 0.5;
    
    // Ajout d'un motif de grille subtil
    pattern += grid_pattern(uv, 20.0) * 0.1;
    
    // Bandes horizontales subtiles
    float horizontal_lines = step(0.98, fract(uv.y * 15.0)) * 0.1;
    pattern += horizontal_lines;
    
    // Variation verticale pour donner un aspect plus moderne
    pattern += sin(uv.x * 30.0) * 0.02;
    
    return clamp(pattern, 0.0, 1.0);
}

void fragment() {
    vec2 scaled_uv = UV * 40.0;
    float pattern = commercial_pattern(scaled_uv);
    
    // Variation de couleur plus subtile pour un look commercial
    vec3 color = mix(accent_color, base_color, pattern);
    
    // Ajout de détails architecturaux modernes
    float architectural_detail = modern_noise(scaled_uv * 2.0) * 0.05;
    color += vec3(architectural_detail);
    
    // Application d'un effet de brillance subtil
    float shine = pow(modern_noise(scaled_uv * 5.0), 3.0) * 0.1;
    
    ALBEDO = color + shine;
    ROUGHNESS = roughness - pattern * 0.3; // Surface plus lisse aux endroits des motifs
    METALLIC = shine * 0.5; // Légère variation métallique
    
    // Normal mapping plus subtil pour un aspect plus lisse
    float normal_strength = 0.1;
    NORMAL = normalize(vec3(pattern * normal_strength, pattern * normal_strength, 1.0));
}