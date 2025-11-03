# CPRS Architecture Analysis - For AI Integration & API Development

## Executive Summary

CPRS uses a **3-tier client-server architecture** with a proprietary RPC (Remote Procedure Call) protocol called **XWB (eXtensible Windows Broker)** to communicate with VistA server. This document analyzes the architecture to design a modern REST API layer for AI integration.

---

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    CPRS CLIENT (Delphi)                      │
├─────────────────────────────────────────────────────────────┤
│  Presentation Layer (Forms/UI)                               │
│    ├── fFrame.pas (Main Frame)                               │
│    ├── fMeds.pas, fNotes.pas, fOrders.pas, etc.            │
│    └── Cover Sheet, Consults, Labs, Problem List, etc.     │
├─────────────────────────────────────────────────────────────┤
│  Business Logic Layer (Units)                                │
│    ├── uCore.pas - Core utilities                           │
│    ├── uConst.pas - Constants                               │
│    └── Domain-specific units                                │
├─────────────────────────────────────────────────────────────┤
│  RPC Abstraction Layer (r*.pas units)                        │
│    ├── rCore.pas - Core RPC calls                           │
│    ├── rMeds.pas - Medication RPCs                          │
│    ├── rOrders.pas - Order RPCs                             │
│    ├── rProbs.pas - Problem list RPCs                       │
│    ├── rLabs.pas - Lab RPCs                                 │
│    └── rTIU.pas - Notes/Documents RPCs                      │
├─────────────────────────────────────────────────────────────┤
│  Network Layer (ORNet.pas)                                   │
│    └── CallVistA() - Universal RPC wrapper                  │
├─────────────────────────────────────────────────────────────┤
│  Broker Component (TRPCB.pas)                                │
│    └── TRPCBroker - Low-level RPC protocol handler          │
└─────────────────────────────────────────────────────────────┘
                            ↓ XWB Protocol
┌─────────────────────────────────────────────────────────────┐
│              VistA SERVER (MUMPS/M)                          │
├─────────────────────────────────────────────────────────────┤
│  RPC Broker Listener (Port 9430)                            │
│    └── Handles XWB protocol, spawns MUMPS jobs              │
├─────────────────────────────────────────────────────────────┤
│  RPC Entry Points (MUMPS Routines)                          │
│    ├── ORWU* - Utility RPCs                                 │
│    ├── ORWPT* - Patient RPCs                                │
│    ├── ORQQPL* - Problem List RPCs                          │
│    ├── ORWPS* - Pharmacy RPCs                               │
│    ├── TIU* - Notes/Documents RPCs                          │
│    └── ORW* - Orders/Results RPCs                           │
├─────────────────────────────────────────────────────────────┤
│  VistA Database (FileMan)                                    │
│    └── MUMPS global variables (^DPT, ^OR, ^GMR, etc.)       │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. RPC Call Architecture

### 2.1 The CallVistA Function - Universal RPC Interface

**Location**: `src/packages/OR/Source/ORNet.pas`

The `CallVistA()` function is the **primary interface** for all RPC calls. It has multiple overloads:

```pascal
// 1. No return value (POST-like)
function CallVistA(const aRPCName: string; 
                   const aParam: array of const;
                   RequireResults: boolean = False): boolean;

// 2. Return as string
function CallVistA(const aRPCName: string; 
                   const aParam: array of const;
                   var aReturn: string; 
                   RequireResults: boolean = False; 
                   aDefault: string = ''): boolean;

// 3. Return as integer
function CallVistA(const aRPCName: string; 
                   const aParam: array of const;
                   var aReturn: Integer; 
                   RequireResults: boolean = False; 
                   aDefault: Integer = 0): boolean;

// 4. Return as double
function CallVistA(const aRPCName: string; 
                   const aParam: array of const;
                   var aReturn: Double; 
                   RequireResults: boolean = False; 
                   aDefault: Double = 0.0): boolean;

// 5. Return as TStrings (list/array)
function CallVistA(const aRPCName: string; 
                   const aParam: array of const;
                   aReturn: TStrings; 
                   RequireResults: boolean = False): boolean;
```

### 2.2 Parameter Types

Parameters are passed as Delphi `array of const` and support multiple types:

| Type | Example | Description |
|------|---------|-------------|
| **Integer** | `[123]` | Numeric values |
| **Boolean** | `[True]` | Converted to '1' or '0' |
| **String** | `['PATIENT,NAME']` | Text values |
| **Extended/Float** | `[123.45]` | Decimal numbers |
| **TStrings** | `[MyList]` | Arrays/lists as mult parameter |
| **nil** | `[nil]` | Empty/no parameter |
| **Reference** | `[#1+'VARNAME']` | Pass by reference (prefixed with #1) |

### 2.3 RPC Call Flow

```
User Action (UI)
    ↓
Business Logic (u*.pas)
    ↓
RPC Wrapper (r*.pas) - e.g., GetUserInfo() in rCore.pas
    ↓
CallVistA('ORWU USERINFO', [nil], x)
    ↓
SetParams() - Converts parameters to TRPCBroker.Param[]
    ↓
TRPCBroker.Call() - Sends XWB protocol packet
    ↓
[Network] TCP Socket to vista-server:9430
    ↓
VistA RPC Broker Listener
    ↓
Spawns MUMPS Job
    ↓
Executes RPC Routine (e.g., ORWU^USERINFO)
    ↓
Returns delimited string result
    ↓
TRPCBroker.Results (TStringList)
    ↓
Parsed by RPC Wrapper (r*.pas)
    ↓
Business Logic receives structured data
```

---

## 3. RPC Naming Conventions

VistA RPCs follow a **strict naming convention**:

### Format: `[PACKAGE][AREA] [FUNCTION]`

| Prefix | Package/Area | Examples |
|--------|-------------|----------|
| **ORWU** | Orders/Results - Utilities | `ORWU USERINFO`, `ORWU HASKEY` |
| **ORWPT** | Orders/Results - Patient | `ORWPT SELECT`, `ORWPT IDINFO` |
| **ORQQPL** | Orders/Results - Problem List | `ORQQPL PROBLEM LIST`, `ORQQPL ADD SAVE` |
| **ORWPS** | Orders/Results - Pharmacy | `ORWPS DETAIL`, `ORWPS MEDHIST` |
| **TIU** | Text Integration Utilities | `TIU GET RECORD TEXT`, `TIU CREATE RECORD` |
| **ORWORB** | Orders/Results - Notifications | `ORWORB FASTUSER` |
| **ORWD** | Orders/Results - Dialogs | `ORWDX WRLST`, `ORWDX SAVE` |
| **ORWDRA** | Orders/Results - Radiology | `ORWDRA32 LOCTYPE` |
| **ORWDX** | Orders/Results - Generic Order | `ORWDX SEND`, `ORWDX LOCK` |

---

## 4. Key RPC Examples

### 4.1 User Authentication & Info

```pascal
// Get user information
function GetUserInfo: TUserInfo;
var
  x: string;
begin
  CallVistA('ORWU USERINFO', [nil], x);
  // Returns: DUZ^Name^UserClass^CanSign^IsProvider^OrderRole^...
  Result.DUZ := StrToInt64Def(Piece(x, U, 1), 0);
  Result.Name := Piece(x, U, 2);
  // ... parse remaining fields
end;

// Check security key
function HasSecurityKey(const KeyName: string): Boolean;
var
  x: string;
begin
  Result := CallVistA('ORWU HASKEY', [KeyName], x) and (x = '1');
end;

// Validate electronic signature
function ValidESCode(const ACode: string): Boolean;
var
  x: string;
begin
  Result := CallVistA('ORWU VALIDSIG', [Encrypt(ACode)], x) and (x = '1');
end;
```

### 4.2 Patient Selection & Demographics

```pascal
// Select patient
CallVistA('ORWPT SELECT', [PatientDFN], x);
// Returns: Name^ICN^SSN^DOB^Age^Sex^Location^...

// Get patient ID info
CallVistA('ORWPT IDINFO', [Patient.DFN], x);
// Returns: Name^SSN^DOB^Age^Sex^SC^Veteran^Location^RoomBed^...

// Patient inquiry (cover sheet data)
CallVistA('ORWPT PTINQ', [Patient.DFN], Dest);
```

### 4.3 Problem List

```pascal
// Get problem list
CallVistA('ORQQPL PROBLEM LIST', [PatientDFN, Status, ADate], Dest);

// Add new problem
CallVistA('ORQQPL ADD SAVE', 
  [PatientInfo, ProviderID, ptVAMC, ProbFile, SearchString], Dest);

// Edit problem
CallVistA('ORQQPL EDIT SAVE', 
  [ProblemIFN, ProviderID, ptVAMC, PrimUser, ProbFile, SearchString], Dest);

// Delete problem
CallVistA('ORQQPL DELETE', [ProblemIFN, ProviderID, ptVAMC, Comment], Dest);
```

### 4.4 Medications

```pascal
// Get medication detail
CallVistA('ORWPS DETAIL', [Patient.DFN, UpperCase(MedID)], aReturn);

// Get medication administration history
CallVistA('ORWPS MEDHIST', [Patient.DFN, OrderID], aReturn);
```

### 4.5 Orders

```pascal
// Get orders list
CallVistA('ORWORR AGET', [Patient.DFN, FilterIEN, StartFrom, Direction], Dest);

// Sign orders
CallVistA('ORWDX SEND', [Patient.DFN, OrderList, ESCode], Result);

// Release orders
CallVistA('ORWDX RELEASE', [Patient.DFN, OrderList], Result);
```

### 4.6 Clinical Notes (TIU)

```pascal
// Get note text
CallVistA('TIU GET RECORD TEXT', [NoteIEN], Dest);

// Create note
CallVistA('TIU CREATE RECORD', [Patient.DFN, TitleIEN, VisitStr, ...], Result);

// Sign note
CallVistA('TIU SIGN RECORD', [NoteIEN, ESCode], Result);
```

---

## 5. Data Format - Delimited Strings

VistA returns data as **caret-delimited strings** (using `^` as delimiter):

### Example: Patient Info
```
"123456^PATIENT,TEST^123-45-6789^2500101^65^M^200^WARD 5A^5A-101^..."
```

### Parsing with Piece() Function

```pascal
Name := Piece(x, U, 2);      // Get 2nd piece
SSN := Piece(x, U, 3);       // Get 3rd piece
DOB := Piece(x, U, 4);       // Get 4th piece
```

**Note**: `U` constant = `^` character

---

## 6. XWB Protocol Overview

### 6.1 Connection Handshake

```
Client → Server: [XWB]10304\nTCPConnect50075<EOT>0f0<EOT>
Server → Client: accept (or job termination message)
```

- `[XWB]10304` - Protocol identifier and version
- `TCPConnect` - Connection type
- `50075` - Version info
- `<EOT>` - End of transmission (ASCII 4)

### 6.2 RPC Call Format

```
[XWB]11302\n{rpc_version}<EOT>{context}<EOT>{rpc_name}<EOT>{param_count}<EOT>{params}<EOT>
```

### 6.3 Authentication

```pascal
// XUS SIGNON SETUP - Initialize session
// XUS AV CODE - Authenticate with Access/Verify codes
// XUS INTRO MSG - Get intro message
```

### 6.4 cipher.txt

The `cipher.txt` file contains 20 lines of character mapping for encrypting Access/Verify codes:
- Used during authentication
- Applied with `Encrypt()` function before sending credentials
- Located in same directory as executable

---

## 7. Proposed REST API Architecture for AI Integration

### 7.1 API Gateway Layer

```
┌──────────────────────────────────────────────────────┐
│           REST API Gateway (Node.js/Python)           │
├──────────────────────────────────────────────────────┤
│  Authentication Middleware                            │
│    ├── JWT tokens                                     │
│    ├── OAuth 2.0                                      │
│    └── API keys                                       │
├──────────────────────────────────────────────────────┤
│  REST Endpoints                                       │
│    ├── /api/v1/patients                              │
│    ├── /api/v1/medications                           │
│    ├── /api/v1/orders                                │
│    ├── /api/v1/notes                                 │
│    ├── /api/v1/labs                                  │
│    └── /api/v1/problems                              │
├──────────────────────────────────────────────────────┤
│  Business Logic Layer                                 │
│    ├── Request validation                             │
│    ├── Data transformation                            │
│    └── Response formatting (JSON)                     │
├──────────────────────────────────────────────────────┤
│  VistA RPC Adapter                                    │
│    ├── RPC connection pool                            │
│    ├── XWB protocol implementation                    │
│    └── cipher.txt integration                         │
└──────────────────────────────────────────────────────┘
                       ↓ XWB Protocol
┌──────────────────────────────────────────────────────┐
│         VistA Server (vista-demo:9430)                │
└──────────────────────────────────────────────────────┘
```

### 7.2 Example REST Endpoints

#### GET /api/v1/patients/{dfn}
```json
{
  "dfn": "123456",
  "name": "PATIENT, TEST",
  "ssn": "123-45-6789",
  "dob": "1960-01-01",
  "age": 65,
  "sex": "M",
  "veteran": true,
  "location": "WARD 5A",
  "roomBed": "5A-101"
}
```

**Maps to**: `ORWPT SELECT`, `ORWPT IDINFO`

#### GET /api/v1/patients/{dfn}/problems
```json
{
  "problems": [
    {
      "ien": "789",
      "code": "I10",
      "description": "Essential (primary) hypertension",
      "status": "Active",
      "onset": "2020-01-15",
      "provider": "PHYSICIAN, PRIMARY"
    }
  ]
}
```

**Maps to**: `ORQQPL PROBLEM LIST`

#### POST /api/v1/patients/{dfn}/problems
```json
{
  "code": "E11.9",
  "description": "Type 2 diabetes mellitus without complications",
  "provider": "500",
  "comment": "Newly diagnosed"
}
```

**Maps to**: `ORQQPL ADD SAVE`

#### GET /api/v1/patients/{dfn}/medications/active
```json
{
  "medications": [
    {
      "orderId": "12345",
      "drug": "LISINOPRIL 10MG TAB",
      "instructions": "TAKE ONE TABLET BY MOUTH DAILY",
      "startDate": "2023-01-01",
      "status": "ACTIVE",
      "refills": "3"
    }
  ]
}
```

**Maps to**: `ORWPS DETAIL`, Active meds extraction logic

#### GET /api/v1/patients/{dfn}/notes
```json
{
  "notes": [
    {
      "ien": "67890",
      "title": "Progress Note",
      "author": "PHYSICIAN, PRIMARY",
      "date": "2025-11-02T10:30:00Z",
      "status": "COMPLETED",
      "text": "Patient reports..."
    }
  ]
}
```

**Maps to**: `TIU GET RECORD TEXT`, TIU list RPCs

---

## 8. AI Integration Strategies

### 8.1 LLM-Powered Clinical Assistant

```javascript
// AI prompt context builder
async function buildPatientContext(dfn) {
  const patient = await api.get(`/patients/${dfn}`);
  const problems = await api.get(`/patients/${dfn}/problems`);
  const meds = await api.get(`/patients/${dfn}/medications/active`);
  const recentNotes = await api.get(`/patients/${dfn}/notes?limit=5`);
  
  return {
    demographics: patient,
    activeProblems: problems.problems,
    medications: meds.medications,
    recentNotes: recentNotes.notes.map(n => n.text)
  };
}

// Send to LLM
const response = await openai.chat.completions.create({
  model: "gpt-4",
  messages: [
    {
      role: "system",
      content: "You are a clinical assistant with access to patient EHR data."
    },
    {
      role: "user",
      content: `Patient context: ${JSON.stringify(context)}\n\nQuestion: ${userQuestion}`
    }
  ]
});
```

### 8.2 Clinical Decision Support

```javascript
// Drug interaction checker
async function checkDrugInteractions(dfn, newDrug) {
  const currentMeds = await api.get(`/patients/${dfn}/medications/active`);
  
  // AI analyzes interactions
  const analysis = await llm.analyze({
    currentMedications: currentMeds.medications,
    proposedDrug: newDrug,
    patientAllergies: await api.get(`/patients/${dfn}/allergies`)
  });
  
  return {
    severity: analysis.severity,
    interactions: analysis.interactions,
    recommendations: analysis.recommendations
  };
}
```

### 8.3 Clinical Note Summarization

```javascript
// Summarize recent notes
async function summarizePatientHistory(dfn) {
  const notes = await api.get(`/patients/${dfn}/notes?days=30`);
  
  const summary = await llm.summarize({
    notes: notes.notes.map(n => n.text),
    focus: ["chief complaints", "diagnoses", "treatment plans"]
  });
  
  return summary;
}
```

### 8.4 Diagnosis Suggestion

```javascript
// AI-assisted diagnosis
async function suggestDiagnoses(symptoms, patientContext) {
  const problems = await api.get(`/patients/${dfn}/problems`);
  const labs = await api.get(`/patients/${dfn}/labs/recent`);
  
  const suggestions = await llm.diagnose({
    symptoms: symptoms,
    existingProblems: problems.problems,
    labResults: labs.results,
    demographics: patientContext.demographics
  });
  
  return suggestions.map(d => ({
    icd10: d.code,
    description: d.description,
    confidence: d.confidence,
    reasoning: d.reasoning
  }));
}
```

---

## 9. Implementation Recommendations

### 9.1 Technology Stack

**API Gateway Options:**

1. **Node.js + Express**
   - Fast development
   - Good XWB protocol libraries available
   - Easy integration with AI services

2. **Python + FastAPI**
   - Excellent for AI/ML integration
   - Strong data processing capabilities
   - Great documentation tools (Swagger)

3. **Go**
   - High performance
   - Excellent concurrency for connection pooling
   - Strong typing

### 9.2 RPC Connection Management

```javascript
// Connection pool pattern
class VistaConnectionPool {
  constructor(config) {
    this.server = config.server;
    this.port = config.port;
    this.maxConnections = config.maxConnections || 10;
    this.pool = [];
  }
  
  async getConnection() {
    // Reuse or create connection
    if (this.pool.length > 0) {
      return this.pool.pop();
    }
    return await this.createConnection();
  }
  
  async createConnection() {
    const conn = new XWBConnection(this.server, this.port);
    await conn.connect();
    await conn.authenticate(this.credentials);
    return conn;
  }
  
  releaseConnection(conn) {
    if (this.pool.length < this.maxConnections) {
      this.pool.push(conn);
    } else {
      conn.close();
    }
  }
}
```

### 9.3 Error Handling

```javascript
// Standardized error responses
class VistaAPIError extends Error {
  constructor(message, rpcName, vistaError) {
    super(message);
    this.rpcName = rpcName;
    this.vistaError = vistaError;
    this.statusCode = this.mapStatusCode(vistaError);
  }
  
  mapStatusCode(vistaError) {
    // Map VistA errors to HTTP status codes
    if (vistaError.includes('NOT AUTHORIZED')) return 403;
    if (vistaError.includes('NOT FOUND')) return 404;
    if (vistaError.includes('TIMEOUT')) return 504;
    return 500;
  }
}
```

### 9.4 Caching Strategy

```javascript
// Redis cache for frequently accessed data
const cache = {
  async get(key) {
    const cached = await redis.get(key);
    return cached ? JSON.parse(cached) : null;
  },
  
  async set(key, value, ttl = 300) {
    await redis.setex(key, ttl, JSON.stringify(value));
  }
};

// Cached patient lookup
async function getPatient(dfn) {
  const cacheKey = `patient:${dfn}`;
  
  let patient = await cache.get(cacheKey);
  if (!patient) {
    patient = await rpcCall('ORWPT SELECT', [dfn]);
    await cache.set(cacheKey, patient, 600); // 10 min TTL
  }
  
  return patient;
}
```

---

## 10. Security Considerations

### 10.1 Authentication Flow

```
User → API Gateway (JWT/OAuth) → Validate Token
                                       ↓
                          Map User to VistA Credentials
                                       ↓
                          VistA RPC Connection (XWB)
                                       ↓
                          Execute RPC with User Context
```

### 10.2 Audit Logging

```javascript
// Log all API calls
async function auditLog(req, res, rpcName, result) {
  await db.auditLog.insert({
    timestamp: new Date(),
    user: req.user.id,
    endpoint: req.path,
    rpcName: rpcName,
    patientDFN: req.params.dfn,
    action: req.method,
    success: res.statusCode < 400,
    ipAddress: req.ip
  });
}
```

### 10.3 Data Encryption

- **In Transit**: TLS 1.3 for API connections
- **At Rest**: Encrypted credentials storage (HashiCorp Vault)
- **VistA Connection**: SSH tunneling or future TLS support

---

## 11. Next Steps for Development

### Phase 1: Core API (2-3 weeks)
1. ✅ XWB protocol client implementation
2. ✅ Connection pool management
3. ✅ Basic authentication (Access/Verify)
4. ✅ Core endpoints: patients, problems, meds

### Phase 2: Enhanced Features (2-3 weeks)
5. ✅ Orders management
6. ✅ Clinical notes (TIU)
7. ✅ Lab results
8. ✅ Caching layer

### Phase 3: AI Integration (3-4 weeks)
9. ✅ LLM integration (OpenAI/Azure)
10. ✅ Clinical summarization
11. ✅ Decision support
12. ✅ Natural language querying

### Phase 4: Production Readiness (2 weeks)
13. ✅ Security hardening
14. ✅ Performance optimization
15. ✅ Monitoring & logging
16. ✅ Documentation

---

## 12. Example Implementation - Node.js

### 12.1 XWB Client Library

```javascript
// vista-rpc-client.js
const net = require('net');
const crypto = require('crypto');

class VistaRPCClient {
  constructor(host, port) {
    this.host = host;
    this.port = port;
    this.socket = null;
    this.connected = false;
  }
  
  async connect() {
    return new Promise((resolve, reject) => {
      this.socket = net.createConnection(this.port, this.host);
      
      this.socket.on('connect', async () => {
        // Send XWB handshake
        const handshake = '[XWB]10304\nTCPConnect50075\u00040f0\u0004';
        this.socket.write(handshake);
        
        this.socket.once('data', (data) => {
          if (data.toString().includes('accept')) {
            this.connected = true;
            resolve();
          } else {
            reject(new Error('Connection rejected'));
          }
        });
      });
      
      this.socket.on('error', reject);
    });
  }
  
  async callRPC(rpcName, params = []) {
    if (!this.connected) {
      throw new Error('Not connected to VistA');
    }
    
    // Build RPC packet
    const packet = this.buildRPCPacket(rpcName, params);
    
    return new Promise((resolve, reject) => {
      this.socket.write(packet);
      
      this.socket.once('data', (data) => {
        const result = this.parseResponse(data);
        resolve(result);
      });
      
      this.socket.once('error', reject);
    });
  }
  
  buildRPCPacket(rpcName, params) {
    const EOT = '\u0004';
    let packet = '[XWB]11302\n1.108' + EOT;
    packet += 'OR CPRS GUI CHART' + EOT; // Context
    packet += rpcName + EOT;
    packet += params.length.toString() + EOT;
    
    params.forEach(param => {
      packet += this.encodeParam(param) + EOT;
    });
    
    return packet;
  }
  
  encodeParam(param) {
    if (param === null || param === undefined) {
      return '0';
    }
    if (typeof param === 'string') {
      return '0' + param.length + param;
    }
    if (typeof param === 'number') {
      return '0' + param.toString().length + param.toString();
    }
    if (Array.isArray(param)) {
      // Handle mult parameters
      let encoded = '2';
      param.forEach((item, index) => {
        encoded += (index + 1) + '^' + item + '\n';
      });
      return encoded;
    }
    return param.toString();
  }
  
  parseResponse(data) {
    const str = data.toString();
    // Parse delimited response
    return str.split('\n').filter(line => line.trim());
  }
  
  disconnect() {
    if (this.socket) {
      this.socket.end();
      this.connected = false;
    }
  }
}

module.exports = VistaRPCClient;
```

### 12.2 REST API Server

```javascript
// server.js
const express = require('express');
const VistaRPCClient = require('./vista-rpc-client');

const app = express();
app.use(express.json());

const vista = new VistaRPCClient(
  'vista-demo-frasod-237.eastus.azurecontainer.io',
  9430
);

// Middleware: Connect to VistA
app.use(async (req, res, next) => {
  if (!vista.connected) {
    try {
      await vista.connect();
    } catch (error) {
      return res.status(503).json({ error: 'VistA unavailable' });
    }
  }
  next();
});

// GET /api/v1/patients/:dfn
app.get('/api/v1/patients/:dfn', async (req, res) => {
  try {
    const result = await vista.callRPC('ORWPT SELECT', [req.params.dfn]);
    const data = parsePatientData(result[0]);
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/v1/patients/:dfn/problems
app.get('/api/v1/patients/:dfn/problems', async (req, res) => {
  try {
    const result = await vista.callRPC('ORQQPL PROBLEM LIST', [
      req.params.dfn,
      'A', // Active
      ''   // All dates
    ]);
    const problems = parseProblems(result);
    res.json({ problems });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/v1/patients/:dfn/problems
app.post('/api/v1/patients/:dfn/problems', async (req, res) => {
  try {
    const { code, description, provider, comment } = req.body;
    
    const result = await vista.callRPC('ORQQPL ADD SAVE', [
      req.params.dfn,
      provider,
      '', // ptVAMC
      [code, description], // ProbFile
      code // SearchString
    ]);
    
    res.status(201).json({ result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// AI Integration endpoint
app.post('/api/v1/ai/analyze-patient', async (req, res) => {
  try {
    const { dfn, question } = req.body;
    
    // Gather patient data
    const patient = await vista.callRPC('ORWPT SELECT', [dfn]);
    const problems = await vista.callRPC('ORQQPL PROBLEM LIST', [dfn, 'A', '']);
    const meds = await vista.callRPC('ORWPS DETAIL', [dfn, '']);
    
    // Send to LLM
    const aiResponse = await callOpenAI({
      patient: parsePatientData(patient[0]),
      problems: parseProblems(problems),
      medications: parseMeds(meds),
      question: question
    });
    
    res.json({ answer: aiResponse });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

function parsePatientData(data) {
  const pieces = data.split('^');
  return {
    name: pieces[0],
    icn: pieces[1],
    ssn: pieces[2],
    dob: pieces[3],
    age: pieces[4],
    sex: pieces[5]
  };
}

function parseProblems(data) {
  return data.map(line => {
    const pieces = line.split('^');
    return {
      ien: pieces[0],
      code: pieces[1],
      description: pieces[2],
      status: pieces[3]
    };
  });
}

app.listen(3000, () => {
  console.log('CPRS API Gateway running on port 3000');
});
```

---

## 13. Testing Strategy

### Unit Tests
```javascript
describe('VistaRPCClient', () => {
  it('should connect to VistA server', async () => {
    const client = new VistaRPCClient('localhost', 9430);
    await expect(client.connect()).resolves.not.toThrow();
  });
  
  it('should call ORWU USERINFO', async () => {
    const result = await client.callRPC('ORWU USERINFO', [null]);
    expect(result).toBeDefined();
  });
});
```

### Integration Tests
```javascript
describe('Patient API', () => {
  it('GET /api/v1/patients/:dfn should return patient data', async () => {
    const res = await request(app).get('/api/v1/patients/123456');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('name');
  });
});
```

---

## 14. Resources & References

### VistA Documentation
- **RPC Broker**: [VistA Documentation Library](https://www.va.gov/vdl/)
- **FileMan**: VistA FileMan Programmer Manual
- **XWB Protocol**: RPC Broker Developer Guide

### CPRS Source Code
- **GitHub**: https://github.com/WorldVistA/VistA
- **Local**: `c:\DEV\CPRS\src\`

### Key Files to Study
- `TRPCB.pas` - RPC Broker component
- `ORNet.pas` - CallVistA wrapper
- `rCore.pas` - Core RPC examples
- `rMeds.pas`, `rOrders.pas`, `rProbs.pas` - Domain-specific RPCs

---

**Document Version**: 1.0  
**Last Updated**: November 2, 2025  
**Status**: Ready for API development
