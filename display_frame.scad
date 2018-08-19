include <frame_config.scad>
use <frame.scad>
use <button.scad>

fcut_line = [
[0,faceplate_thickness+2],
[0,-2],
[-4,-2],
[-4,-backframe_thickness+2]];

module front_cutoff_left() {
    outline = concat(fcut_line, 
    [[display_width,-backframe_thickness+2],
    [display_width,faceplate_thickness+2],
    [0,faceplate_thickness+2]]);
    rotate(a=[90,0,0])
        linear_extrude(height=display_height*2, center=true)
            polygon(outline);
}

module front_cutoff_right() {
    outline = concat(fcut_line, 
    [[-display_width,-backframe_thickness+2],
    [-display_width,faceplate_thickness+2],
    [0,faceplate_thickness+2]]);
    rotate(a=[90,0,0])
        linear_extrude(height=display_height*2, center=true)
            polygon(outline);
}

module front_frame_left() {
    rotate(a=[180,0,0])
        difference() {
            front_frame();
            front_cutoff_left();
        }
}

module front_frame_right() {
    translate([10,0,0])
        rotate(a=[180,0,0])
            difference() {
                front_frame();
                front_cutoff_right();
            }
}

bcut_line = [
[0,2],
[0,-4],
[4,-4],
[4,-backframe_thickness-2]];

module back_cutoff_left() {
    outline = concat(bcut_line, 
    [[display_width,-backframe_thickness-2],
    [display_width,2],
    [0,2]]);
    rotate(a=[90,0,0])
        linear_extrude(height=display_height*2, center=true)
            polygon(outline);
}

module back_cutoff_right() {
    outline = concat(bcut_line, 
    [[-display_width,-backframe_thickness-2],
    [-display_width,2],
    [0,2]]);
    rotate(a=[90,0,0])
        linear_extrude(height=display_height*2, center=true)
            polygon(outline);
}

module back_frame_left() {
    difference() {
        back_frame();
        back_cutoff_left();
    }
}

module back_frame_right() {
    translate([10,0,0])
            difference() {
                back_frame();
                back_cutoff_right();
            }
}

mod = "display";
do_cut = false;

if (mod == "front") {
   if (do_cut) {
      front_frame_left();
      front_frame_right();
   }
   else
      front_frame();
}
else if (mod == "back") {
    if (do_cut) {
     	back_frame_left();
     	back_frame_right();
    }
    else
        back_frame();
}
else if (mod == "display") {
    *back_frame();
    front_frame();
    #side_buttons();
    #bottom_buttons();
}
