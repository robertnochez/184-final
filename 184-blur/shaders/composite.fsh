#version 150

in vec2 texCoord;
out vec4 fragColor;

uniform sampler2D gcolor;

void main() {
    vec2 texelSize = 1.0 / vec2(textureSize(gcolor, 0)); // dynamic resolution

    vec3 result = vec3(0.0);
    float weightSum = 0.0;

    float kernel[49] = float[](
        0, 1, 2, 3, 2, 1, 0,
        1, 4, 6, 8, 6, 4, 1,
        2, 6,12,16,12, 6, 2,
        3, 8,16,24,16, 8, 3,
        2, 6,12,16,12, 6, 2,
        1, 4, 6, 8, 6, 4, 1,
        0, 1, 2, 3, 2, 1, 0
    );


    int index = 0;
    for (int x = -3; x <= 3; x++) {
        for (int y = -3; y <= 3; y++) {
            vec2 offset = vec2(float(x), float(y)) * texelSize;
            float weight = kernel[index];
            result += texture(gcolor, texCoord + offset).rgb * weight;
            weightSum += weight;
            index++;
        }
    }


    fragColor = vec4(result / weightSum, 1.0);
}
