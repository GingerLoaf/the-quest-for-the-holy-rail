# Unity Build Commands

This document describes how to build the Unity project from the command line using the automated build scripts.

## Prerequisites

- Unity 6.3 (LTS) installed
- Git installed and accessible from command line (for local builds only)
- Project cloned with Git LFS properly configured

## Build Methods

The project includes automated build scripts in `Assets/Editor/BuildScript.cs` that provide:

- **Windows Build**: Creates a Windows 64-bit standalone executable
- **macOS Build**: Creates a macOS app bundle

Both methods automatically:
- Retrieve the current version identifier:
  - First check `GITHUB_SHA` (first 7 characters)
  - Then check `GITHUB_RUN_NUMBER` (e.g., `build-123`)
  - Finally fall back to local `git rev-parse --short HEAD`
- Create output directories in the format: `Builds/{Platform}_{VersionIdentifier}/`
- Sanitize the `productName` (replacing spaces and special characters with `_`) to create a stable artifact name
- Include all enabled scenes from the build settings

## Command Line Usage

### Building for Windows

```bash
cd Unity/QuestForHolyRail

# Replace with your Unity installation path
/Applications/Unity/Hub/Editor/6000.3.5f1/Unity.app/Contents/MacOS/Unity \
  -quit -batchmode -projectPath . \
  -executeMethod BuildScript.BuildWindows \
  -logFile -
```

**Output**: `Builds/Windows_{SHA}/{SanitizedProductName}.exe`

### Building for macOS

```bash
cd Unity/QuestForHolyRail

# Replace with your Unity installation path
/Applications/Unity/Hub/Editor/6000.3.5f1/Unity.app/Contents/MacOS/Unity \
  -quit -batchmode -projectPath . \
  -executeMethod BuildScript.BuildMacOS \
  -logFile -
```

**Output**: `Builds/macOS_{SHA}/{SanitizedProductName}.app`

## Unity Editor Menu

You can also trigger builds from within the Unity Editor:

1. Open the project in Unity
2. Go to **Build → Build Windows** or **Build → Build macOS**
3. The build will execute and output to the same directory structure

## Finding Your Unity Installation Path

### macOS
```bash
# Unity Hub installations
ls /Applications/Unity/Hub/Editor/
```

### Windows
```powershell
# Unity Hub installations
dir "C:\Program Files\Unity\Hub\Editor\"
```

## Build Output Structure

```
Unity/QuestForHolyRail/
└── Builds/
    ├── Windows_7d3d2b5/
    │   └── QuestForHolyRail.exe
    └── macOS_7d3d2b5/
        └── QuestForHolyRail.app
```

The version identifier in the folder name makes it easy to track which version of the code was used for each build, while the filename remains stable for distribution tools.

## Troubleshooting

### "git command not found"
Ensure git is installed and accessible from the command line. The build script will fall back to "unknown" if git is not available.

### "No scenes found in build settings"
Open the Unity Editor and add scenes to the build settings:
1. Go to **File → Build Settings**
2. Add your scenes to the **Scenes In Build** list
3. Ensure the scenes you want are checked/enabled

### Unity path not found
Update the Unity executable path in the commands above to match your installation. Check Unity Hub preferences to find the exact installation location.
