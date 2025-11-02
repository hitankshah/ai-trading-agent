# ✅ Configuration Checklist

Use this checklist to ensure everything is properly configured before running the agent.

---

## 🔧 Prerequisites

- [ ] Node.js or Bun installed
  - Bun: https://bun.sh
  - Node.js: https://nodejs.org (v18+)

- [ ] PostgreSQL installed and running
  - Download: https://www.postgresql.org/download/
  - Test: `psql --version`

- [ ] Git installed (for version control)
  - Test: `git --version`

---

## 📥 Dependencies Installation

- [ ] Backend dependencies installed
  ```bash
  bun install
  # or: npm install
  ```

- [ ] Frontend dependencies installed
  ```bash
  cd frontend
  bun install
  cd ..
  ```

- [ ] Prisma client generated
  ```bash
  bun run prisma generate
  ```

---

## 🗄️ Database Setup

- [ ] PostgreSQL server running
  ```bash
  # Windows: net start PostgreSQL
  # Mac: brew services start postgresql
  # Linux: sudo systemctl start postgresql
  ```

- [ ] Database created
  ```sql
  CREATE DATABASE ai_trading_bot;
  ```

- [ ] Migrations applied
  ```bash
  bun run prisma migrate deploy
  ```

- [ ] Database connection verified
  ```bash
  psql $DATABASE_URL
  \dt  # List tables
  \q  # Quit
  ```

---

## 🔐 API Credentials

### OpenRouter (LLM)
- [ ] Account created: https://openrouter.ai
- [ ] API key generated: https://openrouter.ai/keys
- [ ] Key format verified: `sk-or-v1-...`
- [ ] Added to `.env`:
  ```env
  OPENROUTER_API_KEY="sk-or-v1-your-key"
  ```
- [ ] Key tested:
  ```bash
  curl https://api.openrouter.ai/api/v1/auth/key \
    -H "Authorization: Bearer YOUR_KEY"
  ```

### Lighter Protocol (Trading)
- [ ] Account created: https://lighter.ai
- [ ] At least 1 API key generated
- [ ] API keys added to `.env`:
  ```env
  LIGHTER_API_KEY_1="key1"
  LIGHTER_API_KEY_2="key2"
  LIGHTER_API_KEY_3="key3"
  ```

### Wallet Private Keys
- [ ] Private key(s) obtained from wallet
  - MetaMask: Account → Settings → Security & Privacy → Export Private Key
  - Ledger/Trezor: Export via wallet interface
- [ ] Keys in correct format (starts with `0x`)
- [ ] Keys added to `.env`:
  ```env
  ACCOUNT_PRIVATE_KEY_1="0xabcd..."
  ACCOUNT_PRIVATE_KEY_2="0xefgh..."
  ACCOUNT_PRIVATE_KEY_3="0xijkl..."
  ```

### Signer Key
- [ ] Signer private key obtained or generated
- [ ] Added to `.env`:
  ```env
  SIGNER_PRIVATE_KEY="0xmnop..."
  ```

---

## 📝 Environment Configuration

### Required Variables
- [ ] DATABASE_URL
  - Format: `postgresql://user:pass@host:port/database`
  - Example: `postgresql://postgres:password@localhost:5432/ai_trading_bot`

- [ ] OPENROUTER_API_KEY
  - Format: `sk-or-v1-...`

- [ ] LIGHTER_API_KEY_1
  - At least one required

- [ ] ACCOUNT_PRIVATE_KEY_1
  - At least one required

- [ ] SIGNER_PRIVATE_KEY
  - Can be same as ACCOUNT_PRIVATE_KEY_1

### Optional Variables
- [ ] API_PORT (default: 3000)
- [ ] NODE_ENV (default: development)
- [ ] FRONTEND_PORT (default: 5173)

### Verification
- [ ] `.env` file created and filled
- [ ] `.env` is in `.gitignore`
- [ ] All required variables set
- [ ] No extra spaces in values
- [ ] All quotes removed from values
- [ ] `.env` not committed to Git

---

## 📊 Database Verification

- [ ] Tables created:
  ```bash
  bun run prisma db execute --stdin
  # SELECT tablename FROM pg_tables WHERE schemaname = 'public';
  ```

- [ ] Expected tables:
  - [ ] `Models`
  - [ ] `Invocations`
  - [ ] `ToolCalls`
  - [ ] `PortfolioSize`

---

## 🔍 Connection Tests

### Database Connection
- [ ] Test with Prisma Studio:
  ```bash
  bun run prisma studio
  ```

### OpenRouter API
- [ ] Test API key validity:
  ```bash
  curl -s https://api.openrouter.ai/api/v1/auth/key \
    -H "Authorization: Bearer YOUR_KEY" | jq
  ```

### Lighter Protocol
- [ ] Test API key validity:
  ```bash
  curl -s https://api.lighter.ai/v1/health \
    -H "Authorization: Bearer YOUR_KEY"
  ```

---

## 🛡️ Security Checklist

- [ ] `.gitignore` includes:
  - [ ] `.env`
  - [ ] `node_modules/`
  - [ ] `dist/`
  - [ ] `/generated/prisma`

- [ ] Private keys stored safely:
  - [ ] Not in version control
  - [ ] Not in code comments
  - [ ] Not shared in communication

- [ ] API keys rotated:
  - [ ] Regenerate keys if shared
  - [ ] Use different keys for dev/prod
  - [ ] Monitor API usage

- [ ] Account security:
  - [ ] Two-factor authentication enabled (if available)
  - [ ] IP whitelisting configured (if available)
  - [ ] API key permissions minimized

---

## 🚀 Pre-Launch Verification

### Code Quality
- [ ] No compilation errors:
  ```bash
  npx tsc --noEmit
  ```

- [ ] Linting passed (if configured)

### Runtime Verification
- [ ] Agent starts without errors:
  ```bash
  bun run index.ts
  ```

- [ ] API server starts:
  ```bash
  bun run backend.ts
  ```

- [ ] Frontend starts:
  ```bash
  cd frontend && bun run dev
  ```

- [ ] Frontend accessible: http://localhost:5173

- [ ] API endpoints responding:
  - [ ] GET /performance → Returns data
  - [ ] GET /invocations → Returns data

### Database Verification
- [ ] Records being saved
- [ ] Queries executing fast
- [ ] No connection pooling issues

---

## 📈 Configuration Tuning (Optional)

- [ ] Trading strategy updated in `prompt.ts`
- [ ] Markets configured in `markets.ts`
- [ ] Position size limits set
- [ ] Invocation frequency configured
- [ ] Indicators updated in `stockData.ts`

---

## 🎯 Before First Trade

- [ ] Small test amount in account
- [ ] Position size limits set
- [ ] Stop-losses configured
- [ ] Agent running in verbose mode
- [ ] Monitor first few invocations
- [ ] Verify trades executing correctly

---

## 📋 Final Verification

- [ ] All checklist items completed
- [ ] Documentation reviewed
- [ ] Emergency stop procedures understood
- [ ] Monitoring setup verified
- [ ] Support resources bookmarked

---

## 🚨 Emergency Stop

If something goes wrong:

1. **Stop the agent immediately**:
   ```bash
   # Press Ctrl+C in terminal
   ```

2. **Close all positions**:
   ```bash
   bun run index.ts  # Run once to close positions
   ```

3. **Check database**:
   ```bash
   psql $DATABASE_URL
   SELECT * FROM invocations ORDER BY createdAt DESC LIMIT 5;
   ```

4. **Review API logs**:
   - OpenRouter: https://openrouter.ai/usage
   - Lighter: Check trading logs

---

## 📞 Quick Links

- **Bun**: https://bun.sh
- **Prisma**: https://www.prisma.io
- **OpenRouter**: https://openrouter.ai
- **Lighter Protocol**: https://lighter.ai
- **PostgreSQL**: https://www.postgresql.org

---

## ✅ Sign Off

- [ ] I have reviewed all documentation
- [ ] I have completed this checklist
- [ ] I understand the risks
- [ ] I am ready to run the agent

**Ready to launch!** 🚀

---

**Last Updated**: Oct 30, 2025  
**Checklist Version**: 1.0
