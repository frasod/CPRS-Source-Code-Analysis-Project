# CPRS/VistA EHR Source Code Analysis Project# CPRS Client Setup for Cloud VistA



**Purpose**: Academic/research reference for understanding how enterprise Electronic Health Record (EHR) systems are architected, specifically the VA's CPRS (Computerized Patient Record System).This workspace contains configuration and setup files for connecting the CPRS (Computerized Patient Record System) client to a VistA instance running in the cloud.



**Status**: Source code analysis and documentation repository (not a deployable application)## Overview



---CPRS is the graphical client application that healthcare providers use to access VistA. This setup allows you to connect a local CPRS installation to your cloud-hosted VistA server.



## 🎯 What This Repository Is## Prerequisites



This is a **comprehensive analysis and reference project** containing:- Windows workstation (CPRS requires Windows)

- Network access to your cloud VistA instance

1. **Complete CPRS source code** (~600 Delphi files, 60MB) - for studying EHR architecture- VistA server endpoint and port (typically port 9430 for RPC Broker)

2. **Detailed architecture documentation** - RPC protocol, UI patterns, data flow

3. **Complete RPC endpoint mapping** - All 600+ remote procedure calls documented## Current Configuration (November 2, 2025)

4. **AI-powered redesign blueprint** - Modern cloud-native EHR architecture

5. **Migration strategies** - From legacy to modern tech stacks**Active VistA Server:**

- Server: `vista-demo-frasod-237.eastus.azurecontainer.io`

**This repository is for developers, architects, and researchers who want to:**- Port: `9430`

- Understand how a production EHR system is built- Network connectivity: ✅ Verified

- Learn clinical software architecture patterns

- Study RPC-based client/server communication**Setup Scripts:**

- Reference when building new healthcare systems- `fix-cprs-connection.bat` - Configures Windows Registry for connection

- Avoid the mistakes of 1990s architecture- `run-cprs.bat` - Launches CPRS executable

- Design modern, AI-powered EHR systems- See `CONNECTION-LOG.md` for detailed setup history and troubleshooting



---## Quick Start



## 🚫 What This Repository Is NOT### Option 1: Pre-built CPRS Client



- ❌ **Not a running application** - Executables removed, this is source analysis only1. **Download CPRS Client**

- ❌ **Not deployment-ready** - No Docker configs, no connection setup   - Download from WorldVistA: [CPRS Chart 27.90](http://sourceforge.net/projects/worldvista-ehr/files/WorldVistA_EHR_2.0/CPRSChart_27.90ForWVEHR-2.0-Ver10-12-Files.zip/download)

- ❌ **Not maintained software** - Historical reference from VistA/CPRS codebase   - Extract and install on your Windows workstation

- ❌ **Not production code** - Use for learning, not for patient care

2. **Configure Connection**

---   - Update `config/vista-connection.ini` with your cloud VistA endpoint

   - Or use the PowerShell script: `.\scripts\configure-cprs.ps1`

## 📁 Repository Structure

3. **Connect to VistA**

```   - Launch CPRS

CPRS-EHR-ANALYSIS/   - Enter connection details when prompted

├── src/                                    # Complete CPRS source code (598 files)   - Use demo credentials (see below)

│   ├── packages/

│   │   ├── Broker/                         # RPC Broker component### Option 2: Build from Source (Development)

│   │   │   └── TRPCB.pas                  # Core RPC client (2423 lines)

│   │   └── OR/1. **Setup Development Environment**

│   │       └── ORNet.pas                   # RPC wrapper functions (1238 lines)   ```powershell

│   ├── f*.pas                              # 279 UI form files   .\scripts\setup-native-dev.ps1 -DownloadSource -Configure

│   ├── r*.pas                              # 33 RPC wrapper files   ```

│   ├── CPRSChart.dpr                       # Main project file

│   └── (all other Delphi source files)2. **Build CPRS**

│   ```powershell

├── CPRS-ARCHITECTURE-ANALYSIS.md           # Deep dive into architecture   .\scripts\build-cprs.ps1

├── COMPLETE-RPC-MAPPING.md                 # All 600+ RPC endpoints documented   ```

├── UI-ARCHITECTURE-COMPLETE.md             # UI patterns, Java/React migration

├── MASTER-AI-REDESIGN-PROMPT.md            # Complete modern EHR blueprint3. **Run CPRS**

├── SOURCE-CODE-INFO.md                     # Source code organization guide   ```powershell

├── ANALYSIS-INDEX.md                       # Master index of all documentation   .\scripts\run-cprs.ps1 -Server your-vista-endpoint

└── README.md                               # This file   ```

```

See `NATIVE-WINDOWS-DEV.md` for detailed development guide.

---

## VistA Connection Details

## 📚 Key Documentation Files

### RPC Broker Settings

### 1. **CPRS-ARCHITECTURE-ANALYSIS.md** (~500 lines)

Deep technical analysis of CPRS architecture:- **Default Port**: 9430

- RPC Broker protocol (XWB)- **Protocol**: TCP/IP

- Client/server communication patterns- **Service**: VistA RPC Broker

- Delphi VCL framework usage

- Database access patterns### Demo User Accounts

- Security model

- API design for modern replacementThese are pre-configured in the VEHU VistA instance:



### 2. **COMPLETE-RPC-MAPPING.md** (~400 lines)| User             | Access Code | Verify Code | E-Signature | Role                 |

Comprehensive mapping of all RPC endpoints:| ---------------- | ----------- | ----------- | ----------- | -------------------- |

- **600+ RPC calls** organized by domain| PROGRAMMER,ONE   | PRO1234     | PRO1234!!   | 123456      | System Administrator |

- User management (ORWU*)| PROVIDER,VERO    | CAS123      | CAS123..    | 123456      | Healthcare Provider  |

- Patient operations (ORWPT*)| PROVIDER,FORTY   | PROV40      | PROV40!!    | 123456      | Healthcare Provider  |

- Problem lists (ORQQPL*)| VEHU,TEN         | 10VEHU      | QXYG\~011   | 123456      | Demo User            |

- Medications (ORWPS*)| PHARMACIST,EIGHT | PHA1234     | PHA1234!!   | 123456      | Pharmacy             |

- Orders (ORW*DX*)| LABTECH,ELEVEN   | LABT11      | LABT11!!    | 123456      | Laboratory           |

- Clinical notes (TIU*)

- Labs, vitals, reminders, templates> ⚠️ **Note**: These are demonstration credentials for training purposes only.

- Parameter and return value specifications

## Configuration

### 3. **UI-ARCHITECTURE-COMPLETE.md** (~600 lines)

Complete UI architecture analysis:See `CLIENT-CONNECTIVITY.md` for detailed connection setup instructions.

- **279 form files** documented

- Delphi VCL component usage## Troubleshooting

- MDI (Multiple Document Interface) pattern

- Tab-based navigation### Common Issues

- **Java/JavaFX migration strategy** with code examples

- **React/TypeScript migration strategy** with full implementation1. **Connection Timeout**

- Component mapping (Delphi → JavaFX → React)   - Verify firewall allows outbound connections to port 9430

- 9-month migration timeline   - Check that VistA server is running and accessible

   - Test connection: `Test-NetConnection -ComputerName <vista-endpoint> -Port 9430`

### 4. **MASTER-AI-REDESIGN-PROMPT.md** (~1500 lines)

Complete blueprint for modern EHR system:2. **Authentication Failures**

- **React/TypeScript frontend** with full component structure   - Verify username format (LASTNAME,FIRSTNAME)

- **Node.js microservices** architecture   - Check access code and verify code (case-sensitive)

- **PostgreSQL database** schema (production-ready)   - Ensure e-signature is 6 digits

- **AI integration** (OpenAI GPT-4, clinical assistant, auto-summarization)

- **Kubernetes deployment** configs3. **RPC Broker Not Responding**

- **Security implementation** (OAuth 2.0, HIPAA compliance)   - Check VistA server logs

- **Migration strategy** from legacy VistA   - Verify RPC Broker service is running on VistA server

- **Cost estimation** ($3-5M project)   - Confirm port 9430 is exposed and accessible

- **18-24 month timeline**

- Complete code examples for every component## Development & Source Code



### 5. **SOURCE-CODE-INFO.md****For Native Windows Development** (recommended):

Source code organization and download info- See `NATIVE-WINDOWS-DEV.md` - Complete guide for building CPRS from source on Windows

- Quick start: `.\scripts\setup-native-dev.ps1 -DownloadSource -Configure`

---

**For Docker Development**:

## 🏗️ Understanding CPRS Architecture- See `DEVELOPMENT.md` - Docker-based development options (Windows/Wine containers)



### Core Technologies (Legacy)## Resources

- **Language**: Delphi/Object Pascal (Borland Delphi 7-10)

- **UI Framework**: VCL (Visual Component Library)- [VistaVehuAzure Repository](https://github.com/frasod/VistaVehuAzure)

- **Architecture**: MDI (Multiple Document Interface)- [WorldVistA Docker Hub](https://hub.docker.com/r/worldvista/vehu)

- **Communication**: Custom RPC Broker (XWB protocol)- [WorldVistA EHR Downloads](http://sourceforge.net/projects/worldvista-ehr/)

- **Server**: VistA MUMPS database (GT.M or Caché)- [OSEHRA VistA-M Repository](https://github.com/OSEHRA/VistA-M) - VistA source code

- **Deployment**: Windows desktop application

## License

### Key Components

CPRS and VistA are public domain software developed by the U.S. Department of Veterans Affairs.

#### 1. **RPC Broker** (`packages/Broker/TRPCB.pas`)
- Custom TCP protocol for VistA communication
- XWB handshake: `[XWB]10304\nTCPConnect50075<EOT>`
- Synchronous RPC calls
- cipher.txt for encryption
- Parameter types: literal, reference, list, global

#### 2. **RPC Wrappers** (33 `r*.pas` files)
Each file wraps specific VistA RPCs:
- `rCore.pas` - Core user/system RPCs
- `rOrders.pas` - Order entry/management
- `rTIU.pas` - Clinical notes (TIU package)
- `rMeds.pas` - Medication orders
- `rProbs.pas` - Problem list
- `rConsults.pas` - Consult orders
- `rReports.pas` - Lab/radiology reports

#### 3. **UI Forms** (279 `f*.pas` files)
Main clinical tabs:
- `fFrame.pas` - Main MDI frame (6680 lines)
- `fCover.pas` - Cover sheet
- `fProbs.pas` - Problem list
- `fMeds.pas` - Medications
- `fOrders.pas` - Orders
- `fNotes.pas` - Clinical notes
- `fConsults.pas` - Consults
- `fDCSumm.pas` - Discharge summaries
- `fLabs.pas` - Lab results
- `fReports.pas` - Reports

---

## 🔍 How to Use This Repository

### For Learning EHR Architecture
1. Start with `CPRS-ARCHITECTURE-ANALYSIS.md` to understand overall design
2. Review `COMPLETE-RPC-MAPPING.md` to see how clinical functions map to APIs
3. Study `UI-ARCHITECTURE-COMPLETE.md` for UI patterns and workflows
4. Examine source code in `src/` to see implementation details

### For Building a New EHR
1. Read `MASTER-AI-REDESIGN-PROMPT.md` for complete modern architecture
2. Reference RPC mappings to understand required APIs
3. Use UI documentation to plan user workflows
4. Avoid legacy mistakes (synchronous RPCs, MDI interface, proprietary protocols)

### For Migration Projects
1. Map your existing RPCs using `COMPLETE-RPC-MAPPING.md` as template
2. Follow migration strategy in `MASTER-AI-REDESIGN-PROMPT.md`
3. Use parallel systems approach (read from legacy, write to both)
4. Plan 18-24 month timeline for complete cutover

### For Academic Research
1. Study the evolution from 1990s to modern architecture
2. Analyze RPC protocol design decisions
3. Compare MDI vs modern SPA patterns
4. Research healthcare-specific UI/UX requirements

---

## 🧠 Key Lessons from CPRS

### What Worked Well ✅
- **Modular RPC design** - Clear separation of concerns
- **Clinical workflows** - Proven patterns for EHR operations
- **Comprehensive features** - Everything needed for patient care
- **Long-term stability** - Used by VA for 25+ years

### What Didn't Work ❌
- **Proprietary XWB protocol** - Should have used standard HTTP/REST
- **Synchronous RPCs** - Causes UI freezing, poor performance
- **MDI interface** - Outdated, not web-compatible
- **Delphi VCL** - Platform lock-in, no mobile support
- **No API gateway** - Direct RPC calls, no caching/load balancing

### What's Underrated ⭐
- **MUMPS/YottaDB** - Despite reputation, VistA's database (now open-source YottaDB) has proven exceptionally reliable
  - **Zero data loss** - Legendary ACID compliance and crash recovery
  - **High performance** - Handles massive transaction volumes at VA scale
  - **Battle-tested** - 40+ years in production healthcare environments
  - **Modern implementation** - YottaDB (GPL) continues active development
  - Note: Not "bad," just different - hierarchical NoSQL predating modern databases

### Modern Improvements 🚀
- **REST/GraphQL APIs** - Standard protocols, language-agnostic
- **Async/await** - Non-blocking operations
- **React SPA** - Modern, responsive, mobile-ready
- **Microservices** - Scalable, maintainable, cloud-native
- **PostgreSQL or YottaDB** - Choose SQL (familiarity) or keep YottaDB (proven reliability)
- **AI integration** - Clinical decision support, automation

---

## 💡 Use Cases

### 1. **EHR Startups**
Use this as reference architecture for building modern EHR systems. Learn from 25 years of VA clinical experience.

### 2. **Healthcare IT Consultants**
Understand legacy EHR architecture to advise on modernization strategies.

### 3. **University Projects**
Study real-world enterprise healthcare software for CS/health informatics courses.

### 4. **Open Source EHR Projects**
Reference clinical workflows and feature requirements from proven system.

### 5. **VistA Modernization**
If modernizing VistA installations, use documentation and migration strategies.

### 6. **Competitive Analysis**
Compare CPRS architecture to Epic, Cerner, Allscripts, etc.

---

## 📊 Project Statistics

- **Total Source Files**: 598 Delphi files
- **Total Lines of Code**: ~500,000 lines (estimated)
- **RPC Endpoints**: 600+ documented
- **UI Forms**: 279 forms
- **Layout Files**: 696 .dfm files
- **RPC Wrapper Files**: 33 files
- **Main Project**: CPRSChart.dpr
- **Core Broker**: TRPCB.pas (2,423 lines)
- **Core RPC Functions**: ORNet.pas (1,238 lines)
- **Main Application Frame**: fFrame.pas (6,680 lines)

---

## 🎓 Learning Path

**Beginner (Week 1-2)**
1. Read README (this file)
2. Review CPRS-ARCHITECTURE-ANALYSIS.md
3. Skim COMPLETE-RPC-MAPPING.md
4. Look at main files: CPRSChart.dpr, fFrame.pas

**Intermediate (Week 3-4)**
1. Study specific RPC wrapper file (e.g., rCore.pas)
2. Analyze one UI form (e.g., fProbs.pas for problem list)
3. Trace RPC call flow from UI → ORNet → Broker → VistA
4. Review UI-ARCHITECTURE-COMPLETE.md migration strategies

**Advanced (Month 2-3)**
1. Study MASTER-AI-REDESIGN-PROMPT.md in detail
2. Design modern API for specific clinical domain
3. Prototype React component for one CPRS tab
4. Build Node.js microservice with VistA adapter

**Expert (Month 4+)**
1. Plan complete EHR modernization project
2. Design AI-powered clinical workflows
3. Implement prototype with modern stack
4. Contribute improvements back to community

---

## 🤝 Contributing

This is an **analysis/reference project**, not active development. However, contributions welcome:

- **Documentation improvements** - Clarify architecture explanations
- **Additional analysis** - Deep dives into specific modules
- **Modern examples** - React/Node.js equivalents of CPRS features
- **Migration guides** - Practical steps for modernization
- **Case studies** - Real-world usage of this documentation

---

## ⚖️ Legal & Licensing

- **CPRS Source Code**: Public domain (US Government work)
- **VistA**: Public domain (US Department of Veterans Affairs)
- **Documentation**: Created for educational/research purposes
- **No Warranty**: Use at your own risk for reference only

**This software is NOT certified for clinical use. Do not use in production patient care.**

---

## 🔗 Related Resources

### Official WorldVistA Resources
- **📚 EHR Education Curriculum**: https://education.worldvista.org/sample-ehr-curriculum.html  
  *Comprehensive training materials for VistA/CPRS - tutorials, documentation, and learning paths*

- **🐳 Docker Hub**: https://hub.docker.com/u/worldvista  
  *Pre-built VistA Docker containers for quick deployment and testing*

- **📦 SourceForge Downloads**: https://sourceforge.net/projects/worldvista-ehr/files/  
  *Official WorldVistA EHR releases, installers, and binary distributions*

- **💻 GitHub Repository**: https://github.com/WorldVistA/VistA  
  *Complete VistA source code - CPRS client, server packages, and MUMPS routines*

### Modern VistA Implementation
- **🚀 ModernVistA**: https://github.com/frasod/ModernVistA  
  *Contemporary Azure-based VistA deployment with Docker, automated setup, and cloud-native architecture*

### Additional Resources
- **VistA.org**: VistA community portal and documentation
- **OSEHRA**: Open Source Electronic Health Record Alliance (https://www.osehra.org)
- **VA GitHub**: Official VA open source projects (https://github.com/department-of-veterans-affairs)
- **FHIR.org**: Modern healthcare interoperability standard
- **HL7.org**: Healthcare standards organization

### Checking for Source Code Updates

**Automated Update Checker Scripts:**

Run these scripts to check if new CPRS source code has been released from WorldVistA:

**For Windows PowerShell:**
```powershell
.\check-for-updates.ps1
```

**For Bash/Git Bash:**
```bash
./check-for-updates.sh
```

**What the scripts do:**
- ✅ Fetch latest releases and commits from WorldVistA GitHub
- ✅ Compare with your local source code
- ✅ Show exactly what files changed
- ✅ Tell you how many commits behind you are
- ✅ Provide update commands to pull latest changes

**Output includes:**
- Latest 10 commits with dates and messages
- Your current commit and date
- Number of commits you're behind
- List of modified/added/deleted files
- Instructions to update your local copy

---

## 📞 Questions?

This is a **reference repository** for understanding EHR architecture. For questions about:

- **VistA deployment**: Contact OSEHRA or WorldVistA community
- **Modern EHR development**: Reference MASTER-AI-REDESIGN-PROMPT.md
- **Clinical workflows**: Study CPRS-ARCHITECTURE-ANALYSIS.md
- **Code questions**: Read source files in `src/` directory

---

## 🎯 Project Goal

**Enable the next generation of EHR developers to learn from 25+ years of VA clinical software experience, avoid legacy mistakes, and build modern, AI-powered healthcare systems that improve patient care.**

---

**Last Updated**: November 2, 2025  
**Repository Type**: Source Code Analysis & Reference  
**Status**: Documentation Complete  
**Maintained By**: Community contributions welcome

---

*"Standing on the shoulders of giants - learning from CPRS to build better healthcare software."*
