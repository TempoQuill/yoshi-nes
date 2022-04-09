# Yoshi (NES)
A full disassembly of the NES version of Yoshi

# Specs:
-	Mapper: MMC1
-	RAM: 2K (all internal)
-	ROM: 256K PRG - 128K / CHR - 128K
-	Window: 16K PRG / 4K PRG
-	Mirroring: Horizontal (unused)

# Premise:
Enemies are always descending, and the enemies generated will help you, as Mario or Luigi, determine which plates they should land on.

# Modes:
There are 3 total gameplay modes: continual, stage clear, and 2 player.

## Continual:
-	Goal: None
-	Handicap: None
-	Tip: Save as many shell halves as possible; your ranking upon Game Over is determined by the amount of eggs hatched in that game.

## Stage Clear:
-	Goal: Clear the board
-	Handicap: Configurable
-	Tip: Leave the shell halves open so you can clear it later, instead of needing to hatch it.

## 2 Player:
-	Goal: Beat the opponent
-	Handicap: Configurable
-	Tip: Stack as many enemies as you can onto the shell halves.  The more enemies, the bigger the Yoshi, the most garbage sent.

## General Tips:
-	Use the upcoming enemies to decide where to put the current ones; this will help you clear as efficiently as possible.  This is most applicable for the stage clear and 2 player modes.
-	Place the bottom shell halves on the lowest elevations you can find; this will help you send garbage in 2 player mode and optimize your shell count in continual mode.

# Building:
Code for this game comes with ASM6F as well as a `.bat` file that the command prompt will recognize.  To build this, go to the command prompt, follow the directory with `cd`, and type `build`.  There are no configurations.  Feel free to make some.