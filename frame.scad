display_width=234;
display_height=143;
display_top_bezel=8;
display_bottom_bezel=8;
display_left_bezel=4;
display_right_bezel=6;

button_width=10;
button_height=6;
num_buttons=6;

flange_width=2;
flange_height=4;

faceplate_inset=2;
faceplate_lside_width=8;
faceplate_rside_width=10;
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

module outside_frame() {
    translate([0,0,-flange_height/2])
        flange();
    translate([0,0,faceplate_thickness/2])
        faceplate();
}

outside_frame();