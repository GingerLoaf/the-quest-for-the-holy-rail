# Welcome to the GGJ2026 project "The quest for the holy rail"

## Design & direction
Our brain dump doc is here: https://docs.google.com/document/d/1DdkO2H7mJjd2e99lDin_zPU8fjRwCXnkfwpjowOK6y8/edit?tab=t.0

## Technologies & Tools
- We are using Unity 6.3 (LTS)
- We are tracking tasks on github: https://github.com/GingerLoaf/the-quest-for-the-holy-rail/issues

## Git LFS Setup

This project uses **Git Large File Storage (LFS)** to manage large binary files like Unity assets, textures, models, and audio files.

### Installing Git LFS

#### macOS
```bash
# Using Homebrew
brew install git-lfs
```

#### Windows
1. **Using Git for Windows installer** (recommended):
   - Download the latest Git for Windows from [git-scm.com](https://git-scm.com/download/win)
   - Git LFS is included in the installer by default (make sure it is checked during installation)

2. **Using Chocolatey**:
   ```
   choco install git-lfs
   ```

3. **Manual installation**:
   - Download the installer from [git-lfs.github.com](https://git-lfs.github.com/)
   - Run the installer and follow the prompts

### Checking if Git LFS is Installed

Run this command in your terminal:
```
git lfs version
```

If installed correctly, you should see output like:
```
git-lfs/3.4.0 (GitHub; darwin arm64; go 1.21.0)
```

### Initializing Git LFS

After installing Git LFS, you need to initialize it **once per user account**:

```bash
git lfs install
```

You should see:
```
Updated Git hooks.
Git LFS initialized.
```

### Cloning This Repository

When cloning this repository for the first time:

```bash
git clone https://github.com/GingerLoaf/the-quest-for-the-holy-rail.git
cd the-quest-for-the-holy-rail
git lfs pull
```

### Common Signs Git LFS is NOT Installed or Working

If Git LFS isn't properly set up, you may experience:

1. **Pointer files instead of actual files**
   - Files appear as small text files (< 200 bytes) containing text like:
     ```
     version https://git-lfs.github.com/spec/v1
     oid sha256:4d7a...
     size 12345678
     ```

2. **Unity errors on project load**
   - "Asset import failed" errors
   - Missing textures, models, or audio files
   - Broken prefabs or scenes

3. **Git shows large files as modified**
   - Running `git status` shows many large files as changed when you haven't modified them

4. **Slow clone/pull operations**
   - Repository takes unexpectedly long to clone despite small reported size

### Fixing Git LFS Issues

If you're experiencing any of the above issues:

1. **Install Git LFS** (see instructions above)
2. **Initialize Git LFS**:
   ```bash
   git lfs install
   ```
3. **Fetch LFS files**:
   ```bash
   git lfs fetch --all
   git lfs pull
   ```
4. **Verify LFS files**:
   ```bash
   git lfs ls-files
   ```
   This should list all files tracked by LFS

### What Files Are Tracked by Git LFS?

Check the `.gitattributes` file in the repository root to see which file types are managed by Git LFS. 