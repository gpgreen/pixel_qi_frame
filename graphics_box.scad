// Display for Pixel Qi lcd panel
// Copyright 2022 Greg Green
//
// graphics_box.scad

include <frame_config.scad>

pcb_plane_z = graphics_box_height-graphics_box_thickness-graphics_pcb_boss_height;

module graphics_pcb() {
    color("ForestGreen", 1.0) {
    translate([(graphics_pcb_width+20)/2,-(graphics_pcb_height+20)/2,-backframe_thickness])
        rotate([0,180,0]) {
            difference() {
                translate([10,10,pcb_plane_z-graphics_pcb_thickness]) {
                    cube([graphics_pcb_width,graphics_pcb_height,graphics_pcb_thickness]);
                }
                graphics_pcb_boss_holes();
            }
        }
    }
}

module graphics_pcb_boss() {
    cylinder(h=graphics_pcb_boss_height,r=graphics_pcb_boss_radius,$fn=64);
}

module graphics_pcb_bosses() {
    for(coord=graphics_pcb_coords) {
        x = coord[0]+10; y = coord[1]+10;
        translate([x,y,pcb_plane_z])
           graphics_pcb_boss();
    }
}

module graphics_pcb_boss_hole() {
    cylinder(h=100,r=graphics_pcb_hole_radius,$fn=96);
}

module graphics_pcb_boss_holes() {
    for(coord=graphics_pcb_coords) {
        x = coord[0]+10; y = coord[1]+10;
        translate([x,y,-50])
           graphics_pcb_boss_hole();
    }
}

module graphics_box_flange() {
     translate([-(display_width/2-(graphics_pcb_width+20)/2),-(display_height/2-(graphics_pcb_height+20)/2),0])
          cube([display_width,display_height,graphics_box_thickness]);
}

module graphics_box_assy() {
    difference() {
        union() {
            cube([graphics_pcb_width+20,graphics_pcb_height+20,graphics_box_height]);
            graphics_box_flange();
        }
        translate([graphics_box_thickness,graphics_box_thickness,-graphics_box_thickness])
            cube([graphics_pcb_width+20-graphics_box_thickness*2,
                  graphics_pcb_height+20-graphics_box_thickness*2,
                  graphics_box_height-graphics_box_thickness]);
    }
    graphics_pcb_bosses();
}

module graphics_box() {
    translate([(graphics_pcb_width+20)/2,-(graphics_pcb_height+20)/2,-backframe_thickness])
        rotate([0,180,0]) {
            difference() {
                graphics_box_assy();
                graphics_pcb_boss_holes();
            }
        }
}

graphics_box();
graphics_pcb();
