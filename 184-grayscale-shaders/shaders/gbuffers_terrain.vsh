#version 330 compatibility

uniform mat4 gbufferModelViewInverse;

layout(location = 2) out vec4 encodedNormal;

void main() {
    vec3 normal = normalize(gl_NormalMatrix * gl_Normal); // Transform to view space
    normal = mat3(gbufferModelViewInverse) * normal;      // Transform to world space
    encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);        // Encode normal
}