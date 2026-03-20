$fn = 100;

/* [Dimensions] */
Cable_Diameter = 4.5;// [3:.5:10] 
Wall_Thickness = 1.0; // [1:.5:5]
Outside_Diameter = Cable_Diameter + 2 * Wall_Thickness;
Outside_Radius = Outside_Diameter / 2;
Length = 20;//[5:1:50]
Cutoff_Angle = 45;//[0:5:90]
Text_Depth = 0.5;//[0.1:.1:1]

/* [Colors] */
Body_Color = "#0000FF"; // color
Text_Color = "#FF0000"; // color

/* [Label] */
Label_Text = "IDRAC";
Text_Size = 4; //[1:10]

rotate([90, 0, 90])  // rotate whole object + text together
union() {

    // Main body
    color(Body_Color)
    difference() {
        // Base shape: cylinder + rectangle
        union() {
            cylinder(d = Outside_Diameter, h = Length, center = false);
            translate([-Outside_Radius, 0, 0])
                cube([Outside_Diameter, Outside_Radius, Length], center = false);
        }

        // Subtract central hole
        cylinder(d = Cable_Diameter, h = Length, center = false);

        // Subtract wedge
        linear_extrude(height = Length)
            polygon(points = concat(
                [[0, 0]],
                [for (a = [180 + Cutoff_Angle : 1 : 360 - Cutoff_Angle])
                    [(Outside_Radius + 0.1) * cos(a), (Outside_Radius + 0.1) * sin(a)]]
            ));
    }

    // Embossed text on the flat top face, properly oriented
    color(Text_Color)
    translate([0, Outside_Radius - 0.01, Length/2])
        rotate([90, 90, 180])
            linear_extrude(height = Text_Depth + 0.02)
                text(Label_Text,
                     size = Text_Size,
                     halign = "center",
                     valign = "center",
                     font = "Liberation Sans:style=Bold");
}
