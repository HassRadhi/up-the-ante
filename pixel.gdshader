shader_type spatial; // Use this for 3D objects (Godot 3 & 4)

// === Parameters (same spirit as your 2D shader) ===
uniform float shake: hint_range(0, 10) = 0.015;
uniform float noiseQuality: hint_range(0.1, 250, 0.1) = 250.0;
uniform float noiseIntensity: hint_range(0.0, 0.05, 0.001) = 0.001;
uniform float offsetIntensity: hint_range(0.0, 0.05, 0.0001) = 0.0045;
uniform float colorOffsetIntensity: hint_range(0.1, 1.5, 0.001) = 0.2;
uniform float pixelSize: hint_range(1.0, 1024.0) = 200.0;
uniform float grainIntensity: hint_range(0.0, 1.0) = 0.04;

uniform sampler2D albedo_texture : source_color; // Main texture for the object
uniform sampler2D overlay_texture : hint_default_transparent;

uniform bool use_overlay = true;
uniform bool use_lens_distortion = true;

uniform vec4 overlay_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float lens_distortion_strength: hint_range(0.0, 0.3) = 0.05;

// === Helpers ===
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float verticalBar(float pos, float uvY, float offset) {
    float edge0 = (pos - shake);
    float edge1 = (pos + shake);

    float x = smoothstep(edge0, pos, uvY) * offset;
    x -= smoothstep(pos, edge1, uvY) * offset;
    return x;
}

void fragment() {
    // UV coordinates on the mesh (0–1 range)
    vec2 uv = UV;

    // === Pixelation effect in UV space ===
    uv = floor(uv * pixelSize) / pixelSize;

    // === Vertical bars distortion (scanline-like) ===
    vec2 distorted_uv = uv;
    for (float i = 0.0; i < 0.71; i += 0.1313) {
        float d = mod(TIME * i, 1.7);
        float o = sin(1.0 - tan(TIME * 0.24 * i));
        o *= offsetIntensity;
        distorted_uv.x += verticalBar(d, distorted_uv.y, o);
    }

    // === Noise distortion along X ===
    float uvY = distorted_uv.y * noiseQuality;
    uvY = float(int(uvY)) * (1.0 / noiseQuality);
    float noise = rand(vec2(TIME * 0.00001, uvY));
    distorted_uv.x += noise * noiseIntensity;

    // === Color channel offset (chromatic aberration-ish) ===
    vec2 offsetR = vec2(0.006 * sin(TIME), 0.0) * colorOffsetIntensity;
    vec2 offsetG = vec2(0.0073 * cos(TIME * 0.97), 0.0) * colorOffsetIntensity;

    // Optional lens distortion in UV space (fake radial warp)
    vec2 sample_uv = distorted_uv;
    if (use_lens_distortion) {
        vec2 center = vec2(0.5, 0.5);
        vec2 fromCenter = sample_uv - center;
        float r2 = dot(fromCenter, fromCenter); // squared radius
        sample_uv += fromCenter * r2 * lens_distortion_strength;
    }

    // Sample base texture with color offsets
    float r = texture(albedo_texture, sample_uv + offsetR).r;
    float g = texture(albedo_texture, sample_uv + offsetG).g;
    float b = texture(albedo_texture, sample_uv).b;

    vec4 tex = vec4(r, g, b, 1.0);

    // === Overlay texture (like film dirt / UI texture) ===
    if (use_overlay) {
        vec4 overlay_tex = texture(overlay_texture, sample_uv) * overlay_color;
        tex = mix(tex, overlay_tex, overlay_tex.a);
    }

    // === Film grain on top ===
    float grain = rand(sample_uv * vec2(1024.0, 1024.0) + TIME) * 2.0 - 1.0;
    tex.rgb += grainIntensity * grain;

    // Clamp final colour to avoid blowing out
    tex = clamp(tex, 0.0, 1.0);

    // Output to material
    ALBEDO = tex.rgb;
    ALPHA = tex.a;
}
