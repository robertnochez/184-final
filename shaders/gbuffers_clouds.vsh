#version 150

in vec3 position;
in vec2 texcoord;
out vec2 texcoord_out;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

void main() {
    texcoord_out = texcoord;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
