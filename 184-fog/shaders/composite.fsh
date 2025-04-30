#version 150

in vec2 texcoord;
out vec4 fragColor;

/* RENDERTARGETS: 0 */
uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform vec3 fogColor = vec3(0.7, 0.8, 1.0);
uniform float fogDensity = 0.1;
uniform vec3 cameraPosition;
uniform vec3 lightDirection = normalize(vec3(0.0, -1.0, 0.0));

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

float linearizeDepth(float depth) {
    float z = depth * 2.0 - 1.0;
    float near = 0.1;  // Set these according to your actual projection
    float far = 1000.0;
    return (2.0 * near * far) / (far + near - z * (far - near));
}

void main() {
    vec4 sceneColor = texture(colortex0, texcoord);
    float depth = texture(depthtex0, texcoord).x;

    // Convert screen-space UV to NDC
    // Read raw depth
    float rawDepth = texture(depthtex0, texcoord).x;

    // Reconstruct clip-space position
    vec4 clipSpace = vec4(texcoord * 2.0 - 1.0, rawDepth * 2.0 - 1.0, 1.0);

    // Reconstruct view-space
    vec4 viewSpace = gbufferProjectionInverse * clipSpace;
    viewSpace /= viewSpace.w;

    // Reconstruct world-space
    vec4 worldSpace = gbufferModelViewInverse * viewSpace;
    vec3 worldPos = worldSpace.xyz;

    // Compute fog
    // Compute distance-based fog
    // Compute distance from camera
    float distance = length(worldPos - cameraPosition);

    // Fog fades in between 40 and 150 blocks away
    float fogStart = 40.0;
    float fogEnd = 150.0;
    float fogAmount = smoothstep(fogStart, fogEnd, distance);

    // Add vertical (height-based) modifier — more fog near the ground
    fogAmount *= smoothstep(20.0, -30.0, worldPos.y);

    // Add god rays (optional)
    vec3 viewDir = normalize(worldPos - cameraPosition);
    float sunAmount = max(dot(viewDir, -lightDirection), 0.0);
    sunAmount = pow(sunAmount, 20.0);
    fogAmount += sunAmount * 0.6;

    // Clamp final result
    fogAmount = clamp(fogAmount, 0.0, 1.0);

    vec3 finalColor = mix(sceneColor.rgb, fogColor, fogAmount);
    fragColor = vec4(finalColor, 1.0);

}
