# System Architecture & Component Overview

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                          AI TRADING AGENT                           │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Frontend   │    │  API Server  │    │   Agent      │
│  (React)     │    │  (Express)   │    │  (Decision   │
│  Port: 5173  │    │  Port: 3000  │    │   Maker)     │
└──────────────┘    └──────────────┘    └──────────────┘
       │                   │                    │
       │                   │                    │
       └───────────────────┴────────────────────┘
               │
       ┌───────▼──────────┐
       │  PostgreSQL DB   │
       │  (Data Store)    │
       └──────────────────┘
               │
       ┌───────┴─────────────────────────────┐
       │                                     │
┌──────▼──────────┐              ┌──────────▼────────┐
│  OpenRouter API │              │ Lighter Protocol  │
│  (LLM Provider) │              │ (Trading Platform)│
│  Claude, GPT-4  │              │ Exchange & Signer │
└─────────────────┘              └───────────────────┘
```

---

## File Organization & Responsibilities

### 🎯 Core Trading Logic
```
index.ts
├── invokeAgent()           - Main orchestration loop
├── Gets market indicators
├── Gets portfolio status
├── Calls AI model with context
├── AI decides actions (buy/sell)
└── Executes trades via API

prompt.ts
└── System prompt for AI model (trading strategy)
```

### 📊 Data & Markets
```
markets.ts                 - Defined trading pairs (ETH, BTC, etc)
indicators.ts              - Technical indicators (EMA, MACD)
stockData.ts               - Market data fetching
priceTracker.ts            - Price monitoring
getPortfolio.ts            - Portfolio valuation
```

### 💼 Account & Order Management
```
accounts.ts                - Account setup & initialization
createPosition.ts          - Open new trades
cancelOrder.ts             - Close trades
getPortfolio.ts            - Get account balance
openPositions.ts           - Get current open positions
```

### 🔌 API & Backend
```
backend.ts                 - Express API server
├── GET /performance       - Portfolio timeseries chart data
└── GET /invocations       - Recent AI agent invocations

config.ts                  - Constants (API base URL, etc)
```

### 🎨 Frontend
```
frontend/src/
├── App.tsx                - Main React component
├── components/
│   ├── PerformanceChart   - Portfolio performance chart (Recharts)
│   └── RecentInvocations  - AI decisions log
├── main.tsx               - React entry point
└── types/
    └── recharts.d.ts      - TypeScript types
```

### 📦 Database (Prisma)
```
prisma/
├── schema.prisma          - Database schema
│   ├── Models             - Available AI models
│   ├── Invocations        - AI agent invocations
│   ├── ToolCalls          - Trades executed by AI
│   └── PortfolioSize      - Portfolio history
└── migrations/            - Database migration history
```

### 🔐 SDK & Authentication
```
lighter-sdk-ts/            - Trading SDK (auto-generated)
├── signer.ts              - Transaction signing
├── ws.ts                  - WebSocket connections
└── generated/             - OpenAPI generated files
```

---

## Data Flow Diagram

```
1. INITIALIZATION
   ├─ Load database config
   ├─ Initialize Prisma client
   ├─ Load AI model config
   └─ Connect to trading APIs

2. AGENT INVOCATION (repeats every N seconds)
   │
   ├─ Fetch Current State
   │  ├─ Get portfolio balance
   │  ├─ Get open positions
   │  └─ Get market technical indicators (5m & 4h)
   │
   ├─ Build Context
   │  ├─ Prepare market data
   │  ├─ Prepare portfolio info
   │  └─ Create system prompt
   │
   ├─ Call AI Model (OpenRouter)
   │  ├─ Send context + trading prompt
   │  ├─ AI analyzes indicators
   │  └─ AI decides actions
   │
   ├─ Execute AI Decisions
   │  ├─ If "CREATE_POSITION" → createPosition()
   │  └─ If "CLOSE_ALL" → cancelOrder()
   │
   ├─ Record Results
   │  ├─ Save invocation to DB
   │  ├─ Save tool calls (trades)
   │  └─ Save portfolio state
   │
   └─ Repeat

3. USER MONITORING
   │
   ├─ Frontend (React)
   │  ├─ Fetch /performance → Chart
   │  └─ Fetch /invocations → Activity log
   │
   └─ Backend API (Express)
       ├─ Queries database
       └─ Returns JSON
```

---

## Database Schema

```sql
Models
├── id (UUID, primary key)
├── name (string, unique)
├── openRoutermodelName
├── lighterApiKey
├── invocationCount
├── accountIndex
├── Relations:
│   ├── Invocations (1→many)
│   └── PortfolioSize (1→many)

Invocations
├── id (UUID, primary key)
├── modelId (foreign key → Models)
├── response (string - AI response)
├── createdAt
├── updatedAt
├── Relations:
│   ├── Model (many→1)
│   └── ToolCalls (1→many)

ToolCalls
├── id (UUID, primary key)
├── invocationId (foreign key → Invocations)
├── toolCallType (enum: CREATE_POSITION, CLOSE_POSITION)
├── metadata (JSON string)
├── createdAt
├── updatedAt

PortfolioSize
├── id (UUID, primary key)
├── modelId (foreign key → Models)
├── totalValue (decimal)
├── createdAt
├── Relations:
│   └── Model (many→1)
```

---

## API Endpoints

### Express Backend (`backend.ts` - Port 3000)

#### GET `/performance`
- **Purpose**: Get portfolio value over time
- **Returns**: 
  ```json
  {
    "data": [
      { "createdAt": "2025-10-30T10:00:00Z", "totalValue": 10000, "model": { "name": "Model1" } },
      { "createdAt": "2025-10-30T11:00:00Z", "totalValue": 10500, "model": { "name": "Model1" } }
    ],
    "lastUpdated": "2025-10-30T11:00:00Z"
  }
  ```
- **Cache**: 5 minutes

#### GET `/invocations?limit=30`
- **Purpose**: Get recent AI agent invocations
- **Parameters**:
  - `limit` (optional): 1-200 (default: 30)
- **Returns**:
  ```json
  {
    "data": [
      {
        "id": "uuid",
        "modelId": "uuid",
        "response": "AI response...",
        "model": { "name": "Model1" },
        "toolCalls": [
          { "toolCallType": "CREATE_POSITION", "metadata": "{...}", "createdAt": "..." }
        ],
        "createdAt": "2025-10-30T11:00:00Z"
      }
    ],
    "lastUpdated": "2025-10-30T11:00:00Z",
    "stale": false
  }
  ```
- **Cache**: 2 minutes

---

## External APIs Used

### 1. OpenRouter API
- **Purpose**: LLM (Large Language Model) provider
- **Endpoint**: `https://api.openrouter.ai/v1/messages`
- **Models Available**: Claude, GPT-4, Mistral, LLaMA, etc.
- **Authentication**: Bearer token in Authorization header
- **Cost**: Pay per token usage

### 2. Lighter Protocol API
- **Purpose**: Trading execution platform
- **Endpoint**: `https://mainnet.zklighter.elliot.ai`
- **Features**:
  - Get account positions
  - Create/cancel orders
  - Get market data
  - Account balance
- **Authentication**: API key in headers

### 3. PostgreSQL Database
- **Purpose**: Data persistence
- **Tables**: Models, Invocations, ToolCalls, PortfolioSize
- **Client**: Prisma ORM

---

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Runtime | Bun / Node.js | JavaScript/TypeScript execution |
| Language | TypeScript | Type-safe development |
| Backend Framework | Express | REST API server |
| Frontend Framework | React | UI dashboard |
| Frontend Bundler | Vite | Fast build tool |
| ORM | Prisma | Database abstraction |
| Database | PostgreSQL | Data storage |
| LLM Provider | OpenRouter | AI model access |
| Trading Platform | Lighter Protocol | Order execution |
| HTTP Client | Fetch API | API requests |

---

## Environment Variables

```env
# Database
DATABASE_URL                  - PostgreSQL connection string

# AI & APIs
OPENROUTER_API_KEY           - LLM provider API key
LIGHTER_API_KEY_*            - Trading platform API keys
ACCOUNT_PRIVATE_KEY_*        - Wallet private keys
SIGNER_PRIVATE_KEY           - Transaction signer key

# Server
API_PORT                      - Express server port (default: 3000)
NODE_ENV                      - Environment (development/production)
```

---

## Key Components Explained

### 1. Agent (index.ts)
- Runs trading decisions autonomously
- Calls AI model to analyze market
- Executes trades based on AI decisions
- Records all actions in database

### 2. API Server (backend.ts)
- Provides REST endpoints for frontend
- Caches database queries
- Serves performance charts
- Tracks invocation history

### 3. Frontend (React)
- Displays portfolio performance
- Shows AI invocation history
- Real-time monitoring
- Runs on separate port (5173)

### 4. Database (Prisma)
- Stores all trading history
- Tracks AI decisions
- Records portfolio values
- Enables analytics

---

## Execution Flow

```
START
  │
  ├─→ Load Environment Variables
  │
  ├─→ Initialize Prisma Client
  │
  ├─→ Start Express Server (Port 3000)
  │    ├─ GET /performance endpoint
  │    └─ GET /invocations endpoint
  │
  ├─→ Main Agent Loop
  │    ├─→ Fetch market indicators
  │    ├─→ Fetch account portfolio
  │    ├─→ Fetch open positions
  │    ├─→ Call AI model (OpenRouter)
  │    │   └─→ AI analyzes market
  │    ├─→ Execute AI decisions
  │    │   ├─→ Create positions (buy/sell)
  │    │   └─→ Close positions
  │    ├─→ Save to database
  │    │   ├─→ Save invocation record
  │    │   ├─→ Save tool calls
  │    │   └─→ Save portfolio state
  │    │
  │    └─→ Wait (configurable interval)
  │
  └─→ LOOP (repeats forever)
```

---

## Performance Considerations

1. **Database Queries**
   - Use indexes for faster lookups
   - Cache API responses (5 min for performance, 2 min for invocations)
   - Consider connection pooling

2. **API Rate Limiting**
   - OpenRouter: depends on plan
   - Lighter Protocol: check documentation
   - Implement backoff strategies

3. **Market Data**
   - Fetch indicators every 5 minutes
   - Cache recent prices
   - Use WebSocket for real-time updates

4. **Frontend**
   - Vite provides fast HMR (Hot Module Reload)
   - React minimizes re-renders
   - API responses cached in frontend

---

**Document Version**: 1.0  
**Last Updated**: Oct 30, 2025
