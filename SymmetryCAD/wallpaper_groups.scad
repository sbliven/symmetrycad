/*
 * SymmetryCAD - The OpenSCAD crystallographic toolbox
 *
 * License: LGPL 2.1 or later
 */

use <scad-utils/linalg.scad> // for identity4()
use <matrix_utils.scad>

/////////////////////////
// 2D Crystal families //
/////////////////////////

function cell2_oblique(a,b,gamma) = [a,b,1,90,90,gamma]; // aka parallellogrammatic
function cell2_rectangular(a,b) = [a,b,1,90,90,90];
function cell2_rhombic(a,gamma) = [a,a,1,90,90,gamma]; // equivalent to centered rectangular
function cell2_square(a) = [a,a,1,90,90,90];
function cell2_hexagonal(a) = [a,a,1,90,90,120]; // aka hexagonal

/////////////////////////
// 2D wallpaper groups //
/////////////////////////

// 1. p1 (oblique)
wg_p1 = [identity4()];

// 2. p2 (oblique)
wg_p2 = wrap_ops( expand_matrices(
    [ identity4(),
    [[-1, 0],
     [ 0,-1]] //-x,-y
    ]));
// 3. pm (rectangular)
wg_pm = wrap_ops( expand_matrices(
    [ identity4(),
    [[-1, 0],
     [ 0, 1]] //-x,y
    ]));
// 4. pg (rectangular)
wg_pg = wrap_ops( expand_matrices(
    [ identity4(),
     [[-1, 0, 0, 0],
      [ 0, 1, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]] //-x, y+1/2
    ]));
// 5. cm (rectangular)
wg_cm = wrap_ops( expand_matrices(
    [ identity4(),
     [[-1, 0],
      [ 0, 1]], // -x,y
     [[ 1, 0, 0, .5],
      [ 0, 1, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]], //x+1/2, y+1/2
     [[-1, 0, 0, .5],
      [ 0, 1, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]] //-x+1/2, y+1/2
    ]));
// 6. p2mm (rectangular)
wg_p2mm = wrap_ops( expand_matrices(
    [ identity4(),
    [[-1, 0],
     [ 0,-1]], // -x, -y
    [[-1, 0],
     [ 0, 1]], // -x, y
    [[ 1, 0],
     [ 0,-1]], // x, -y
    ]));
// 7. p2mg (rectangular)
wg_p2mg = wrap_ops( expand_matrices(
    [ identity4(),
    [[-1, 0],
     [ 0,-1]], // -x, -y
     [[-1, 0, 0, .5],
      [ 0, 1, 0, 0],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]], //-x+1/2, y
     [[ 1, 0, 0, .5],
      [ 0,-1, 0, 0],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]] //x+1/2, -y
    ]));
// 8. p2gg (rectangular)
wg_p2gg = wrap_ops( expand_matrices(
    [ identity4(),
    [[-1, 0],
     [ 0,-1]], // -x, -y
     [[-1, 0, 0, .5],
      [ 0, 1, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]], //-x+1/2, y+1/2
     [[ 1, 0, 0, .5],
      [ 0,-1, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]] //x+1/2, -y+1/2
    ]));
// 9. c2mm (rectangular)
wg_cmm = wrap_ops( expand_matrices(
    [ identity4(),
     [[-1, 0],
      [ 0,-1]], // -x,-y
     [[ 1, 0, 0, .5],
      [ 0, 1, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]], //x+1/2, y+1/2
     [[-1, 0, 0, .5],
      [ 0,-1, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]] //-x+1/2,-y+1/2
    ]));
// 10. p4 (square)
wg_p4 = wrap_ops( expand_matrices(
    [ identity4(),
     [[-1, 0],
      [ 0,-1]], // -x,-y
     [[ 0,-1],
      [ 1, 0]], // -y,x
     [[ 0, 1],
      [-1, 0]], // y,-x
    ]));
// 11. p4mm (square)
wg_p4mm = wrap_ops( expand_matrices(
    [ identity4(),
     [[-1, 0],
      [ 0,-1]], // -x,-y
     [[ 0,-1],
      [ 1, 0]], // -y,x
     [[ 0, 1],
      [-1, 0]], // y,-x
     [[-1, 0],
      [ 0, 1]], // -x,y
     [[ 1, 0],
      [ 0, -1]], // x,-y
     [[ 0, 1],
      [ 1, 0]], // y,x
     [[ 0,-1],
      [-1, 0]], // -y,-x
    ]));
// 12. p4gm (square)
wg_p4gm = wrap_ops( expand_matrices(
    [ identity4(),
     [[-1, 0],
      [ 0,-1]], // -x,-y
     [[ 0,-1],
      [ 1, 0]], // -y,x
     [[ 0, 1],
      [-1, 0]], // y,-x
     [[-1, 0, 0, .5],
      [ 0, 1, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]], // -x+1/2,y+1/2
     [[ 1, 0, 0, .5],
      [ 0,-1, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]], // x+1/2,-y+1/2
     [[ 0, 1, 0, .5],
      [ 1, 0, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]], // y+1/2,x+1/2
     [[ 0,-1, 0, .5],
      [-1, 0, 0, .5],
      [ 0, 0, 1, 0],
      [ 0, 0, 0, 1]], // -y+1/2,-x+1/2
    ]));
// 13. p3 (hexagonal)
wg_p3 = wrap_ops( expand_matrices(
    [ identity4(),
     [[ 0,-1],
      [ 1,-1]], // -y, x-y
     [[-1, 1],
      [-1, 0]] // -x+y,-x
    ]));
// 14. p3m1 (hexagonal)
wg_p3m1 = wrap_ops( expand_matrices(
    [ identity4(),
     [[ 0,-1],
      [ 1,-1]], // -y, x-y
     [[-1, 1],
      [-1, 0]], // -x+y,-x
     [[ 0,-1],
      [-1, 0]], // -y,-x
     [[-1, 1],
      [ 0, 1]], // -x+y,y
     [[ 1, 0],
      [ 1,-1]] // x,x-y
    ]));
// 15. p31m (hexagonal)
wg_p31m = wrap_ops( expand_matrices(
    [ identity4(),
     [[ 0,-1],
      [ 1,-1]], // -y, x-y
     [[-1, 1],
      [-1, 0]], // -x+y,-x
     [[ 0, 1],
      [ 1, 0]], // y,x
     [[ 1,-1],
      [ 0,-1]], // x-y,-y
     [[-1, 0],
      [-1, 1]] // -x,-x+y
    ]));
// 16. p6 (hexagonal)
wg_p6 = wrap_ops( expand_matrices(
    [ identity4(),
     [[ 0,-1],
      [ 1,-1]], // -y, x-y
     [[-1, 1],
      [-1, 0]], // -x+y,-x
     [[-1, 0],
      [ 0,-1]], // -x,-y
     [[ 0, 1],
      [-1, 1]], // y,-x+y
     [[ 1,-1],
      [ 1, 0]] // x-y,x
    ]));
// p6m (hexagonal)
wg_p6m = wrap_ops( expand_matrices(
    [ identity4(),
     [[ 0,-1],
      [ 1,-1]], // -y, x-y
     [[-1, 1],
      [-1, 0]], // -x+y,-x
     [[-1, 0],
      [ 0,-1]], // -x,-y
     [[ 0, 1],
      [-1, 1]], // y,-x+y
     [[ 1,-1],
      [ 1, 0]], // x-y,x
     [[ 0,-1],
      [-1, 0]], // -y,-x
     [[-1, 1],
      [ 0, 1]], // -x+y,y
     [[ 1, 0],
      [ 1,-1]], // x,x-y
     [[ 0, 1],
      [ 1, 0]], // y,x
     [[ 1,-1],
      [ 0,-1]], // x-y,-y
     [[-1, 0],
      [-1, 1]] // -x,-x+y
    ]));

// All 17 wallpaper groups
wallpaper_groups = [wg_p1,wg_p2, // 2 oblique
    wg_pm,wg_pg,wg_cm,wg_p2mm,wg_p2mg,wg_p2gg,wg_cmm, // 7 rectangular
    wg_p4,wg_p4mm,wg_p4gm, // 3 square
    wg_p3,wg_p3m1,wg_p31m,wg_p6,wg_p6m]; // 5 hexagonal
