# RAVA8 Desk Totem Enclosure

A parametric two part enclosure for the RAVA8 TRNG (gabrielguerrer/rava8_rng).
No published enclosure exists for this board; this one is modeled from the
exact geometry in the repo's EAGLE file (`src/rng_rava.brd`): 37.02 x 59.92 mm
board, four M3 holes on a 29.325 x 54.825 mm grid, USB center 14.03 mm from the
left edge in the USB-down orientation.

The board stands vertical, component side forward, USB edge down. The micro
USB plug lives inside the base cavity and the cable exits through the rear
arch. A right angle micro USB cable gives the cleanest look. A translucent
diffuser panel slides into side grooves from the top; an LED wired to the
board's LED header sits in the 10 mm gap behind it and makes the front glow.

Outer size: 42.8 x 88.7 x 22.6 mm. "RAVA8" is engraved on the right flank.

## Files

- `rava8_totem.scad`: the parametric source. Everything is a variable.
- `rava8_totem_body.stl`: main shell. Print back face down, no supports.
- `rava8_totem_diffuser.stl`: front panel. Print flat.

## Print settings (Inventor Center)

- Body: PETG or PLA, 0.2 mm layers, 3 perimeters, 15 percent infill.
- Diffuser: transparent or natural filament, 2 perimeters, 0 to 5 percent
  infill, or print it in white at 1 perimeter for a softer glow.
- No supports for either part. Minor sag inside the front groove lip is
  cosmetic and does not affect the slide fit.

## Assembly

1. Program the board first (ICSP is enclosed once mounted).
2. Screw the board to the four posts with M3 self tapping screws into the
   2.7 mm pilot holes, USB edge toward the base.
3. Optional: stick an LED or short LED strip behind the diffuser position,
   wired to the board's LED header.
4. Slide the diffuser down through the top slot.
5. Feed a micro USB plug in through the rear arch, seat it, stand it up.

## Before printing the final version

Do a caliper check against a real board and dry fit one draft print: the
numbers from the EAGLE file are exact, but connector overhang and plug body
sizes vary by cable. `base_h` (20 mm) is the value to grow if your cable's
plug plus bend needs more room. Tweak variables at the top of the .scad and
re-export:

```
openscad -o rava8_totem_body.stl -D 'part="body"' rava8_totem.scad
openscad -o rava8_totem_diffuser.stl -D 'part="diffuser"' rava8_totem.scad
```
