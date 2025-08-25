# WhatsApp Web AppImage

![Build Status](https://github.com/lokendarjangid/whatsapp_webview_linux/workflows/Build%20and%20Release%20WhatsApp%20Web%20AppImage/badge.svg)
![CI Status](https://github.com/lokendarjangid/whatsapp_webview_linux/workflows/CI%20-%20Build%20Test/badge.svg)

A simple WhatsApp Web client built with Python and GTK, packaged as an AppImage for easy distribution.

## 📥 Download

### Pre-built Releases
Download the latest AppImage from [GitHub Releases](https://github.com/lokendarjangid/whatsapp_webview_linux/releases) - no building required!

1. Download `WhatsApp-Web-*-x86_64.AppImage`
2. Make it executable: `chmod +x WhatsApp-Web-*.AppImage`
3. Run it: `./WhatsApp-Web-*.AppImage`

### Automatic Builds
Every commit to the main branch automatically builds a new AppImage available in the [Actions artifacts](https://github.com/lokendarjangid/whatsapp_webview_linux/actions).

## Quick Start

### Automatic Installation (Recommended)

Run the automatic dependency installer that works across different Linux distributions:

```bash
./install-dependencies.sh
```

This script automatically detects your Linux distribution and installs:

- Python 3 and pip
- PyGObject (Python GTK bindings)
- GTK 3 and WebKit2GTK libraries
- FUSE2 libraries (required for AppImage)
- Build tools (wget, curl)

### Manual Installation

If you prefer to install dependencies manually:

```bash
# For Ubuntu/Debian:
sudo apt update
sudo apt install python3 python3-pip python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-webkit2-4.0 libfuse2 wget

# For Fedora:
sudo dnf install python3 python3-pip python3-gobject gtk3-devel webkit2gtk3-devel fuse-libs wget

# For Arch Linux:
sudo pacman -S python python-pip python-gobject gtk3 webkit2gtk fuse2 wget

# For openSUSE:
sudo zypper install python3 python3-pip python3-gobject gtk3-devel webkit2gtk3-devel libfuse2 wget
```

## Building the AppImage

The build script now automatically checks for and installs FUSE dependencies:

### Method 1: Simple Build (Recommended)

```bash
./build-appimage-simple.sh
```

This script will:

1. Automatically detect your Linux distribution
2. Install FUSE2 libraries if needed
3. Create a lightweight AppImage

### Method 2: Full Build (Advanced)

```bash
./build-appimage.sh
```

This attempts to bundle more dependencies but may require additional setup.

## Running the Application

After building, you can run the AppImage:

```bash
./WhatsApp-Web-x86_64.AppImage
```

Or make it executable and run from file manager:

```bash
chmod +x WhatsApp-Web-x86_64.AppImage
```

## Features

- Clean, minimal interface
- Direct access to WhatsApp Web
- Runs as a native desktop application
- Cross-distribution compatibility (AppImage)

## 🚀 GitHub Actions & CI/CD

This project includes automated GitHub Actions workflows:

### 🔄 Continuous Integration
- **CI Build Test** - Runs on every push/PR to test compatibility
- **Multi-Distro Test** - Weekly tests across different Ubuntu versions and Python versions

### 📦 Automatic Releases
- **Build & Release** - Automatically creates releases when you push a git tag
- Builds AppImage and uploads to GitHub Releases
- Generates release notes automatically

### Creating a Release

1. **Create and push a tag:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **GitHub Actions will automatically:**
   - Build the AppImage
   - Create a GitHub Release
   - Upload the AppImage as a release asset
   - Generate release notes

### Manual Workflow Trigger
You can also manually trigger builds from the GitHub Actions tab.

## 🔧 Development

## 📁 Files Structure

- `whatsapp.py` - Main application source code
- `whatsapp.desktop` - Desktop entry file
- `whatsapp.png` - WhatsApp icon
- `requirements.txt` - Python dependencies
- `install-dependencies.sh` - Automatic dependency installer
- `build-appimage-simple.sh` - Simple AppImage build script
- `build-appimage.sh` - Advanced AppImage build script
- `cleanup.sh` - Build cleanup script
- `test-setup.sh` - Dependency verification script
- `.github/workflows/` - GitHub Actions workflows
  - `build-release.yml` - Main build and release workflow
  - `ci.yml` - Continuous integration testing
  - `multi-distro.yml` - Multi-distribution compatibility testing
- `README.md` - This file

## Troubleshooting

### FUSE Errors

If you get "libfuse.so.2" errors, the build script will automatically try to install FUSE2:

```bash
# The error:
# dlopen(): error loading libfuse.so.2
# AppImages require FUSE to run.
```

**Solution**: Run the dependency installer or build script which auto-installs FUSE2:

```bash
./install-dependencies.sh
# or
./build-appimage-simple.sh  # (includes FUSE check)
```

### Missing Dependencies

If you get errors about missing GTK or WebKit libraries:

```bash
# Run the automatic installer
./install-dependencies.sh

# Or install manually based on your distribution
```

### AppImage Won't Run

1. Make sure the AppImage is executable: `chmod +x WhatsApp-Web-x86_64.AppImage`
2. Check if you have the required system libraries installed
3. Try running the Python script directly: `python3 whatsapp.py`

### Building Issues

If the build fails:

1. Check internet connection (needed to download appimagetool and icon)
2. Ensure you have write permissions in the current directory
3. Try the simple build script first: `./build-appimage-simple.sh`

## License

This project is provided as-is for educational purposes. WhatsApp is a trademark of Meta Platforms, Inc.
