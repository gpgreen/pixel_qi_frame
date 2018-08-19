display_width=234;
display_height=143;
display_top_bezel=8;
display_bottom_bezel=8;
display_left_bezel=4;
display_right_bezel=6;

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

button_width=10;
button_height=6;
button_thickness=faceplate_thickness+2;
button_rad=1;
num_bot_buttons=6;
num_side_buttons=5;
button_bottom_offset=5;
button_side_offset=5;

pcb_thickness=1;

button_boss_radius=3;
button_boss_height=3.5;

backframe_boss_radius=3;
backframe_boss_height=backframe_thickness-pcb_thickness-button_boss_height;

frame_boss_radius=3;

// Vector of display corners
display_corners = [
    [-display_width/2-faceplate_lside_width,-display_height/2-faceplate_bottom_width,0],
    [-display_width/2-faceplate_lside_width,display_height/2+faceplate_top_width,0],
    [display_width/2+faceplate_rside_width,display_height/2+faceplate_top_width,0],
    [display_width/2+faceplate_rside_width,-display_height/2-faceplate_bottom_width,0]
];
