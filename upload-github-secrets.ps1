# ========================================
# GitHub Secrets Bulk Upload Script
# ========================================

# STEP 1: Fill in your credentials in github-secrets.env file
# STEP 2: Run this script in PowerShell

$repo = "mjhanzaibmemon/foodie-app"
$secretsFile = "github-secrets.env"

Write-Host "`n🚀 GitHub Secrets Bulk Upload Tool`n" -ForegroundColor Cyan

# Check if GitHub CLI is installed
try {
    $ghVersion = gh --version 2>$null
    Write-Host "✅ GitHub CLI detected: $($ghVersion[0])" -ForegroundColor Green
} catch {
    Write-Host "❌ GitHub CLI not found. Installing...`n" -ForegroundColor Yellow
    
    # Install GitHub CLI
    Write-Host "Installing GitHub CLI via winget..." -ForegroundColor Cyan
    winget install --id GitHub.cli -e --silent
    
    Write-Host "`n✅ GitHub CLI installed! Please close and reopen PowerShell, then run this script again." -ForegroundColor Green
    Write-Host "After reopening, run: gh auth login" -ForegroundColor Yellow
    exit
}

# Check if authenticated
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Not authenticated with GitHub. Please login first:`n" -ForegroundColor Yellow
    Write-Host "   gh auth login`n" -ForegroundColor Cyan
    exit
}

Write-Host "✅ Authenticated with GitHub`n" -ForegroundColor Green

# Check if secrets file exists
if (-not (Test-Path $secretsFile)) {
    Write-Host "❌ Error: $secretsFile not found!" -ForegroundColor Red
    Write-Host "`nPlease create the file from template:" -ForegroundColor Yellow
    Write-Host "   1. Copy github-secrets.env.template to github-secrets.env" -ForegroundColor Cyan
    Write-Host "   2. Fill in your actual credentials" -ForegroundColor Cyan
    Write-Host "   3. Run this script again`n" -ForegroundColor Cyan
    exit
}

# Read and upload secrets
Write-Host "📤 Uploading secrets to $repo...`n" -ForegroundColor Cyan

$successCount = 0
$failCount = 0

Get-Content $secretsFile | ForEach-Object {
    $line = $_.Trim()
    
    # Skip empty lines and comments
    if ($line -eq "" -or $line.StartsWith("#")) {
        return
    }
    
    if ($line -match '^([^=]+)=(.+)$') {
        $secretName = $matches[1].Trim()
        $secretValue = $matches[2].Trim()
        
        # Skip placeholder values
        if ($secretValue -match '\*+' -or $secretValue -match 'XXXX' -or $secretValue -match 'xxxxx') {
            Write-Host "⚠️  Skipping $secretName (placeholder value detected)" -ForegroundColor Yellow
            return
        }
        
        Write-Host "  Adding: $secretName" -ForegroundColor Cyan
        
        try {
            $secretValue | gh secret set $secretName --repo $repo 2>&1 | Out-Null
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✅ $secretName" -ForegroundColor Green
                $script:successCount++
            } else {
                Write-Host "  ❌ Failed: $secretName" -ForegroundColor Red
                $script:failCount++
            }
        } catch {
            Write-Host "  ❌ Error adding $secretName : $_" -ForegroundColor Red
            $script:failCount++
        }
        
        Start-Sleep -Milliseconds 300
    }
}

# Summary
Write-Host "`n" + "="*50 -ForegroundColor Cyan
Write-Host "📊 Upload Summary:" -ForegroundColor Cyan
Write-Host "="*50 -ForegroundColor Cyan
Write-Host "  ✅ Success: $successCount secrets" -ForegroundColor Green
Write-Host "  ❌ Failed:  $failCount secrets" -ForegroundColor $(if($failCount -gt 0){"Red"}else{"Green"})
Write-Host "="*50 + "`n" -ForegroundColor Cyan

if ($successCount -gt 0) {
    Write-Host "🎉 Secrets uploaded successfully!`n" -ForegroundColor Green
    Write-Host "⚠️  IMPORTANT: Delete github-secrets.env file now for security!" -ForegroundColor Yellow
    Write-Host "   Run: Remove-Item github-secrets.env -Force`n" -ForegroundColor Cyan
}

# Verify secrets
Write-Host "🔍 Verifying secrets in repository...`n" -ForegroundColor Cyan
gh secret list --repo $repo
