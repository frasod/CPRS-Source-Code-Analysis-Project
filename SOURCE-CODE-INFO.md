# CPRS Source Code - Downloaded Successfully ✅

## Source Information
- **Repository**: https://github.com/WorldVistA/VistA
- **Path in Repo**: `Packages/Order Entry Results Reporting/CPRS/CPRS-Chart/`
- **Download Date**: November 2, 2025
- **Local Location**: `c:\DEV\CPRS\src\`

## Statistics
- **Total Delphi Files**: 598 (`.dpr` and `.pas` files)
- **Total Size**: ~60 MB
- **Main Project File**: `CPRSChart.dpr`

## Directory Structure
```
src/
├── CPRSChart.dpr           # Main Delphi project file
├── CPRSChart.dproj         # Delphi project configuration
├── borlndmm.dll            # Borland Memory Manager DLL
├── BA/                     # Behavioral Analysis
├── Consults/               # Consults functionality
├── Cover Sheet/            # Cover sheet components
├── Encounter/              # Encounter components
├── Extras/                 # Extra features (PDMP, DST)
├── Orders/                 # Orders functionality
├── Templates/              # Template system
├── Vitals/                 # Vitals components
├── packages/               # Component packages
│   ├── Broker/            # RPC Broker components
│   ├── FilemanComponents/ # FileMan integration
│   ├── OR/                # Order Entry/Results Reporting
│   ├── CopyPaste/         # Copy/Paste functionality
│   ├── PKI/               # Public Key Infrastructure
│   └── 508/               # Section 508 accessibility
└── f*.pas, r*.pas, u*.pas # Forms, RPC calls, and utility units
```

## Key Components

### Core Files
- `CPRSChart.dpr` - Main application entry point
- `fFrame.pas` - Main application frame
- `uCore.pas` - Core utilities and functions
- `rCore.pas` - Core RPC broker calls

### Connection Components
- `packages/Broker/Source/` - RPC Broker components for VistA communication
- `ORNet.pas` - Network connection handling
- `TRPCB.pas` - RPC Broker component

### Major Functional Areas
- **Orders** (`Orders/` folder) - Order entry, display, and management
- **Notes** (`fNotes.pas`, `rTIU.pas`) - Clinical notes and documentation
- **Labs** (`fLabs.pas`, `rLabs.pas`) - Lab results
- **Meds** (`fMeds.pas`, `rMeds.pas`) - Medication orders and management
- **Problems** (`fProbs.pas`, `rProbs.pas`) - Problem list
- **Consults** (`Consults/` folder) - Consultation management
- **Vitals** (`Vitals/` folder) - Vital signs

## Build Information

### Required Delphi Version
CPRS is built with **Delphi XE** (or newer). Check `CPRSChart.dproj` for specific version.

### Required Libraries
- **RPC Broker Components** (included in `packages/Broker/`)
- **FileMan Components** (included in `packages/FilemanComponents/`)
- **Section 508 Components** (included in `packages/508/`)
- **borlndmm.dll** - Borland Memory Manager (included)

### Build Paths
You'll need to add these to Delphi's library path:
- `src/packages/Broker/Source/`
- `src/packages/OR/Source/`
- `src/packages/FilemanComponents/Source/`
- `src/packages/508/Source/`
- `src/packages/CopyPaste/Source/`
- `src/packages/PKI/Source/`
- `src/BA/`
- `src/Consults/`
- `src/Cover Sheet/`
- `src/Encounter/`
- `src/Orders/`
- `src/Templates/`
- `src/Vitals/`

## Existing Build (Preserved)
The pre-built CPRS executable and files remain intact in:
- **Location**: `c:\DEV\CPRS\build\`
- **Executable**: `CPRSChart.exe` (version 1.32.114.1)
- **cipher.txt**: Present and configured
- **Status**: Ready to use once VistA server RPC Broker is fixed

## Next Steps for Development

### 1. Install Delphi
You'll need Delphi XE or newer to build this source code.

### 2. Open Project
Open `c:\DEV\CPRS\src\CPRSChart.dproj` in Delphi IDE.

### 3. Configure Library Paths
Add all the package source directories (listed above) to your Delphi library path.

### 4. Build Packages First
Before building CPRSChart.dpr, build these packages in order:
1. Broker package
2. FilemanComponents package
3. OR package
4. Other component packages (508, CopyPaste, PKI)

### 5. Build Application
Once packages are installed, build CPRSChart.dpr.

### 6. Test Connection
When VistA server RPC Broker is fixed, test your custom build against:
- **Server**: vista-demo-frasod-237.eastus.azurecontainer.io:9430
- **Credentials**: PROGRAMMER,ONE / PRO1234 / PRO1234!!

## Documentation References
- **VistA Admin Issue**: See `VISTA-ADMIN-ISSUE-REPORT.md` for current server-side connection issue
- **Connection Setup**: See `CONNECTION-LOG.md` for client configuration details
- **Quick Start**: See `QUICK-START.md` for running the pre-built executable

## Notes
- Source code matches the executable version (1.32.114.1) available in the `build/` folder
- cipher.txt from the frasod/VistaVehuAzure repo is already configured in `build/`
- RPC Broker connection issue is server-side, not related to CPRS code
- All client-side configuration is complete and working

---
*Source downloaded from WorldVistA/VistA repository on November 2, 2025*
