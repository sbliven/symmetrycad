/*
 * SymmetryCAD - The OpenSCAD crystallographic toolbox
 *
 * License: LGPL 2.1 or later
 */


// SYMMETRY
// Functions for applying symmetry operations

use <coordinates.scad>
include <point_groups.scad>

// Generate a full unit cell from the child modules
// sg = list of 4D matrices giving the space group operators. Typically one of the sg_* objects from space_groups.scad
// cell = vector with cell parameters [a,b,c,alpha,beta,gamma]. Typically from the cell_* function matching the space group
module unit_cell(sg, cell) {
    ortho = orthomatrix(cell);
    deortho = deorthomatrix(cell);
    for( op = sg ) {
        multmatrix(ortho*op*deortho)
        children();
    }
}


// Wireframe box around the unit cell
// cell = vector with cell parameters [a,b,c,alpha,beta,gamma]
// r = frame radius
module unit_cell_frame(cell,r=.5,$fs=.01) {
    op = orthomatrix(cell);
    for(x = [0,1]) {
        for(y = [0,1]) {
            for(z = [0,1]) {
                translate(transform_point3(op,[x,y,z]))
                sphere(r=r);
            }
        }
    }

    for(x = [0,1],y = [0,1]) {
        line( transform_point3(op,[x,y,0]), transform_point3(op,[x,y,1]), r);
        line( transform_point3(op,[x,0,y]), transform_point3(op,[x,1,y]), r);
        line( transform_point3(op,[0,x,y]), transform_point3(op,[1,x,y]), r);
    }
    multmatrix(op)
    *cube([1,1,1],center=false);
}

// Line between two points
// p1,p2 = vector [x,y,z] of endpoints
// r = line radius
module line(p1, p2, r=1) {
    dp = p2-p1;
    length = norm(dp);  // radial distance
    b = acos(dp[2]/length); // inclination angle
    c = atan2(dp[1],dp[0]);     // azimuthal angle

    translate(p1)
    rotate([0, b, c])
    cylinder(h=length, r=r);
}

// Wireframe tetrahedron
// It is oriented such that it could be inscribed in a cube oriented along the axes
// edgelen = edge length
// r = line radius
module tetrahedron_frame(edgelen,r=.5,$fs=.01) {
    l = edgelen*sqrt(2)/4;
    cell = cell0_point();
    unit_cell(pg_t,cell) {
        line([0,0,l],[l,l,l],r);
        translate([l,l,l])
        sphere(r);
    }
}

// Wireframe pyritohedron (12 irregular pentagonal faces)
// 
// The h parameter controls the type of pentagon. At it's default value (phi=(1+sqrt(5))/2),
// the faces are regular pentagons. As h gets closer to zero, height of each pentagon's peak gets lower until
// it degenerates into a rectangle with 1:2 aspect ratio, inscribing the pyritohedron on a cube of size
// basesize. As h increases, the cube's faces move outward and the base of the pentagon gets smaller
// until it degenerates into a rhombus.
//
// basesize = distance between the three-fold axes (e.g. the cube's edge length if h=0)
// h = interpolate between a cube (0) and a rhombic dodecahedron (1)
// r = line radius
module pyritohedron_frame(basesize,h=sqrt(5)/2-.5, r=.5, $fs=.01) {
    l = basesize*sqrt(2)/4;
    cell = cell0_point();
    unit_cell(pg_th,cell) {
        line([0,l*(1+h),0],[0,l*(1+h),l*(1-h*h)],r);
        line([0,l*(1+h),l*(1-h*h)],[l,l,l],r);
    }
}
// Wireframe cube (centered)
// edgelen = edge length
// r = line radius
module cube_frame(edgelen,r=.5, $fs=.01) {
//    difference() {
//        cube([edgelen,edgelen,edgelen],center=true);
//        cube([edgelen+r,edgelen-r,edgelen-r],center=true);
//        cube([edgelen-r,edgelen+r,edgelen-r],center=true);
//        cube([edgelen-r,edgelen-r,edgelen+r],center=true);
//    }
    translate(-[edgelen,edgelen,edgelen]/2)
    unit_cell_frame([edgelen,edgelen,edgelen,90,90,90],r,$fs=$fs);
}
// EXAMPLES
//line([15,0,15],[10,10,10],.5,$fn=12);
unit_cell_frame([10,15,20,110,80,120]);

// tetrahedron inscribed in a cube
//tetrahedron_frame(25); %cube([25,25,25]*sqrt(2)/2,center=true);

// pyritohedron around cube
//pyritohedron_frame(25,.5); %cube([25,25,25]*sqrt(2)/2,center=true);

cube_frame(25);