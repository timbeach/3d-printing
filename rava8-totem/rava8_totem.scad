// RAVA8 desk totem enclosure
// Board: gabrielguerrer/rava8_rng, all board facts measured from src/rng_rava.brd (EAGLE 9.6.2)
// Orientation: board stands vertical, component side forward, USB edge DOWN.
// The micro USB plug lives inside the base cavity; the cable exits through the rear arch.
// A right angle micro USB cable gives the cleanest result.
//
// Parts: render with -D 'part="body"' or -D 'part="diffuser"' (or "all" for preview).
// Print: body back face down, diffuser flat. No supports needed.
// Diffuser prints best in transparent or natural PETG, 2 perimeters, 0 or low infill.

part = "all"; // "body" | "diffuser" | "all"

/* ---- Board facts (do not change, measured from the EAGLE file) ---- */
pcb_w  = 37.02;             // board width
pcb_h  = 59.92;             // board height
pcb_t  = 1.6;               // board thickness
hole_x = [3.865, 33.19];    // M3 hole centers from board lower left (symmetric)
hole_y = [2.545, 57.37];
usb_cx = 14.03;             // USB center from left edge, USB-down orientation

/* ---- Tunables ---- */
wall       = 2.4;   // shell wall thickness
clr        = 0.5;   // side clearance around the board
standoff_h = 5;     // board standoff height off the back wall
front_gap  = 10;    // board face to diffuser (room for an LED behind the panel)
diff_t     = 1.6;   // diffuser panel thickness
diff_clr   = 0.4;   // sliding clearance for the diffuser channel
groove     = 1.5;   // groove depth into each side wall
lip_t      = 1.6;   // front frame lip thickness
frame_b    = 3.0;   // visible frame border around the window
base_h     = 20;    // cavity under the board for the USB plug and cable bend
top_gap    = 4;     // headroom above the board
post_od    = 7;     // standoff post outer diameter
screw_d    = 2.7;   // M3 self tapping pilot hole
usb_open_w = 16;    // finger opening in the floor under the USB
arch_w     = 26;    // rear cable arch width
label      = "RAVA8";
label_dep  = 0.6;

/* ---- Derived ---- */
inner_w = pcb_w + 2*clr;
outer_w = inner_w + 2*wall;
inner_d = standoff_h + pcb_t + front_gap;
ch_z0   = wall + inner_d;            // diffuser channel back face
ch_t    = diff_t + diff_clr;
outer_d = ch_z0 + ch_t + lip_t;
outer_h = wall + base_h + pcb_h + top_gap + wall;
ch_w    = inner_w + 2*groove;
board_y0 = wall + base_h;            // board bottom edge height

$fn = 48;

module body() {
  difference() {
    // shell
    cube([outer_w, outer_h, outer_d]);

    // main cavity
    translate([wall, wall, wall])
      cube([inner_w, outer_h - 2*wall, inner_d]);

    // diffuser channel: grooves into both side walls, out through the top
    translate([(outer_w - ch_w)/2, wall, ch_z0])
      cube([ch_w, outer_h, ch_t]);

    // front window
    translate([wall + frame_b, wall + frame_b, ch_z0])
      cube([inner_w - 2*frame_b, outer_h - 2*wall - 2*frame_b, outer_d]);

    // floor opening under the USB (push the plug up from below)
    translate([wall + clr + usb_cx - usb_open_w/2, -1, wall])
      cube([usb_open_w, wall + 2, inner_d]);

    // rear cable arch
    translate([outer_w/2, 0, -1]) {
      translate([-arch_w/2, -1, 0]) cube([arch_w, wall + base_h - 4 + 1, wall + 2]);
      translate([0, wall + base_h - 4, 0]) cylinder(d = arch_w, h = wall + 2);
    }

    // right side wall label, reads bottom to top when the totem stands
    translate([outer_w - label_dep, wall + base_h + 4, outer_d/2])
      rotate([90, 0, 90])
        linear_extrude(label_dep + 0.01)
          text(label, size = 6, font = "Liberation Sans:style=Bold",
               halign = "left", valign = "center");
  }

  // standoff posts
  for (hx = hole_x, hy = hole_y)
    translate([wall + clr + hx, board_y0 + hy, 0])
      difference() {
        cylinder(d = post_od, h = wall + standoff_h);
        translate([0, 0, wall]) cylinder(d = screw_d, h = standoff_h + 1);
      }
}

module diffuser() {
  dw = ch_w - 0.5;         // slide fit
  dh = outer_h - wall + 2.5; // reaches the floor, tab proud of the top
  difference() {
    cube([dw, dh, diff_t]);
    // thumb chamfers on the tab corners
    translate([-1, dh - 1, -1]) rotate([0, 0, -45]) cube([4, 4, diff_t + 2]);
    translate([dw + 1, dh - 1, -1]) rotate([0, 0, -45]) cube([4, 4, diff_t + 2]);
  }
}

if (part == "body") body();
if (part == "diffuser") diffuser();
if (part == "all") {
  body();
  // diffuser shown in place
  color("white", 0.35)
    translate([(outer_w - (ch_w - 0.5))/2, wall, ch_z0 + diff_clr/2])
      diffuser();
  // ghost of the board for the preview
  color("green", 0.5)
    translate([wall + clr, board_y0, wall + standoff_h])
      cube([pcb_w, pcb_h, pcb_t]);
}

echo(str("Outer: ", outer_w, " x ", outer_h, " x ", outer_d, " mm"));
