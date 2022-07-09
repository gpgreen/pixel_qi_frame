// Display for Pixel Qi lcd panel
// Copyright 2022 Greg Green
//
// graphics_box.scad

include <frame_config.scad>

// some derived variables
pcb_plane_z = graphics_box_height-graphics_box_thickness-graphics_pcb_boss_height;
box_width = graphics_pcb_width+graphics_pcb_offset*2;
box_height = graphics_pcb_height+graphics_pcb_offset*2;

module graphics_pcb_boss() {
    cylinder(h=graphics_pcb_boss_height,r=graphics_pcb_boss_radius,$fn=64);
}

module graphics_pcb_bosses() {
    for(coord=graphics_pcb_coords) {
        x = coord[0]+graphics_pcb_offset; y = coord[1]+graphics_pcb_offset;
        translate([x,y,pcb_plane_z])
           graphics_pcb_boss();
    }
}

module graphics_pcb_boss_hole(use_insert) {
    rad = use_insert ? graphics_pcb_insert_radius : graphics_pcb_hole_radius;
    cylinder(h=100,r=rad,$fn=96);
}

module graphics_pcb_boss_holes(use_insert) {
    for(coord=graphics_pcb_coords) {
        x = coord[0]+graphics_pcb_offset; y = coord[1]+graphics_pcb_offset;
        translate([x,y,-50])
           graphics_pcb_boss_hole(use_insert);
    }
}

module graphics_conx_hole() {
    translate([graphics_pcb_offset+graphics_box_thickness+2,
               box_height+2,
               pcb_plane_z-10])
        rotate([90,0,0])
        minkowski() {
            cube([38,5,6]);
            cylinder(r=6,h=6,$fn=64);
        }
}

module graphics_box_flange() {
     translate([-(display_width/2-box_width/2),-(display_height/2-box_height/2),0])
          cube([display_width,display_height,graphics_box_thickness]);
}

module graphics_box() {
    difference() {
        union() {
            cube([box_width,box_height,graphics_box_height]);
            graphics_box_flange();
        }
        // remove the interior of the box
        translate([graphics_box_thickness,graphics_box_thickness,-graphics_box_thickness])
            cube([box_width-graphics_box_thickness*2,
                  box_height-graphics_box_thickness*2,
                  graphics_box_height-graphics_box_thickness]);
    }
    graphics_pcb_bosses();
}

module graphics_box_assy() {
    translate([-box_width/2,box_height/2,-backframe_thickness])
        rotate([0,180,180]) {
            difference() {
                graphics_box();
                graphics_pcb_boss_holes(true);
                graphics_conx_hole();
            }
            if (show_pcbs==1)
                graphics_pcb();
        }
}

module graphics_pcb() {
    color("ForestGreen", 1.0) {
        difference() {
            translate([graphics_pcb_offset,graphics_pcb_offset,pcb_plane_z-graphics_pcb_thickness]) {
                cube([graphics_pcb_width,graphics_pcb_height,graphics_pcb_thickness]);
            }
            graphics_pcb_boss_holes(false);
        }
    }
}

graphics_box_assy();
