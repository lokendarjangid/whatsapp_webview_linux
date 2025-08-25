# .gitignore Summary for WhatsApp Web AppImage

## 🚫 Files and Directories Excluded from Git

### Build Artifacts
- `*.AppImage` - The final AppImage executables
- `AppDir/` - Temporary build directory
- `squashfs-root/` - Extracted appimagetool directory
- `appimagetool-x86_64.AppImage` - Downloaded build tool

### Python-Related
- `__pycache__/`, `*.pyc`, `*.pyo` - Compiled Python files
- `venv/`, `env/`, `.venv/` - Virtual environments
- `*.egg-info/`, `dist/`, `build/` - Package build artifacts
- `.pytest_cache/`, `coverage.xml` - Testing artifacts

### Development Tools
- `.vscode/`, `.idea/` - IDE configuration
- `*.swp`, `*.swo` - Editor temporary files
- `.DS_Store`, `Thumbs.db` - System files

### Logs and Temporary Files
- `*.log`, `*.tmp`, `*.temp` - Log and temporary files
- `*.bak`, `*.backup` - Backup files

## ✅ Files Tracked in Git

### Core Application
- `whatsapp.py` - Main application code
- `whatsapp.desktop` - Desktop entry file
- `whatsapp.png` - Application icon
- `requirements.txt` - Python dependencies

### Build and Automation
- `build-appimage-simple.sh` - Main build script
- `build-appimage.sh` - Advanced build script
- `install-dependencies.sh` - Dependency installer
- `cleanup.sh` - Build cleanup script
- `test-setup.sh` - Testing script
- `create-release.sh` - Release helper script

### Documentation and Configuration
- `README.md` - Project documentation
- `CHANGELOG.md` - Version history
- `.github/workflows/` - GitHub Actions
- `.gitignore` - This file

### Why These Exclusions?

1. **Build Artifacts** - Can be regenerated, often large
2. **Virtual Environments** - Platform-specific, recreatable
3. **IDE Files** - Personal preferences, not universal
4. **System Files** - OS-specific, not needed in repo
5. **Temporary Files** - Temporary by nature
6. **Compiled Files** - Generated from source code

### Testing the .gitignore

To test what files will be ignored:
```bash
git status --ignored
```

To see what would be added:
```bash
git add --dry-run .
```
