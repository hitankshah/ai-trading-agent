# Credentials & API Keys Setup Guide

## Overview
This document explains where to get each credential needed to run the AI Trading Agent.

---

## 1. PostgreSQL Database URL 🗄️

### What it is:
Connection string to your PostgreSQL database.

### Where to get it:

#### Option A: Local PostgreSQL
1. Install PostgreSQL from https://www.postgresql.org/download/
2. Create a database:
   ```sql
   CREATE DATABASE ai_trading_bot;
   ```
3. Get the connection URL format:
   ```
   postgresql://postgres:your_password@localhost:5432/ai_trading_bot
   ```
   - Replace `your_password` with your PostgreSQL password

#### Option B: Cloud PostgreSQL (Recommended for production)

**Neon.tech (Free tier available):**
1. Go to https://neon.tech
2. Sign up and create a new project
3. Copy the connection string from dashboard
4. Looks like: `postgresql://user:password@ep-xxx.us-east-1.neon.tech/dbname`

**Supabase:**
1. Go to https://supabase.com
2. Create new project
3. Go to Settings → Database → Connection string
4. Copy the `psql` connection string

**Railway.app:**
1. Go to https://railway.app
2. Create PostgreSQL plugin
3. Copy DATABASE_URL from variables

### Add to `.env`:
```env
DATABASE_URL="postgresql://user:password@host:port/database"
```

---

## 2. OpenRouter API Key 🤖

### What it is:
API key to access LLMs (Claude, GPT-4, etc.) via OpenRouter.

### How to get it:

1. Go to https://openrouter.ai
2. Click **"Sign Up"** (or login if you have account)
3. Complete signup process
4. Go to https://openrouter.ai/keys
5. Click **"Create Key"**
6. Copy the key (starts with `sk-or-v1-`)

### Pricing:
- Pay-as-you-go model
- Usually $0.001 - $0.1 per request
- First $5 free credit for new users
- See pricing at https://openrouter.ai/models

### Add to `.env`:
```env
OPENROUTER_API_KEY="sk-or-v1-your-key-here"
```

### Verify it works:
```bash
curl https://api.openrouter.ai/api/v1/auth/key \
  -H "Authorization: Bearer sk-or-v1-your-key-here"
```

---

## 3. Lighter Protocol API Keys 📊

### What it is:
API credentials for the Lighter Protocol trading platform (where you trade).

### How to get it:

1. Go to https://lighter.ai
2. Sign up and create account
3. Complete KYC verification (if required)
4. Go to Dashboard → API Keys or Settings
5. Create new API key
6. Copy the key and secret

### You can create multiple keys for:
- Different accounts
- Different trading strategies
- Different environments (dev/prod)

### Add to `.env`:
```env
LIGHTER_API_KEY_1="your_first_api_key"
LIGHTER_API_KEY_2="your_second_api_key"
LIGHTER_API_KEY_3="your_third_api_key"
```

### Note:
- Each key should correspond to a different trading account
- Keep these secret!
- You can revoke keys anytime

---

## 4. Private Keys (for Transaction Signing) 🔐

### What it is:
Private keys from your wallets to sign blockchain transactions.

### How to get them:

#### From MetaMask:
1. Open MetaMask
2. Click your account icon → Settings → Security & Privacy
3. Scroll to "Private Key"
4. Click "Export Private Key" (requires password confirmation)
5. Copy the key (starts with `0x`)

#### From Hardware Wallet (Ledger, Trezor):
1. You'll need to use a signing library (like ethers.js)
2. Or generate a new account specifically for trading
3. Export the private key from your wallet interface

#### Generate New Account:
```bash
# Using ethers.js CLI or web interface
# https://etherscan.io or https://www.3dice.com/tools/random_key.html
```

### Add to `.env`:
```env
ACCOUNT_PRIVATE_KEY_1="0xabcdef1234567890..."
ACCOUNT_PRIVATE_KEY_2="0xfedcba0987654321..."
ACCOUNT_PRIVATE_KEY_3="0x111111111111111..."
```

### ⚠️ SECURITY:
- **NEVER** share your private keys
- **NEVER** commit `.env` to GitHub
- Use `.gitignore` to exclude `.env`
- Consider using hardware wallets for production
- Use different keys for dev/testing vs production

---

## 5. Signer Private Key 🔑

### What it is:
A dedicated private key for signing zkLighter transactions.

### How to get it:

Option 1: Use one of your private keys above
```env
SIGNER_PRIVATE_KEY="0xabcdef1234567890..."
```

Option 2: Generate a new one for signing only:
```bash
# Most secure approach
# Create a new account just for signing
```

### Add to `.env`:
```env
SIGNER_PRIVATE_KEY="0xmnopqr1234567890..."
```

---

## Summary Checklist

Before running the app, ensure you have:

- [ ] PostgreSQL database created and connection URL
- [ ] OpenRouter API key (from https://openrouter.ai)
- [ ] Lighter Protocol API keys (at least 1, up to 3)
- [ ] Private keys for trading accounts (at least 1)
- [ ] Signer private key (can be same as above)
- [ ] `.env` file filled with all above credentials
- [ ] `.env` added to `.gitignore`

---

## Testing Your Credentials

### Test Database Connection:
```bash
bun run prisma db execute --stdin < test.sql
# or use a GUI like DBeaver or pgAdmin
```

### Test OpenRouter API:
```bash
curl https://api.openrouter.ai/api/v1/auth/key \
  -H "Authorization: Bearer YOUR_KEY"
```

### Test Lighter API:
```bash
curl https://api.lighter.ai/v1/accounts \
  -H "Authorization: Bearer YOUR_KEY"
```

---

## Troubleshooting

### "Invalid API Key"
- Verify the key is copied correctly
- Check there are no extra spaces
- Regenerate the key if needed

### "Connection refused"
- Ensure PostgreSQL is running
- Check DATABASE_URL is correct
- Verify firewall isn't blocking connection

### "Access Denied"
- Verify credentials have correct permissions
- Check account isn't locked/suspended
- Contact support if needed

---

## Security Best Practices

1. **Use environment variables** - Never hardcode secrets
2. **Rotate keys regularly** - Generate new keys quarterly
3. **Use different keys for environments** - dev ≠ production
4. **Monitor activity** - Check API usage logs
5. **Use IP whitelisting** - Restrict API key access to your IP
6. **Keep backups** - Store backup of keys securely
7. **Use vaults** - Consider using Vault or AWS Secrets Manager

---

**Last Updated**: Oct 30, 2025
