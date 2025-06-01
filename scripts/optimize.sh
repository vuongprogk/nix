#!/usr/bin/env bash

# NixOS Configuration Optimization Script
# This script helps maintain and optimize your NixOS flake configuration

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "❌ Not in a git repository. Please run from your NixOS config directory."
    exit 1
fi

print_step "🔄 Updating flake inputs..."
nix flake update

print_step "🧹 Collecting garbage..."
nix-collect-garbage -d
if command -v sudo >/dev/null; then
    sudo nix-collect-garbage -d
fi

print_step "⚡ Optimizing nix store..."
nix store optimise

print_step "🔧 Building configuration..."
hostname=$(hostname)
if sudo nixos-rebuild switch --flake ".#${hostname}" --show-trace; then
    print_success "✅ Configuration optimized and rebuilt successfully!"
else
    print_error "❌ Build failed. Check the error messages above."
    exit 1
fi

print_step "📊 System info:"
echo "Hostname: ${hostname}"
echo "Kernel: $(uname -r)"
echo "NixOS Generation: $(nixos-version)"

print_success "🎉 All done! Your system is optimized and up to date."
