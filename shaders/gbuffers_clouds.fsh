#version 150

in vec2 texcoord_out;
out vec4 fragColor;
uniform sampler2D texture;
uniform float time;

void main() {
    float wave = sin(texcoord_out.x * 15.0 + time * 1.0) * 0.03;
    vec2 animatedTextureCoord = texcoord_out + vec2(time, wave);
    vec4 base = texture2D(texture, animatedTextureCoord);
    fragColor = vec4(vec3(1.0), base.a * 0.4);
}
