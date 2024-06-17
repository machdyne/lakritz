/*
 * Lakritz Case
 * Copyright (c) 2024 Lone Dynamics Corporation. All rights reserved.
 *
 * required hardware:
 *  - 4 x M3 x 25mm countersunk bolts
 *  - 4 x M3 nuts
 *
 */

$fn = 100;

board_width = 47;
board_thickness = 1.5;
board_length = 76;
board_height = 1.6;
board_spacing = 2;

wall = 1.5;

top_height = 20;
bottom_height = 6;

translate([wall,wall,0]) mdy_board();

translate([0,0,15])
	mdy_case_top();

translate([0,0,-15])
	mdy_case_bottom();

translate([0,0,25])
	mdy_case_cap();

module mdy_board() {
	
	difference() {
		color([0,0.5,0])
			roundedcube(board_width,board_length,board_thickness,5);
		translate([5, 5, -1]) cylinder(d=3.2, h=10);
		translate([5, 76-5, -1]) cylinder(d=3.2, h=10);
		translate([47-5, 5, -1]) cylinder(d=3.2, h=10);
		translate([47-5, 76-5, -1]) cylinder(d=3.2, h=10);
	}	
	
}

module mdy_case_cap() {

	translate([wall, wall, 0]) {
				
		difference() {
			union() {
				translate([23.5-(23.5/2),13.25,19]) cube([23.5,17.5,3]);
				translate([23.5-(21.8/2),14,15]) cube([21.8,16,5]);
			}
			translate([23.5-(20/2),15,11]) cube([20,14,10]);
		}
	}
}

module mdy_case_top() {

	translate([0,25,19])
		rotate([90,0,270])
			translate([-0,-10,0])
				linear_extrude(1)
					text("L A K R I T Z", size=4, halign="center",
						font="Liberation Sans:style=Bold");
	

	// supports
	translate([wall, wall, 0]) {
		translate([44.5,17.1,0]) cube([3.5,7.15,19]);
	}
	
	difference() {
				
		color([0.5,0.5,0.5])
			roundedcube(board_width+(wall*2),board_length+(wall*2),top_height,5);

		// cutouts
			
		translate([2,9.5,-2])
			roundedcube(board_width-1.25,board_length-16,20,5);

		translate([9.5,2,-2])
			roundedcube(board_width-16,board_length,20,5);			
	
		translate([wall, wall, 0]) {

			// vents
			translate([47/2-(15/2),60,0]) rotate([0,0,-10]) cube([15,1,25]);
			translate([47/2-(15/2),55,0]) rotate([0,0,-10]) cube([15,1,25]);
			translate([47/2-(15/2),50,0]) rotate([0,0,-10]) cube([15,1,25]);
	
			// USBC
			translate([30,60.2-(9.5/2),0]) cube([30,9.5,3.5]);

			// DDMI
			translate([30,32-(15.5/2),-1]) cube([30,15.5,6+1]);

			// AUDIO
			translate([30,14-(6.2/2),-1]) cube([30,6.2,5+1]);
			
			// DUAL USBA
			translate([23.5-(15/2),-5,0]) cube([15,10,15.8+1]);
	
			// SD
			translate([-10,26-(15/2),-2]) cube([15,15,2+2]);

			// LED
			//translate([-10,12.5-(2/2),0]) cube([20,1,1]);
			
			// PMODA
			translate([-10,53.625-(16/2),0]) cube([25,16,5.1]);

			// MMOD VERTICAL
			translate([23.5-(22/2),14,15]) cube([22,16,10]);
			
			// bolt holes
			translate([5, 5, -21]) cylinder(d=3.5, h=40);
			translate([5, 76-5, -21]) cylinder(d=3.5, h=40);
			translate([47-5, 5, -20]) cylinder(d=3.5, h=40);
			translate([47-5, 76-5, -21]) cylinder(d=3.5, h=40);

			// flush mount bolt holes
			translate([5, 5, top_height-1.5]) cylinder(d=5.25, h=4);
			translate([5, 76-5, top_height-1.5]) cylinder(d=5.25, h=4);
			translate([47-5, 5, top_height-1.5]) cylinder(d=5.25, h=4);
			translate([47-5, 76-5, top_height-1.5]) cylinder(d=5.25, h=4);


		}
		
	}	
}

module mdy_case_bottom() {
	
	difference() {
		color([0.5,0.5,0.5])
			roundedcube(board_width+(wall*2),board_length+(wall*2),bottom_height,5);
		
		// cutouts
		translate([3,10,1.5])
			roundedcube(board_width-3,board_length-17,10,5);
				
		translate([10.5,2.5,1.5])
			roundedcube(board_width-17.5,board_length-2,10,5);

		translate([wall, wall, 0]) {
			
		// board cutout
		translate([0,0,bottom_height-board_height])
			roundedcube(board_width+0.2,board_length+0.2,board_height+1,2.5);

		translate([wall, wall, 0]) {

			// USBC
			translate([30.5,60.2-(12.5/2),1.5]) cube([15.2,12.5,10.5+1]);

		}

		// bolt holes
		translate([5, 5, -11]) cylinder(d=3.2, h=25);
		translate([5, 76-5, -11]) cylinder(d=3.2, h=25);
		translate([47-5, 5, -11]) cylinder(d=3.2, h=25);
		translate([47-5, 76-5, -11]) cylinder(d=3.2, h=25);

		// nut holes
		translate([5, 5, -1]) cylinder(d=7, h=4, $fn=6);
		translate([5, 76-5, -1]) cylinder(d=7, h=4, $fn=6);
		translate([47-5, 5, -1]) cylinder(d=7, h=4, $fn=6);
		translate([47-5, 76-5, -1]) cylinder(d=7, h=4, $fn=6);

		}
		
	}	
}

// https://gist.github.com/tinkerology/ae257c5340a33ee2f149ff3ae97d9826
module roundedcube(xx, yy, height, radius)
{
    translate([0,0,height/2])
    hull()
    {
        translate([radius,radius,0])
        cylinder(height,radius,radius,true);

        translate([xx-radius,radius,0])
        cylinder(height,radius,radius,true);

        translate([xx-radius,yy-radius,0])
        cylinder(height,radius,radius,true);

        translate([radius,yy-radius,0])
        cylinder(height,radius,radius,true);
    }
}
