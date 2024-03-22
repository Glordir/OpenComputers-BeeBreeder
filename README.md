# Bee Breeder

This program uses the OpenComputers mod for Minecraft to breed better stats onto Forestry Bees.

It was tested in the Modpack GTNH-2.5.1.

## Setup

It needs: 1x Alveary, 3x Compressed Chest, 1x Trash Can / Filing Cabinet, 1x Transposer, 1x Computer, 1x Screen

The output chest needs to be below the transposer. The input chest, buffer chest and trash can need to be on the side of the transposer. The input chest will be detected by checking which chest contains the starting bees. The Trash Can may be replaced by a Filing Cabinet - this ensures that no bees can be accidentally voided.

### How I Set It Up

![Front-View](https://github.com/Glordir/OpenComputers-BeeBreeder/assets/14185727/71766b0a-bf9a-4edb-8b56-a2d4f20ced56)

![Back-View](https://github.com/Glordir/OpenComputers-BeeBreeder/assets/14185727/ffb902d4-cc8b-4689-9b84-7960de01e630)

- Computer (Graphics Card Tier 3, CPU Tier 3, 2x Memory Tier 3.5, Hard Disk Drive Tier 1) + Screen Tier 3
- The Frame Housing contains an Oblivion Frame. The frame is automatically repaired in a Thaumic Restorer using an Item Conduit with Advanced Filters.
- Once the Alveary is finished, the bees are moved to a Scanner using an Item Conduit, the scanned bees are then moved into the input chest.

## How To Use

1. Insert at least 32 breeder drones (Magenta) into the input chest.
2. Insert one bee with the target species as the active trait into the input chest.
3. Make sure that at least one bee in the input chest is a princess (Magenta or Target species)
4. Start the program (main) and press Enter.

## Notes

- Breeder Bee = The bee with the stats that you want, except the species.
- The breeder bee needs to have the species Magenta.
- All Bees need to be analyzed.
- All bees with an active species other than Magenta or the target species in the input chest will be ignored.
- To breed the target stats onto multiple species, I just add one princess per target species into the input chest. The programm will then breed the target stats onto the different princesses.


I wrote this Program for my personal use, and uploaded it here only so that others play around with it / take inspiration from it to create their own program.  
**The program may void useful/important bees (move them to the trash can) if not used correctly.**
