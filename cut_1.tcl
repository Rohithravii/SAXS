mol new slab_dmpc_min_2.pdb


# Define the head group selection criteria (adjust according to your lipid type)

# Calculate the geometric center of the bilayer in the xy-plane
set center_xy [measure center [atomselect top " resname DMPC"]]
set center_x [lindex $center_xy 0]
set center_y [lindex $center_xy 1]

# Convert nanometers to Angstroms for the radius (20 nm = 200 Angstroms)
set radius 135

# Select the head groups within 20 nm from the center in the xy-plane
set headgroup_sel [atomselect top "name P N"]
set resids {}

# Iterate over each head group atom and check its distance in the xy-plane
foreach atom [$headgroup_sel list] {
    set pos [atomselect top "index $atom" frame 1]
    set x [lindex [$pos get {x}] 0]
    set y [lindex [$pos get {y}] 0]

    # Calculate distance from the center in xy-plane
    set dx [expr {$x - $center_x}]
    set dy [expr {$y - $center_y}]
    set distance [expr {sqrt($dx*$dx + $dy*$dy)}]

    if {$distance < $radius} {
        lappend resids [[atomselect top "index $atom"] get resid]
    }

    $pos delete
}

# Select entire lipid molecules corresponding to these head groups
set lipid_sel [atomselect top "resid $resids"]


Remove duplicate residue IDs as each lipid has only one headgroup
set unique_resids [lsort -unique $resids]

# Count the number of unique headgroups selected
set num_headgroups [llength $unique_resids]
puts "Number of headgroups within the radius: $num_headgroups"

# Select entire lipid molecules corresponding to these head groups
set lipid_sel [atomselect top "resid $resids"]





# Write the selected lipids (head group with tail) to a file
$lipid_sel writepdb selected_lipids_xy.pdb

# Clean up
$headgroup_sel delete
$lipid_sel delete
