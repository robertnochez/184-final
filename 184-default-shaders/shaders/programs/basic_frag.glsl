//uniforms
uniform sampler2D gtexture;

//vertexToFragment
in vec2 texCoord;
in vec3 foliageColor;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0; //colortex0 - outcolor


void main() {

    //input color
    vec4 outputColorData = texture(gtexture,texCoord);
    vec3 albedo = pow(outputColorData.rgb,vec3(2.2)) * pow(foliageColor,vec3(2.2));
    float transparency = outputColorData.a;

    if (transparency < .1) {
        discard;
    }

    //output color
    outColor0 = vec4(pow(albedo,vec3(1/2.2)),transparency);

}
