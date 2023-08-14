Documentation can be found here: https://docs.google.com/document/d/1a_Y_sPnWuPyXuZQulnAQQ7tt8m6cMErSneYgr6OBkk8/edit
# 1   Objective

The goal of our final project is to design a digital clock with the following features: 12/24 hour clock, stopwatch and timer. The clock is to be described in Verilog HDL, then uploaded onto an FPGA. The results must be projected onto a monitor via an onboard VGA Cable. This project aims to provide us with a deeper understanding of HDL’s and the interfaces used to relay digital signals and data onto monitors and screens.



# 2.1 Design Description

The project is divided into two sections, the VGA visuals and the clock  internals. The clock is divided into many different submodules that facilitate its operation, this will be discussed further in the report. The VGA Driver syncs the internal clock of the FPGA with the refresh-rate standards of the VGA, allowing us to control the display color pixel-by-pixel. To ease workflow, we divided the screen into various rectangular zones, the sizes of which were determined by the 640x480 limitation set by the VGA.  The aforementioned zones were then put together to form 7-Segment displays, the components of which could be easily manipulated to show any number required by the clock.

The clock-internals were grouped together by a single top module that facilitated their connection, which was wrapped by the VGA-Driver, which was the project top module. The clock is composed of debouncers, clock-dividers, a multiplexer, a 2:4 decoder, counters and the sub-modules for each mode. The debouncers were implemented to ensure the FPGA inputs get read correctly, and the clock-dividers were used to drive the various submodules at 1-Hz, simulating real-time. The 2:4 decoder received input from a 2-bit counter, the purpose of which was to track the current mode of the clock, cycling through them at every push of a button. The output of the decoder would then enable the relevant submodules for input-receival. This was vital as the modules all use the same buttons for input. Finally, the multiplexer is connected to the select-button to determine which clock-output should be given to the VGA topmodel for rendering.

Each sub-module has its intended purpose. The precise implementation will be discussed in section 3.1 & 3.2, for now we will focus on the purpose-driven description. Each module works with and outputs a 24-Bit BCD number. Every 4-Bits represent a unit of time, starting with tens of hours and going down to singular seconds. All the submodules are driven by the 100 Mhz clock, but the incrementing is controlled by a 1Hz output of a clock divider.

## 12/24 Hour Clock 

The system-clock was divided into two modules, one for the 12-Hour AM/PM time, the other for 24-Hour military time. This division was a design choice forced by limitations with the visual-interfacing we described, the details of which are mentioned in Section 2.3. These modules began with a default time of 12:00:00 AM, or 00:00:00. The moment the startup/reset cycle has commenced the clocks check the 1-Hz increment input, and increment whenever it goes high. For the clocks, the increment input is constantly switching on and off at 1-Hz, 50% duty cycle.  The clock operates in the background even after switching modes.

### Stopwatch

The stopwatch can be paused or unpaused via the push of a button asynchronously. This is done via a combinational logic flag. If the flag reads paused, the input input is ignored, freezing the screen on the current status. If the flag reads unpaused, the stopwatch is incremented every cycle, again by the 1Hz clock-divider. When the user desires, another push button can be used to reset the timer to zero.

### Timer

The timer works similarly to the stopwatch but in reverse. We opted to use a switch for the pause and unpause mechanism for variety. While the timer is paused, it can be set to any desired value asynchronously through the use of the push buttons, with one button to select a digit and one button to increment the selected digit. The timer can also be reset to the time it was originally set to, and has a flag to check its pause status. 

## 2.2 Schematics & Diagrams

Figure 1: Schematic of Top Clock Module. There are 7 total inputs (including a global reset) and 4 total outputs. 
	The design process begins with a collection of words put together to describe something. Those words are then brought into visual representation via schematics and diagrams that allow us to bring forth our work into being. Our first visual schematic was a mock-up of the clock display (Fig.2)
 
The mock-up guided our design process and ultimately led us to our final design. There were multiple changes along the way, such as changing our color-scheme and opting for a 7-Segment display instead of a 14-Segment one, but laying down our initial goal visually guided us throughout the design process.

## 2.3 Design Choices
	
We made several design choices throughout the course of the project. Some were  drawing-board initiatives to simplify the implementation, whereas others were trade-offs required for a functional design.

The clock was made to operate on BCD numbers. This resulted in extremely readable outputs, easy debugging for testbenches and, most importantly, simple conversion into a 7-Segment driver-decoder, which was vital due to our choice of using a 7-Segment Display for rendering our clock outputs. The 7SD was an extremely reliable choice, allowing us to easily display any of the numbers in the base-10 radix. Creating this standard would allow us to add or modify our clock within minutes, even allowing us to create 9-Segment displays for certain characters, or even a 14-Segment display should the need arise. The choice to work in BCD also bore unexpected fruit in that it slashed the number of modules needed in the final design. If we went down the binary route, we would need to convert our binary into BCD eventually for display. However, since we were already in BCD, that need was no longer present.

These design choices were not without flaw, of course. The choice to use BCD instead of binary complicated the logic-design of our modules. We needed to think in BCD with every operation, and ensure that the BCD number caps at 1001. This resulted in a more complex description than anticipated, making our code less standardized than we had hoped. Another design choice with its own setback was the 7-Segment display. While its positives far outweighed the negatives, the inability to display characters such as M meant we faced a challenge when it came to displaying non-numeric characters and strings, such as the Am/Pm indicator. 

The design choices for the submodules were also done in effort of creating an easier to work with design, rather than a very efficient one. Working this way allowed for easy debugging and test benching, and critically allowed for easy problem isolation. A problem in one module usually would not ripple into the next. This design choice had the side effect of making parallel functionality between modes more difficult to implement, as signals had to be routed many times through the top module. However, it made switching one set of designs for another a quick, painless process.

Every design choice made had its own reasons and context. However, they all taught us valuable lessons about the design process in logic-design and engineering in general. Each choice had an alternative, and each alternative had its own alternative. The project could be redone hundreds of times over, each with a different angle of approach.



# 3.1 Design Implementation
After deciding on a top level design (Fig.1), we began to work. The VGA strobe was largely unchanged from the initial square demonstration, bar a few additions to display a digital clock rather than a grid of squares. Our more intriguing work was on implementing the clock. 

Within our clock module, we routed three buttons, a clock signal, a reset signal, and a switch. All button inputs were debounced. The clock signal was used to control a 1Hz clock, which enabled the timekeeping of the device. All button inputs were debounced and routed to their respective modules. In order to ensure that all modules would not be triggered by the same button press, a decoder was used to send a “button enable” signal to each module to ensure it was only triggered when it was displayed on the screen. The signals from the clock, stopwatch, and timer were then fed into a 24-bit wide 4 to 1 multiplexer, and fed to the VGA strobe. 

## 3.2 System Functionality
Opting for a simple user interface, our clock functions mostly on single-press button architecture. To select a digit to edit in the clock or timer, or to increment said digit, the user needs only to press two buttons. One that increments across the screen selecting each digit, whilst another increments the selection up by 1, overflowing when reaching the maximum. Another button is mapped to switch between modes, and the same button used to increment on other modes is used to start or stop the stopwatch. This results in a system that is functionally sound without hindering the user.

## 3.3 Error Correction 
Many of the problems we faced were visual in nature, due to our lack of experience in VGA Drivers. The VGA port “maps” its pixels onto a 640x480 screen, which gets blown-up or shrunk-down by the monitor VGA is connected to. This detail made it quite difficult to work with the VGA as we needed to accommodate this growth factor whilst sectioning off portions of the screen as mentioned in section 2. These errors were corrected by defining offset parameters used to adjust the size and location of each digit until they fit into place. 

# 4. Results

Using testbenches, we were able to test our designs before their eventual implementation. The verification of our clock, stopwatch, and timer can be found below. Figures can be found in the documentation link above. 


# 5. Summary & Conclusions

Working with a project that required external interfacing of the FPGA outputs proved to be a worthwhile challenge. Syncing the horizontal and vertical VGA timings, feeding binary and BCD information between separate modules to build a larger system and facing error after error after error taught us just how intensely important (and slightly frustrating) logic design is. It also gave us insight into our shortcomings on the project and any improvements we can pursue in a second iteration. Some basic ones include module optimization (speed-up and power consumption), size reduction and GUI overhaul. We also considered the addition of more exciting features, such as recording laps, displaying two modes in parallel, alerting when a timer has finished and taking in touchscreen or keyboard inputs. There are many paths we could take on a redesign, of course. Some offer exemplary speed, whilst others could be a swiss-army knife in the world of digital clocks. It is certain that no matter which redesign we would choose to pursue, the knowledge we gain from the endeavor makes the time spent working on it well worth it.
