#version 410

uniform mat4 transform;
uniform float size;
uniform int detail;

layout (points) in;
layout (triangle_strip,
        max_vertices = 120  // = 5 * 2 * (MAX_DETAIL + 1)
       ) out;

in vec4 vColor[];
out vec4 fColor;

#define Pi 3.141592564



void circle(vec4 center, float size_mult) {
    float r = 0.5 * size * size_mult;
    for (int i = 0; i <= detail; i++) {
        gl_Position = transform * center;
        EmitVertex();

        float angle = 0.25 * Pi + 2.0 * Pi * float(i) / float(detail);
        gl_Position = transform * (center + vec4(r * cos(angle), r * sin(angle), 0.0, 0.0));
        EmitVertex();
    }

    EndPrimitive();
}

void main() {
    float halo_amount = 5;
    fColor = vColor[0];

    circle(gl_in[0].gl_Position,1);

    for (int k = 2; k <= halo_amount; k++) {
        fColor = vColor[0];
        fColor[3] = 0.01;
        circle(gl_in[0].gl_Position,k*k);
    }

}
