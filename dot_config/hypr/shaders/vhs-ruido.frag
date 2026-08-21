#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
    vec4 color = texture(tex, v_texcoord);
    
    // Calcula o ruído puramente baseado nas coordenadas do pixel
    float noise = random(v_texcoord);
    
    // Intensidade da textura (0.05 é bem sutil)
    color.rgb += (noise - 0.5) * 0.05;
    
    fragColor = color;
}
