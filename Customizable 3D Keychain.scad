// Parameters
name = "OSCAR";
font_style = "Arial:style=Bold";
font_size = 13;
letter_spacing = 1.1;
puffiness = 3;
hole_diameter = 4;

$fn = 20; // leggermente ridotto per velocità

// Ring placement
ring_outer_r = (hole_diameter / 2) + 3;
ring_x = -ring_outer_r;
ring_y = font_size / 3;

// --- Half-sphere inflation kernel (molto più leggero) ---
module puff_kernel(r) {
    translate([0,0,r])
        sphere(r=r);
}

// --- Base shape (testo + linguetta) ---
module base_shape() {
    union() {
        // Text (2D)
        text(name, size=font_size, font=font_style, spacing=letter_spacing);

        // Ring tab (2D)
        translate([ring_x, ring_y])
            hull() {
                circle(r = ring_outer_r);
                translate([ring_outer_r, 0])
                    square([1, ring_outer_r], center=true);
            }
    }
}

// --- Final model ---
difference() {
    // Puffiness applied
    minkowski() {
        linear_extrude(height = 0.01)  // minimo indispensabile
            base_shape();

        puff_kernel(puffiness);
    }

    // Hole
    translate([ring_x, ring_y, -1])
        cylinder(h = puffiness*2 + 5, d = hole_diameter);
}
