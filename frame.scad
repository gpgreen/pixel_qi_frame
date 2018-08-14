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

button_boss_radius=3;
button_boss_height=3;

flange_width=2;
flange_height=4;

faceplate_inset=2;
faceplate_lside_width=22;
faceplate_rside_width=20;
faceplate_top_width=5;
faceplate_bottom_width=18;
faceplate_thickness=4;

backframe_thickness=7;
backframe_center_thickness=2;
backframe_inset=3;

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

module button_pcb_boss() {
    cylinder(h=button_boss_height,r=button_boss_radius);
}

module left_button_pcb_bosses() {
    for(i=[0:num_side_buttons]) {
        yint = display_height/(num_side_buttons+1);
        y = yint * (num_side_buttons/2 - i + 1);
        translate([-display_width/2-faceplate_lside_width+button_side_offset+button_width/2,y-yint,-button_boss_height])
            button_pcb_boss();
        }
    }
    
module right_button_pcb_bosses() {
    for(i=[0:num_side_buttons]) {
        yint = display_height/(num_side_buttons+1);
        y = yint * (num_side_buttons/2 - i + 1);
        translate([display_width/2+faceplate_rside_width-button_side_offset-button_width/2,y-yint,-button_boss_height])
            button_pcb_boss();
        }
    }
    
module bottom_button_pcb_bosses() {
    for(i=[0:num_bot_buttons]) {
        xint = display_width/(num_bot_buttons+1);
        x = xint * (num_bot_buttons/2 - i + 1);
        translate([x-xint,-display_height/2-    faceplate_bottom_width+button_bottom_offset+button_height/2,-button_boss_height])
            button_pcb_boss();
    }
}

module outside_trim() {
    linear_extrude(height=display_width*2, center=true)
        polygon(points=[[-2,0],[-2,faceplate_thickness+2],[2,faceplate_thickness+2],[0,0],[-2,0]]);
}

module outside_trim_all() {
    translate([-display_width/2-faceplate_lside_width,0,0])
        rotate(a=[90,0,0])
            outside_trim();
    translate([display_width/2+faceplate_rside_width,0,0])
        rotate(a=[90,0,180])
            outside_trim();
    translate([0,-display_height/2-faceplate_bottom_width,0])
        rotate(a=[90,0,90])
            outside_trim();
    translate([0,display_height/2+faceplate_top_width,0])
        rotate(a=[90,0,-90])
            outside_trim();
}

module faceplate_assembly() {
    translate([0,0,-flange_height/2])
        flange();
    translate([0,0,faceplate_thickness/2])
        faceplate();
    left_button_pcb_bosses();
    right_button_pcb_bosses();
    bottom_button_pcb_bosses();
}

module front_frame() {
    difference() {
        faceplate_assembly();
        outside_trim_all();
        button_holes();
    }
}

module back_frame_plate() {
    linear_extrude(height=backframe_center_thickness, center=false) {
        polygon(points=[
            [-display_width/2+backframe_inset+display_left_bezel,-display_height/2+faceplate_inset+display_bottom_bezel],
            [-display_width/2+backframe_inset+display_left_bezel, display_height/2-faceplate_inset-display_top_bezel],
            [display_width/2-backframe_inset-display_right_bezel, display_height/2-faceplate_inset-display_top_bezel],
            [display_width/2-backframe_inset-display_right_bezel, -display_height/2+faceplate_inset+display_bottom_bezel],
            [-display_width/2-faceplate_lside_width,-display_height/2-faceplate_bottom_width],
            [-display_width/2-faceplate_lside_width, display_height/2+faceplate_top_width],
            [display_width/2+faceplate_rside_width, display_height/2+faceplate_top_width],
            [display_width/2+faceplate_rside_width, -display_height/2-faceplate_bottom_width]],
            paths=[[0,1,2,3],[4,5,6,7]]);
    }
}

module back_frame_outer_flange() {
    linear_extrude(height=backframe_thickness, center=true) {
        polygon(points=[
            [-display_width/2-faceplate_lside_width,-display_height/2-faceplate_bottom_width],
            [-display_width/2-faceplate_lside_width, display_height/2+faceplate_top_width],
            [display_width/2+faceplate_rside_width, display_height/2+faceplate_top_width],
            [display_width/2+faceplate_rside_width, -display_height/2-faceplate_bottom_width],

            [-display_width/2-faceplate_lside_width+2,-display_height/2-faceplate_bottom_width+2],
            [-display_width/2-faceplate_lside_width+2, display_height/2+faceplate_top_width-2],
            [display_width/2+faceplate_rside_width-2, display_height/2+faceplate_top_width-2],
            [display_width/2+faceplate_rside_width-2, -display_height/2-faceplate_bottom_width+2]],
            paths=[[0,1,2,3],[4,5,6,7]]);
    }
}

module back_frame() {
    translate([0,0,-backframe_thickness])
        back_frame_plate();
    translate([0,0,-backframe_thickness/2])
        back_frame_outer_flange();
}

front_frame();
back_frame();