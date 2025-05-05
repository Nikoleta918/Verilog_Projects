VGA Labyrinth Game – SystemVerilog Project
Overview
This project implements a simple VGA-based labyrinth game using two SystemVerilog modules:

Panel_Display_lab.sv: Responsible for rendering the VGA video output, generating synchronization signals, and displaying a static labyrinth and moving elements (like player and goal) on screen.

game.sv: Integrates input from a PS/2 keyboard to control player movement within the labyrinth and coordinates game logic (movement rules, collision detection, goal condition, etc.).

Together, these modules provide a visual maze where a player-controlled block can navigate through a path rendered on a VGA display.

File Descriptions
Panel_Display_lab.sv
Function:
Displays a maze and various elements (walls, path, player, entrance, exit) on a VGA screen using specific color coding.

Inputs:

clk: System clock

rst: Asynchronous reset

address[3:0]: ROM address for game map

data[31:0]: Map data (provided by top-level game module)

Outputs:

hsync, vsync: VGA synchronization signals

red, green, blue: 4-bit color signals for VGA

data[31:0]: The ROM output based on input address

Features:

Internal video timing generation (column/row counters)

Draws maze blocks based on position

Colors:

White: walls

Red: player

Green: entrance/exit

Blue: maze paths

Timing logic for VGA 640x480 with additional sync handling

game.sv
Function:
Top-level module that handles game logic and player interaction via keyboard input, then forwards video signals to Panel_Display_lab.

Inputs:

clk: Main clock

rst: Reset

kData, kClock: PS/2 keyboard data and clock

Outputs:

hsync, vsync: Forwarded to VGA

red, green, blue: Forwarded VGA color output

led[7:0]: Debug output showing internal states and keypress detection

Features:

Keyboard input decoding (W/A/S/D for movement)

Collision detection (walls block movement)

Player position tracking (player_row, player_colunms)

Maintains ROM-based maze (start_lab)

Supports movement flags and direction validation

Syncs data with Panel_Display_lab to draw updated positions

How It Works
Keyboard Interface:

Decodes PS/2 keyboard signals into movement directions.

Maps specific scancodes:

W → Up

A → Left

S → Down

D → Right

Game Logic:

Prevents player movement into walls by checking ROM data.

Updates player coordinates if the move is valid.

Video Output:

Player and maze data are rendered on screen using color-coded blocks.

Panel_Display_lab handles rendering logic using VGA timing.

ROM Data (start_lab):

Hardcoded 12-row maze where each 32-bit word represents a row.

Each 2 bits define a cell:

00 = wall

01, 10, 11 = paths or special markers

Hardware Requirements
FPGA board with:

VGA output

PS/2 input (keyboard)

8 LEDs for debug

Clock source

Reset signal

Compilation and Simulation
Load the project into an FPGA toolchain (e.g., Intel Quartus, Xilinx Vivado).

Ensure keyboard and VGA pins are mapped to the correct FPGA I/O.

Simulate using a SystemVerilog-compatible simulator if desired (ModelSim, etc.).

Synthesize and upload to the FPGA.
