#!/usr/bin/env pwsh
# Check for CPRS/VistA source code updates from WorldVistA GitHub

$ErrorActionPreference = "Stop"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "CPRS/VistA Source Code Update Checker" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$REPO_OWNER = "WorldVistA"
$REPO_NAME = "VistA"
$GITHUB_API = "https://api.github.com"
$LOCAL_SRC = "$PSScriptRoot/src"

# Check if we have git installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git is not installed. Please install Git to check for updates." -ForegroundColor Red
    exit 1
}

# Check if src directory exists and is a git repo
if (-not (Test-Path $LOCAL_SRC)) {
    Write-Host "❌ Source directory not found: $LOCAL_SRC" -ForegroundColor Red
    Write-Host "   Run this from the CPRS project root directory." -ForegroundColor Yellow
    exit 1
}

Write-Host "📂 Local source: $LOCAL_SRC" -ForegroundColor Gray
Write-Host "🌐 Remote repo: https://github.com/$REPO_OWNER/$REPO_NAME" -ForegroundColor Gray
Write-Host ""

# Get latest release info from GitHub API
Write-Host "🔍 Checking GitHub for latest release..." -ForegroundColor Yellow

try {
    $releases = Invoke-RestMethod -Uri "$GITHUB_API/repos/$REPO_OWNER/$REPO_NAME/releases" -Method Get
    
    if ($releases.Count -eq 0) {
        Write-Host "ℹ️  No official releases found. Checking latest commits..." -ForegroundColor Yellow
        
        # Get latest commits
        $commits = Invoke-RestMethod -Uri "$GITHUB_API/repos/$REPO_OWNER/$REPO_NAME/commits?per_page=10" -Method Get
        
        Write-Host ""
        Write-Host "📋 Latest 10 commits on master branch:" -ForegroundColor Cyan
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
        
        foreach ($commit in $commits) {
            $shortSha = $commit.sha.Substring(0, 7)
            $date = [DateTime]::Parse($commit.commit.author.date).ToString("yyyy-MM-dd")
            $message = $commit.commit.message.Split("`n")[0]
            
            Write-Host "  $shortSha" -ForegroundColor Green -NoNewline
            Write-Host " [$date] " -ForegroundColor Gray -NoNewline
            Write-Host "$message" -ForegroundColor White
            Write-Host "    Author: $($commit.commit.author.name)" -ForegroundColor DarkGray
        }
    }
    else {
        Write-Host ""
        Write-Host "📦 Latest Releases:" -ForegroundColor Cyan
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
        
        # Show last 5 releases
        $releaseCount = [Math]::Min(5, $releases.Count)
        for ($i = 0; $i -lt $releaseCount; $i++) {
            $release = $releases[$i]
            $date = [DateTime]::Parse($release.published_at).ToString("yyyy-MM-dd")
            
            Write-Host ""
            Write-Host "  📌 $($release.tag_name)" -ForegroundColor Green -NoNewline
            Write-Host " - $($release.name)" -ForegroundColor White
            Write-Host "     Published: $date" -ForegroundColor Gray
            
            if ($release.body) {
                $body = $release.body.Trim()
                if ($body.Length -gt 200) {
                    $body = $body.Substring(0, 200) + "..."
                }
                Write-Host "     $body" -ForegroundColor DarkGray
            }
            
            Write-Host "     🔗 $($release.html_url)" -ForegroundColor Blue
        }
    }
}
catch {
    Write-Host "⚠️  Could not fetch GitHub data (rate limited or network issue)" -ForegroundColor Yellow
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

# Check local git status
Write-Host ""
Write-Host "📊 Local Repository Status:" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Push-Location $LOCAL_SRC

try {
    # Get current commit
    $currentCommit = git rev-parse HEAD
    $shortCommit = $currentCommit.Substring(0, 7)
    
    Write-Host "  Current commit: $shortCommit" -ForegroundColor Green
    
    # Get commit date
    $commitDate = git log -1 --format=%cd --date=short
    Write-Host "  Commit date: $commitDate" -ForegroundColor Gray
    
    # Get commit message
    $commitMessage = git log -1 --format=%s
    Write-Host "  Message: $commitMessage" -ForegroundColor White
    
    # Check if there's a remote
    $remotes = git remote -v
    if ($remotes) {
        Write-Host ""
        Write-Host "  Configured remotes:" -ForegroundColor Yellow
        git remote -v | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
        
        Write-Host ""
        Write-Host "🔄 Fetching latest changes from remote..." -ForegroundColor Yellow
        
        try {
            git fetch origin 2>&1 | Out-Null
            
            # Check how many commits behind
            $behind = git rev-list --count HEAD..origin/master 2>&1
            
            if ($LASTEXITCODE -eq 0 -and $behind -match '^\d+$') {
                $behindCount = [int]$behind
                
                if ($behindCount -eq 0) {
                    Write-Host ""
                    Write-Host "✅ You are up to date with origin/master" -ForegroundColor Green
                }
                else {
                    Write-Host ""
                    Write-Host "⚠️  You are $behindCount commit(s) behind origin/master" -ForegroundColor Yellow
                    
                    Write-Host ""
                    Write-Host "📋 New commits available:" -ForegroundColor Cyan
                    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
                    
                    # Show what changed
                    $newCommits = git log --oneline HEAD..origin/master
                    $newCommits | ForEach-Object {
                        Write-Host "    $_" -ForegroundColor Yellow
                    }
                    
                    Write-Host ""
                    Write-Host "📝 Files that changed:" -ForegroundColor Cyan
                    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
                    
                    $changedFiles = git diff --name-status HEAD..origin/master
                    $changedFiles | ForEach-Object {
                        if ($_ -match '^M\s+(.+)$') {
                            Write-Host "    [Modified]  $($Matches[1])" -ForegroundColor Yellow
                        }
                        elseif ($_ -match '^A\s+(.+)$') {
                            Write-Host "    [Added]     $($Matches[1])" -ForegroundColor Green
                        }
                        elseif ($_ -match '^D\s+(.+)$') {
                            Write-Host "    [Deleted]   $($Matches[1])" -ForegroundColor Red
                        }
                    }
                    
                    Write-Host ""
                    Write-Host "💡 To update your local copy:" -ForegroundColor Cyan
                    Write-Host "   cd $LOCAL_SRC" -ForegroundColor White
                    Write-Host "   git pull origin master" -ForegroundColor White
                }
            }
            else {
                Write-Host ""
                Write-Host "ℹ️  Could not determine if updates are available" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "⚠️  Could not fetch from remote: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host ""
        Write-Host "ℹ️  No remote configured. This is a local-only repository." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "💡 To add the WorldVistA remote:" -ForegroundColor Cyan
        Write-Host "   cd $LOCAL_SRC" -ForegroundColor White
        Write-Host "   git remote add origin https://github.com/$REPO_OWNER/$REPO_NAME.git" -ForegroundColor White
        Write-Host "   git fetch origin" -ForegroundColor White
    }
}
catch {
    Write-Host "⚠️  Error checking git status: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "🔗 Resources:" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  📚 Education: https://education.worldvista.org/sample-ehr-curriculum.html" -ForegroundColor Blue
Write-Host "  🐳 Docker Hub: https://hub.docker.com/u/worldvista" -ForegroundColor Blue
Write-Host "  📦 SourceForge: https://sourceforge.net/projects/worldvista-ehr/files/" -ForegroundColor Blue
Write-Host "  💻 GitHub: https://github.com/WorldVistA/VistA" -ForegroundColor Blue
Write-Host ""

Write-Host "✅ Update check complete!" -ForegroundColor Green
Write-Host ""
