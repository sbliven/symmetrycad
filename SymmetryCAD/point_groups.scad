/*
 * SymmetryCAD - The OpenSCAD crystallographic toolbox
 *
 * License: LGPL 2.1 or later
 */

use <scad-utils/lists.scad> // for flatten()
use <scad-utils/linalg.scad> // for identity4()
use <matrix_utils.scad>

////////////////////////////
// Fake "lattice" systems //
////////////////////////////

// single point (for polygonal groups)
function cell0_point() = [1,1,1,90,90,90];
// z axis (for axial groups)
function cell0_axis(h=10) = [1,1,h,90,90,90];

//////////////////
// Point Groups //
//////////////////

// n-fold rotation around z-axis
function pg_cn(n) =
    [ for(i = [0:n-1])
        [[cos(i*360/n),-sin(i*360/n),0,0],
         [sin(i*360/n), cos(i*360/n),0,0],
         [0,          0,             1,0],
         [0,          0,             0,1]] // rotation
    ];

// n-fold rotoreflection symmetry
function pg_s2n(n) = 
    let(rots = pg_cn(n))
    [for(i = [0:n-1])
        rots[i] * 
        [[1, 0, 0, 0],
         [0, 1, 0, 0],
         [0, 0, pow(-1,i), 0],
         [0, 0, 0, 1]] // reflect odd across xy
    ];
    
// n-fold rotation with reflection symmetry
function pg_cnh(n) =
    let(rots = pg_cn(n))
    concat(rots,
        [for(i = [0:n-1])
            rots[i] * 
            [[1, 0, 0, 0],
             [0, 1, 0, 0],
             [0, 0,-1, 0],
             [0, 0, 0, 1]] // reflect across xy
        ]);
// Pyramidal (biradial) symmetry
function pg_cnv(n) =
    let(rots = pg_cn(n))
    concat(rots,
        [for(i = [0:n-1])
            rots[i] * 
            [[1, 0, 0, 0],
             [0,-1, 0, 0],
             [0, 0, 1, 0],
             [0, 0, 0, 1]] // reflect across xz
        ]);
// Dihedral symmetry
function pg_dn(n) =
    let(rots = pg_cn(n))
    concat(rots,
        [for(i = [0:n-1])
            rots[i] * 
            [[1, 0, 0, 0],
             [0,-1, 0, 0],
             [0, 0,-1, 0],
             [0, 0, 0, 1]] // rotate around x
        ]);
// Antiprismatic symmetry
function pg_dnd(n) =
    let(rots = pg_s2n(2*n))
    flatten(
        [for(i = [0:2*n-1])
            [   rots[i],
                rots[i] * 
                [[1, 0, 0, 0],
                 [0,-1, 0, 0],
                 [0, 0, 1, 0],
                 [0, 0, 0, 1]] // reflect across xz
            ]
        ]);
// Prismatic symmetry
function pg_dnh(n) =
    let(rots = pg_cn(n))
    flatten(
        [for(i = [0:n-1])
            [   rots[i],
                rots[i] *
                [[1, 0, 0, 0],
                 [0, 1, 0, 0],
                 [0, 0,-1, 0],
                 [0, 0, 0, 1]], // reflect across xy
                rots[i] * 
                [[1, 0, 0, 0],
                 [0,-1, 0, 0],
                 [0, 0,-1, 0],
                 [0, 0, 0, 1]], // rotate around x
                rots[i] * 
                [[1, 0, 0, 0],
                 [0,-1, 0, 0],
                 [0, 0, 1, 0],
                 [0, 0, 0, 1]] // reflect across xz
            ]
        ]);
        
//TODO implement polyhedral point groups
// chiral tetrahedral symmetry
pg_t = [identity4()];
// full tetrahedral symmetry
pg_td = [identity4()];
// pyritohedral symmetry
pg_th = [identity4()];
// chiral octahedral symmetry
pg_o = [identity4()];
// full octahedral symmetry
pg_oh = [identity4()];
// chiral icosahedral symmetry
pg_i = [identity4()];
// full icosahedral symmetry
pg_ih = [identity4()];
