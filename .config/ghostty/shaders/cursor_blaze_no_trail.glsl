
float sdBox(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// //Author: https://iquilezles.org/articles/distfunctions2d/
float sdTrail(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3)
{
    float d = dot(p - v0, p - v0);
    float s = 1.0;

    // Edge from v3 to v0
    {
        vec2 e = v3 - v0;
        vec2 w = p - v0;
        vec2 b = w - e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
        d = min(d, dot(b, b));

        // Compute branchless boolean conditions:
        float c0 = step(0.0, p.y - v0.y); // 1 if (p.y >= v0.y)
        float c1 = 1.0 - step(0.0, p.y - v3.y); // 1 if (p.y <  v3.y)
        float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x); // 1 if (e.x*w.y > e.y*w.x)
        float allCond = c0 * c1 * c2;
        float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
        // If either allCond or noneCond is 1, then flip factor becomes -1.
        float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
        s *= flip;
    }

    // Edge from v0 to v1
    {
        vec2 e = v0 - v1;
        vec2 w = p - v1;
        vec2 b = w - e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
        d = min(d, dot(b, b));

        float c0 = step(0.0, p.y - v1.y);
        float c1 = 1.0 - step(0.0, p.y - v0.y);
        float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
        float allCond = c0 * c1 * c2;
        float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
        float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
        s *= flip;
    }

    // Edge from v1 to v2
    {
        vec2 e = v1 - v2;
        vec2 w = p - v2;
        vec2 b = w - e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
        d = min(d, dot(b, b));

        float c0 = step(0.0, p.y - v2.y);
        float c1 = 1.0 - step(0.0, p.y - v1.y);
        float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
        float allCond = c0 * c1 * c2;
        float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
        float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
        s *= flip;
    }

    // Edge from v2 to v3
    {
        vec2 e = v2 - v3;
        vec2 w = p - v3;
        vec2 b = w - e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
        d = min(d, dot(b, b));

        float c0 = step(0.0, p.y - v3.y);
        float c1 = 1.0 - step(0.0, p.y - v2.y);
        float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
        float allCond = c0 * c1 * c2;
        float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
        float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
        s *= flip;
    }

    return s * sqrt(d);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float ParametricBlend(float t)
{
    float sqr = t * t;
    return sqr / (2.0 * (sqr - t) + 1.0);
}

float antialising(float distance) {
    return 1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, distance);
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    // Conditions using step
    float condition1 = step(b.x, a.x) * step(a.y, b.y); // a.x < b.x && a.y > b.y
    float condition2 = step(a.x, b.x) * step(b.y, a.y); // a.x > b.x && a.y < b.y

    // If neither condition is met, return 1 (else case)
    return 1.0 - max(condition1, condition2);
}

// Catppuccin Mocha: Peach settling, Red flash.
const vec4 TRAIL_COLOR = vec4(0.980, 0.702, 0.529, 1.0);        // Peach #FAB387
const vec4 TRAIL_COLOR_ACCENT = vec4(0.953, 0.545, 0.659, 1.0); // Red #F38BA8
//
// Other Catppuccin Mocha pairings (settle color, then flash accent).
// Uncomment one pair and comment out the active pair above.
//
// Mauve / Pink
// const vec4 TRAIL_COLOR = vec4(0.796, 0.651, 0.969, 1.0);        // Mauve #CBA6F7
// const vec4 TRAIL_COLOR_ACCENT = vec4(0.961, 0.761, 0.906, 1.0); // Pink #F5C2E7
//
// Blue / Sapphire
// const vec4 TRAIL_COLOR = vec4(0.537, 0.706, 0.980, 1.0);        // Blue #89B4FA
// const vec4 TRAIL_COLOR_ACCENT = vec4(0.455, 0.780, 0.925, 1.0); // Sapphire #74C7EC
//
// Sky / Lavender
// const vec4 TRAIL_COLOR = vec4(0.537, 0.863, 0.922, 1.0);        // Sky #89DCEB
// const vec4 TRAIL_COLOR_ACCENT = vec4(0.706, 0.745, 0.996, 1.0); // Lavender #B4BEFE
//
// Green / Teal
// const vec4 TRAIL_COLOR = vec4(0.651, 0.890, 0.631, 1.0);        // Green #A6E3A1
// const vec4 TRAIL_COLOR_ACCENT = vec4(0.580, 0.886, 0.835, 1.0); // Teal #94E2D5
//
// Yellow / Peach
// const vec4 TRAIL_COLOR = vec4(0.976, 0.886, 0.686, 1.0);        // Yellow #F9E2AF
// const vec4 TRAIL_COLOR_ACCENT = vec4(0.980, 0.702, 0.529, 1.0); // Peach #FAB387
//
// Red / Maroon
// const vec4 TRAIL_COLOR = vec4(0.953, 0.545, 0.659, 1.0);        // Red #F38BA8
// const vec4 TRAIL_COLOR_ACCENT = vec4(0.922, 0.627, 0.675, 1.0); // Maroon #EBA0AC
//
// Flamingo / Rosewater
// const vec4 TRAIL_COLOR = vec4(0.949, 0.804, 0.804, 1.0);        // Flamingo #F2CDCD
// const vec4 TRAIL_COLOR_ACCENT = vec4(0.961, 0.878, 0.863, 1.0); // Rosewater #F5E0DC
//
// Text / Lavender (neutral cursor, soft blue flash)
// const vec4 TRAIL_COLOR = vec4(0.804, 0.839, 0.957, 1.0);        // Text #CDD6F4
// const vec4 TRAIL_COLOR_ACCENT = vec4(0.706, 0.745, 0.996, 1.0); // Lavender #B4BEFE
//
// Non-Catppuccin originals
// const vec4 TRAIL_COLOR = vec4(0.482, 0.886, 1.0, 1.0);
// const vec4 TRAIL_COLOR_ACCENT = vec4(0.0, 0.424, 1.0, 1.0);
const vec4 CURRENT_CURSOR_COLOR = TRAIL_COLOR;
const vec4 PREVIOUS_CURSOR_COLOR = TRAIL_COLOR;
const float DURATION = 0.3;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif
    //Normalization for fragCoord to a space of -1 to 1;
    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    //Normalization for cursor position and size;
    //cursor xy has the postion in a space of -1 to 1;
    //zw has the width and height
    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    //When drawing a parellelogram between cursors for the trail i need to determine where to start at the top-left or top-right vertex of the cursor
    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;

    //Set every vertex of my parellogram
    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + currentCursor.z * invertedVertexFactor, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor, previousCursor.y - previousCursor.w);

    vec4 newColor = vec4(fragColor);

    float progress = ParametricBlend(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0));

    //Distance between cursors determine the total length of the parallelogram;
    float lineLength = distance(currentCursor.xy, previousCursor.xy);
    float distanceToEnd = distance(vu.xy, vec2(currentCursor.x + (currentCursor.z / 2.), currentCursor.y - (currentCursor.w / 2.)));
    float alphaModifier = distanceToEnd / (lineLength * (1.0 - progress));

    // float d2 = sdTrail(vu, v0, v1, v2, v3);
    // newColor = mix(newColor, TRAIL_COLOR_ACCENT, 1.0 - smoothstep(d2, -0.01, 0.001));
    // newColor = mix(newColor, TRAIL_COLOR, 1.0 - smoothstep(d2, -0.01, 0.001));
    // newColor = mix(newColor, TRAIL_COLOR, antialising(d2));

    float cCursorDistance = sdBox(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
    newColor = mix(newColor, TRAIL_COLOR_ACCENT, 1.0 - smoothstep(cCursorDistance, -0.000, 0.003 * (1. - progress)));
    newColor = mix(newColor, CURRENT_CURSOR_COLOR, 1.0 - smoothstep(cCursorDistance, -0.000, 0.003 * (1. - progress)));

    // float pCursorDistance = sdBox(vu, previousCursor.xy - (previousCursor.zw * offsetFactor), previousCursor.zw * 0.5);
    // newColor = mix(newColor, PREVIOUS_CURSOR_COLOR, antialising(pCursorDistance));

    fragColor = mix(fragColor, newColor, 1.);
    // fragColor = mix(fragColor, newColor, 1.0 - alphaModifier);
}
