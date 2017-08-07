/*
 * SymmetryCAD - The OpenSCAD crystallographic toolbox
 *
 * License: LGPL 2.1 or later
 */


// DEMO
// Examples and README figures


include <SymmetryCAD/SymmetryCAD.scad>
// use <SymmetryCAD/coordinates.scad>

// Example object
module object() {
    // DEVANAGARI OM (https://en.wikipedia.org/wiki/Om), 12x12mm
    // Comes with Macs; Windows may need a different font
    color([0,0,1])
    linear_extrude(1)
    text("\u0950",font="Arial Unicode MS");
}

module slide1() {
    object();
}

module slide2() {
    cell = cell2_rectangular(30,50);
    wg = wg_cm;

    unit_cell_box(cell);

    unit_cell(wg,cell)
    object();
}



module slide3() {
    cell = cell2_rectangular(30,50);
    wg = wg_cm;

//    wallpaper(wg,cell);
    regular_lattice([3,3],cell) {
        unit_cell_box(cell);
        unit_cell(wg,cell)
        object();
    }
}

module wallpaper(wg,cell,label="") {
    intersection() {
        cube([100,100,10],center=true);
        covering_lattice([100,100],cell) {
            unit_cell_box(cell);
            unit_cell(wg,cell)
            object();
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

module slide4() {
    wallpaper_grid();
}
module test() {
    hexagonal = cell2_hexagonal(30);
    wallpaper(wg_p3, hexagonal, "p3");
//    unit_cell(wg_p3,hexagonal)
//    *object();
//
//    *unit_cell_box(hexagonal);
//
//    %cube([1,1,1]);
//
//    ortho = orthomatrix(hexagonal);
//    deortho = deorthomatrix(hexagonal);
//    echo(ortho*deortho);
//
//    multmatrix(wg_p3[1]*deortho)
//    object();

}

slide = 2;

if(slide == 1) slide1();
else if(slide == 2) slide2();
else if(slide == 3) slide3();
else if(slide == 4) slide4();

//(slide == 1 ? slide1() :
//slide == 2 ? slide2() :
//slide == 3 ? slide3() :
//slide == 4 ? slide4() :
//undef);

//test();
