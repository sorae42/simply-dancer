# Simply Dancer

A script that add "dancing" character to your gameplay! This is NOT the same feature as Stepmania's background 3D character.

**NOTE: THIS IS NOT A STEPMANIA THEME! THIS IS A SCRIPT THAT SHOULD BE PATCHED TO YOUR STEPMANIA THEME!!**

Features:
- Dancing character to your gameplay screen!
- Easy to switch character in the Player option screen!
- Support for 2 players!
- Easy drag and drop new dancer assets!
- The dancer "correctly" dance to fit the music and reacts to BPM changes!

This was an exclusive feature in my discontinued Simply Gensokyo theme, now splitted up for the purpose of integrating to other themes, with additional improvement as well!

## Requirement

- Stepmania 5 (and its fork like ITGMania, OutFox)
- Simply Love (and its fork)*

*: Theme that looks like it's based on Simply Love but is not a fork or doesn't base on its codebase will not work. 

## Preparing and adding new dancer
You must prepare an animation sheet of such character you want to add and name their file corresponding to the directory name, with the frame width, height and "(doubleres)" if your character can be added with double the resolution.

For example, if your character has a sheet of 14 x 2 and named "NMReimu", you must name them and put them in the folder like this: `NMReimu 14x2 (doubleres).png`.

After the preparation, drag the file of your character to the `Dancers` folder in the theme directory and they should be in the player options menu!

Example is provided in the root of this repo.

## Installation/Patching themes
This script is not an easy drag and drop install. You might want to request your theme maker to patch this scripts for you.

If you are a theme maker, the files in this repo are meant to be patched to your theme. These files are either new or existing files. The head and content of each files should be enough for you to work with. You should probably know what you are doing based on the filepath of this repo.

# Attributions

The Simply Love theme is maintained by the community, originally made by hurtpiggypig for SM 3.95.

This repo does not reuse any code from anyone beside my code on the Simply Gensokyo theme.

If you wish to integrate this script to your theme, please do credits the project and link back to this repo!
