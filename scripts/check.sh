#!/usr/bin/env bash

# Quick build script for testing configuration changes
# This does a dry-run build to check for errors without applying changes

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

hostname=$(hostname)

print_step "🔍 Checking flake syntax..."
if nix flake check --no-build; then
    print_success "✅ Flake syntax is valid"
else
    print_error "❌ Flake syntax errors found"
    exit 1
fi

print_step "🏗️  Building configuration (dry-run)..."
if nixos-rebuild dry-build --flake ".#${hostname}"; then
    print_success "✅ Configuration builds successfully!"
    print_step "Run './scripts/optimize.sh' to apply changes"
else
    print_error "❌ Build failed. Check the error messages above."
    exit 1
fi
