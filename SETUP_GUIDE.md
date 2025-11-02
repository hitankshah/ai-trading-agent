# AI Trading Agent - Setup & Run Guide

## Project Overview
This is an AI-powered trading agent that uses:
- **LLM**: OpenRouter API (Claude, GPT-4, etc.)
- **Trading Platform**: Lighter Protocol (zkLighter)
- **Database**: PostgreSQL with Prisma ORM
- **Backend**: Express.js with TypeScript
- **Frontend**: React + Vite for monitoring

---

## Prerequisites

1. **Bun** (JavaScript runtime - faster alternative to Node.js)
   - Download from: https://bun.sh
   - Or use npm/yarn if preferred

2. **PostgreSQL** (Database)
   - Download from: https://www.postgresql.org/download/
   - Ensure PostgreSQL server is running

3. **Git** (Version Control)

---

## Installation Steps

### 1. Install Dependencies

```bash
# Root directory (backend)
bun install

# Frontend directory
cd frontend
bun install
cd ..
```

**Alternative with npm:**
```bash
npm install
cd frontend && npm install && cd ..
```

---

### 2. Setup Database

#### Option A: Using PostgreSQL Locally

1. **Create a database:**
   ```sql
   CREATE DATABASE ai_trading_bot;
   ```

2. **Update `.env` file** with your database URL:
   ```
   DATABASE_URL="postgresql://postgres:password@localhost:5432/ai_trading_bot"
   ```

#### Option B: Using Remote Database
- Use Neon, Supabase, or similar PostgreSQL provider
- Update DATABASE_URL in `.env`

### 3. Run Prisma Migrations

```bash
# Generate Prisma client
bun run prisma generate

# Run migrations to create tables
bun run prisma migrate deploy

# (Optional) Push schema to database
bun run prisma db push
```

---

### 4. Environment Configuration

Edit `.env` file with your actual credentials:

```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/ai_trading_bot"

# OpenRouter API (Get from https://openrouter.ai)
OPENROUTER_API_KEY="sk-or-v1-xxxxxxxxxxxxxxxx"

# Lighter Protocol API Keys (Get from https://lighter.ai)
LIGHTER_API_KEY_1="your_api_key_1"
LIGHTER_API_KEY_2="your_api_key_2"
LIGHTER_API_KEY_3="your_api_key_3"

# Private Keys/Mnemonics for Trading Accounts
ACCOUNT_PRIVATE_KEY_1="0xabcd..."
ACCOUNT_PRIVATE_KEY_2="0xefgh..."
ACCOUNT_PRIVATE_KEY_3="0xijkl..."

# Signer Key
SIGNER_PRIVATE_KEY="0xmnop..."

# Server Configuration
API_PORT=3000
NODE_ENV=development
```

**How to get credentials:**
1. **OpenRouter API Key**: https://openrouter.ai/keys
2. **Lighter Protocol**: https://lighter.ai (register and create API keys)
3. **Private Keys**: Use your wallet's private keys or create new accounts

---

## Running the Application

### Option 1: Run Only Backend

```bash
bun run index.ts
```

This starts the trading agent with:
- AI-powered decision making
- Automatic position management
- Portfolio tracking

### Option 2: Run Backend + API Server

```bash
# Terminal 1: Backend with agent invocations
bun run index.ts

# Terminal 2: Express API server
bun run backend.ts
```

The API server runs on `http://localhost:3000` with endpoints:
- `GET /performance` - Portfolio performance timeseries
- `GET /invocations` - Recent AI agent invocations

### Option 3: Full Stack (Backend + Frontend)

```bash
# Terminal 1: Backend
bun run index.ts

# Terminal 2: API Server
bun run backend.ts

# Terminal 3: Frontend (React)
cd frontend
bun run dev
```

Frontend runs on `http://localhost:5173` (Vite default)

---

## File Structure & Purpose

### Root Files
- `index.ts` - Main agent orchestration
- `backend.ts` - Express API server
- `config.ts` - Configuration constants
- `prompt.ts` - LLM system prompt
- `accounts.ts` - Account management
- `markets.ts` - Supported trading markets

### Trading Features
- `createPosition.ts` - Open trades
- `cancelOrder.ts` - Close trades
- `openPositions.ts` - Get current positions
- `getPortfolio.ts` - Portfolio valuation
- `priceTracker.ts` - Price monitoring
- `stockData.ts` - Technical indicators (EMA, MACD)

### Database
- `prisma/schema.prisma` - Database models
- `generated/prisma/` - Auto-generated Prisma client

### Frontend
- `frontend/src/App.tsx` - Main React app
- `frontend/src/components/` - UI components
  - `PerformanceChart.tsx` - Portfolio chart
  - `RecentInvocations.tsx` - AI decisions log

### Lighter SDK
- `lighter-sdk-ts/` - Generated trading SDK

---

## Troubleshooting

### Issue: Database connection failed
```
Error: connect ECONNREFUSED 127.0.0.1:5432
```
**Solution:**
- Ensure PostgreSQL is running
- Check DATABASE_URL in `.env`
- Verify database exists

### Issue: OpenRouter API Key invalid
```
Error: 401 Unauthorized
```
**Solution:**
- Get API key from https://openrouter.ai/keys
- Ensure key is copied exactly in `.env`

### Issue: Prisma client not found
```
Error: Cannot find module '@prisma/client'
```
**Solution:**
```bash
bun run prisma generate
bun install
```

### Issue: Port already in use
```
Error: listen EADDRINUSE :::3000
```
**Solution:**
```bash
# Change port in backend.ts or .env
# Or kill process using the port
```

---

## Development Workflow

### 1. Modify database schema
```bash
# Edit prisma/schema.prisma
bun run prisma migrate dev --name descriptive_name
```

### 2. Update AI prompt
```bash
# Edit prompt.ts with your trading strategy
# Changes apply on next agent invocation
```

### 3. Add new markets
```bash
# Edit markets.ts
# Add to MARKETS object
```

### 4. Test locally
```bash
# Set NODE_ENV=development
# Run with verbose logging
bun run index.ts
```

---

## Deployment Options

### Option 1: Heroku / Railway
```bash
# Requires: Procfile, runtime.txt

# Deploy with database
```

### Option 2: Docker
```dockerfile
FROM oven/bun:latest
WORKDIR /app
COPY . .
RUN bun install
CMD ["bun", "run", "index.ts"]
```

### Option 3: VPS (Ubuntu/EC2)
```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash

# Clone and setup
git clone <repo>
cd ai-trading-agent
bun install
bun run prisma migrate deploy
bun run index.ts
```

---

## Important Notes

⚠️ **Security**
- Never commit `.env` file with real keys
- Use different keys for dev/prod
- Rotate API keys regularly
- Keep private keys secure

⚠️ **Trading**
- Test with small amounts first
- Monitor positions regularly
- Set position size limits
- Have stop-losses configured

⚠️ **Performance**
- Monitor database queries
- Cache market data appropriately
- Limit API calls per invocation
- Use connection pooling for PostgreSQL

---

## Next Steps

1. ✅ Install dependencies
2. ✅ Setup PostgreSQL
3. ✅ Configure `.env` with credentials
4. ✅ Run Prisma migrations
5. ✅ Start the agent: `bun run index.ts`
6. ✅ Monitor via API or frontend
7. ✅ Adjust prompt/strategy as needed

---

## Support & Resources

- Bun Docs: https://bun.sh/docs
- Prisma Docs: https://www.prisma.io/docs
- OpenRouter: https://openrouter.ai/docs
- Lighter Protocol: https://lighter.ai/docs

---

**Created**: Oct 30, 2025  
**Project**: AI Trading Agent
