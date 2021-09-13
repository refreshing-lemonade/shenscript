# ShenScript

ShenScript is a lua script that effectively creates an improved training mode for the Famicom game Joy Mech Fight (1993).

## Features

ShenScript includes features such as: Frame advantage timer, invincibility and damage scaling display, hitbox visualizer, toggles for health and stun, and a proper training dummy.

## Usage

To enable training mode, either edit the lua file where specified or go into a regular match and press SELECT on the pause menu. While in training mode you can toggle different features on and off.
 - A - Toggle hitbox display
 - B - Change stun behavior
 - Select - Toggle training mode
 - Up - Toggle restore health
 - Down - Toggle dummy to perform action state as a reversal
 - Left/Right - Change action state of dummy

Hitbox display doesn't properly work for characters that change their palette for their moves (Kaen, Nay, Leo, etc) but all characters display hitboxes properly on the character select screen. Once you select a character you can press left and right to view the hitboxes of their different attacks.

## Contributing
Feel free to change this as you see fit or request additions, if enough people want additions I can update it.

## License
[MIT](https://choosealicense.com/licenses/mit/)