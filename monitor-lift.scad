/*[Dimensions]*/
monitor_space_height = 28.75;//[28:0.01:40]
monitor_space_width = 48; //[44:0.01:50]
monitor_height = 25.625;
monitor_width = 44;
monitor_low_gap = 2.75;
total_depth = 24;//[20:32]
back_depth = 9;//[7:16]
base_height = 2; //[1:0.1:4]
top_middle_height = 6; //[6:12]
lift_position = 28.75; //[28.75:0.01:57]

/*[Lift Dimensions]*/
lift_width = 7;
lift_base_depth = 7;
lift_base_height = 2.5;
lift_depth = 4.5;
lift_cross_width = 19;
lift_cross_height = 8;
lift_cross_base_height = 10;
lift_cross_depth = 1.5;

/*[Board Thickness]*/
large_board = 0.75; //[0.5,0.75,1]
small_board = 0.50; //[0.125,0.25,0.5,0.75]
back_board = 0.250; //[0.125,0.25,0.375]

/*[Display]*/
imperial = true;
show_part_label = true;
show_inside_base_back = true;
show_vertical_walls = true;
show_front_shelves = true;
show_base = true;
show_back = true;
show_air_vent = true;
show_monitor_lift = true;

/*[Hidden]*/
label_size = 1; //[0.5,1,1.5,2]
air_vent_width = 14;

function middle_height() = monitor_space_height;
function side_height() = middle_height() + large_board*2;
function shelf_depth() = total_depth - back_depth;
function front_middle_height() = middle_height() - top_middle_height;
function storage_width() = monitor_space_width / 2;
function total_width() = monitor_space_width + storage_width() * 2;
function base_front_width() = total_width()/2 - air_vent_width/2;
function base_floor() = base_height + large_board;
function top_shelf_floor() = monitor_space_height + base_floor() - top_middle_height;
function monitor_floor() = base_floor() + monitor_low_gap + lift_position - monitor_space_height;
function scale_factor() = imperial ? 1 : 25.4;
scale_factor=scale_factor();
function unit() = imperial ? chr(34) : str("mm");
unit=unit();

module board_part(part, desc, x, y, z, c) {
    echo(str(part,": ",x*scale_factor,unit," x ",y*scale_factor,unit," x ",z*scale_factor,unit," (",desc,")"));
    color(c)
        cube([x, y, z]);
    
    if (show_part_label) {
        translate([x/2, y/2, -0.01])
        linear_extrude(z+0.01)
            text(part, size=label_size, halign="center", valign="center");
        translate([0.5, 0.5, -0.01])
        linear_extrude(z+0.01)
            text(part, size=label_size, halign="left", valign="bottom");
        translate([x-0.5, y-0.5, -0.01])
        linear_extrude(z+0.01)
            text(part, size=label_size, halign="right", valign="top");
        translate([x/2, y-0.5, -0.01])
        linear_extrude(z+0.01)
            text(part, size=label_size, halign="center", valign="top");
        translate([x/2, 0.5, -0.01])
        linear_extrude(z+0.01)
            text(part, size=label_size, halign="center", valign="bottom");
    }
}

module large_board_part(part, desc, x, y, c) {
    board_part(part, desc, x, y, large_board, c);
}

module small_board_part(part, desc, x, y, c) {
    board_part(part, desc, x, y, small_board, c);
}

module back_board_part(part, desc, x, y, c) {
    board_part(part, desc, x, y, back_board, c);
}

module middle_backboard() {
    part = "A";
    desc = "Middle Backboard";
    x = monitor_space_width;
    y = middle_height();
    c = "#7FA0D9";
    small_board_part(part, desc, x, y, c);
}

module bottom() {
    part = "B";
    desc = "Bottom";
    x = total_width();
    y = total_depth;
    c = "#DD9038";
    large_board_part(part, desc, x, y, c);
}

module bottom_shelf_middle() {
    part = "C";
    desc = "Bottom Shelf Middle";
    x = monitor_space_width;
    y = shelf_depth();
    c = "#A6CC79";
    small_board_part(part, desc, x, y, c);
}

module bottom_shelf_side() {
    part = "D";
    desc = "Bottom Shelf Side";
    x = storage_width() - large_board;
    y = total_depth;
    c = "#6E8A48";
    small_board_part(part, desc, x, y, c);
}

module middle_side_back_wall() {
    part = "E";
    desc = "Middle Side Back Wall";
    x = back_depth;
    y = middle_height();
    c = "#BCA491";
    large_board_part(part, desc, x, y, c);
}

module middle_side_front_wall() {
    part = "F";
    desc = "Middle Side Front Wall";
    x = shelf_depth();
    y = front_middle_height();
    c = "#7B7066";
    large_board_part(part, desc, x, y, c);
}

module side_wall() {
    part = "G";
    desc = "Side Wall";
    x = total_depth;
    y = side_height();
    c = "#A69183";
    large_board_part(part, desc, x, y, c);
}

module middle_top_part_wall() {
    part = "H";
    desc = "Middle Top Part Wall";
    x = shelf_depth();
    y = top_middle_height - small_board;
    c = "#8C9261";
    large_board_part(part, desc, x, y, c);
}

module middle_middle_top_part_wall() {
    part = "I";
    desc = "Middle Middle Top Part Wall";
    x = shelf_depth();
    y = top_middle_height - small_board;
    c = "#8C9261";
    small_board_part(part, desc, x, y, c);
}

module top_middle_shelf() {
    part = "J";
    desc = "Top Middle Shelf";
    x = total_width();
    y = shelf_depth();
    c = "#6E8B48";
    small_board_part(part, desc, x, y, c);
}

module top_middle_back_shelf() {
    part = "K";
    desc = "Top Middle Back Shelf";
    x = storage_width() - large_board;
    y = back_depth;
    c = "#819854";
    small_board_part(part, desc, x, y, c);
}

module base_front() {
    part = "L";
    desc = "Base Front";
    x = base_front_width();
    y = base_height;
    c = "#5C7144";
    large_board_part(part, desc, x, y, c);
}

module base_back() {
    part = "M";
    desc = "Base Back";
    x = total_width() - large_board*2;
    y = base_height;
    c = "#5C7144";
    large_board_part(part, desc, x, y, c);
}

module base_side() {
    part = "N";
    desc = "Base Side";
    x = total_depth - large_board;
    y = base_height;
    c = "#5F7A42";
    large_board_part(part, desc, x, y, c);
}

module base_joist() {
    part = "O";
    desc = "Base Joist";
    x = total_depth - large_board*2;
    y = base_height;
    c = "#456080";
    large_board_part(part, desc, x, y, c);
}

module back_board() {
    part = "P";
    desc = "Back Board";
    x = total_width() + large_board*2;
    y = monitor_space_height + large_board;
    c = "#4E6483";
    back_board_part(part, desc, x, y, c);
}

module monitor() {
    translate([storage_width() + large_board + (monitor_space_width - monitor_width)/2, lift_depth + lift_cross_depth + 1, monitor_floor()])
    rotate([90, 0, 0])
    color("black")
        cube([monitor_width, monitor_height, 1]);
}

module lift() {
    translate([storage_width() + large_board + (monitor_space_width - lift_width)/2, 0, base_floor()])
    color("#CCD3A0")
        cube([lift_width, lift_base_depth, lift_base_height]);
    
    translate([storage_width() + large_board + (monitor_space_width - lift_width)/2, 0, base_floor() + lift_base_height])
        cube([lift_width, lift_depth, lift_position - lift_base_height]);
    
    translate([storage_width() + large_board + (monitor_space_width - lift_cross_width)/2, lift_depth, monitor_floor() + lift_cross_height])
        cube([lift_cross_width, lift_cross_depth, lift_cross_height]);
}

module front_shelves() {
    translate([large_board, back_depth, top_shelf_floor()])
        top_middle_shelf();
    
    translate([large_board, 0, top_shelf_floor()])
        top_middle_back_shelf();

    translate([monitor_space_width + storage_width() + large_board*2, 0, top_shelf_floor()])
        top_middle_back_shelf();

    translate([storage_width(), back_depth, top_shelf_floor() + small_board])
    rotate([90, 0, 90])
        middle_top_part_wall();

    translate([monitor_space_width/2 + storage_width() + large_board, back_depth, top_shelf_floor() + small_board])
    rotate([90, 0, 90])
        middle_middle_top_part_wall();

    translate([monitor_space_width + storage_width() + large_board, back_depth, top_shelf_floor() + small_board])
    rotate([90, 0, 90])
        middle_top_part_wall();
}

module inside_base_back() {
    translate([storage_width() + large_board, back_depth, base_floor()])
    rotate([90, 0, 0])
        middle_backboard();
    
    translate([large_board, 0, base_height])
        bottom();
    
    translate([storage_width() + large_board, back_depth, base_floor()])
        bottom_shelf_middle();

    translate([large_board, 0, base_floor()])
    bottom_shelf_side();

    translate([monitor_space_width + storage_width() + large_board + large_board, 0, base_floor()])
    bottom_shelf_side();
}

module vertical_walls() {
    translate([storage_width(), 0, base_floor()])
    rotate([90, 0, 90])
        middle_side_back_wall();

    translate([storage_width() + monitor_space_width + large_board, 0, base_floor()])
    rotate([90, 0, 90])
        middle_side_back_wall();
    
    translate([storage_width(), back_depth, base_floor()])
    rotate([90, 0, 90])
        middle_side_front_wall();

    translate([storage_width() + monitor_space_width + large_board, back_depth, base_floor()])
    rotate([90, 0, 90])
        middle_side_front_wall();
    
    translate([0, 0, base_height - large_board])
    rotate([90, 0, 90])
        side_wall();

    translate([total_width() + large_board, 0, base_height - large_board])
    rotate([90, 0, 90])
        side_wall();
}

module base() {
    translate([large_board, total_depth, 0])
    rotate([90, 0, 0])
        base_front();

    translate([large_board + base_front_width() + air_vent_width, total_depth, 0])
    rotate([90, 0, 0])
        base_front();
    
    translate([large_board*2, large_board, 0])
    rotate([90, 0, 0])
        base_back();
    
    translate([large_board, 0, 0])
    rotate([90, 0, 90])
        base_side();

    translate([large_board + base_front_width() - large_board, large_board, 0])
    rotate([90, 0, 90])
        base_joist();

    translate([large_board + base_front_width() + air_vent_width, large_board, 0])
    rotate([90, 0, 90])
        base_joist();

    translate([large_board + storage_width() - large_board, large_board, 0])
    rotate([90, 0, 90])
        base_joist();

    translate([large_board + monitor_space_width + storage_width(), large_board, 0])
    rotate([90, 0, 90])
        base_joist();

    translate([large_board + total_width() - large_board, 0, 0])
    rotate([90, 0, 90])
        base_side();

    if(show_air_vent)
        translate([total_width()/2 + large_board, 4, 0])
        color("brown")
            square([13.5, 5.5],true); 
}

module back() {
    translate([0, 0, base_height])
    rotate([90, 0, 0])
        back_board();
}

scale([scale_factor, scale_factor, scale_factor]) {
    if(show_inside_base_back) inside_base_back();
    if(show_vertical_walls) vertical_walls();
    if(show_front_shelves) front_shelves();
    if(show_base) base();
    if(show_back) back();
    if(show_monitor_lift) {
        monitor();
        lift();
    }
}
