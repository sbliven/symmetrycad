# SymmetryCAD
The OpenSCAD crystallographic toolbox

## Summary

SymmetryCAD is an [OpenSCAD](http://www.openscad.org) library for all kinds of geometric symmetry operations. It can be used for enforcing mirror or rotational symmetry on your 3D objects, constructing tilings and tessellations, or for building 3D molecular crystals in OpenSCAD. Functions are available for all 17 possible 2D tilings (wallpaper groups) and all 230 possible 3D tilings (space groups).

## Gallery

If you use SymmetryCAD, leave a comment on [github](https://github.com/sbliven/symmetrycad/issues) or [thingiverse](http://www.thingiverse.com/spencer) to feature it here!

## Installation

SymmetryCAD requires [scad-utils](https://github.com/openscad/scad-utils) to be installed. You can download the latest version from https://github.com/openscad/scad-utils/archive/master.zip.

Unzip the package and add the whole folder to your OpenSCAD library folder. This is most easily found by opening OpenSCAD and going to 'File'>'Show Library Folder...'. On macOS it will be in '~/Documents/OpenSCAD/libraries'.

Add SymmetryCAD to the same folder. If you download the latest release you should be able to unpack it directly in libraries; if downloading from the github source you only need the 'SymmetryCAD' subdirectory.

## Basic use

To get started, simply include the following line in your .scad file:

```
include <SymmetryCAD/SymmetryCAD.scad>
```

## License

Copyright Spencer Bliven (2017)

Code is licensed under the GNU Lesser General Public License, version 2.1 or later.

Contributions and bug reports are welcome and should be submitted through (github)[https://github.com/sbliven/symmetrycad].
