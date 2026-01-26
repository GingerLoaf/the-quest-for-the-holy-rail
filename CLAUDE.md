# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**The Quest for the Holy Rail** - A skating and rail grinding game built in Unity 6.3 LTS for GGJ2026.

- **Design Doc:** https://docs.google.com/document/d/1DdkO2H7mJjd2e99lDin_zPU8fjRwCXnkfwpjowOK6y8/
- **Repository:** https://github.com/GingerLoaf/the-quest-for-the-holy-rail

## Build Commands

This is a Unity project. Open the project folder `Unity/QuestForHolyRail/` in Unity Hub. There are no CLI build/test commands - all building and testing happens through the Unity Editor.

## Architecture

### Core Systems

**Rail Grinding Controller** (`Assets/StarterAssets/ThirdPersonController/Scripts/ThirdPersonController_RailGrinder.cs`)
- Main gameplay script extending third-person movement with spline-based rail grinding
- Player activates grind input near a spline → direction auto-detected from approach vector → CharacterController disabled while spline drives movement
- Key state: `_grindT` (spline position 0-1), `_grindDirection` (StartToEnd/EndToStart), `_grindSpeedCurrent`
- Exit via jump applies velocity in travel direction

**Spline Query Utilities** (`Assets/Samples/Splines/2.8.2/.../Runtime/ShowNearestPoint.cs`)
- Static methods `GetNearestPointOnSplines()` and `GetNearestPointWithDirection()`
- Direction detection: dot product of movement vector against spline tangent at nearest point
- Returns `NearestPointResult` struct with position, distance, spline parameter, and `SplineTravelDirection`

**Input System** (`Assets/StarterAssets/InputSystem/StarterAssetsInputs.cs`)
- Uses Unity's new Input System
- Inputs: Move (Vector2), Look (Vector2), Jump, Sprint, Grind (custom action)

### Movement Flow

1. **Walking/Running:** Standard CharacterController-based movement with Cinemachine camera
2. **Grinding:** When grind activated near spline:
   - `OnGrindRequested()` → `ShowNearestPoint.GetNearestPointWithDirection()` finds nearest spline
   - Direction determined by dot(movement, tangent) with threshold
   - `StartGrind()` disables CharacterController, snaps to spline
   - `Grind()` updates position along spline each frame
   - Jump exits grind and applies velocity

### Key Unity Packages

- `com.unity.splines` (2.8.2) - Rail/spline system
- `com.unity.cinemachine` (2.10.5) - Camera management
- `com.unity.inputsystem` (1.17.0) - Input handling
- `com.unity.mathematics` (1.3.3) - float3, quaternions for spline math

## Code Style

Follow the style guide at `Assets/HolyRail/Documents/CSharp Style Guide.md`. Key points:

- **Naming:** Classes/Methods `PascalCase`, private fields `_camelCase`
- **Unity lifecycle methods** (`Awake`, `Start`, `Update`): Always `private`
- **Serialized properties:** Prefer `[field: SerializeField] public Type Prop { get; private set; }`
- **Braces:** Allman style (opening brace on own line)
- **Variables:** Default to `var` for locals; explicit types for numeric literals
- **No `#region`** - indicates class is too large
- **No redundant XML docs** - self-documenting code preferred
- **Keep console clean** - address warnings immediately
