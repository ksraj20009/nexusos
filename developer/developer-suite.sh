#!/bin/bash
# Vajra OS — Developer Suite
# Install and configure development tools
set -e

echo "◆ Vajra OS — Developer Suite Setup"

# Install core dev tools
DEV_PACKAGES=(
    git git-lfs build-essential cmake ninja-build
    python3 python3-pip python3-venv python3-dev
    nodejs npm
    default-jdk maven
    rustc cargo
    golang-go
    code vim neovim tmux
    docker.io docker-compose
    jq yq httpie curl wget
    sqlite3 postgresql-client mysql-client
    redis-tools
    clang-format cppcheck valgrind
    shellcheck
)

echo "  Installing developer packages..."
sudo apt-get update -qq
for pkg in "${DEV_PACKAGES[@]}"; do
    if dpkg -l "$pkg" &>/dev/null; then
        echo "    ✓ $pkg (already installed)"
    else
        sudo apt-get install -y "$pkg" 2>/dev/null && echo "    ✓ $pkg" || echo "    ⚠ $pkg (failed)"
    fi
done

# Configure Git defaults
git config --global user.name "Vajra OS Developer" 2>/dev/null || true
git config --global user.email "dev@vajra.os" 2>/dev/null || true
git config --global init.defaultBranch main 2>/dev/null || true
git config --global pull.rebase false 2>/dev/null || true

# Install Python dev tools
pip3 install --user black flake8 mypy pylint ipython pytest pipenv virtualenv 2>/dev/null || true
echo "  ✓ Python dev tools installed"

# Install Node global tools
npm install -g typescript ts-node eslint prettier nodemon 2>/dev/null || true
echo "  ✓ Node dev tools installed"

# Create project scaffolding tool
mkdir -p /opt/vajra/dev
cat > /opt/vajra/dev/scaffold.sh << 'SCAFFOLD'
#!/bin/bash
# Vajra OS Project Scaffolding
PROJECT_NAME="${1:-my-project}"
PROJECT_TYPE="${2:-python}"
PROJECT_DIR="$HOME/projects/$PROJECT_NAME"

mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

case "$PROJECT_TYPE" in
    python)
        python3 -m venv venv
        echo "$PROJECT_NAME" > README.md
        echo "__pycache__/" > .gitignore
        echo "venv/" >> .gitignore
        mkdir -p src tests docs
        echo "" > src/__init__.py
        ;;
    node)
        npm init -y
        mkdir -p src tests
        ;;
    rust)
        cargo init
        ;;
    go)
        go mod init "$PROJECT_NAME"
        mkdir -p cmd internal pkg
        ;;
    web)
        mkdir -p src/css src/js assets
        cat > index.html << HTML
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>$PROJECT_NAME</title></head>
<body><h1>$PROJECT_NAME</h1></body>
</html>
HTML
        ;;
esac

git init 2>/dev/null
echo "◆ Project '$PROJECT_NAME' ($PROJECT_TYPE) created at $PROJECT_DIR"
SCAFFOLD
chmod +x /opt/vajra/dev/scaffold.sh
ln -sf /opt/vajra/dev/scaffold.sh /usr/local/bin/vajra-scaffold 2>/dev/null || true

# Create dev environment setup
cat > /opt/vajra/dev/setup-dev-env.sh << 'DEVENV'
#!/bin/bash
export PS1="\[\033[36m\]⚡ vajra-dev:\w\$\[\033[0m\] "
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

alias gs="git status"
alias gl="git log --oneline"
alias gp="git push"
alias gc="git commit"
alias ll="ls -la"
alias py="python3"
alias serve="python3 -m http.server 8000"
alias ports="ss -tlnp"

echo "◆ Vajra dev environment loaded"
DEVENV
chmod +x /opt/vajra/dev/setup-dev-env.sh

if ! grep -q "vajra/dev/setup-dev-env" "$HOME/.bashrc" 2>/dev/null; then
    echo 'source /opt/vajra/dev/setup-dev-env.sh' >> "$HOME/.bashrc"
fi

echo "  ✓ Developer suite installed"
echo "  ◆ Scaffold tool: vajra-scaffold <name> <python|node|rust|go|web>"
echo "◆ Done"
