
# Select all atoms in the bilayer (or specify a more precise selection if needed)
set bilayer_sel [atomselect top "resname DMPC"]

# Get the coordinates of all selected atoms
set all_coords [$bilayer_sel get {x y}]

# Initialize min and max variables
set min_x [lindex [lindex $all_coords 0] 0]
set max_x $min_x
set min_y [lindex [lindex $all_coords 0] 1]
set max_y $min_y

# Iterate over each coordinate to find the extents
foreach coord $all_coords {
    set x [lindex $coord 0]
    set y [lindex $coord 1]

    if {$x < $min_x} {set min_x $x}
    if {$x > $max_x} {set max_x $x}
    if {$y < $min_y} {set min_y $y}
    if {$y > $max_y} {set max_y $y}
}

# Calculate length and width
set length [expr {$max_x - $min_x}]
set width [expr {$max_y - $min_y}]

# Output the results
puts "Length of bilayer in x-direction: $length Å"
puts "Width of bilayer in y-direction: $width Å"

# Clean up
$bilayer_sel delete

