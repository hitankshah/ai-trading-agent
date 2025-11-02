# AI Trading Agent 🤖📈

An autonomous AI-powered trading bot that uses OpenRouter LLMs to make intelligent trading decisions on the Lighter Protocol exchange.

## 🎯 Features

- **AI-Powered Trading**: Uses Claude/GPT-4 via OpenRouter for market analysis
- **Technical Indicators**: EMA20, MACD, price tracking
- **Portfolio Management**: Real-time balance and position tracking  
- **Automated Execution**: Autonomous buy/sell decisions based on market conditions
- **Database Persistence**: PostgreSQL with Prisma ORM
- **REST API**: Express backend for monitoring
- **React Dashboard**: Real-time portfolio and invocation tracking
- **Multi-Account Support**: Manage multiple trading accounts

## 📋 Prerequisites

- **Node.js/Bun**: JavaScript runtime
- **PostgreSQL**: Database (local or cloud)
- **API Keys**:
  - OpenRouter (for LLM access)
  - Lighter Protocol (for trading)
  - Private keys for wallet signing

## 🚀 Quick Start

### 1. Clone & Install
```bash
git clone <repo>
cd ai-trading-agent

# Use the quick-start script
# Windows:
./quick-start.ps1

# Mac/Linux:
./quick-start.sh

# Or manually:
bun install
cd frontend && bun install && cd ..
```

### 2. Setup Environment
```bash
# Copy template
cp .env.example .env

# Edit with your credentials
# See CREDENTIALS_SETUP.md for details
```

### 3. Setup Database
```bash
# Generate Prisma client
bun run prisma generate

# Run migrations
bun run prisma migrate deploy
```

### 4. Run the Application

**Backend Only:**
```bash
bun run index.ts
```

**Backend + API Server:**
```bash
# Terminal 1
bun run index.ts

# Terminal 2
bun run backend.ts
```

**Full Stack (Backend + API + Frontend):**
```bash
# Terminal 1: Agent
bun run index.ts

# Terminal 2: API Server
bun run backend.ts

# Terminal 3: React Frontend
cd frontend && bun run dev
```

Frontend available at: http://localhost:5173  
API available at: http://localhost:3000

## 📚 Documentation

- **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** - Detailed installation & configuration
- **[CREDENTIALS_SETUP.md](./CREDENTIALS_SETUP.md)** - API keys & credentials guide
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - System design & data flow

## 🔧 Configuration

### Environment Variables
```env
DATABASE_URL                  # PostgreSQL connection
OPENROUTER_API_KEY           # LLM provider key
LIGHTER_API_KEY_*            # Trading API keys (1-3)
ACCOUNT_PRIVATE_KEY_*        # Wallet private keys
SIGNER_PRIVATE_KEY           # Transaction signer
```

See `.env.example` for all options.

### Markets Configuration
Edit `markets.ts` to add/modify trading pairs:
```typescript
export const MARKETS = {
  ETH: { marketId: 1, ... },
  BTC: { marketId: 2, ... },
  // Add more markets
}
```

### Trading Strategy
Customize AI behavior in `prompt.ts`:
```typescript
export const PROMPT = `
  You are a trading assistant that analyzes markets...
  [Add your strategy instructions here]
`
```

## 📊 API Endpoints

### Performance Chart Data
```
GET /performance
```
Returns portfolio value timeseries for charting.

### Recent Invocations
```
GET /invocations?limit=30
```
Returns recent AI agent decisions and trades executed.

## 🏗️ Project Structure

```
ai-trading-agent/
├── index.ts                  # Main agent logic
├── backend.ts                # Express API server
├── config.ts                 # Constants
├── prompt.ts                 # AI system prompt
├── accounts.ts               # Account management
├── markets.ts                # Trading pairs
├── createPosition.ts         # Open trades
├── cancelOrder.ts            # Close trades
├── getPortfolio.ts           # Balance tracking
├── openPositions.ts          # Position queries
├── indicators.ts             # Technical indicators
├── stockData.ts              # Market data
├── priceTracker.ts           # Price monitoring
│
├── prisma/
│   └── schema.prisma         # Database schema
│
├── frontend/                 # React dashboard
│   ├── src/
│   │   ├── App.tsx
│   │   ├── components/
│   │   │   ├── PerformanceChart.tsx
│   │   │   └── RecentInvocations.tsx
│   │   └── types/
│   └── package.json
│
├── lighter-sdk-ts/           # Trading SDK
├── .env                      # Environment variables (git ignored)
├── .env.example              # Template
├── package.json
├── tsconfig.json
└── README.md                 # This file
```

## 🔐 Security

⚠️ **Important**:
- Never commit `.env` with real API keys
- Keep private keys secure
- Use different keys for dev/prod
- Rotate API keys regularly
- Use `.gitignore` to exclude sensitive files

## 💡 How It Works

```
1. Agent fetches current market data & technical indicators
2. Collects portfolio balance and open positions
3. Sends all data to AI model (OpenRouter)
4. AI analyzes the market and makes trading decisions
5. Agent executes AI-recommended trades on Lighter Protocol
6. Results are saved to PostgreSQL database
7. Frontend displays portfolio performance & activity
8. Process repeats on configured interval
```

## 🛠️ Development

### Add a New Market
1. Edit `markets.ts`
2. Add market configuration
3. Update `indicators.ts` if needed
4. Restart agent

### Modify Trading Strategy
1. Edit `prompt.ts`
2. Update system instructions
3. Changes apply on next invocation

### Database Changes
```bash
# After editing prisma/schema.prisma:
bun run prisma migrate dev --name description
```

## 📈 Performance Tuning

- **Increase Trade Frequency**: Lower interval in agent invocation
- **Optimize AI Prompt**: Better context = better decisions
- **Add More Indicators**: Enhance market analysis
- **Connection Pooling**: For PostgreSQL queries
- **Caching**: API responses cached per endpoint

## 🐛 Troubleshooting

### Database Connection Error
- Ensure PostgreSQL is running
- Verify DATABASE_URL in `.env`
- Check database exists

### API Key Invalid
- Verify keys in `.env`
- Check no extra spaces
- Regenerate if needed

### Port Already in Use
- Change port in `.env` or code
- Or kill process on that port

See [SETUP_GUIDE.md](./SETUP_GUIDE.md) for more solutions.

## 📦 Dependencies

- **@prisma/client** - Database ORM
- **@openrouter/ai-sdk-provider** - LLM provider
- **ai** - AI/LLM SDK
- **express** - Web framework
- **cors** - CORS middleware
- **react** - Frontend framework
- **recharts** - Charting library
- **vite** - Frontend bundler

## 🚢 Deployment

### Heroku
```bash
git push heroku main
```
Requires: Procfile, PostgreSQL addon

### Docker
```bash
docker build -t ai-trading-agent .
docker run -e DATABASE_URL=... ai-trading-agent
```

### VPS (Ubuntu)
```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash

# Deploy and run
git clone <repo>
cd ai-trading-agent
bun install
bun run prisma migrate deploy
bun run index.ts
```

## 📝 License

See LICENSE file for details.

## 🤝 Contributing

1. Fork repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## 💬 Support

- Check documentation files
- Review code comments
- Check GitHub issues
- Contact maintainers

## ⚠️ Disclaimer

This is an experimental trading bot. Use at your own risk:
- Markets are volatile
- Losses are possible
- Start with small amounts
- Monitor regularly
- Have stop-losses configured
- Understand the strategies

## 🎓 Learning Resources

- [Bun Documentation](https://bun.sh/docs)
- [Prisma ORM](https://www.prisma.io/docs)
- [OpenRouter API](https://openrouter.ai/docs)
- [Lighter Protocol](https://lighter.ai/docs)
- [Express.js](https://expressjs.com)
- [React Documentation](https://react.dev)

## 📞 Contact

For questions or support, open an issue or contact the maintainers.

---

**Version**: 1.0.0  
**Last Updated**: Oct 30, 2025  
**Status**: Active Development
