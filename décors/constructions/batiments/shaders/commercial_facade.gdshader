shader_type spatial;

uniform vec3 base_color : source_color = vec3(0.85, 0.82, 0.78);
uniform vec3 dark_color : source_color = vec3(0.65, 0.62, 0.58);
uniform float night_darkness : hint_range(0.0, 1.0) = 0.9; // Réduit à 0.7 pour plus de visibilité
uniform vec3 night_tint : source_color = vec3(0.7, 0.85, 1.0); // Bleu plus clair
uniform float ambient_light : hint_range(0.0, 1.0) = 5.0; // Lumière ambiante minimale
uniform float window_density : hint_range(0.0, 1.0) = 5.0; // Densité des fenêtres éclairées

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float grid_pattern(vec2 uv, float size) {
    vec2 grid = fract(uv * size);
    return step(0.05, grid.x) * step(0.05, grid.y);
}

float windows(vec2 uv) {
    // Génère un motif de fenêtres plus régulier pour un commerce
    vec2 grid = floor(uv * 15.0); // Augmenté pour plus de fenêtres
    float r = random(grid);
    return step(1.0 - window_density, r) * 0.7; // Augmenté pour plus de luminosité
}

void fragment() {
    vec2 scaled_uv = UV * 20.0;
    float pattern = noise(scaled_uv);
    
    // Ajoute un motif commercial
    pattern += grid_pattern(UV, 30.0) * 0.1;
    
    vec3 color = mix(dark_color, base_color, pattern);
    float detail = noise(scaled_uv * 40.0) * 0.1;
    color += vec3(detail);
    
    // Fenêtres éclairées plus grandes et plus lumineuses
    float window_light = windows(UV);
    
    // Éclairage nocturne
    color = mix(color * (1.0 - night_darkness), color, ambient_light);
    color = mix(color, color * night_tint, 0.3);
    
    // Fenêtres plus brillantes pour un commerce
    color += vec3(1.0, 0.95, 0.8) * window_light * 1.2;
    
    ALBEDO = color;
}