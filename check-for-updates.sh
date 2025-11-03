#!/bin/bash
# Check for CPRS/VistA source code updates from WorldVistA GitHub

set -e

echo "=================================================="
echo "CPRS/VistA Source Code Update Checker"
echo "=================================================="
echo ""

# Configuration
REPO_OWNER="WorldVistA"
REPO_NAME="VistA"
GITHUB_API="https://api.github.com"
LOCAL_SRC="$(dirname "$0")/src"

# Check if we have git installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git to check for updates."
    exit 1
fi

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "❌ curl is not installed. Please install curl to check for updates."
    exit 1
fi

# Check if src directory exists
if [ ! -d "$LOCAL_SRC" ]; then
    echo "❌ Source directory not found: $LOCAL_SRC"
    echo "   Run this from the CPRS project root directory."
    exit 1
fi

echo "📂 Local source: $LOCAL_SRC"
echo "🌐 Remote repo: https://github.com/$REPO_OWNER/$REPO_NAME"
echo ""

# Get latest release info from GitHub API
echo "🔍 Checking GitHub for latest release..."

RELEASES=$(curl -s "$GITHUB_API/repos/$REPO_OWNER/$REPO_NAME/releases" || echo "[]")

if [ "$RELEASES" = "[]" ] || [ "$(echo "$RELEASES" | grep -c "tag_name")" -eq 0 ]; then
    echo "ℹ️  No official releases found. Checking latest commits..."
    
    # Get latest commits
    COMMITS=$(curl -s "$GITHUB_API/repos/$REPO_OWNER/$REPO_NAME/commits?per_page=10")
    
    echo ""
    echo "📋 Latest 10 commits on master branch:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    echo "$COMMITS" | grep -A 3 '"sha":' | head -40 | while IFS= read -r line; do
        if [[ $line =~ \"sha\":\ *\"([^\"]+)\" ]]; then
            SHA="${BASH_REMATCH[1]:0:7}"
            echo -n "  $SHA"
        elif [[ $line =~ \"date\":\ *\"([^\"]+)\" ]]; then
            DATE="${BASH_REMATCH[1]:0:10}"
            echo -n " [$DATE] "
        elif [[ $line =~ \"message\":\ *\"([^\"]+)\" ]]; then
            MSG="${BASH_REMATCH[1]}"
            echo "$MSG"
        fi
    done
else
    echo ""
    echo "📦 Latest Releases:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Show last 5 releases
    echo "$RELEASES" | grep -A 5 '"tag_name":\|"name":\|"published_at":\|"html_url":' | head -30
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check local git status
echo ""
echo "📊 Local Repository Status:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd "$LOCAL_SRC"

# Get current commit
CURRENT_COMMIT=$(git rev-parse HEAD)
SHORT_COMMIT="${CURRENT_COMMIT:0:7}"

echo "  Current commit: $SHORT_COMMIT"

# Get commit date
COMMIT_DATE=$(git log -1 --format=%cd --date=short)
echo "  Commit date: $COMMIT_DATE"

# Get commit message
COMMIT_MESSAGE=$(git log -1 --format=%s)
echo "  Message: $COMMIT_MESSAGE"

# Check if there's a remote
REMOTES=$(git remote -v)
if [ -n "$REMOTES" ]; then
    echo ""
    echo "  Configured remotes:"
    git remote -v | sed 's/^/    /'
    
    echo ""
    echo "🔄 Fetching latest changes from remote..."
    
    if git fetch origin 2>&1 > /dev/null; then
        # Check how many commits behind
        BEHIND=$(git rev-list --count HEAD..origin/master 2>/dev/null || echo "unknown")
        
        if [ "$BEHIND" = "0" ]; then
            echo ""
            echo "✅ You are up to date with origin/master"
        elif [ "$BEHIND" != "unknown" ]; then
            echo ""
            echo "⚠️  You are $BEHIND commit(s) behind origin/master"
            
            echo ""
            echo "📋 New commits available:"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            
            # Show what changed
            git log --oneline HEAD..origin/master | sed 's/^/    /'
            
            echo ""
            echo "📝 Files that changed:"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            
            git diff --name-status HEAD..origin/master | while read -r status file; do
                case "$status" in
                    M) echo "    [Modified]  $file" ;;
                    A) echo "    [Added]     $file" ;;
                    D) echo "    [Deleted]   $file" ;;
                    *) echo "    [$status]       $file" ;;
                esac
            done
            
            echo ""
            echo "💡 To update your local copy:"
            echo "   cd $LOCAL_SRC"
            echo "   git pull origin master"
        else
            echo ""
            echo "ℹ️  Could not determine if updates are available"
        fi
    else
        echo "⚠️  Could not fetch from remote"
    fi
else
    echo ""
    echo "ℹ️  No remote configured. This is a local-only repository."
    echo ""
    echo "💡 To add the WorldVistA remote:"
    echo "   cd $LOCAL_SRC"
    echo "   git remote add origin https://github.com/$REPO_OWNER/$REPO_NAME.git"
    echo "   git fetch origin"
fi

echo ""
echo "=================================================="
echo "🔗 Resources:"
echo "=================================================="
echo "  📚 Education: https://education.worldvista.org/sample-ehr-curriculum.html"
echo "  🐳 Docker Hub: https://hub.docker.com/u/worldvista"
echo "  📦 SourceForge: https://sourceforge.net/projects/worldvista-ehr/files/"
echo "  💻 GitHub: https://github.com/WorldVistA/VistA"
echo ""

echo "✅ Update check complete!"
echo ""
