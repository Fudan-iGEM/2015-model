
set targetMark1    "1.00"
set targetMark2    "1.00"
set targets1 {}
set targets2 {}
set masses1 {}
set masses2 {}

set inStream1 [open $targetAtomPdb1 r]
foreach line [split [read $inStream1] \n] {
    set string1 [string range $line 0 3]
    set string2 [string range $line 6 10]
    set string3 [string range $line 17 20]	
    set string4 [string range $line 12 15]
    set string5 [string range $line 46 53]
    set string6 [string range $line 72 75]
    set string673 [string range $line 73 75]
    set string7 [string range $line 22 25]
    set string8 [string range $line 62 65]
    set string9 [string range $line 55 60]
    
    if { ([string equal $string1 {ATOM}] || \
 	      [string equal $string1 {HETA}] ) && \
 	     [string equal $targetMark1 $string8] } {	
 	lappend targets1 "[string trim $string6]\
 			    [string trim $string7] [string trim $string4]"
	lappend masses1 "[string trim $string9]"
    }
}
close $inStream1
set inStream2 [open $targetAtomPdb2 r]
foreach line [split [read $inStream2] \n] {
    set string1 [string range $line 0 3]
    set string2 [string range $line 6 10]
    set string3 [string range $line 17 20]	
    set string4 [string range $line 12 15]
    set string5 [string range $line 46 53]
    set string6 [string range $line 72 75]
    set string673 [string range $line 73 75]
    set string7 [string range $line 22 25]
    set string8 [string range $line 64 67]
    set string9 [string range $line 55 60]
    
    if { ([string equal $string1 {ATOM}] || \
 	      [string equal $string1 {HETA}] ) && \
 	     [string equal $targetMark2 $string8] } {	
 	lappend targets2 "[string trim $string6]\
 			    [string trim $string7] [string trim $string4]"
	lappend masses2 "[string trim $string9]"
    }
}
close $inStream2

# make list of atoms
set atoms1 {}
foreach target1 $targets1 {
    foreach {segname resid atom} $target1 { break }
    set atomindex1 [atomid $segname $resid $atom]
    lappend atoms1 $atomindex1
    addatom $atomindex1
}
set numatoms1 [llength $atoms1]

if { $numatoms1 > 0 } {
    set applyforce 1
} else {
    print "WARNING: no target atoms have been detected"
    set applyforce 0
}

set atoms2 {}
foreach target2 $targets2 {
    foreach {segname resid atom} $target2 { break }
    set atomindex2 [atomid $segname $resid $atom]
    lappend atoms $atomindex2
    addatom $atomindex2
}
set numatoms2 [llength $atoms2]

if { $numatoms2 > 0 } {
    set applyforce 1
} else {
    print "WARNING: no target atoms have been detected"
    set applyforce 0
}


# Take force factor from NAMD config file
set linaccel_namd1 [vecscale [expr 1.0/418.68] $linaccel1]
set angaccel_namd1 [expr double($angaccel1)/418.68]
set linaccel_namd2 [vecscale [expr 1.0/418.68] $linaccel2]
set angaccel_namd2 [expr double($angaccel2)/418.68]
set PI 3.1415926535898

print "Linear acceleration applied: ($linaccel1) Ang*ps^-2"
print "Angular acceleration applied: (0 0 $angaccel1) Rad*ps^-2"

print "Linear acceleration applied: ($linaccel2) Ang*ps^-2"
print "Angular acceleration applied: (0 0 $angaccel2) Rad*ps^-2"
proc calcforces { } {
    global atoms1 numatoms1 masses1 linaccel_namd1 angaccel_namd1
    global atoms2 numatoms2 masses2 linaccel_namd2 angaccel_namd2
    global applyforce
    global PI
    
    if { $applyforce } {
	# Get coordinates
	loadcoords coords
	
	# First calculate center of mass
	set comsum1 "0 0 0"
	set comsum2 "0 0 0
	set totalmass1 0
	set totalmass2 0
	foreach atom1 $atoms1 mass1 $masses1 {
	    set comsum1 [vecadd $comsum1 [vecscale $mass1 $coords($atom1)]]
	    set totalmass1 [expr $totalmass1 + $mass1]
	}
	foreach atom2 $atoms2 mass2 $masses2 {
	    set comsum2 [vecadd $comsum2 [vecscale $mass2 $coords($atom2)]]
	    set totalmass2 [expr $totalmass2 + $mass2]
	}
	set com1 [vecscale [expr 1.0/$totalmass1] $comsum1]
	set com2 [vecscale [expr 1.0/$totalmass2] $comsum2]
	print "Center of mass1 = $com1 \n"
	print "Center of mass2 = $com2 "
	
	foreach atom1 $atoms1 mass1 $masses1 {
	    # Linear force1
	    set linforce1 [vecscale $mass1 $linaccel_namd1]
	    
	    # Angular force
	  #  set r [vecsub $coords($atom) $com]
	   # set x [lindex $r 0]
	  #  set y [lindex $r 1]
	   # set rho [expr sqrt(pow($x, 2) + pow($y, 2))]
	   # set phi [expr atan2($y, $x) + $PI/2]
	  #  if { $atom == 1 } {
	#	print "atom $atom: phi = $phi"
	    }
	foreach atom2 $atoms2 mass2 $masses2 {
	    # Linear force2
	    set linforce2 [vecscale $mass2 $linaccel_namd2]
	   }
	    addforce $atom1 $linforce1
	    addforce $atom2 $linforce2
	}
    }
}

