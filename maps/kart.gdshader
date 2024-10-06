shader_type spatial;

uniform vec2 grid_size = vec2(0.1, 0.1); // Размеры ячеек решётки
uniform vec4 line_color = vec4(1.0, 1.0, 1.0, 1.0); // Цвет линий решётки
uniform vec4 fill_color = vec4(0.0, 0.0, 0.0, 0.0); // Цвет заполнения ячеек

void fragment() {
    vec2 uv = UV.xy / grid_size;
    vec2 grid = fract(uv);
    
    float line_width = 0.4; // Ширина линий решётки
    float line = step(line_width, grid.x) * step(line_width, grid.y);
    
    vec4 color = mix(line_color, fill_color, line);
    ALBEDO = color.rgb;
    ALPHA = color.a;
}