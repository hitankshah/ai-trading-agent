# Quick Start Script for AI Trading Agent
# Run this in PowerShell from the project root

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "AI Trading Agent - Quick Start Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if .env exists
if (-Not (Test-Path ".env")) {
    Write-Host "❌ .env file not found!" -ForegroundColor Red
    Write-Host "📋 Copying from .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "✅ .env file created. Please edit it with your credentials." -ForegroundColor Green
    Write-Host ""
    Write-Host "Edit the following in .env:" -ForegroundColor Yellow
    Write-Host "  - DATABASE_URL (PostgreSQL connection string)" -ForegroundColor Gray
    Write-Host "  - OPENROUTER_API_KEY (from https://openrouter.ai)" -ForegroundColor Gray
    Write-Host "  - LIGHTER_API_KEY_* (from https://lighter.ai)" -ForegroundColor Gray
    Write-Host "  - Private keys for trading accounts" -ForegroundColor Gray
    Write-Host ""
    exit
}

Write-Host "✅ .env file exists" -ForegroundColor Green
Write-Host ""

# Check if Bun is installed
$bunPath = bun --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Bun is installed: $bunPath" -ForegroundColor Green
    $packageManager = "bun"
} else {
    Write-Host "⚠️  Bun not found. Checking for npm..." -ForegroundColor Yellow
    $npmVersion = npm --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ npm is installed: $npmVersion" -ForegroundColor Green
        $packageManager = "npm"
    } else {
        Write-Host "❌ Neither Bun nor npm found!" -ForegroundColor Red
        Write-Host "Please install one of them:" -ForegroundColor Yellow
        Write-Host "  - Bun: https://bun.sh" -ForegroundColor Gray
        Write-Host "  - npm: https://nodejs.org" -ForegroundColor Gray
        exit
    }
}

Write-Host ""
Write-Host "📦 Installing dependencies..." -ForegroundColor Cyan
if ($packageManager -eq "bun") {
    bun install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
        exit
    }
    Write-Host "✅ Backend dependencies installed" -ForegroundColor Green
    
    Write-Host "Installing frontend dependencies..." -ForegroundColor Cyan
    Set-Location frontend
    bun install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install frontend dependencies" -ForegroundColor Red
        Set-Location ..
        exit
    }
    Write-Host "✅ Frontend dependencies installed" -ForegroundColor Green
    Set-Location ..
} else {
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
        exit
    }
    Write-Host "✅ Backend dependencies installed" -ForegroundColor Green
    
    Write-Host "Installing frontend dependencies..." -ForegroundColor Cyan
    Set-Location frontend
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install frontend dependencies" -ForegroundColor Red
        Set-Location ..
        exit
    }
    Write-Host "✅ Frontend dependencies installed" -ForegroundColor Green
    Set-Location ..
}

Write-Host ""
Write-Host "📊 Setting up database..." -ForegroundColor Cyan

if ($packageManager -eq "bun") {
    Write-Host "Generating Prisma client..." -ForegroundColor Yellow
    bun run prisma generate
    
    Write-Host "Running migrations..." -ForegroundColor Yellow
    bun run prisma migrate deploy
} else {
    Write-Host "Generating Prisma client..." -ForegroundColor Yellow
    npx prisma generate
    
    Write-Host "Running migrations..." -ForegroundColor Yellow
    npx prisma migrate deploy
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Edit .env with your credentials" -ForegroundColor Gray
Write-Host "2. Ensure PostgreSQL is running" -ForegroundColor Gray
Write-Host "3. Run one of the following commands:" -ForegroundColor Gray
Write-Host ""
Write-Host "   Run Backend Only:" -ForegroundColor Yellow
Write-Host "   $packageManager run index.ts" -ForegroundColor White
Write-Host ""
Write-Host "   Run Backend + API Server:" -ForegroundColor Yellow
Write-Host "   Terminal 1: $packageManager run index.ts" -ForegroundColor White
Write-Host "   Terminal 2: $packageManager run backend.ts" -ForegroundColor White
Write-Host ""
Write-Host "   Run Full Stack (Backend + API + Frontend):" -ForegroundColor Yellow
Write-Host "   Terminal 1: $packageManager run index.ts" -ForegroundColor White
Write-Host "   Terminal 2: $packageManager run backend.ts" -ForegroundColor White
Write-Host "   Terminal 3: cd frontend && $packageManager run dev" -ForegroundColor White
Write-Host ""
Write-Host "📚 For more details, see SETUP_GUIDE.md" -ForegroundColor Cyan
Write-Host ""
