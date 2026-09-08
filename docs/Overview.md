---
title: Overview
nav_order: 2
---

# Quick Overview
CatPaw provides many helpful utils on top of Love2D, with most of them being usable without any form of architectural lock in for your game. Use only the bits you need, this includes only copying/pulling those files, to keep your build light (not that text files take much, anyways).

# Layers
CatPaw provides a middle ground between frameworks (Love2D, Raylib, etc...) and general purpose engines (Unity, GMS Godot, etc...), and gives you the option of either a fully code based workflow with zero GUIs, or one complemented by GUIs where needed (level creation, etc...).
The engine is cut into layers. Lower layers can be used completely separately from those above, 

## Layers - [`hook`]
Provides backend abstraction so that you can use any Lua based backend. (Currently only Love2D is supported; future plans include CoronaSDK/Solaris2D, Raylib, Usagi, and a custom backend.)

## Layers - [`core`]
Provides many useful utils, that can be used standalone, most classes/modules in this layer have zero dependencies on the rest of the engines (beyond Kikito's `middleclass`, so you'll need that), so you can grab only their single file

Examples:
- Logger
- Remote Console View
- Hot Reload (For files you write, and built-in support for things such as the Data Registry.)
- Event System (Fully works with the abstraction layer to abstract love, and later other, OS events.)
- Scheduler / Timers
- Debug HUDS / Views
- Profiler
- Serialization
- Various Utils (Math, Color, Geometry, Tables, Strings, etc...)
- Finite State Machines (FSMs)
- Particle System Helpers
- etc.. 

## Layers - [`engine`]
Provides architectural components that help you structure and manage your game. Most of those require some amount of architectural lock-in for your game, but save a lot of time and offer more powerful features in return.

Examples:
- Entity Component System
- Asset Registry (Includes support for things such as missing textures and auto scaling.)
- Data Registry (For data driven development,
- Sprite Drawing & Animations (Supports separate files, and spritesheets.)
- Window scale fixing/handling.
- Views & Camera (Supports player tracking. Supports multiple cameras for things such as split-screen, minimaps, overlays, etc...).
- Screen shake, shaders, other FX, etc...
- etc...

## Layers - [`template`]
Provides pre-made mechanics and features for rapid prototyping. Things you'd probably switch out later on for your own custom system but are handy to drop in quickly into temp code for testing, or for things such as game jams.
If the rules allow it, you could even use these for code golf and demoscene projects.

This provides built-ins for rapid prototyping. Things you'd probably switch out later on for your own custom system but are incredibly valuable for proof of concept, MVPs, demos, etc... Things like a pre-made movement system, pre-setup physics world, inventory system, and other game-mechanics or systems that are ready-made for plug-and-play testing.

Examples:
- Movement 
- Inventory
- Crafting
- Combat 

I still try to make those as configurable and modular as possible. For example, for inventories, supporting slot based inventories (Minecraft style), size/shape based (DayZ/Unturned style) or weight based (The Long Dark / ARK Survival style). This is usually done by a mix of configurations passed to classes and/or separate classes (e,g, for different inventory styles). But, regardless, the main of this layer continues to be prototyping or game jams, so if you're making a serious game you'll probably want to (at least eventually) switch these out for your own systems.

# Code-Only-First With Optional GUIs
Code only; with external standalone editors for things that really need them, such as level editors and recipe editors; and support for popular editors such as Tiled or LDtk.
- All external editors support multiple export options, so you can use them standalone with any other engine or framework you'd like.
- Includes external editors for things where you mostly expect game designers or non-technical people to work on them; such for as stats (the Data Registry). crafting recipes, etc...
- Includes external editors for when you need live previews of the numbers your tweaking, for working on things such as procedural content (terrain, maps, quests, etc...)
- This is mostly accomplished using an inspector-like-GUI-hook-in-class that can also be used from within CatPaw itself. This means that it is trivial to have such live GUI widgets/"knobs" that are overlayed on your game and support hot reload.
- etc...
- NOTE: No external editors are currently implemented. So the above points are all PLANNED, only. But we do have Tiled support. 

# License - MIT, Do What You Want
Open sourced under the permissive MIT license,  forever. Do whatever you want, no fees or anything.

Any new, standalone or otherwise, tools for CatPaw (such as the editors mentioned above) will also be open sourced under the permissive MIT license.

# Zero Gen AI
**Zero gen-AI usage. Fully handcrafted, with love (pun intended).**
