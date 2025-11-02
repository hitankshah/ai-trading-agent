# 🎯 Quick Reference Card

**AI Trading Agent - Essential Information on One Page**

---

## What is This?

An AI-powered trading bot that uses OpenRouter LLMs to analyze markets and make autonomous trading decisions on Lighter Protocol.

---

## What You Need

| Item | Where to Get | Format |
|------|-------------|--------|
| PostgreSQL | https://postgresql.org | Connection string |
| OpenRouter Key | https://openrouter.ai/keys | `sk-or-v1-...` |
| Lighter API Key | https://lighter.ai | API key |
| Private Keys | Your wallet | `0xabcd...` (66 chars) |
| Bun/Node.js | https://bun.sh | v18+ |

---

## File Locations

```
.env ........................ ⚠️ YOUR CREDENTIALS (keep secret!)
.env.example ................ Reference template
quick-start.ps1 ............ Windows setup
quick-start.sh ............. Mac/Linux setup

Documentation/
├── START_HERE.md .......... Read this first!
├── DOCUMENTATION_INDEX.md . File index
├── CREDENTIALS_SETUP.md ... How to get keys
├── SETUP_GUIDE.md ......... Installation
├── ARCHITECTURE.md ........ System design
├── LAUNCH_CHECKLIST.md .... Verification
├── TROUBLESHOOTING.md ..... Solutions
└── README_FULL.md ......... Full reference

Code/
├── index.ts ............... Main agent
├── backend.ts ............. API server
├── prompt.ts .............. Trading strategy
└── frontend/ .............. React UI
```

---

## Setup (5 Steps)

### 1️⃣ Install Dependencies
```bash
bun install
cd frontend && bun install && cd ..
```

### 2️⃣ Get Credentials
- OpenRouter: https://openrouter.ai/keys
- Lighter: https://lighter.ai
- PostgreSQL connection string

### 3️⃣ Configure
```bash
cp .env.example .env
# Edit .env with your credentials
```

### 4️⃣ Setup Database
```bash
bun run prisma generate
bun run prisma migrate deploy
```

### 5️⃣ Run (3 Terminals)
```bash
# Terminal 1: Agent
bun run index.ts

# Terminal 2: API
bun run backend.ts

# Terminal 3: Frontend
cd frontend && bun run dev
```

---

## Access Points

| Component | URL/Port | Purpose |
|-----------|----------|---------|
| Frontend | http://localhost:5173 | Dashboard |
| API | http://localhost:3000 | Data endpoints |
| Database | PostgreSQL | Data storage |
| Console | Terminal output | Agent logs |

---

## API Endpoints

```bash
# Get portfolio performance
GET http://localhost:3000/performance

# Get recent trades
GET http://localhost:3000/invocations?limit=30
```

---

## Key Files to Edit

| File | What to Change | When |
|------|---|---|
| `.env` | API keys & credentials | Before first run |
| `prompt.ts` | Trading strategy | To change AI behavior |
| `markets.ts` | Trading pairs | To add/remove markets |
| `config.ts` | API endpoints | For different networks |

---

## Important Commands

```bash
# View database
bun run prisma studio

# Generate Prisma client
bun run prisma generate

# Run migrations
bun run prisma migrate deploy

# Check TypeScript errors
npx tsc --noEmit

# View logs
bun run index.ts 2>&1 | tee app.log
```

---

## Common Issues & Fixes

| Problem | Fix |
|---------|-----|
| Port in use | Change API_PORT in .env or kill process |
| DB won't connect | Check DATABASE_URL and PostgreSQL running |
| Invalid API key | Regenerate from provider dashboard |
| "Prisma client not found" | Run `bun run prisma generate` |
| Out of memory | Increase NODE_OPTIONS |

---

## Security ⚠️

- ❌ Never commit `.env` with real keys
- ❌ Never share private keys
- ✅ Use `.gitignore` for `.env`
- ✅ Use different keys for dev/prod
- ✅ Rotate keys monthly

---

## Environment Variables Required

```env
# Database
DATABASE_URL="postgresql://user:pass@host:port/db"

# APIs
OPENROUTER_API_KEY="sk-or-v1-..."
LIGHTER_API_KEY_1="your-key"

# Keys
ACCOUNT_PRIVATE_KEY_1="0x..."
SIGNER_PRIVATE_KEY="0x..."

# Optional
API_PORT=3000
NODE_ENV=development
```

---

## Technology Stack

| Layer | Tech |
|-------|------|
| Runtime | Bun / Node.js |
| Language | TypeScript |
| Backend | Express.js |
| Frontend | React + Vite |
| Database | PostgreSQL + Prisma |
| AI | OpenRouter SDK |
| Trading | Lighter Protocol SDK |

---

## Documentation Map

```
START_HERE.md
    │
    ├─→ DOCUMENTATION_INDEX.md
    │   │
    │   ├─→ GETTING_STARTED.md
    │   │
    │   ├─→ CREDENTIALS_SETUP.md ⭐ (READ FIRST)
    │   │
    │   ├─→ SETUP_GUIDE.md
    │   │
    │   ├─→ ARCHITECTURE.md
    │   │
    │   ├─→ LAUNCH_CHECKLIST.md
    │   │
    │   ├─→ TROUBLESHOOTING.md (When stuck)
    │   │
    │   └─→ README_FULL.md (Full reference)
    │
    └─→ This file (quick reference)
```

---

## Quick Decisions

### "I'm stuck"
→ Check [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)

### "I need API keys"
→ Follow [CREDENTIALS_SETUP.md](./CREDENTIALS_SETUP.md)

### "How do I install?"
→ Read [SETUP_GUIDE.md](./SETUP_GUIDE.md)

### "How does it work?"
→ Study [ARCHITECTURE.md](./ARCHITECTURE.md)

### "Am I ready to launch?"
→ Use [LAUNCH_CHECKLIST.md](./LAUNCH_CHECKLIST.md)

---

## Before You Run

- [ ] .env file created and filled
- [ ] PostgreSQL running and accessible
- [ ] Dependencies installed
- [ ] Database migrations applied
- [ ] All API keys valid
- [ ] No port conflicts
- [ ] Security checked

---

## During Execution

**Terminal 1 (Agent)**: Watch for trading decisions  
**Terminal 2 (API)**: Should show "listening on 3000"  
**Terminal 3 (Frontend)**: Should start on port 5173  

**Browser**: Go to http://localhost:5173 to monitor

---

## Troubleshooting Quick Links

- Port already in use? → [TROUBLESHOOTING.md - Issue #10](./TROUBLESHOOTING.md)
- Database error? → [TROUBLESHOOTING.md - Issue #4](./TROUBLESHOOTING.md)
- API key invalid? → [TROUBLESHOOTING.md - Issue #7](./TROUBLESHOOTING.md)
- Can't find Prisma? → [TROUBLESHOOTING.md - Issue #12](./TROUBLESHOOTING.md)

---

## Resources

| Resource | URL |
|----------|-----|
| Bun | https://bun.sh |
| Prisma | https://prisma.io |
| OpenRouter | https://openrouter.ai |
| Lighter | https://lighter.ai |
| PostgreSQL | https://postgresql.org |
| React | https://react.dev |
| Express | https://expressjs.com |

---

## Timeline

- ⏱️ **5 min**: Read [DOCUMENTATION_INDEX.md](./DOCUMENTATION_INDEX.md)
- ⏱️ **15 min**: Read [CREDENTIALS_SETUP.md](./CREDENTIALS_SETUP.md) and get keys
- ⏱️ **10 min**: Edit `.env` with your credentials
- ⏱️ **20 min**: Run setup script
- ⏱️ **5 min**: Start 3 terminals
- ✅ **Total: 55 minutes to launch**

---

## Status Indicators

### ✅ Ready to Launch When
- All .env variables filled
- PostgreSQL running
- Dependencies installed
- No console errors
- Ports available

### ❌ Check If
- Can't connect to database
- API key gives errors
- Port is in use
- Modules missing

---

## One Last Thing

🎉 **YOU'RE READY!**

Next action: Read [START_HERE.md](./START_HERE.md) or [CREDENTIALS_SETUP.md](./CREDENTIALS_SETUP.md)

---

**Quick Reference Version**: 1.0  
**Created**: October 30, 2025  
**Status**: Complete ✅
