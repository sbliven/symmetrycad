/*
 * SymmetryCAD - The OpenSCAD crystallographic toolbox
 *
 * License: LGPL 2.1 or later
 */


// COORDINATES
// This file contains various math functions for crystallographic operations.
// For a primer on crystallographic coordinate systems, see
// http://jean.cavarelli.free.fr/unistra/Public//biophys/rx/biblio/19_06_cowtan_coordinate_frames.pdf


use <scad-utils/linalg.scad> //take3
use <scad-utils/spline.scad> //matrix_invert


// Convert operators from crystallographic fractional coordinates to orthonormal coordinates
// op = a 4D matrix operating on fractional coordinates
// cell = vector with unit cell parameters
// returns a 4D matrix that converts fractional coordinates to orthonormal coordinates
function xtal2ortho(op, cell) = orthomatrix(cell)*op;

// Othogonalization matrix, used to convert fractional coordinates to orthonormal
// [x,y,z,1] = orthomatrix(cell) * [u,v,w,1]
//
// cell = vector with unit cell parameters
// returns a 4D matrix that converts fractional coordinates to orthonormal coordinates
function orthomatrix(cell) =
    // Formulas from http://www.ruppweb.org/Xray/tutorial/Coordinate%20system%20transformation.htm
    let(a=cell[0], b=cell[1], c=cell[2], alpha=cell[3], beta=cell[4], gamma=cell[5])
    let(ca=cos(alpha), cb=cos(beta), cg=cos(gamma), sg=sin(gamma) )
    let(V=a*b*c*sqrt(1-ca*ca-cb*cb-cg*cg+2*ca*cb*cg))
    [[a,    b*cg,   c*cb,               0 ],
     [0,    b*sg,   c*(ca-cb*cg)/sg,    0 ],
     [0,    0,      V/a/b/sg,           0 ],
     [0,    0,      0,                  1 ]];

// Computes the inverse of orthomatrix(cell). This transforms orthonormal coordinates back to fractional coords.
// [u,v,w,1] = deorthomatrix(cell) * [x,y,z,1]
//
// cell = vector with unit cell parameters
// returns a 4D matrix that converts orthonormal coordinates to fractional coordinates
function deorthomatrix(cell) =
    let(a=cell[0], b=cell[1], c=cell[2], alpha=cell[3], beta=cell[4], gamma=cell[5])
    let(ca=cos(alpha), cb=cos(beta), cg=cos(gamma), sg=sin(gamma))
    let(V=a*b*c*sqrt(1-ca*ca-cb*cb-cg*cg+2*ca*cb*cg))
    [[1/a,  -cg/a/sg,   (b*cg*c*(ca-cb*cg)/sg-b*c*cb*sg)/V, 0 ],
     [0,    1/b/sg,     -a*c*(ca-cb*cg)/V/sg,               0 ],
     [0,    0,          a*b*sg/V,                           0 ],
     [0,    0,          0,                                  1 ]];


// Transform a point by applying the given operation.
// This is conceptually equivalent to op*point, but handles the conversion from 4D coordinates
// op = 4D matrix
// point = 3D or 4D vector
// returns a 3D vector
function transform_point3(op, point) =
    take3(op * (len(point) == 4 ? point : concat(take3(point), [1]) ));

// Transform a point by the inverse of an operation.
// This is conceptually equivalent to op^-1 * point.
// op = 4D matrix
// point = 3D or 4D vector
// returns a 3D vector
function backtransform_point3(op,point) =
    transform_point3(matrix_invert(op),point);
