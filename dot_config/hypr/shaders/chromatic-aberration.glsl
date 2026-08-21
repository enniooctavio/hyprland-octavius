#version 100
precision mediump float;

varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec2 uv = v_texcoord;
    
    // Offset suave para manter a leitura nítida e o visual cyberpunk
    float offset = 0.0008;
    
    vec4 red = texture2D(tex, uv + vec2(offset, 0.0));
    vec4 green = texture2D(tex, uv);
    vec4 blue = texture2D(tex, uv - vec2(offset, 0.0));
    
    gl_FragColor = vec4(red.r, green.g, blue.b, green.a);
}
