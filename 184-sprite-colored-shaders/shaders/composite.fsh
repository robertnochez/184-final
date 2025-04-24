#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

const vec3 blocklightColor = vec3(1.0, 0.5, 0.08);
const vec3 skylightColor = vec3(0.05, 0.15, 0.3);
const vec3 sunlightColor = vec3(1.0);
const vec3 ambientColor = vec3(0.1);

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
  vec4 homPos = projectionMatrix * vec4(position, 1.0);
  return homPos.xyz / homPos.w;
}

void main() {
    

	color = texture(colortex0, texcoord);
color.rgb = pow(color.rgb, vec3(2.2));

    vec2 lightmap = texture(colortex1, texcoord).rg; // we only need the r and g components
    vec3 encodedNormal = texture(colortex2, texcoord).rgb;
    vec3 normal = normalize((encodedNormal - 0.5) * 2.0); // we normalize to make sure it is of unit length

    vec3 lightVector = normalize(shadowLightPosition);
    vec3 worldLightVector = mat3(gbufferModelViewInverse) * lightVector;

    color.rgb = vec3(lightmap, 0.0);
}