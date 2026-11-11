# Learn to Fly Idle: source code

The ActionScript 3 code of the Flash version of Learn to Fly Idle, as last saved (2018).

This is for reading, not building. The art, sound and Flash project file aren't included.

## What's here

1. `src/`: the game's classes.
2. `scripts/`: the code that sat on timeline frames inside the Flash project file, one file per timeline. Each block starts with a comment saying which layer and frame it's on.
3. `framework/lbg/`: Light Bringer Games' shared Flash library, which the game uses for logging, saving, audio and more.

Not included, since they aren't ours to relicense: `PixelPerfectCollisionDetection` from freeactionscript.com, and Adobe's Flash components.

Third-party framework code keeps its original terms: `CollisionDetection.as` (Grant Skinner, MIT), `MouseWheelTrap.as` (spikything.com, MIT), `Easing.as` (Robert Penner, BSD) and `BigInt.as` (Leemon Baird, ActionScript port by Ian Peters, public domain).

## Saves and run rules

Existing local Flash saves still load from the original storage location. File import accepts `.sav` exports from this release.

Research caps at level 10. A later qualifying kill can overwrite a stored clear time under 7,000 seconds with a slower time.

## License

The [LBG-NCNC License v1.0](LICENSE.md) covers Light Bringer Games' source code in this repository.

You can read, use, change, and share the code for noncommercial purposes, including by forking it on GitHub. When sharing, credit Light Bringer Games and keep the license and copyright notices. Get written permission before distributing or hosting a product based on the code that competes with or undercuts a Light Bringer Games product or service, even if it's free. The full license governs.

Light Bringer Games reserves its rights in the game's name, art, and sound. Third-party files have their own licenses.
