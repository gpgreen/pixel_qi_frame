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

frame_boss_radius=3;

button_boss_radius=3;
button_boss_height=3.5;

flange_height=5;
flange_gap=0.5;
flange_width=2+flange_gap;

faceplate_inset=2;
faceplate_lside_width=22;
faceplate_rside_width=20;
faceplate_top_width=5;
faceplate_bottom_width=18;
faceplate_thickness=4;

backframe_thickness=8;
backframe_center_thickness=2;
backframe_inset=5;

pcb_thickness=1;

backframe_boss_radius=3;
backframe_boss_height=backframe_thickness-pcb_thickness-button_boss_height;

// Vector of display corners
display_corners = [
    [-display_width/2-faceplate_lside_width,-display_height/2-faceplate_bottom_width,0],
    [-display_width/2-faceplate_lside_width,display_height/2+faceplate_top_width,0],
    [display_width/2+faceplate_rside_width,display_height/2+faceplate_top_width,0],
    [display_width/2+faceplate_rside_width,-display_height/2-faceplate_bottom_width,0]
];

module frame_hole() {
    cylinder(h=backframe_thickness*2, r=1.5);
}

module frame_holes() {
    offset = frame_boss_radius+3;
    fho = [[offset,offset,-backframe_thickness],
        [offset,-offset,-backframe_thickness],
        [-offset,-offset,-backframe_thickness],
        [-offset,offset,-backframe_thickness]];
    trans = display_corners + fho;
    
    translate(trans[0])
        frame_hole();
    translate(trans[1])
        frame_hole();
    translate(trans[2])
        frame_hole();
    translate(trans[3])
        frame_hole();
}

module flange() {
    linear_extrude(height=flange_height, center=true) {
        polygon(points=[
            [-display_width/2-flange_gap,-display_height/2-flange_gap],
            [-display_width/2-flange_gap, display_height/2+flange_gap],
            [display_width/2+flange_gap, display_height/2+flange_gap],
            [display_width/2+flange_gap, -display_height/2-flange_gap],
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

module faceplate_inner_trim() {
    linear_extrude(height=10, scale=1.05)
    offset(r=faceplate_inset+2)
        polygon(points=[
            [-display_width/2+faceplate_inset+2+display_left_bezel,-display_height/2+faceplate_inset+2+display_bottom_bezel],
            [-display_width/2+faceplate_inset+2+display_left_bezel, display_height/2-faceplate_inset-2-display_top_bezel],
            [display_width/2-faceplate_inset-2-display_right_bezel, display_height/2-faceplate_inset-2-display_top_bezel],
            [display_width/2-faceplate_inset-2-display_right_bezel,-display_height/2+faceplate_inset+2+display_bottom_bezel]]);
}

module front_frame_boss() {
    cylinder(h=flange_height,r=frame_boss_radius);
}

module front_frame_bosses() {
    offset = frame_boss_radius+3;
    ffb = [[offset,offset,-flange_height],
        [offset,-offset,-flange_height],
        [-offset,-offset,-flange_height],
        [-offset,offset,-flange_height]];
    trans = display_corners + ffb;
    
    translate(trans[0])
        front_frame_boss();
    translate(trans[1])
        front_frame_boss();
    translate(trans[2])
        front_frame_boss();
    translate(trans[3])
        front_frame_boss();
}

module faceplate_assembly() {
    translate([0,0,-flange_height/2])
        flange();
    translate([0,0,faceplate_thickness/2])
        faceplate();
    left_button_pcb_bosses();
    right_button_pcb_bosses();
    bottom_button_pcb_bosses();
    front_frame_bosses();
}

module front_frame() {
    difference() {
        faceplate_assembly();
        outside_trim_all();
        button_holes();
        faceplate_inner_trim();
	frame_holes();
    }
}

module back_frame_plate() {
    linear_extrude(height=backframe_center_thickness, center=false) {
        polygon(points=[
            [-display_width/2+backframe_inset+display_left_bezel,-display_height/2+backframe_inset+display_bottom_bezel],
            [-display_width/2+backframe_inset+display_left_bezel, display_height/2-backframe_inset-display_top_bezel],
            [display_width/2-backframe_inset-display_right_bezel, display_height/2-backframe_inset-display_top_bezel],
            [display_width/2-backframe_inset-display_right_bezel, -display_height/2+backframe_inset+display_bottom_bezel],
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

module back_pcb_boss() {
    cylinder(h=backframe_boss_height,r=backframe_boss_radius);
}

module left_back_pcb_bosses() {
    for(i=[0:num_side_buttons]) {
        yint = display_height/(num_side_buttons+1);
        y = yint * (num_side_buttons/2 - i + 1);
        translate([-display_width/2-faceplate_lside_width+button_side_offset+button_width/2,y-yint,-backframe_thickness])
            back_pcb_boss();
        }
    }
    
module right_back_pcb_bosses() {
    for(i=[0:num_side_buttons]) {
        yint = display_height/(num_side_buttons+1);
        y = yint * (num_side_buttons/2 - i + 1);
        translate([display_width/2+faceplate_rside_width-button_side_offset-button_width/2,y-yint,-backframe_thickness])
            back_pcb_boss();
        }
    }
    
module bottom_back_pcb_bosses() {
    for(i=[0:num_bot_buttons]) {
        xint = display_width/(num_bot_buttons+1);
        x = xint * (num_bot_buttons/2 - i + 1);
        translate([x-xint,-display_height/2-    faceplate_bottom_width+button_bottom_offset+button_height/2,-backframe_thickness])
            back_pcb_boss();
    }
}

module frame_boss() {
    cylinder(h=backframe_thickness-flange_height,r=frame_boss_radius);
}

module back_frame_bosses() {
    offset = frame_boss_radius+3;
    bfb = [[offset,offset,-backframe_thickness],
        [offset,-offset,-backframe_thickness],
        [-offset,-offset,-backframe_thickness],
        [-offset,offset,-backframe_thickness]];
    trans = display_corners + bfb;
    
    translate(trans[0])
        frame_boss();
    translate(trans[1])
        frame_boss();
    translate(trans[2])
        frame_boss();
    translate(trans[3])
        frame_boss();
}

module back_frame_assy() {
    translate([0,0,-backframe_thickness])
        back_frame_plate();
    translate([0,0,-backframe_thickness/2])
        back_frame_outer_flange();
    left_back_pcb_bosses();
    right_back_pcb_bosses();
    bottom_back_pcb_bosses();
    back_frame_bosses();
}

module back_frame() {
    difference() {
        back_frame_assy();
        frame_holes();
    }
}

cut_line = [
[0,faceplate_thickness+2],
[0,-2],
[-4,-2],
[-4,-backframe_thickness+2]];

module cutoff_left() {
    outline = concat(cut_line, 
    [[display_width,-backframe_thickness+2],
    [display_width,faceplate_thickness+2],
    [0,faceplate_thickness+2]]);
    rotate(a=[90,0,0])
        linear_extrude(height=display_height*2, center=true)
            polygon(outline);
}

module cutoff_right() {
    outline = concat(cut_line, 
    [[-display_width,-backframe_thickness+2],
    [-display_width,faceplate_thickness+2],
    [0,faceplate_thickness+2]]);
    rotate(a=[90,0,0])
        linear_extrude(height=display_height*2, center=true)
            polygon(outline);
}

//front_frame();
//back_frame();
//cutoff();

module front_frame_left() {
    rotate(a=[180,0,0])
        difference() {
            front_frame();
            cutoff_left();
        }
}

module front_frame_right() {
    translate([10,0,0])
        rotate(a=[180,0,0])
            difference() {
                front_frame();
                cutoff_right();
            }
}

*front_frame_left();
front_frame_right();