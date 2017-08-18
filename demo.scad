/*
 * SymmetryCAD - The OpenSCAD crystallographic toolbox
 *
 * License: LGPL 2.1 or later
 */


// DEMO
// Examples and README figures
// Most slides should be viewed from the top view


include <SymmetryCAD/SymmetryCAD.scad>
// use <SymmetryCAD/coordinates.scad>


// Snowflake figures
module snowflake_branch() {
    // Main star
    cube([2,50,1]);
    // First branch
    translate([0,25,0])
    rotate([0,0,-60])
    cube([2,24,1]);
    // Second branch
    translate([7,25/2,0])
    cube([1,25,1]);
}
module slide1a() {
    snowflake_branch();
}
module slide1b() {
    unit_cell(pg_dnh(6),cell0_point()) {
        snowflake_branch();
    }
}

// All point groups
module axial_point_group(pg,label="") {
    // Generate symmetry
    cell = cell0_axis(10);
    unit_cell(pg,cell) {
        color([0,0,1])
        rotate([0,0,30])
        translate([30,0,0])
        rotate([90,0,90])
        // triangle object
        linear_extrude(1)
        polygon( [[0,0],[0,10*sqrt(3)/2],[-5,0]] );
    }
    
    // Rotation circle
    rotate_extrude(convexity=10, $fn=32)
    translate([30,0,0])
    circle(r = .5, $fn=16);

    // Grey rotation cylinder
    %difference() {
        cylinder(r=30, h=30, center=true,$fn=100);
        cylinder(r=30-.1, h=30+2, center=true,$fn=100);
    }
    
    // Label
    if(label != undef && label != "") {
        rotate([45,0,0]) // Tilt towards camera
        linear_extrude(1)
        text(label, size=8, halign="center", valign="center");
    } else {
        sphere(r=1);
    }
}
module polyhedral_point_group(pg,label="") {
    cell = cell0_point();
    unit_cell(pg,cell) {

        translate([30,10,10])
        scale([.5,.5,.5])
        testcube(back=false);            
    }
    // Label
    if(label != undef && label != "") {
        translate([0,-70,0])
        rotate([3,0,0]) // Tilt towards camera
        linear_extrude(1)
        text(label, size=8, halign="center", valign="center");
    } else {
        sphere(r=1);
    }
}
module point_group_grid() {
    xspacing = 110;
    yspacing = 120;

    translate([-1.5*xspacing,1.3*yspacing,0])
    rotate([-45,0,0])
    axial_point_group(pg_cn(6),"cn");
    translate([-0.5*xspacing,1.3*yspacing,0])
    rotate([-45,0,0])
    axial_point_group(pg_s2n(6),"s2n");
    translate([ 0.5*xspacing,1.3*yspacing,0])
    rotate([-45,0,0])
    axial_point_group(pg_cnh(6),"cnh");
    translate([ 1.5*xspacing,1.3*yspacing,0])
    rotate([-45,0,0])
    axial_point_group(pg_cnv(6),"cnv");

    translate([-1*xspacing, .4*yspacing,0])
    rotate([-45,0,0])
    axial_point_group(pg_dn(6),"dn");
    translate([ 0*xspacing, .4*yspacing,0])
    rotate([-45,0,0])
    axial_point_group(pg_dnd(6),"dnd");
    translate([ 1*xspacing, .4*yspacing,0])
    rotate([-45,0,0])
    axial_point_group(pg_dnh(6),"dnh");

    translate([-1*xspacing,-.5*yspacing,0])
    rotate([-30,0,0]) {
        tetrahedron_frame(100);
        polyhedral_point_group(pg_t,"t");
    }
    translate([-0*xspacing,-.5*yspacing,0])
    rotate([-30,0,0]) {
        tetrahedron_frame(100);
        polyhedral_point_group(pg_td,"td");
    }
    translate([ 1*xspacing,-.5*yspacing,0])
    rotate([-30,0,0]) {
        //tetrahedron_frame(40);
        pyritohedron_frame(100,.3);
        polyhedral_point_group(pg_th,"th");
    }

    translate([-1.5*xspacing,-1.5*yspacing,0])
    rotate([-30,0,0]) {
        cube_frame(80);
        polyhedral_point_group(pg_o,"o");
    }
    translate([-0.5*xspacing,-1.5*yspacing,0])
    rotate([-30,0,0]) {
        cube_frame(80);
        polyhedral_point_group(pg_oh,"oh");
    }
    translate([ 0.5*xspacing,-1.5*yspacing,0])
    rotate([-30,0,0]) {
        pyritohedron_frame(90);
        polyhedral_point_group(pg_i,"i");
    }
    translate([ 1.5*xspacing,-1.5*yspacing,0])
    rotate([-30,0,0]) {
        pyritohedron_frame(90);
        polyhedral_point_group(pg_ih,"ih");
    }
}

module slide2() {
    point_group_grid();
}

// Wallpaper groups
module character() {
    // DEVANAGARI OM (https://en.wikipedia.org/wiki/Om), 12x12mm
    // Comes with Macs; Windows may need a different font
    color([0,0,1])
    linear_extrude(1)
    text("\u0950",font="Arial Unicode MS");
}

module wallpaper(wg,cell,label="") {
    intersection() {
        cube([100,100,10],center=true);
        covering_lattice([100,100],cell) {
            unit_cell_frame(cell);
            unit_cell(wg,cell)
            character();
        }
    }
    color([0,0,1])
    difference() {
        cube([100,100,1],center=true);
        cube([99,99,10],center=true);
    }
    translate([0,-60,0])
    linear_extrude(1)
    text(label, size=8, halign="center", valign="baseline");
}
module wallpaper_grid() {
    oblique = cell2_oblique(30,50,75);
    rectangular = cell2_rectangular(30,50);
    squarecell = cell2_square(30);
    hexagonal = cell2_hexagonal(30);
    //wallpaper_groups = [wg_p1,wg_p2, // 2 oblique
    //    wg_pm,wg_pg,wg_cm,wg_p2mm,wg_p2mg,wg_p2gg,wg_cmm, // 7 rectangular
    //    wg_p4,wg_p4mm,wg_p4gm, // 3 square
    //    wg_p3,wg_p3m1,wg_p31m,wg_p6,wg_p6m]; // 5 hexagonal

    // Each wallpaper is 100x100. We have 17, layed out in a 6x3 square
    xspacing = 110;
    yspacing = 115;

    translate([-2.5*xspacing,yspacing,0])
    wallpaper(wg_p1, oblique, "p1");
    translate([-1.5*xspacing,yspacing,0])
    wallpaper(wg_p2, oblique, "p2");
    translate([-.5*xspacing,yspacing,0])
    wallpaper(wg_pm, rectangular, "pm");
    translate([.5*xspacing,yspacing,0])
    wallpaper(wg_pg, rectangular, "pg");
    translate([1.5*xspacing,yspacing,0])
    wallpaper(wg_cm, rectangular, "cm");
    translate([2.5*xspacing,yspacing,0])
    wallpaper(wg_p2mm, rectangular, "p2mm");

    translate([-2.5*xspacing,0,0])
    wallpaper(wg_p2mg, rectangular, "p2mg");
    translate([-1.5*xspacing,0,0])
    wallpaper(wg_p2gg, rectangular, "p2gg");
    translate([-.5*xspacing,0,0])
    wallpaper(wg_cmm, rectangular, "cmm");
    translate([.5*xspacing,0,0])
    wallpaper(wg_p4, squarecell, "p4");
    translate([1.5*xspacing,0,0])
    wallpaper(wg_p4mm, squarecell, "p4mm");
    translate([2.5*xspacing,0,0])
    wallpaper(wg_p4gm, squarecell, "p4gm");

    translate([-2.5*xspacing,-yspacing,0])
    wallpaper(wg_p3, hexagonal, "p3");
    translate([-1.5*xspacing,-yspacing,0])
    wallpaper(wg_p3m1, hexagonal, "p3m1");
    translate([-.5*xspacing,-yspacing,0])
    wallpaper(wg_cmm, hexagonal, "cmm");
    translate([.5*xspacing,-yspacing,0])
    wallpaper(wg_p6, hexagonal, "p6");
    translate([1.5*xspacing,-yspacing,0])
    wallpaper(wg_p6m, hexagonal, "p6m");
}

module slide3() {
    // C2 wallpaper group
    cell = cell2_rectangular(30,50);
    wg = wg_cm;
    // Generate Symmetry
    unit_cell(wg,cell)
    character();
    // Box around unit cell
    unit_cell_frame(cell);
}



module slide4() {
    cell = cell2_rectangular(30,50);
    wg = wg_cm;

//    wallpaper(wg,cell);
    regular_lattice([3,3],cell,center=true) {
        unit_cell_frame(cell);
        unit_cell(wg,cell)
        character();
    }
}



module slide5() {
    wallpaper_grid();
}


// Space Group demo
// Example chiral object
// c = OpenSCAD color ([r,g,b] as floats)
// r = object radius
// back = Include colored circles towards the negative axes?
module testcube(c=[1,1,0],r=10,back=true) {
    color(c=c)
    cube([r*1.8,r*1.8,r*1.8], center=true);
    //z
    translate([0,0,r*.9])
    color(c=[0,0,1])
    cylinder(r=r*.8,h=r*.2,center=true);
    //y
    rotate([-90,0,0])
    translate([0,0,r*.9])
    color(c=[0,1,0])
    cylinder(r=r*.8,h=r*.2,center=true);
    //x
    rotate([0,90,0])
    color(c=[1,0,0])
    translate([0,0,r*.9])
    cylinder(r=r*.8,h=r*.2,center=true);

    if(back) {
        //z
        translate([0,0,-r*.9])
        color(c=[0,0,.2])
        cylinder(r=r*.8,h=r*.2,center=true);
        //y
        rotate([90,0,0])
        translate([0,0,r*.9])
        color(c=[0,.2,0])
        cylinder(r=r*.8,h=r*.2,center=true);
        //x
        rotate([0,-90,0])
        color(c=[.2,0,0])
        translate([0,0,r*.9])
        cylinder(r=r*.8,h=r*.2,center=true);
    }
}
module space_group_demo(sg,cell,label="") {
    bounds = [200,200,100];
//    intersection() {
//        cube(bounds,center=true);

//        covering_lattice(bounds,cell,center=true) {
        regular_lattice([3,3,2],cell,center=true) {
            unit_cell_frame(cell);
            unit_cell(sg, cell) {
                translate([10,10,10])
                testcube(r=5, back=false);
            }
        }
//    }
//    color([0,0,1])
//    difference() {
//        cube(bounds,center=true);
//        cube([bounds[0]+1,bounds[1]-1,bounds[2]-1],center=true);
//        cube([bounds[0]-1,bounds[1]+1,bounds[2]-1],center=true);
//        cube([bounds[0]-1,bounds[1]-1,bounds[2]+1],center=true);
//    }
    translate([0,-bounds[1]/2-10,-bounds[2]/2])
    linear_extrude(1)
    text(label, size=8, halign="center", valign="baseline");
}

module space_group_grid() {
    xspacing = 210;
    yspacing = 325;

    translate([-0.5*xspacing, 0.5*yspacing,0])
    space_group_demo(sg_P1, cell3_triclinic(50,75,25,90,90,90), "P1");
    translate([ 0.5*xspacing, 0.5*yspacing,0])
    space_group_demo(sg_C121,cell3_monoclinic(45,55,40,90),"C2");
    translate([-0.5*xspacing,-0.5*yspacing,0])
    space_group_demo(sg_P212121,cell3_orthorhombic(45,55,40),"P212121");
    translate([ 0.5*xspacing,-0.5*yspacing,0])
    space_group_demo(sg_P3121,cell3_hexagonal(45,40),"P3121");
}

module slide6() {
    space_group_grid();
}

module diamond() {
    $fs=.1;
    cell = cell3_cubic(35.23);
    
    regular_lattice([2,2,2],cell,true) {
        unit_cell_frame(cell);
        unit_cell(sg_Fd_3m,cell) {
            color([.5,.5,.5])
            sphere(r=7/2);

            color([1,1,1])
            line([0,0,0],[35.23/4,35.23/4,35.23/4]);
        }
    }
}

module protein() {
    cell = cell3_orthorhombic(56.080,   65.760,   70.510);
    regular_lattice([2,1,1],cell,true) {
        unit_cell_frame(cell);
        unit_cell(sg_P212121,cell) {
            color([.5,.5,1])
            import("doc/1i37_surf.stl");
        }
    }

}

slide = 2;

if(slide == 0) slide1a();
else if(slide == 1) slide1b();
else if(slide == 2) slide2();
else if(slide == 3) slide3();
else if(slide == 4) slide4();
else if(slide == 5) slide5();
else if(slide == 6) slide6();
//else if(slide == 7) slide7();
//else if(slide == 8) slide8();
//else if(slide == 9) slide9();
//else if(slide == 10) slide10();

//diamond();
//protein();