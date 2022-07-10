// Display for Pixel Qi lcd panel
// Copyright 2022 Greg Green
//
// frame.scad

include <frame_config.scad>

module frame_hole(use_insert) {
    rad = use_insert ? frame_hole_insert_radius : frame_hole_radius;
    cylinder(h=backframe_thickness*2,r=rad,$fn=96);
}

module frame_holes(use_insert) {
    z_offset = use_insert ? -backframe_thickness*2+faceplate_thickness-.5 : -backframe_thickness;
    for (t = bolt_hole_centers) {
        translate([t[0], t[1], z_offset])
            frame_hole(use_insert);
    }
}

module flange(ht) {
    linear_extrude(height=ht, center=false) {
        polygon(points=[
            [-display_width/2-flange_gap,-display_height/2-flange_gap],
            [-display_width/2-flange_gap, display_height/2+flange_gap],
            [display_width/2+flange_gap, display_height/2+flange_gap],
            [display_width/2+flange_gap, -display_height/2-flange_gap],
            [-display_width/2-flange_width-flange_gap,-display_height/2-flange_width-flange_gap],
            [-display_width/2-flange_width-flange_gap, display_height/2+flange_width+flange_gap],
            [display_width/2+flange_width+flange_gap, display_height/2+flange_width+flange_gap],
            [display_width/2+flange_width+flange_gap, -display_height/2-flange_width-flange_gap]],
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

module led_hole() {
    translate([led_placement.x,center_bottom_button_y+led_placement.y,-8])
        cylinder(r=led_radius, h=16, $fn=96);
}

module button_hole() {
    minkowski() {
        cube([button_width+.15, button_height+.15, faceplate_thickness+2], center=true);
        cylinder(r=button_radius+.15, h=1, $fn=64);
    }
}

module bottom_button_holes() {
     for(x=bottom_button_x_offsets) {
          translate([x,center_bottom_button_y,2])
          button_hole();
     }
}

module side_button_holes() {
    for(y = side_button_y_offsets) {
        translate([center_left_button_x,y,2])
            button_hole();
        translate([center_right_button_x,y,2])
            button_hole();
    }
}

module button_holes() {
    if (have_side_buttons==1) {
        side_button_holes();
    }
    if (have_bottom_buttons==1) {
        bottom_button_holes();
    }
}

module button_pcb_boss() {
    cylinder(h=button_boss_height,r=button_boss_radius,$fn=64);
    translate([0,0,-pcb_thickness])
        cylinder(h=pcb_thickness,r=pcb_boss_radius,$fn=64);
}

module side_button_pcb_bosses() {
    for(y = side_button_pcb_offsets) {
        translate([center_left_button_x,y,-button_boss_height])
           button_pcb_boss();
        translate([center_right_button_x,y,-button_boss_height])
           button_pcb_boss();
    }
}

module bottom_button_pcb_bosses() {
    for(x=bottom_button_pcb_offsets) {
        translate([x,center_bottom_button_y,-button_boss_height])
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
        offset(r=faceplate_inset+2,$fn=64)
            polygon(points=[
            [-display_width/2+faceplate_inset+2+display_left_bezel,-display_height/2+faceplate_inset+2+display_bottom_bezel],
            [-display_width/2+faceplate_inset+2+display_left_bezel, display_height/2-faceplate_inset-2-display_top_bezel],
            [display_width/2-faceplate_inset-2-display_right_bezel, display_height/2-faceplate_inset-2-display_top_bezel],
            [display_width/2-faceplate_inset-2-display_right_bezel,-display_height/2+faceplate_inset+2+display_bottom_bezel]]);
}

module front_frame_boss() {
    cylinder(h=flange_height,r=frame_boss_radius,$fn=64);
}

module front_frame_bosses() {
    for (t = bolt_hole_centers) {
        translate([t.x, t.y, -flange_height])
            front_frame_boss();
    }
}

module faceplate_assembly() {
    translate([0,0,-flange_height])
        flange(flange_height);
    translate([0,0,faceplate_thickness/2])
        faceplate();
    if (have_side_buttons==1) side_button_pcb_bosses();
    if (have_bottom_buttons==1) bottom_button_pcb_bosses();
    front_frame_bosses();
}

module front_frame() {
    difference() {
        faceplate_assembly();
        outside_trim_all();
        if (have_side_buttons==1 || have_bottom_buttons==1) button_holes();
        faceplate_inner_trim();
        frame_holes(true);
        if (have_led_hole==1) led_hole();
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
    cylinder(h=backframe_boss_height,r=backframe_boss_radius,$fn=64);
}

module side_back_pcb_bosses() {
    for(y = side_button_pcb_offsets) {
        translate([center_left_button_x,y,-backframe_thickness])
            back_pcb_boss();
        translate([center_right_button_x,y,-backframe_thickness])
            back_pcb_boss();
    }
}

module bottom_back_pcb_bosses() {
    for(x=bottom_button_pcb_offsets) {
        translate([x,center_bottom_button_y,-backframe_thickness])
            back_pcb_boss();
    }
}

module back_frame_boss() {
    cylinder(h=backframe_thickness-flange_height,r=frame_boss_radius,$fn=64);
}

module back_frame_bosses() {
    for (t = bolt_hole_centers) {
        translate([t.x, t.y, -backframe_thickness])
            back_frame_boss();
    }
}

module display_pad(thickness) {
     cube([10,5,thickness]);
}

module display_pads() {
    translate([-display_width/2+3,-5,-backframe_thickness+backframe_center_thickness])
        rotate([0,0,90])
            display_pad(backframe_thickness-backframe_center_thickness-display_thickness);
    translate([display_width/2+2,-5,-backframe_thickness+backframe_center_thickness])
        rotate([0,0,90])
            display_pad(backframe_thickness-backframe_center_thickness-display_thickness);
    translate([-45,display_height/2-3,-backframe_thickness+backframe_center_thickness])
        display_pad(backframe_thickness-backframe_center_thickness-display_thickness);
    translate([-45,-display_height/2-2,-backframe_thickness+backframe_center_thickness])
        display_pad(backframe_thickness-backframe_center_thickness-display_thickness);
    translate([45,display_height/2-3,-backframe_thickness+backframe_center_thickness])
        display_pad(backframe_thickness-backframe_center_thickness-display_thickness);
    translate([45,-display_height/2-2,-backframe_thickness+backframe_center_thickness])
        display_pad(backframe_thickness-backframe_center_thickness-display_thickness);
}

module bottom_connector_hole() {
    translate([bottom_connector_x,center_bottom_button_y-4,-15])
        cube([15,8,20]);
}

module left_side_connector_hole() {
    translate([center_left_button_x+4,-7,-15])
        rotate(a=[0,0,-90])
            cube([14,8,20]);
}

module right_side_connector_hole() {
    translate([center_right_button_x+4,-7,-15])
        rotate(a=[0,0,90])
            cube([14,8,20]);
}

module display_button_connector_hole() {
   translate([-95,-display_height/2-backframe_inset,-flange_height-3])
       cube([24,10,5]);
}

module back_frame_assy() {
    translate([0,0,-backframe_thickness])
        back_frame_plate();
    translate([0,0,-backframe_thickness/2])
        back_frame_outer_flange();
    translate([0,0,-backframe_thickness])
        flange(backframe_thickness-flange_height);
    if (have_side_buttons==1) side_back_pcb_bosses();
    if (have_bottom_buttons==1) bottom_back_pcb_bosses();
    back_frame_bosses();
    display_pads();
}

module back_frame() {
    difference() {
        back_frame_assy();
        frame_holes(false);
        if (have_connector_holes==1 && have_bottom_buttons==1) bottom_connector_hole();
        if (have_connector_holes==1 && have_side_buttons==1) {
            left_side_connector_hole();
            right_side_connector_hole();
        }
        if (have_display_buttons==1) display_button_connector_hole();
    }
}

front_frame();
back_frame();
