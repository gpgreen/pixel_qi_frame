include <frame_config.scad>
use <frame.scad>
use <button.scad>

fcut_line = [
[4,faceplate_thickness+.5],
[4,faceplate_thickness-2],
[2,faceplate_thickness-2],
[2,faceplate_thickness-1],
[-1,faceplate_thickness-1],
[-1,-3],
[-3,-3],
[-3,-2],
[-5,-2],
[-5,-backframe_thickness+2]];

module front_cutoff_bottom() {
    fcut_offset=[
    [-cut_gap,0],
    [-cut_gap,cut_gap],
    [cut_gap,cut_gap],
    [cut_gap,cut_gap],
    [-cut_gap,cut_gap],
    [-cut_gap,cut_gap],
    [cut_gap,cut_gap],
    [cut_gap,cut_gap],
    [-cut_gap,cut_gap],
    [-cut_gap,0]];
    outline = concat(fcut_line+fcut_offset, 
    [[display_width,-backframe_thickness+2],
    [display_width,faceplate_thickness],
    [4-cut_gap,faceplate_thickness+.5]]);
    rotate(a=[90,0,0])
        linear_extrude(height=display_height*2, center=true)
            polygon(outline);
}

module front_cutoff_top() {
    outline = concat(fcut_line, 
    [[-display_width,-backframe_thickness+2],
    [-display_width,faceplate_thickness],
    [4,faceplate_thickness+.5]]);
    rotate(a=[90,0,0])
        linear_extrude(height=display_height*2, center=true)
            polygon(outline);
}

module front_frame_left() {
    translate([-10,0,0])
        rotate(a=[180,0,0])
            difference() {
                front_frame();
                translate([-70,0,0])
                    front_cutoff_bottom();
            }
}

module front_frame_bottom() {
    translate([0,30,0])
        rotate(a=[180,0,0])
            difference() {
                front_frame();
                translate([-70,0,0])
                     front_cutoff_top();
                translate([70,0,0])
                    rotate(a=[0,0,180])
                        front_cutoff_top();
                translate([-75,0,-75])
                    cube([150,150,150]);
            }
}

module front_frame_top() {
    translate([0,-20,0])
        rotate(a=[180,0,0])
            difference() {
                front_frame();
                translate([-70,0,0])
                     front_cutoff_top();
                translate([70,0,0])
                    rotate(a=[0,0,180])
                        front_cutoff_top();
                translate([-75,-150,-75])
                    cube([150,150,150]);
            }
}

module front_frame_right() {
    translate([10,0,0])
        rotate(a=[180,0,0])
            difference() {
                front_frame();
                translate([70,0,0])
                    rotate(a=[0,0,180])
                        front_cutoff_bottom();
            }
}

bcut_line = [
[4,-backframe_thickness-1],
[4,-backframe_thickness+1],
[0,-backframe_thickness+1],
[0,-3],
[-2,-3],
[-2,-4],
[-4,-4],
[-4,0]];

module back_cutoff_top() {
    outline = concat(bcut_line,
    [[display_width,0],
    [display_width,-backframe_thickness-1],
    [4,-backframe_thickness-1]]);
    rotate(a=[90,0,0])
        linear_extrude(height=display_height*2, center=true)
            polygon(outline);
}

module back_cutoff_bottom() {
    bcut_offset = [
    [cut_gap,0],
    [cut_gap,cut_gap],
    [cut_gap,cut_gap],
    [cut_gap,cut_gap],
    [-cut_gap,cut_gap],
    [-cut_gap,cut_gap],
    [cut_gap,cut_gap],
    [cut_gap,0]];
    outline = concat(bcut_line + bcut_offset, 
    [[-display_width,0],
    [-display_width,-backframe_thickness-1],
    [4+cut_gap,-backframe_thickness-1]]);
    rotate(a=[90,0,0])
        linear_extrude(height=display_height*2, center=true)
            polygon(outline);
}

module back_frame_left() {
    difference() {
        back_frame();
	translate([-80,0,0])
		back_cutoff_top();
    }
}

module back_frame_right() {
    difference() {
        back_frame();
	translate([80,0,0])
		rotate(a=[0,0,180])
			back_cutoff_top();
    }
}

module back_frame_bottom() {
    translate([0,-30,0])
            difference() {
                back_frame();
                translate([-80,0,0])
                     back_cutoff_bottom();
                translate([80,0,0])
                    rotate(a=[0,0,180])
                        back_cutoff_bottom();
                translate([-90,0,-90])
                    cube([180,180,180]);
            }
}

module back_frame_top() {
    translate([0,20,0])
            difference() {
                back_frame();
                translate([-80,0,0])
                     back_cutoff_bottom();
                translate([80,0,0])
                    rotate(a=[0,0,180])
                        back_cutoff_bottom();
                translate([-90,-180,-90])
                    cube([180,180,180]);
            }
}

mod = "display";
do_cut = true;

if (mod == "front_frame") {
    if (do_cut) {
        front_frame_left();
        front_frame_right();
        front_frame_top();
        front_frame_bottom();
    }
    else
        front_frame();
}
else if (mod == "back_frame") {
    if (do_cut) {
     	back_frame_left();
     	back_frame_right();
     	back_frame_top();
     	back_frame_bottom();
    }
    else
        back_frame();
}
else if (mod == "bottom_button") {
    bottom_button();
}
else if (mod == "side_button") {
    side_button();
}
else if (mod == "front_frame_left")
    front_frame_left();
else if (mod == "front_frame_right")
    front_frame_right();
else if (mod == "front_frame_top")
    front_frame_top();
else if (mod == "front_frame_bottom")
    front_frame_bottom();
else if (mod == "back_frame_left")
    back_frame_left();
else if (mod == "back_frame_right")
    back_frame_right();
else if (mod == "back_frame_bottom")
    back_frame_bottom();
else if (mod == "back_frame_top")
    back_frame_top();
else if (mod == "display") {
    back_frame();
    front_frame();
    side_buttons();
    bottom_buttons();
}
