set pdb mod_start_wb.pdb
set psf mod_start_wb.psf
set targetPdb sel_puf1.pdb
set selection "protein and resid 9 to 360"
set targetMark "1.00"

mol load psf $psf pdb $pdb

set all [atomselect top all]
$all set beta 0
$all set occupancy 0

set target [atomselect top $selection]
set masses [$target get mass]

$target set beta $targetMark
$target set occupancy $masses

$all writepdb $targetPdb

exit
