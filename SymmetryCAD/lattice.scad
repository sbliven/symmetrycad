/*
 * SymmetryCAD - The OpenSCAD crystallographic toolbox
 *
 * License: LGPL 2.1 or later
 */

// LATTICE
// Functions to tile objects in 3D

use <coordinates.scad>

// Creates a regular grid of any child objects.
// Typically this would wrap a `unit_cell()` instance.
// Note that for large lattices rendering can be very slow.
//
// size = 2D or 3D vector giving the number or repeats in each direction
// cell = vector with cell parameters [a,b,c,alpha,beta,gamma]. Typically from the cell* functions
// center = boolean. If false, put the lattice origin at [0,0,0]. Otherwise, center the lattice. (default false)
module regular_lattice(size,cell,center=false) {
    ortho = orthomatrix(cell);
    zsize = (len(size)>2 ? size[2] : 1);
    for( x=[0:size[0]-1], y=[0:size[1]-1], z=[0:zsize-1] ) {
        p = center ? [x-size[0]/2.,y-size[1]/2., z-zsize/2.] : [x,y,z];
        translate( transform_point3(ortho,p) )
        children();
    }
}

// Creates a grid that would fully cover the cube specified by bounds.
// For cells with non-90 degree angles, this results in a "jagged" lattice border.
// Typically `covering_lattice()` would wrap a `unit_cell()` instance, and the
// result would be intersected with `cube(bounds,center)` to give a cubic chunk
// of crystal.
// Note that for large lattices rendering can be very slow.
//
// size = 2D or 3D vector giving the number or repeats in each direction
// cell = vector with cell parameters [a,b,c,alpha,beta,gamma]. Typically from the cell* functions
// center = boolean. If false, put the lattice origin at [0,0,0]. Otherwise, center the lattice. (default false)
module covering_lattice(bounds, cell, center=true) {
    // The columns of the orthogonal matrix give a, b, and c vectors
    ortho = orthomatrix(cell);
    echo(ortho=ortho);
    a = [ortho[0][0], ortho[1][0], ortho[2][0]];
    b = [ortho[0][1], ortho[1][1], ortho[2][1]];
    c = [ortho[0][2], ortho[1][2], ortho[2][2]];

    // Lattice bounds
    Xmin = center ? bounds[0]/2 : 0;
    Xmax = center ? bounds[0]/2 : bounds[0];
    Ymin = center ? bounds[1]/2 : 0;
    Ymax = center ? bounds[1]/2 : bounds[1];
    Zmin = center ? bounds[2]/2 : 0;
    Zmax = center ? bounds[2]/2 : bounds[2];

    origin = center ? transform_point3(ortho,[.5,.5,.5]) : [0,0,0];
    echo(origin=origin);

    // compute the region fully convered by the unit cell from each direction
    vertices = [ for( x=[0:1], y=[0:1], z=[0:1] ) transform_point3(ortho, [x,y,z]) ];
    xmin = max([for(v = [0:3]) vertices[v][0] ]);
    xmax = min([for(v = [4:7]) vertices[v][0] ]);
    ymin = max([for(v = [0,1,4,5]) vertices[v][1] ]);
    ymax = min([for(v = [2,3,6,7]) vertices[v][1] ]);
    zmin = max([for(v = [0,2,4,6]) vertices[v][2] ]);
    zmax = min([for(v = [1,3,5,7]) vertices[v][2] ]);
//    echo(xmin=xmin,xmax=xmax);
//    echo(ymin=ymin,ymax=ymax);
//    echo(zmin=zmin,zmax=zmax);

    // Calculate number of cells in each direction (z plus, z minus, y plus, ...)=
    // This is constant in z direction
    nzp = ceil( (Zmax - origin[2] -zmax)/c[2] + 1);
    nzn = ceil( (Zmin + origin[2] +zmin)/c[2] );
    echo(nzn=nzn,nzp=nzp);
    for( z = [-nzn:nzp-1]) {
        // Some point along c axis
        p1 = origin + z*c;
//        echo(p1=p1);

        // Number of cells along b axis
        nyp = ceil( (Ymax - p1[1] - ymax)/b[1] + 1);
        nyn = ceil( (Ymin + p1[1] + ymin)/b[1]);
//        echo(nyn=nyn,nyp=nyp);


        for( y = [-nyn:nyp-1]) {
            // Some point in bc plane
            p2 = p1 + y*b;
//            echo(p2=p2);

            // Number of cells along a axis
            nxp = ceil( (Xmax - p2[0] - xmax)/a[0] + 1);
            nxn = ceil( (Xmin + p2[0] + xmin)/a[0]);

            for( x = [-nxn:nxp-1] ) {
                // Unit cell origin
                p3 = p2 + x*a;

                translate(p3) {
                    children();
                }
            }
        }
    }
}

cell = [20,20,20,110,80,120];
//cell = [20,20,20,90,90,90];
//regular_lattice([3,3], cell) {
//    sphere(r=2);
//    multmatrix(orthomatrix(cell))
//    translate([.5,.5,.5])
//    %cube([.8,.8,.8],center=true);
//}

// Test for covering_lattice
// the lattice should fully cover the cube in all directions but go no farther
bounds = [60,60,41];
center = true;
covering_lattice(bounds, cell, center=center) {
    sphere(r=2);
    multmatrix(orthomatrix(cell))
    translate([.5,.5,.5])
    %cube([.8,.8,.8],center=true);
}
difference() {
    cube(bounds,center=center);
    cube([bounds[0]-1,bounds[1]-1,bounds[2]+1],center=center);
    cube([bounds[0]-1,bounds[1]+1,bounds[2]-1],center=center);
    cube([bounds[0]+1,bounds[1]-1,bounds[2]-1],center=center);
}
