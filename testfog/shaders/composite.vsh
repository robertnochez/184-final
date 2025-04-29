#version 150

in vec4 vaPosition;
out vec2 texcoord;

void main() {
    gl_Position = vaPosition;
    texcoord = vaPosition.xy * 0.5 + 0.5;
}
