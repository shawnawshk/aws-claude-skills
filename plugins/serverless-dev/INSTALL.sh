#!/bin/bash
# Installation script for AWS Serverless Development Claude Plugin

set -e

PLUGIN_SOURCE="/home/coder/serverless-dev"
PLUGIN_NAME="aws-serverless-dev"

echo "🚀 AWS Serverless Development Plugin Installer"
echo "=============================================="
echo ""

# Function to install as personal plugin
install_personal() {
    echo "📦 Installing as personal plugin (available across all projects)..."
    INSTALL_DIR="$HOME/.claude/plugins/$PLUGIN_NAME"

    # Create plugins directory if it doesn't exist
    mkdir -p "$HOME/.claude/plugins"

    # Remove existing installation if present
    if [ -d "$INSTALL_DIR" ]; then
        echo "⚠️  Existing installation found. Removing..."
        rm -rf "$INSTALL_DIR"
    fi

    # Copy plugin
    echo "📋 Copying plugin files..."
    cp -r "$PLUGIN_SOURCE" "$INSTALL_DIR"

    echo "✅ Plugin installed to: $INSTALL_DIR"
}

# Function to install as project plugin
install_project() {
    if [ -z "$1" ]; then
        echo "❌ Error: Project path required"
        echo "Usage: $0 project /path/to/project"
        exit 1
    fi

    PROJECT_PATH="$1"
    echo "📦 Installing as project plugin (only for: $PROJECT_PATH)..."
    INSTALL_DIR="$PROJECT_PATH/.claude/plugins/$PLUGIN_NAME"

    # Create plugins directory if it doesn't exist
    mkdir -p "$PROJECT_PATH/.claude/plugins"

    # Remove existing installation if present
    if [ -d "$INSTALL_DIR" ]; then
        echo "⚠️  Existing installation found. Removing..."
        rm -rf "$INSTALL_DIR"
    fi

    # Copy plugin
    echo "📋 Copying plugin files..."
    cp -r "$PLUGIN_SOURCE" "$INSTALL_DIR"

    echo "✅ Plugin installed to: $INSTALL_DIR"
}

# Function to verify installation
verify_installation() {
    INSTALL_DIR="$1"

    echo ""
    echo "🔍 Verifying installation..."

    # Check required files
    REQUIRED_FILES=(
        ".claude-plugin/plugin.json"
        "skills/aws-serverless/SKILL.md"
        ".mcp.json"
        "README.md"
        "CLAUDE.md"
    )

    ALL_OK=true
    for file in "${REQUIRED_FILES[@]}"; do
        if [ -f "$INSTALL_DIR/$file" ]; then
            echo "  ✅ $file"
        else
            echo "  ❌ $file (missing)"
            ALL_OK=false
        fi
    done

    # Count reference files
    REF_COUNT=$(find "$INSTALL_DIR/skills/aws-serverless/reference" -name "*.md" 2>/dev/null | wc -l)
    echo "  ✅ Reference files: $REF_COUNT/10"

    if [ "$ALL_OK" = true ]; then
        echo ""
        echo "✨ Installation verified successfully!"
        return 0
    else
        echo ""
        echo "⚠️  Installation incomplete. Some files are missing."
        return 1
    fi
}

# Function to show usage
show_usage() {
    echo "Usage:"
    echo "  $0 personal              # Install for all projects (recommended)"
    echo "  $0 project <path>        # Install for specific project"
    echo ""
    echo "Examples:"
    echo "  $0 personal"
    echo "  $0 project ~/my-serverless-app"
}

# Main installation logic
case "${1:-personal}" in
    personal)
        install_personal
        verify_installation "$HOME/.claude/plugins/$PLUGIN_NAME"
        echo ""
        echo "📚 Next steps:"
        echo "  1. Restart Claude Code (if running)"
        echo "  2. Try: 'Create a serverless API with Lambda'"
        echo "  3. Check: /plugins to see installed plugins"
        ;;
    project)
        install_project "$2"
        verify_installation "$2/.claude/plugins/$PLUGIN_NAME"
        echo ""
        echo "📚 Next steps:"
        echo "  1. cd $2"
        echo "  2. Start Claude Code in this directory"
        echo "  3. Try: 'Create a serverless API with Lambda'"
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        echo "❌ Unknown option: $1"
        show_usage
        exit 1
        ;;
esac
