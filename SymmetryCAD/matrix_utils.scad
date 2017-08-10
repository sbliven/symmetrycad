/*
 * SymmetryCAD - The OpenSCAD crystallographic toolbox
 *
 * License: LGPL 2.1 or later
 */
 
 // MATRIX UTILS
 // Helper functions for matrix operations and linear algebra
 
 
// Update an operator such that it keeps a particular point within the unit cell
// op = 4D matrix operating in fractional space
// reference = a 3D or 4D vector with the reference point (in fractional coords).
//             Defaults to a small positive point near the origin
// returns a 4D matrix differing only by a translation between unit cells
function wrap_op(op, reference=[0.05, 0.04, 0.03]) =
    let(applied = op*(len(reference) == 4 ? reference : concat(reference,1) ))
    [[1,0,0, -floor(applied[0])],
     [0,1,0, -floor(applied[1])],
     [0,0,1, -floor(applied[2])],
     [0,0,0, 1]] * op;
// Update a list of operator such that they all keep a particular point within the unit cell
// ops = list of 4D matrices operating in fractional space
// reference = a 4D vector with the reference point. Defaults to a small positive point near the origin
// returns a 4D matrix differing only by a translation between unit cells
function wrap_ops(ops, reference=[0.05, 0.04, 0.03]) = [ for (op = ops) wrap_op(op,reference) ];

// Expand a 2D or 3D matrix into a 4D matrix
function expand_matrix(op) =
    len(op) == 2 ?
        [ concat(op[0],[0,0]),
          concat(op[1],[0,0]),
          [0,0,1,0],
          [0,0,0,1]]
    : len(op) == 3 ?
        [ concat(op[0],[0]),
          concat(op[1],[0]),
          concat(op[2],[0]),
          [0,0,0,1]]
    : op;
// Expand a list of 2D or 3D matrices into a list of 4D matrices
function expand_matrices(ops) = [for (op = ops) expand_matrix(op) ];

