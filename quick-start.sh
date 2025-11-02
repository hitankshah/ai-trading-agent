#!/bin/bash

# Quick Start Script for AI Trading Agent
# Run this from the project root

echo "========================================="
echo "AI Trading Agent - Quick Start Setup"
echo "========================================="
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "📋 Copying from .env.example..."
    cp .env.example .env
    echo "✅ .env file created. Please edit it with your credentials."
    echo ""
    echo "Edit the following in .env:"
    echo "  - DATABASE_URL (PostgreSQL connection string)"
    echo "  - OPENROUTER_API_KEY (from https://openrouter.ai)"
    echo "  - LIGHTER_API_KEY_* (from https://lighter.ai)"
    echo "  - Private keys for trading accounts"
    echo ""
    exit 1
fi

echo "✅ .env file exists"
echo ""

# Check if Bun is installed
if command -v bun &> /dev/null; then
    BUN_VERSION=$(bun --version)
    echo "✅ Bun is installed: $BUN_VERSION"
    PACKAGE_MANAGER="bun"
elif command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "✅ npm is installed: $NPM_VERSION"
    PACKAGE_MANAGER="npm"
else
    echo "❌ Neither Bun nor npm found!"
    echo "Please install one of them:"
    echo "  - Bun: https://bun.sh"
    echo "  - npm: https://nodejs.org"
    exit 1
fi

echo ""
echo "📦 Installing dependencies..."

if [ "$PACKAGE_MANAGER" = "bun" ]; then
    bun install || { echo "❌ Failed to install dependencies"; exit 1; }
    echo "✅ Backend dependencies installed"
    
    echo "Installing frontend dependencies..."
    cd frontend
    bun install || { echo "❌ Failed to install frontend dependencies"; cd ..; exit 1; }
    echo "✅ Frontend dependencies installed"
    cd ..
else
    npm install || { echo "❌ Failed to install dependencies"; exit 1; }
    echo "✅ Backend dependencies installed"
    
    echo "Installing frontend dependencies..."
    cd frontend
    npm install || { echo "❌ Failed to install frontend dependencies"; cd ..; exit 1; }
    echo "✅ Frontend dependencies installed"
    cd ..
fi

echo ""
echo "📊 Setting up database..."

if [ "$PACKAGE_MANAGER" = "bun" ]; then
    echo "Generating Prisma client..."
    bun run prisma generate
    
    echo "Running migrations..."
    bun run prisma migrate deploy
else
    echo "Generating Prisma client..."
    npx prisma generate
    
    echo "Running migrations..."
    npx prisma migrate deploy
fi

echo ""
echo "========================================="
echo "✅ Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Edit .env with your credentials"
echo "2. Ensure PostgreSQL is running"
echo "3. Run one of the following commands:"
echo ""
echo "   Run Backend Only:"
echo "   $PACKAGE_MANAGER run index.ts"
echo ""
echo "   Run Backend + API Server:"
echo "   Terminal 1: $PACKAGE_MANAGER run index.ts"
echo "   Terminal 2: $PACKAGE_MANAGER run backend.ts"
echo ""
echo "   Run Full Stack (Backend + API + Frontend):"
echo "   Terminal 1: $PACKAGE_MANAGER run index.ts"
echo "   Terminal 2: $PACKAGE_MANAGER run backend.ts"
echo "   Terminal 3: cd frontend && $PACKAGE_MANAGER run dev"
echo ""
echo "📚 For more details, see SETUP_GUIDE.md"
echo ""
