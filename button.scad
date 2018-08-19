include <frame_config.scad>

module button_top() {
    minkowski() {
        cube([button_width-button_rad, 
        button_height-button_rad, 
        button_thickness-button_rad], 
        center=true);
        cylinder(r=button_rad, h=1, $fn=50);
    }
}

module button_bottom() {
    linear_extrude(height=1, center=true) {
        polygon(points=[
	[0, 0],
	[button_width+2,0],
	[button_width+2, button_height],
	[0, button_height],
	[0,0]]);
    }
}

module side_button_bottom() {
    linear_extrude(height=1, center=true) {
        polygon(points=[
	[0, 0],
	[button_width,0],
	[button_width, button_height+2],
	[0, button_height+2],
	[0,0]]);
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

//bottom_button();
//translate([20,0,0])
    //side_button();

module side_buttons() {
    for(i=[0:num_side_buttons-1]) {
        yint = display_height/(num_side_buttons+1);
        y = yint * (num_side_buttons/2 - i);
        translate([-display_width/2-faceplate_lside_width+button_side_offset+button_width/2,y-yint/2,-1])
            side_button();
	translate([display_width/2+faceplate_rside_width-button_side_offset-button_width/2,y-yint/2,-1])
	    side_button();
    }
}

module bottom_buttons() {
    for(i=[0:num_bot_buttons-1]) {
        xint = display_width/(num_bot_buttons+1);
        x = xint * (num_bot_buttons/2 - i);
        translate([x-xint/2,-display_height/2-faceplate_bottom_width+button_bottom_offset+button_height/2,-1])
            bottom_button();
    }
}

side_buttons();
bottom_buttons();
