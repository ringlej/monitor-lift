/*[Dimensions]*/
lift_min_height = 28.75;//[28:0.01:40]
storage_width = 12;//[8:30]
monitor_space_width = 46; //[44:0.01:50]
monitor_height = 25.625;
monitor_width = 44;
monitor_low_gap = 2.75;
total_depth = 17;//[16:32]
back_depth = 8.5;//[7:0.1:16]
base_height = 2; //[1:0.1:4]
top_middle_height = 6; //[6:0.01:12]
lift_position = 28.75; //[28.75:0.01:57]
frame_part_width = 1.5;
frame_top_width = 2.25;
frame_middle_width = 2.5;

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
wood_board = 1; //[0.75,1]

/*[Display]*/
imperial = true;
show_dimension_box = true;
show_part_label = true;
show_inside_base_back = true;
show_middle_back = true;
show_vertical_walls = true;
show_front_shelves = true;
show_base = true;
show_back = true;
show_top = true;
show_face_frame = true;
show_air_vent = true;
show_monitor_lift = true;

/*[Hidden]*/
label_size = 1; //[0.5,1,1.5,2]
air_vent_width = 14;
eps = 0.001;

function middle_height() = lift_min_height;
function side_height() = middle_height() + large_board*2;
function shelf_depth() = total_depth - back_depth;// - small_board;
function front_middle_height() = middle_height() - top_middle_height;
function storage_width() = storage_width;
function total_width() = monitor_space_width + storage_width() * 2;
function base_front_width() = total_width()/2 - air_vent_width/2;
function base_floor() = base_height + large_board;
function top_floor() = lift_min_height + base_floor();
function top_shelf_floor() = top_floor() - top_middle_height;
function monitor_floor() = base_floor() + monitor_low_gap + lift_position - lift_min_height;
function scale_factor() = imperial ? 1 : 25.4;
scale_factor=scale_factor();
function unit() = imperial ? chr(34) : str("mm");
unit=unit();

module dimensions() {
    x = large_board*2 + wood_board*2 + total_width();
    y = total_depth + back_board + wood_board;
    z = base_height + large_board*2 + lift_min_height;

    echo(str("Total Dimesions: ",x*scale_factor,unit," x ",y*scale_factor,unit," x ",z*scale_factor,unit));

    if (show_dimension_box) {
        translate([-wood_board, -back_board, 0])
            cube([x, y, z]);
    }
}

module board_part(part, desc, x, y, z, c) {
    echo(str(part,": ",x*scale_factor,unit," x ",y*scale_factor,unit," x ",z*scale_factor,unit," (",desc,")"));
    color(c)
    translate([eps,eps,eps])
        cube([x-eps*2, y-eps*2, z-eps*2]);

    if (show_part_label) {
        translate([x/2, y/2, -eps])
        linear_extrude(z+eps*2)
            text(part, size=label_size, halign="center", valign="center");
        translate([0.5, 0.5, -eps])
        linear_extrude(z+eps*2)
            text(part, size=label_size, halign="left", valign="bottom");
        translate([x-0.5, y-0.5, -eps])
        linear_extrude(z+eps*2)
            text(part, size=label_size, halign="right", valign="top");
        translate([x/2, y-0.5, -eps])
        linear_extrude(z+eps*2)
            text(part, size=label_size, halign="center", valign="top");
        translate([x/2, 0.5, -eps])
        linear_extrude(z+eps*2)
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

module wood_board_part(part, desc, x, y, c) {
    board_part(part, desc, x, y, wood_board, c);
}

module middle_backboard() {
    part = "A";
    desc = "Middle Backboard";
    x = monitor_space_width;
    y = middle_height();
    c = "#7FA0D9";
    difference() {
        small_board_part(part, desc, x, y, c);
        translate([x/2, small_board, -eps])
            linear_extrude(small_board+eps) {
                circle(d=1, $fn=100);
                translate([-0.5, -small_board-eps, 0])
                    square([1, small_board]);
            }
    }
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
    difference() {
        small_board_part(part, desc, x, y, c);
        translate([x/2, small_board, -eps])
            linear_extrude(small_board+eps) {
                circle(d=1, $fn=100);
                translate([-0.5, -small_board-eps, 0])
                    square([1, small_board]);
            }
    }
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
    y = lift_min_height + large_board*2 + wood_board;
    c = "#4E6483";
    back_board_part(part, desc, x, y, c);
}

frame_color = "#EFF53A";
function frame_inside_width() = total_width() + large_board*2 - frame_part_width*2;
function frame_y() = total_depth + wood_board;
module face_side() {
    part = "Q";
    desc = "Face Side";
    x = frame_part_width;
    y = side_height();
    c = frame_color;
    wood_board_part(part, desc, x, y, c);
}

module face_top() {
    part = "R";
    desc = "Face Top";
    x = frame_inside_width();
    y = frame_part_width;
    c = frame_color;
    wood_board_part(part, desc, x, y, c);
}

module face_middle() {
    part = "S";
    desc = "Face Middle";
    x = frame_inside_width();
    y = frame_middle_width;
    c = frame_color;
    wood_board_part(part, desc, x, y, c);
}

module face_bottom_divider() {
    part = "T";
    desc = "Face Bottom Divider";
    x = frame_part_width;
    y = front_middle_height() - frame_middle_width;
    c = frame_color;
    wood_board_part(part, desc, x, y, c);
}

module face_top_divider() {
    part = "U";
    desc = "Face Top Divider";
    x = frame_part_width;
    y = top_middle_height - frame_part_width - small_board;
    c = frame_color;
    wood_board_part(part, desc, x, y, c);
}

module face_bottom() {
    part = "V";
    desc = "Face Bottom";
    x = frame_inside_width();
    y = large_board*2 + small_board;
    c = frame_color;
    wood_board_part(part, desc, x, y, c);
}

function top_width() = frame_inside_width() + frame_part_width*2;
top_color = "#816E41";
top_trim_color = "#CD841F";

module top_front() {
    part = "W";
    desc = "Top Front";
    x = top_width();
    y = shelf_depth() + small_board;
    c = top_color;
    wood_board_part(part, desc, x, y, c);
}

module top_side() {
    part = "X1";
    desc = "Top Side";
    x = storage_width() + large_board;
    y = back_depth - small_board;
    c = top_color;
    wood_board_part(part, desc, x, y, c);
}

module top_middle() {
    part = "X2";
    desc = "Top Middle";
    x = monitor_space_width;
    y = back_depth - small_board;
    c = top_color;
    wood_board_part(part, desc, x, y, c);
}

module top_front_trim() {
    part = "Y";
    desc = "Top Front Trim";
    x = top_width() + wood_board*2;
    y = frame_part_width;
    c = top_trim_color;
    wood_board_part(part, desc, x, y, c);
}

module top_side_trim() {
    part = "Z";
    desc = "Top Side Trim";
    x = total_depth;
    y = frame_part_width;
    c = top_trim_color;
    wood_board_part(part, desc, x, y, c);
}

module monitor() {
    translate([storage_width() + large_board + (monitor_space_width - monitor_width)/2, lift_depth + lift_cross_depth + 1, monitor_floor()])
    rotate([90, 0, 0])
    color("black")
        cube([monitor_width, monitor_height, 1]);
}

module lift() {
    color("#CCD3A0") {
        translate([storage_width() + large_board + (monitor_space_width - lift_width)/2, 0, base_floor()])
            cube([lift_width, lift_base_depth, lift_base_height]);
    
        translate([storage_width() + large_board + (monitor_space_width - lift_width)/2, 0, base_floor() + lift_base_height])
            cube([lift_width, lift_depth, lift_position - lift_base_height]);
    
        translate([storage_width() + large_board + (monitor_space_width - lift_cross_width)/2, lift_depth, monitor_floor() + lift_cross_height])
            cube([lift_cross_width, lift_cross_depth, lift_cross_height]);
    }
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
    if(show_middle_back) {
        translate([storage_width() + large_board, back_depth, base_floor()])
        rotate([90, 0, 0])
            middle_backboard();
    }

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

    translate([base_front_width(), large_board, 0])
    rotate([90, 0, 90])
        base_joist();

    translate([large_board + base_front_width() + air_vent_width, large_board, 0])
    rotate([90, 0, 90])
        base_joist();

    translate([storage_width(), large_board, 0])
    rotate([90, 0, 90])
        base_joist();

    translate([large_board + monitor_space_width + storage_width(), large_board, 0])
    rotate([90, 0, 90])
        base_joist();

    translate([total_width(), 0, 0])
    rotate([90, 0, 90])
        base_side();

    if(show_air_vent)
        translate([total_width()/2 + large_board, 4, 0])
        color("brown")
            square([13.5, 5.5],true); 
}

module back() {
    translate([0, 0, base_height - large_board])
    rotate([90, 0, 0])
        back_board();
}

function top_middle_floor() = top_floor() + (show_monitor_lift ? (lift_position - lift_min_height) : 0);
        
module top() {
    translate([0, back_depth - small_board, top_floor()])
        top_front();
    
    translate([0, 0, top_floor()])
        top_side();

    translate([storage_width() + monitor_space_width + large_board, 0, top_floor()])
        top_side();

    translate([storage_width() + large_board, 0, top_middle_floor()])
        top_middle();
    
    translate([-wood_board, total_depth + wood_board, top_floor() - small_board])
    rotate([90, 0, 0])
        top_front_trim();
    
    translate([-wood_board, 0, top_floor() - small_board])
    rotate([90, 0, 90])
        top_side_trim();

    translate([total_width() + small_board + wood_board, 0, top_floor() - small_board])
    rotate([90, 0, 90])
        top_side_trim();

}

module face_frame() {
    translate([0, frame_y(), base_height - large_board])
    rotate([90, 0, 0])
        face_side();

    translate([storage_width() - large_board/2, frame_y(), base_floor() + small_board])
    rotate([90, 0, 0])
        face_bottom_divider();
    
    translate([storage_width() + monitor_space_width + large_board/2, frame_y(), base_floor() + small_board])
    rotate([90, 0, 0])
        face_bottom_divider();

    translate([storage_width() + monitor_space_width + large_board/2, frame_y(), top_shelf_floor() + small_board])
    rotate([90, 0, 0])
        face_top_divider();
    
    translate([monitor_space_width/2 + storage_width() + small_board/2, frame_y(), top_shelf_floor() + small_board])
    rotate([90, 0, 0])
        face_top_divider();
    
    translate([storage_width() - large_board/2, frame_y(), top_shelf_floor() + small_board])
    rotate([90, 0, 0])
        face_top_divider();
    
    translate([total_width(), frame_y(), base_height - large_board])
    rotate([90, 0, 0])
        face_side();
    
    translate([frame_part_width, frame_y(), top_floor() - frame_part_width])
    rotate([90, 0, 0])
        face_top();

    translate([frame_part_width, frame_y(), top_shelf_floor() - frame_middle_width + small_board])
    rotate([90, 0, 0])
        face_middle();

    translate([frame_part_width, frame_y(), base_height - large_board])
    rotate([90, 0, 0])
        face_bottom();
}

scale([scale_factor, scale_factor, scale_factor]) {
    %dimensions();
    if(show_inside_base_back) inside_base_back();
    if(show_vertical_walls) vertical_walls();
    if(show_front_shelves) front_shelves();
    if(show_base) base();
    if(show_back) back();
    if(show_top) top();
    if(show_monitor_lift) {
        monitor();
        lift();
    }
    if(show_face_frame) face_frame();
}
