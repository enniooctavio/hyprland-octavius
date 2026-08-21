#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    // Puxa a cor limpa da tela
    vec4 color = texture(tex, v_texcoord);

    // 1. EFEITO SCANLINE (Linhas horizontais)
    // Multiplique o 800.0 por um valor maior se quiser linhas mais finas
    float scanline = sin(v_texcoord.y * 800.0) * 0.03; 
    color.rgb -= scanline;

    // 2. EFEITO VIGNETTE (Bordas escuras)
    // Calcula a distância do centro da tela (0.5, 0.5)
    vec2 center = v_texcoord - 0.5;
    float dist = length(center);
    // Escurece os cantos gradativamente
    color.rgb *= 1.0 - (dist * dist * 0.6);

    fragColor = color;
}
