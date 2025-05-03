<h1 align="center">Nebula Overlay</h1>

<p align="center">A gentoo overlay containing a mix of updates to outdated ebuilds from other sources and new ebuilds for things I couldn't find elsewhere.</p>

## Add and Enable the Overlay

```bash
# eselect repository add nebula git https://github.com/ericanebula/gentoo-overlay
# eselect repository enable nebula
```

## Packages

### games-util/input-remapper

https://github.com/sezanzeb/input-remapper

> An easy to use tool for Linux to change the behaviour of your input devices.
Supports X11, Wayland, combinations, programmable macros, joysticks, wheels,
triggers, keys, mouse-movements and more. Maps any input to any other input. 

### net-im/revolt-desktop

https://github.com/revoltchat/desktop

> This is a desktop application for Revolt built on Electron.

#### ⚠️ Deprecation notice ⚠️

This project will soon be replaced by https://github.com/revoltchat/frontend

I'll try to introduce an ebuild for the new project eventually as well.

### games-emulation/rpcs3

https://github.com/RPCS3/rpcs3

This is a fix for the package from the Guru overlay. The RPCS3 project [moved the VulkanMemoryAllocator dependency into a submodule](https://github.com/RPCS3/rpcs3/commit/596e6cc2c39ca452a5a3d42af5b9224de46a9bc3) and the Guru ebuild hasn't been updated yet.

I'd rather submit this as a Pull Request to the Guru overlay but I am not yet set up to do that. So for now it lives here.

### games-misc/sm64coopdx

https://github.com/coop-deluxe/sm64coopdx

> sm64coopdx is an online multiplayer project for the Super Mario 64 PC port that synchronizes all entities and every level for multiple players.

#### ⚠️ Requires you to supply the ROM ⚠️

Building sm64coopdx requires a copy of the N64 game so it can extract assets. For obvious reasons I can't include a copy in this repo. You will need to add your own to this repo's files.

You'll need the US version (I don't know how to support other languages currently). 

1. Rename the file to `baserom.us.z64`
2. Place it in `/var/db/repos/nebula/games-misc/sm64coopdx/files/` (Assuming your repos are in the default location).

Now you can install the ebuild as normal.
