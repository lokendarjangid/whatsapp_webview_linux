#!/bin/bash

# Install dependencies for WhatsApp Web AppImage

set -e

echo "🔧 Installing dependencies for WhatsApp Web AppImage..."

# Function to detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    elif command -v lsb_release >/dev/null 2>&1; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

# Function to install packages based on distribution
install_dependencies() {
    local distro=$(detect_distro)
    echo "Detected distribution: $distro"
    
    case "$distro" in
        ubuntu|debian|pop|mint|elementary)
            echo "Installing dependencies for Debian/Ubuntu..."
            sudo apt-get update
            sudo apt-get install -y \
                python3 \
                python3-pip \
                python3-gi \
                python3-gi-cairo \
                gir1.2-gtk-3.0 \
                gir1.2-webkit2-4.0 \
                libfuse2 \
                wget \
                curl
            ;;
        fedora)
            echo "Installing dependencies for Fedora..."
            sudo dnf install -y \
                python3 \
                python3-pip \
                python3-gobject \
                gtk3-devel \
                webkit2gtk3-devel \
                fuse-libs \
                wget \
                curl
            ;;
        rhel|centos|rocky|almalinux)
            echo "Installing dependencies for RHEL/CentOS..."
            sudo yum install -y epel-release
            sudo yum install -y \
                python3 \
                python3-pip \
                python3-gobject \
                gtk3-devel \
                webkit2gtk3-devel \
                fuse-libs \
                wget \
                curl
            ;;
        arch|manjaro)
            echo "Installing dependencies for Arch Linux..."
            sudo pacman -Sy --noconfirm \
                python \
                python-pip \
                python-gobject \
                gtk3 \
                webkit2gtk \
                fuse2 \
                wget \
                curl
            ;;
        opensuse|opensuse-leap|opensuse-tumbleweed)
            echo "Installing dependencies for openSUSE..."
            sudo zypper install -y \
                python3 \
                python3-pip \
                python3-gobject \
                gtk3-devel \
                webkit2gtk3-devel \
                libfuse2 \
                wget \
                curl
            ;;
        *)
            echo "⚠️  Unsupported or unknown distribution: $distro"
            echo "Please install the following packages manually:"
            echo "  - Python 3 with pip"
            echo "  - Python GTK bindings (PyGObject)"
            echo "  - GTK 3 development libraries"
            echo "  - WebKit2GTK development libraries"
            echo "  - FUSE2 libraries"
            echo "  - wget and curl"
            exit 1
            ;;
    esac
}

# Check if running as root (not recommended)
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  Running as root is not recommended. Please run as a regular user."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Install system dependencies
install_dependencies

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip3 install --user PyGObject

# Verify installation
echo "🔍 Verifying installation..."
python3 -c "
import gi
gi.require_version('Gtk', '3.0')
gi.require_version('WebKit2', '4.0')
from gi.repository import Gtk, WebKit2
print('✅ All Python dependencies are working!')
"

# Check FUSE
if ldconfig -p | grep -q libfuse.so.2; then
    echo "✅ FUSE2 libraries are available"
else
    echo "❌ FUSE2 libraries not found. AppImage might not work."
fi

echo ""
echo "🎉 Installation complete!"
echo "You can now build the AppImage by running:"
echo "   ./build-appimage-simple.sh"
echo ""
echo "Or run the app directly with:"
echo "   python3 whatsapp.py"
