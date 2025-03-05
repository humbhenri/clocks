#!/usr/bin/env tclsh

package require Tk

# Create the main window
wm title . "Analog Clock"

canvas .canvas -width 300 -height 300
pack .canvas -fill both -expand true

# Define the center of the clock
set centerX 150
set centerY 150
set radius 120

# Function to draw the clock face
proc draw_clock {} {
    global centerX centerY radius
    .canvas delete all

    # Draw clock circle
    .canvas create oval [expr $centerX - $radius] [expr $centerY - $radius] \
        [expr $centerX + $radius] [expr $centerY + $radius] \
        -outline "black" -width 2

    # Draw clock ticks
    for {set i 0} {$i < 12} {incr i} {
        set angle [expr $i * 30]
        set x1 [expr $centerX + cos($angle * 3.14159 / 180) * ($radius - 10)]
        set y1 [expr $centerY - sin($angle * 3.14159 / 180) * ($radius - 10)]
        set x2 [expr $centerX + cos($angle * 3.14159 / 180) * $radius]
        set y2 [expr $centerY - sin($angle * 3.14159 / 180) * $radius]
        .canvas create line $x1 $y1 $x2 $y2 -fill "black"
    }
}

# Function to update the hands of the clock
proc update_clock {} {
    global centerX centerY radius

    # Get the current time
    set time [clock seconds]
    set hours [clock format $time -format "%I"]
    set minutes [clock format $time -format "%M"]
    set seconds [clock format $time -format "%S"]

    # Convert to angles
    set hour_angle [expr {($hours % 12) * 30 + ($minutes / 60.0) * 30}]
    set minute_angle [expr {$minutes * 6}]
    set second_angle [expr {$seconds * 6}]

    # Clear previous hands
    .canvas delete hands

    # Draw hands
    .canvas create line $centerX $centerY \
        [expr $centerX + cos(($hour_angle - 90) * 3.14159 / 180) * ($radius * 0.5)] \
        [expr $centerY + sin(($hour_angle - 90) * 3.14159 / 180) * ($radius * 0.5)] \
        -fill "black" -width 6 -tags hands

    .canvas create line $centerX $centerY \
        [expr $centerX + cos(($minute_angle - 90) * 3.14159 / 180) * ($radius * 0.8)] \
        [expr $centerY + sin(($minute_angle - 90) * 3.14159 / 180) * ($radius * 0.8)] \
        -fill "blue" -width 4 -tags hands

    .canvas create line $centerX $centerY \
        [expr $centerX + cos(($second_angle - 90) * 3.14159 / 180) * ($radius * 0.9)] \
        [expr $centerY + sin(($second_angle - 90) * 3.14159 / 180) * ($radius * 0.9)] \
        -fill "red" -width 2 -tags hands
}

# Function to update the clock every second
proc update_time {} {
    update_clock
    after 1000 update_time
}

proc resize_clock {w h} {
    global centerX centerY radius

    # Set new center and radius based on canvas size
    set centerX [expr $w / 2]
    set centerY [expr $h / 2]
    set radius [expr [min $w $h] / 2.5]

    # Redraw everything
    draw_clock
    update_clock
}

# Helper function to find the minimum of two numbers
proc min {a b} {
    if {$a < $b} {
        return $a
    } else {
        return $b
    }
}

# Bind resize event to update clock
bind .canvas <Configure> {resize_clock %w %h}


# Draw clock face and start the time updates
draw_clock
update_time

