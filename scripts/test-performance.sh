#!/usr/bin/env bash

# Shell Performance Testing Script
# This script measures zsh and tmux startup times

set -euo pipefail

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_result() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

measure_command() {
    local cmd="$1"
    local description="$2"
    local iterations=${3:-3}
    
    echo "Testing: $description"
    local total=0
    
    for i in $(seq 1 $iterations); do
        local start=$(date +%s%N)
        eval "$cmd" >/dev/null 2>&1
        local end=$(date +%s%N)
        local duration=$(( (end - start) / 1000000 )) # Convert to milliseconds
        total=$((total + duration))
        echo "  Run $i: ${duration}ms"
    done
    
    local average=$((total / iterations))
    print_result "  Average: ${average}ms"
    echo
}

print_header "Shell & Tmux Performance Test"

print_warning "Testing zsh startup time..."
measure_command "zsh -i -c exit" "Zsh interactive startup"

print_warning "Testing tmux startup time..."
measure_command "tmux new-session -d -s perf_test && tmux kill-session -t perf_test" "Tmux session creation/destruction"

print_warning "Testing combined tmux + zsh startup..."
measure_command "tmux new-session -d -s perf_test 'zsh -i -c exit' && tmux kill-session -t perf_test" "Tmux with zsh initialization"

print_header "Performance Tips"
echo "• Good tmux startup: < 200ms"
echo "• Good zsh startup: < 100ms" 
echo "• If times are high, consider:"
echo "  - Disabling unused zsh plugins"
echo "  - Caching expensive operations"
echo "  - Using lazy loading for tools"
echo "  - Reducing history size"
echo ""
print_result "Run this script after rebuilding to measure improvements!"
