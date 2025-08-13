
"""
eco_pairs_A81.py — QEL A81 utility
Given a two-digit number XY (10..99), compute suggested cardinal modulation.
Validation must be somatic/ritual (see QEL VIII).
"""
def mod_from_two_digit(xy: int):
    if xy < 10 or xy > 99:
        raise ValueError("xy must be between 10 and 99")
    X = xy // 10
    Y = xy % 10
    orient = +X               # Hz (attack)
    norte  = -max(1, Y-1)     # Hz (sustain)
    occ    = (X - Y) % 3      # vibrato amplitude in Hz (±occ)
    sur_decay = min(25, X + Y) # % decay extension
    return {
        "Oriente:+Hz": orient,
        "Norte:-Hz": norte,
        "Occidente:±Hz": occ,
        "Sur:decay%": sur_decay,
        "Puentes": {"5th":"9+0", "9th":"0+9"}
    }

if __name__ == "__main__":
    for n in (18, 27, 64, 72, 81):
        print(n, mod_from_two_digit(n))
