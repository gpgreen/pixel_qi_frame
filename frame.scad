display_width=234;
display_height=143;
display_top_bezel=8;
display_bottom_bezel=8;
display_left_bezel=4;
display_right_bezel=6;

button_width=10;
button_height=6;
button_rad=1;
num_bot_buttons=6;
num_side_buttons=5;
button_bottom_offset=5;
button_side_offset=5;

flange_width=2;
flange_height=4;

faceplate_inset=2;
faceplate_lside_width=22;
faceplate_rside_width=20;
faceplate_top_width=5;
faceplate_bottom_width=18;
faceplate_thickness=4;


module flange() {
    linear_extrude(height=flange_height, center=true) {
        polygon(points=[
            [-display_width/2,-display_height/2],
            [-display_width/2, display_height/2],
            [display_width/2, display_height/2],
            [display_width/2, -display_height/2],
            [-display_width/2-flange_width,-display_height/2-flange_width],
            [-display_width/2-flange_width, display_height/2+flange_width],
            [display_width/2+flange_width, display_height/2+flange_width],
            [display_width/2+flange_width, -display_height/2-flange_width]],
            paths=[[0,1,2,3],[4,5,6,7]]);
    }
}

module faceplate() {
    linear_extrude(height=faceplate_thickness, center=true) {
        polygon(points=[
            [-display_width/2+faceplate_inset+display_left_bezel,-display_height/2+faceplate_inset+display_bottom_bezel],
            [-display_width/2+faceplate_inset+display_left_bezel, display_height/2-faceplate_inset-display_top_bezel],
            [display_width/2-faceplate_inset-display_right_bezel, display_height/2-faceplate_inset-display_top_bezel],
            [display_width/2-faceplate_inset-display_right_bezel, -display_height/2+faceplate_inset+display_bottom_bezel],
            [-display_width/2-faceplate_lside_width,-display_height/2-faceplate_bottom_width],
            [-display_width/2-faceplate_lside_width, display_height/2+faceplate_top_width],
            [display_width/2+faceplate_rside_width, display_height/2+faceplate_top_width],
            [display_width/2+faceplate_rside_width, -display_height/2-faceplate_bottom_width]],
            paths=[[0,1,2,3],[4,5,6,7]]);
    }
}

module button_hole() {
    minkowski() {
        cube([button_width, button_height, faceplate_thickness], center=true);
        cylinder(r=button_rad, h=1, $fn=50);
    }
}

module bottom_button_holes() {
    for(i=[0:num_bot_buttons-1]) {
        xint = display_width/(num_bot_buttons+1);
        x = xint * (num_bot_buttons/2 - i);
        translate([x-xint/2,-display_height/2-faceplate_bottom_width+button_bottom_offset+button_height/2,2])
            button_hole();
    }
}

module left_button_holes() {
    for(i=[0:num_side_buttons-1]) {
        yint = display_height/(num_side_buttons+1);
        y = yint * (num_side_buttons/2 - i);
        translate([-display_width/2-faceplate_lside_width+button_side_offset+button_width/2,y-yint/2,2])
            button_hole();
    }
}

module right_button_holes() {
    for(i=[0:num_side_buttons-1]) {
        yint = display_height/(num_side_buttons+1);
        y = yint * (num_side_buttons/2 - i);
        translate([display_width/2+faceplate_rside_width-button_side_offset-button_width/2,y-yint/2,2])
            button_hole();
    }
}

module button_holes() {
    left_button_holes();
    bottom_button_holes();
    right_button_holes();
}

module faceplate_assembly() {
    translate([0,0,-flange_height/2])
        flange();
    translate([0,0,faceplate_thickness/2])
        faceplate();
}
    
module outside_frame() {
    difference() {
        faceplate_assembly();
        button_holes();
    }
}

outside_frame();