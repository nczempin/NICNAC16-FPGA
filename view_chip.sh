#!/usr/bin/env bash
set -e

echo "Installing KLayout for chip visualization..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y klayout
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y klayout
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S klayout
    else
        echo "Please install KLayout manually from https://www.klayout.de/"
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew >/dev/null 2>&1; then
        brew install klayout
    else
        echo "Please install KLayout manually from https://www.klayout.de/"
        exit 1
    fi
else
    echo "Please install KLayout manually from https://www.klayout.de/"
    exit 1
fi

GDSII_FILE="asic_flow/designs/nicnac16_cpu/runs/run_20250604_235041/results/signoff/nicnac16_cpu.klayout.gds"

if [ -f "$GDSII_FILE" ]; then
    echo "Opening your NICNAC16 CPU chip layout..."
    klayout "$GDSII_FILE" &
else
    echo "GDSII file not found. Run ./run_openlane_docker.sh first."
    exit 1
fi