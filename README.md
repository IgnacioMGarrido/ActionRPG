<h1 align="center">
  Action RPG</br>
  <small>Zelda Alike</small>
</h1>


<hr>

This project is heavily based on [Make Professional 2d Games with Godot](https://github.com/GDquest/make-pro-2d-games-with-godot/) and it is made with the purpose of learning Godot

<p align='center'>
  <img src="http://i.imgur.com/YP7nnP5.png" alt="Screenshot of the current state of the project" />
</p>

## Dependencies ##

- Godot 3.1 (Any Beta realease should work fine) you can download Godot 3.1 Beta [here](https://downloads.tuxfamily.org/godotengine/3.1/)

## Features ##

Here's a list of the basic gameplay acomplished in [Make Professional 2d Games with Godot](https://github.com/GDquest/make-pro-2d-games-with-godot/).


### Gameplay ###

- A player that can walk, jump, and do a three hit combo with a sword
- Two monsters with steering based movement
- Boss with 3 phases, drops random stacks of coins upon dying
- Items, and inventory, and a shop that will cover your basics for an RPG game

### Core systems ###

- LevelLoader, to load maps cleanly, keep the player's data around
- Save and load system
- Game node to handle pause and initialize the game at the start
- Shader to animate the transition between levels

### User interface ###

- An inventory menu and a shop menu where you can buy and sell items between two characters
- A pause menu with sound options
- A system to create life bars that hook onto monsters and follow them in the game world, but that are still managed by the UI system
- The animated player life bar (tutorial)
- Animated boss light bar that appears when the boss spans

### Visual effects ###

- Layered particle systems like explosions, bursting fire, rock sparkles, dust
- Beautiful noise-based fog thanks to [Gonkee](https://github.com/Gonkee/Gonkee-Fog-Shader)

### A few misc extras

- Modular hit box and damage source system to create ranged and melee weapons
- Stats node to manage the player and the monsters' health
- Gaps the player can fall into
