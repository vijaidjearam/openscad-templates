$fn = 100;

/* [Dimensions] */
Cable_Diameter = 6.0;// [3:.5:10] 
Wall_Thickness = 1.5; // [1:.5:5]
Outside_Diameter = Cable_Diameter + 2 * Wall_Thickness;
Outside_Radius = Outside_Diameter / 2;
Length = 15;//[5:1:50]
Cutoff_Angle = 45;//[0:5:90]
Text_Depth = 0.4;//[0.1:.1:1]
/* [Colors] */
Body_Color = "#0000FF"; // color
Text_Color = "#FF0000"; // color
/* [Label] */
Label_Text = "100W";
Text_Size = 4; //[1:10]

difference() {
rotate([90, 0, 90])  // rotate whole object 90° around X axis and 90° around Z axis
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

    // Subtract 90° wedge (4:30 → 7:30)
    linear_extrude(height = Length)
        polygon(points = concat(
            [[0, 0]],   // tip at center
            [for (a = [180 + Cutoff_Angle : 1 : 360 - Cutoff_Angle])
                [(Outside_Radius + 0.1) * cos(a), (Outside_Radius + 0.1) * sin(a)]]
        ));

}

// Debossed text "Label_Text"
        color(Body_Color)
        translate([Length/2, 0, Outside_Radius-Text_Depth])  // position at the flat top surface, offset by deboss depth
            linear_extrude(height = Text_Depth)
                // offset(r = 0.5)
                text(Label_Text, size = Text_Size, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");

}

// Debossed text "Label_Text"
        color(Text_Color)
        translate([Length/2, 0, Outside_Radius-Text_Depth])  // position at the flat top surface, offset by deboss depth
            linear_extrude(height = Text_Depth+.001)
                // offset(r = 0.5)
                text(Label_Text, size = Text_Size, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
