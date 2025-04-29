#version 150

in vec2 texcoord;
out vec4 fragColor;

/* RENDERTARGETS: 0 */
uniform sampler2D colortex0; // main color buffer
uniform sampler2D depthtex0; // depth buffer

uniform vec3 fogColor = vec3(0.7, 0.8, 1.0);
uniform float fogDensity = 0.1;
uniform vec3 cameraPosition;
uniform vec3 lightDirection = normalize(vec3(0.0, -1.0, 0.0)); // Overhead sun
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

void main() {
    vec4 sceneColor = texture(colortex0, texcoord);
    float depth = texture(depthtex0, texcoord).x;

    // Convert to NDC space
    vec4 ndc = vec4(texcoord * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);

    // Unproject to world space
    vec4 viewSpace = gbufferProjectionInverse * ndc;
    viewSpace /= viewSpace.w;
    vec4 worldSpace = gbufferModelViewInverse * viewSpace;
    vec3 worldPos = worldSpace.xyz;

    vec3 viewDir = normalize(worldPos - cameraPosition);
    float distance = length(worldPos - cameraPosition);

    // Volumetric fog based on distance
    float fogAmount = 1.0 - exp(-distance * fogDensity);
    fogAmount *= smoothstep(20.0, -10.0, worldPos.y); // thicker near ground

    // God rays based on view alignment with light
    float sunAmount = max(dot(viewDir, -lightDirection), 0.0);
    sunAmount = pow(sunAmount, 20.0);
    fogAmount += sunAmount * 0.6;

    fogAmount = clamp(fogAmount, 0.0, 1.0);

    vec3 finalColor = mix(sceneColor.rgb, fogColor, fogAmount);
    fragColor = vec4(finalColor, 1.0);
}
