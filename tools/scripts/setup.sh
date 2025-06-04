#!/usr/bin/env bash
# NICNAC16 Development Environment Setup
# Supports both FPGA and ASIC development workflows

set -e

echo "🚀 NICNAC16 Development Environment Setup"
echo "========================================="
echo

# Initialise submodules in case OpenLane or the PDK are provided that way
git submodule update --init --recursive || true

# Commands required for FPGA development
required_cmds=(g++ make cppcheck iverilog gtkwave python3)

# Track packages that need installation
missing_pkgs=()

echo "📦 Checking FPGA development tools..."

# Check for command line tools
for cmd in "${required_cmds[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing_pkgs+=("$cmd")
  fi
done

# Add Python development packages
if ! dpkg -s python3-pip >/dev/null 2>&1; then
    missing_pkgs+=(python3-pip)
fi

if ! dpkg -s python3-venv >/dev/null 2>&1; then
    missing_pkgs+=(python3-venv)
fi

# Install missing packages
if [[ ${#missing_pkgs[@]} -ne 0 ]]; then
  echo "Installing packages: ${missing_pkgs[*]}"
  sudo apt-get update -y || true
  sudo apt-get install -y "${missing_pkgs[@]}" || true
fi

# Verify command line tools
for cmd in "${required_cmds[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd not installed" >&2
    exit 1
  fi
done

echo "✅ FPGA development tools installed"

# Set up Python virtual environment for testing
echo ""
echo "🐍 Setting up Python virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "Created virtual environment: venv/"
fi

source venv/bin/activate
pip install --upgrade pip
pip install cocotb pytest

# Verify Python packages
python3 -c "import cocotb; print(f'✅ cocotb version: {cocotb.__version__}')" || {
    echo "Warning: cocotb not properly installed"
}

echo "✅ Python environment configured"

# ASIC Development Setup
echo ""
echo "🔧 Setting up ASIC development tools..."

# Check for Docker
if ! command -v docker >/dev/null 2>&1; then
    echo "⚠️  Docker not found. Installing Docker..."
    
    # Install Docker
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Set up the stable repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker Engine
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    
    # Add user to docker group
    sudo usermod -aG docker $USER
    echo "⚠️  Please log out and back in for Docker group changes to take effect"
else
    echo "✅ Docker found: $(docker --version)"
fi

# Check if Docker is running and accessible
if docker ps >/dev/null 2>&1; then
    echo "✅ Docker is running and accessible"
else
    echo "⚠️  Docker is installed but not accessible. You may need to:"
    echo "   1. Start Docker service: sudo systemctl start docker"
    echo "   2. Add yourself to docker group: sudo usermod -aG docker $USER"
    echo "   3. Log out and back in"
fi

# Pull OpenLane Docker image
echo ""
echo "📥 Setting up OpenLane Docker image..."
if docker images | grep -q "efabless/openlane"; then
    echo "✅ OpenLane Docker image already available"
else
    echo "Pulling OpenLane Docker image (this may take a while)..."
    docker pull efabless/openlane:latest || {
        echo "⚠️  Failed to pull OpenLane image. Check Docker installation and internet connection."
    }
fi

# Create OpenLane helper script if it doesn't exist
OPENLANE_SCRIPT="./run_openlane_docker.sh"
if [ ! -f "$OPENLANE_SCRIPT" ]; then
    echo ""
    echo "📝 Creating OpenLane helper script: $OPENLANE_SCRIPT"
    
    # Check if we're in asic_flow directory or project root
    if [ -f "asic_flow/run_openlane_docker.sh" ]; then
        cp asic_flow/run_openlane_docker.sh ./run_openlane_docker.sh
        chmod +x ./run_openlane_docker.sh
        echo "✅ Copied existing OpenLane script to project root"
    else
        echo "⚠️  OpenLane script not found at asic_flow/run_openlane_docker.sh"
        echo "   You may need to create it manually or run this script from the project root"
    fi
fi

echo ""
echo "🎉 Setup Complete!"
echo "================="
echo ""
echo "FPGA Development:"
echo "  • Tools installed: iverilog, gtkwave, etc."
echo "  • Python environment: venv/ (activate with 'source venv/bin/activate')"
echo "  • Run tests: make test"
echo ""
echo "ASIC Development:"
echo "  • Docker and OpenLane ready"
echo "  • Run ASIC flow: ./run_openlane_docker.sh"
echo ""
echo "To use Python tools (cocotb), activate the virtual environment first:"
echo "  source venv/bin/activate"