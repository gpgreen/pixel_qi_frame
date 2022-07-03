have_side_buttons=0;
have_bottom_buttons=1;
have_led_hole=1;
have_connector_holes=0;

display_width=234;
display_height=143;
display_top_bezel=8;
display_bottom_bezel=8;
display_left_bezel=4;
display_right_bezel=6;

flange_height=5;
flange_gap=1;
flange_width=2;

faceplate_inset=2;
faceplate_lside_width=(have_side_buttons==1)? 22 : 6;
faceplate_rside_width=(have_side_buttons==1)? 20 : 6;
faceplate_top_width=6;
faceplate_bottom_width=(have_bottom_buttons==1)? 25 : 6;
faceplate_thickness=4;

backframe_thickness=11;
backframe_center_thickness=2;
backframe_inset=5;

// bottom button placement
bottom_button_x_offsets = [-100, -82, -69, -53, -36];
bottom_button_pcb_offsets = [-91, -45];
bottom_connector_x = -20;

//button_width=10;
//button_height=6;
button_width=6;
button_height=4;
button_thickness=faceplate_thickness+2;
button_rad=1;
num_side_buttons=5;
// center of button offset from outer frame edge
button_bottom_offset=5;
// inner edge of button offset from inner frame edge
button_side_offset=5;

// bosses
pcb_boss_radius=2;
pcb_thickness=1.5;

button_boss_radius=3;
button_boss_height=5.5;

backframe_boss_radius=3;
backframe_boss_height=backframe_thickness-pcb_thickness-button_boss_height;

// frame holes
frame_hole_rad = 1.6;
frame_boss_radius=3;

// led coord
led_placement = [-103,-display_height/2-faceplate_bottom_width+button_bottom_offset+button_height/2+7];
led_rad = 2;
cut_gap=.2;

// Vector of display corners
display_corners = [
    [-display_width/2-faceplate_lside_width,-display_height/2-faceplate_bottom_width,0],
    [-display_width/2-faceplate_lside_width,display_height/2+faceplate_top_width,0],
    [display_width/2+faceplate_rside_width,display_height/2+faceplate_top_width,0],
    [display_width/2+faceplate_rside_width,-display_height/2-faceplate_bottom_width,0]
];
