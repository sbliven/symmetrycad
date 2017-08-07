/*
 * SymmetryCAD - The OpenSCAD crystallographic toolbox
 *
 * License: LGPL 2.1 or later
 */


// SYMMETRY
// Functions for applying symmetry operations

use <coordinates.scad>

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


// Generate a thin box around the unit cell
module unit_cell_box(cell,r=.5,$fs=.01) {
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
module line(p1, p2, r) {
    dp = p2-p1;
    length = norm(dp);  // radial distance
    b = acos(dp[2]/length); // inclination angle
    c = atan2(dp[1],dp[0]);     // azimuthal angle

    translate(p1)
    rotate([0, b, c])
    cylinder(h=length, r=r);
}

// EXAMPLES
//line([15,0,15],[10,10,10],1,$fn=12);
//unit_cell_box([10,15,20,110,80,120]);
