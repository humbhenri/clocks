# This program draws an analogical clock 
# author: Humberto Henrique Campos Pinheiro
# created: 18/07/13

# configure window
wm title . TkClock
wm geometry . 250x250+0+0
frame .fr
pack .fr -fill both -expand 1

# draw the clock
canvas .fr.can
pack .fr.can -side top -fill both -expand 1
set wall [expr min([.fr.can cget -width], [.fr.can cget -height])-50]
set centerX 120
set centerY 120
set radius 90
.fr.can create oval 20 20 $wall $wall -fill #000

# map a number from 0-59 to radians
proc toRadian {x} {
    set pi 3.1415
    #assure that $x is not interpreted as octal
    regexp {^0*(\d+)} $x _dummy x
    expr ($x * $pi/30) - ($pi/2)
}

# return the coordinates of the clock hands based in current time
proc hourX {centerX radius} {
    set hour [expr [clock format [clock seconds] -format {%l}] * 5]
    expr $centerX + 0.4 * $radius * cos([toRadian $hour])
}

proc hourY {centerY radius} {
    set hour [expr [clock format [clock seconds] -format {%l}] * 5]
    expr $centerY + 0.4 * $radius * sin([toRadian $hour])
}

proc minuteX {centerX radius} {
    set minute [clock format [clock seconds] -format {%M}]
    expr $centerX + 0.7 * $radius * cos([toRadian $minute])
}

proc minuteY {centerY radius} {
    set minute [clock format [clock seconds] -format {%M}]
    expr $centerY + 0.7 * $radius * sin([toRadian $minute])
}

proc secondX {centerX radius} {
    set second [clock format [clock seconds] -format {%S}]
    expr $centerX + $radius * cos([toRadian $second])
}

proc secondY {centerY radius} {
    set second [clock format [clock seconds] -format {%S}]
    expr $centerY + $radius * sin([toRadian $second])
}

set hourHand [.fr.can create line $centerX $centerY [hourX $centerX $radius] \
[hourY $centerY $radius] -fill red]

set minuteHand [.fr.can create line $centerX $centerY [minuteX $centerX $radius] \
[minuteY $centerY $radius] -fill red]

set secondHand [.fr.can create line $centerX $centerY [secondX $centerX $radius] \
[secondY $centerY $radius] -fill green]

# update every second
proc tick {} {
    global hourHand minuteHand secondHand centerX centerY radius
    .fr.can coords $hourHand $centerX $centerY [hourX $centerX $radius] \
        [hourY $centerY $radius]
    .fr.can coords $minuteHand $centerX $centerY [minuteX $centerX $radius] \
        [minuteY $centerY $radius]
    .fr.can coords $secondHand $centerX $centerY [secondX $centerX $radius] \
        [secondY $centerY $radius]
    after 1000 tick
    return
}
tick
