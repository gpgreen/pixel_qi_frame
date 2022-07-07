// Display from for Pixel Qi lcd panel
// Copyright 2022 Greg Green
//
// button.scad

include <frame_config.scad>

module button_top() {
    minkowski() {
        cube([button_width-button_radius*.5,
        button_height-button_radius*.5,
        button_thickness-2],
        center=true);
        cylinder(r=button_radius, h=1, $fn=64);
    }
}

module button_bottom() {
    linear_extrude(height=1, center=true) {
        polygon(points=[
	[-1, -.75],
	[button_width+3,-.75],
	[button_width+3, button_height+.75],
	[-1, button_height+.75],
	[-1,-.75]]);
    }
}

module side_button_bottom() {
    linear_extrude(height=1, center=true) {
        polygon(points=[
	[-.75, -1],
	[button_width+.75,-1],
	[button_width+.75, button_height+3],
	[-.75, button_height+3],
	[-.75,-1]]);
    }
}

module bottom_button() {
    translate([-button_width/2-1,-button_height/2,0.5])
        button_bottom();
    translate([0,0,button_thickness/2])
        button_top();
}

module side_button() {
    translate([-button_width/2,-button_height/2-1,0.5])
        side_button_bottom();
    translate([0,0,button_thickness/2])
        button_top();
}

module side_buttons() {
    for(i=[0:num_side_buttons-1]) {
        yint = display_height/(num_side_buttons+1);
        y = yint * (num_side_buttons/2 - i);
        translate([center_left_button_x,y-yint/2,-1])
            side_button();
	    translate([center_right_button_x,y-yint/2,-1])
	        side_button();
    }
}

module bottom_buttons() {
    for(x=bottom_button_x_offsets) {
        translate([x,center_bottom_button_y,-1])
            bottom_button();
    }
}

side_buttons();
bottom_buttons();
