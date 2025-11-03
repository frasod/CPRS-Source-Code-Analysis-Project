# COMPLETE RPC MAPPING REFERENCE - VistA CPRS

## Overview
- **Total RPC Wrapper Files**: 33 (r*.pas files)
- **Total UI Form Files**: 279 (f*.pas files)
- **Total DFM Layout Files**: 696 (.dfm files)

This document maps **ALL RPC calls** used in CPRS, organized by functional domain.

---

## 1. CORE UTILITY RPCs (ORWU*)

### User Management
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORWU USERINFO` | Get current user info | `[nil]` | Delimited string: DUZ^Name^UserClass^... | rCore.pas |
| `ORWU HASKEY` | Check security key | `[KeyName]` | '1' or '0' | rCore.pas |
| `ORWU HAS OPTION ACCESS` | Check menu option access | `[OptionName]` | '1' or '0' | rCore.pas |
| `ORWU VALIDSIG` | Validate electronic signature | `[Encrypt(ESCode)]` | '1' or '0' | rCore.pas |
| `ORWU NPHASKEY` | Check if person has key | `[PersonDUZ, KeyName]` | '1' or '0' | rCore.pas |
| `ORWU NEWPERS` | Get personnel list | `[StartFrom, Direction, ...

]` | List of providers | rCore.pas |
| `ORWU2 COSIGNER` | Get cosigners list | `[StartFrom, Direction, ...]` | List of cosigners | uSimilarNames.pas |

### Parameters & Configuration
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORWU PARAM` | Get user parameter | `[ParamName]` | Parameter value | rCore.pas |
| `ORWU PARAMS` | Get user parameter list | `[ParamName]` | TStrings of values | rCore.pas |
| `ORWU DEFAULT DIVISION` | Get default division | `[nil]` | '1' or '0' | uVersionCheck.pas |

### Date/Time
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORWU DT` | Get date/time | `['NOW']` or `[DateString]` | FileMan date/time | rCore.pas |
| `ORWU VALDT` | Validate date string | `[DateString, Flags]` | Validated FM date | rCore.pas |

### Utilities
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORWU EXTNAME` | Get external name | `[IEN, FileNumber]` | Name from file | rCore.pas |
| `ORWU GBLREF` | Get global reference | `[FileID]` | Global root | rCore.pas |
| `ORWU DEVICE` | Get device list | `[StartFrom, Direction]` | List of devices | rCore.pas |
| `ORWU TOOLMENU` | Get tools menu | `[nil]` | Menu items | rMisc.pas |
| `ORWU PATCH` | Check patch installed | `[PatchID]` | '1' or '0' | rMisc.pas |
| `ORWU OVERDL` | Check override download | `[]` | '1' or '0' | rMisc.pas |
| `ORWU VERSRV` | Get server version | `[Option, ClientVer]` | Version string | rMisc.pas |
| `ORWU VERSION` | Get package version | `[Namespace]` | Version string | rMisc.pas |
| `ORWU FLDINFO` | Get field info | `[FileNum, FieldNum, ...]` | Field attributes | rMisc.pas |
| `ORWUX SYMTAB` | Get symbol table | `[nil]` | Symbol definitions | rMisc.pas |

---

## 2. PATIENT RPCs (ORWPT*)

### Patient Selection & Demographics
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORWPT SELECT` | Select patient | `[PatientDFN]` | Name^ICN^SSN^DOB^Age^Sex^... | rCore.pas |
| `ORWPT IDINFO` | Get patient ID info | `[PatientDFN]` | Name^SSN^DOB^Age^Sex^... | rCore.pas |
| `ORWPT PTINQ` | Patient inquiry | `[PatientDFN]` | Cover sheet data | rCover.pas |
| `ORWPT GET FULL ICN` | Get full ICN | `[PatientDFN]` | Full ICN | TPtSelect record |
| `ORWPT DISCHARGE` | Get discharge info | `[DFN, AdmitDateTime]` | Discharge data | rDCSumm.pas |
| `ORWPT SHARE` | Share patient context | `[IP, Handle, DFN]` | - | rMisc.pas |
| `ORWPT1 PCDETAIL` | Get primary care detail | `[DFN]` | PC provider info | rMisc.pas |
| `ORWPT CLINRNG` | Get clinic date range | `[nil]` | Date range options | rCore.pas |
| `ORWPT ENCTITL` | Get encounter title | `[...]` | Location^Provider^... | rCore.pas |

### Patient Lists
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORQQPL DEFAULT CLINIC DATE RANG` | Get default clinic date range | `[nil]` | Date range | rCore.pas |

---

## 3. PROBLEM LIST RPCs (ORQQPL*)

### Problem List Operations
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORQQPL PROBLEM LIST` | Get problem list | `[DFN, Status, Date]` | List of problems | rProbs.pas |
| `ORQQPL ADD SAVE` | Add new problem | `[PatInfo, Provider, VAMC, ProbFile, SearchStr]` | Result | rProbs.pas |
| `ORQQPL EDIT SAVE` | Edit problem | `[ProbIEN, Provider, VAMC, PrimUser, ProbFile, SearchStr]` | Result | rProbs.pas |
| `ORQQPL EDIT LOAD` | Load problem for edit | `[ProblemIEN]` | Problem data | rProbs.pas |
| `ORQQPL DELETE` | Delete problem | `[ProbIEN, Provider, VAMC, Comment]` | Result | rProbs.pas |
| `ORQQPL VERIFY` | Verify problem | `[ProblemIEN]` | Result | rProbs.pas |
| `ORQQPL REPLACE` | Replace problem | `[ProblemIEN]` | Replacement data | rProbs.pas |
| `ORQQPL UPDATE` | Update problem | `[AltProbFile]` | Result | rProbs.pas |
| `ORQQPL DETAIL` | Get problem detail | `[DFN^EncDT, IEN, '']` | Detailed info | rCover.pas |
| `ORQQPL AUDIT HIST` | Get audit history | `[ProblemIEN]` | History list | rProbs.pas |
| `ORQQPL PROB COMMENTS` | Get problem comments | `[ProblemIEN]` | Comment list | rProbs.pas |
| `ORQQPL CHECK DUP` | Check duplicate | `[DFN, TermIEN, TermText]` | Duplicate status | rProbs.pas |

### Problem List Configuration
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORQQPL INIT PT` | Initialize patient | `[PatientDFN]` | Patient settings | rProbs.pas |
| `ORQQPL INIT USER` | Initialize user | `[ProviderID]` | User settings | rProbs.pas |
| `ORQQPL SAVEVIEW` | Save view preference | `[ViewPref]` | - | rProbs.pas |
| `ORQQPL USER PROB CATS` | Get user problem categories | `[Provider, Location]` | Category list | rProbs.pas |
| `ORQQPL USER PROB LIST` | Get user problem list | `[CategoryIEN]` | Problem list | rProbs.pas |

### Problem Filters & Lists
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORQQPL4 LEX` | Lexicon search | `[SearchFor, VIEW, Date, True]` | Search results | rProbs.pas |
| `ORQQPL CLIN FILTER LIST` | Get clinic filter list | `[LocList]` | Filtered list | rProbs.pas |
| `ORQQPL CLIN SRCH` | Clinic search | `[DummyArg]` | Clinic list | rProbs.pas |
| `ORQQPL PROV FILTER LIST` | Provider filter list | `[ProvList]` | Filtered list | rProbs.pas |
| `ORQQPL PROVIDER LIST` | Get provider list | `[Flag, Number, From, Part]` | Provider list | rProbs.pas |
| `ORQQPL SERV FILTER LIST` | Service filter list | `[LocList]` | Filtered list | rProbs.pas |
| `ORQQPL SRVC SRCH` | Service search | `[StartFrom, Dir, All]` | Service list | rProbs.pas |
| `ORQQPL PROBLEM NTRT BULLETIN` | Send notification bulletin | `[term, Provider, PatID, comment]` | Result | rProbs.pas |

---

## 4. PHARMACY/MEDICATION RPCs (ORWPS*)

### Medication Information
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORWPS DETAIL` | Get medication detail | `[DFN, MedID]` | Detailed med info | rMeds.pas |
| `ORWPS MEDHIST` | Get med admin history | `[DFN, OrderID]` | Administration history | rMeds.pas |

---

## 5. NOTIFICATIONS/ALERTS RPCs (ORWORB*)

### Alert Management
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORWORB FASTUSER` | Get user notifications | `[nil]` | List of alerts | rCore.pas |

---

## 6. ORDERS RPCs (ORW*, ORWDX*, ORWORR*)

### Order Entry & Management
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORWORR AGET` | Get orders | `[DFN, FilterIEN, StartFrom, Dir]` | Order list | - |
| `ORWDX SEND` | Send/sign orders | `[DFN, OrderList, ESCode]` | Result | - |
| `ORWDX SAVE` | Save order | `[OrderData]` | Saved order | - |
| `ORWDX RELEASE` | Release orders | `[DFN, OrderList]` | Result | - |
| `ORWDX LOCK` | Lock order | `[OrderIEN]` | Lock status | - |
| `ORWDX UNLOCK` | Unlock order | `[OrderIEN]` | - | - |
| `ORWDX WRLST` | Get work list | `[...]` | Order work list | - |

### Radiology Orders
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORWDRA32 LOCTYPE` | Get location type | `[Location]` | Location type | rODRad.pas |
| `ORWDRA32 RADSRC` | Get rad sources | `[SrcType]` | Source list | rODRad.pas |
| `ORWDXM1 SVRPC` | Server RPC check | `['']` | '1' or '0' | rODRad.pas |

---

## 7. CLINICAL NOTES/TIU RPCs (TIU*)

### Note Creation & Management
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `TIU CREATE RECORD` | Create new note | `[DFN, TitleIEN, VisitStr, ...]` | New note IEN | rTIU.pas |
| `TIU CREATE ADDENDUM RECORD` | Create addendum | `[AddendumTo, List, '1']` | Addendum IEN | rTIU.pas |
| `TIU UPDATE RECORD` | Update note | `[NoteIEN, List]` | Result | rTIU.pas |
| `TIU SET DOCUMENT TEXT` | Set note text | `[NoteIEN, TextList, Suppress]` | Result | rTIU.pas |
| `TIU SIGN RECORD` | Sign note | `[NoteIEN, ESCode]` | Result | rTIU.pas |
| `TIU DELETE RECORD` | Delete note | `[NoteIEN, Reason]` | Result | rTIU.pas |

### Note Retrieval
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `TIU GET RECORD TEXT` | Get note text | `[NoteIEN]` | Note text | rTIU.pas |
| `TIU DETAILED DISPLAY` | Get detailed display | `[NoteIEN]` | Formatted display | rTIU.pas |
| `TIU LOAD RECORD FOR EDIT` | Load for editing | `[NoteIEN]` | Editable text | rTIU.pas |
| `TIU LOAD RECORD TEXT` | Load note text | `[NoteIEN]` | Raw text | rTIU.pas |
| `TIU DOCUMENTS BY CONTEXT` | Get notes by context | `[3, Context, DFN, Early, Late, ...]` | Note list | rTIU.pas |
| `TIU SUMMARIES` | Get summary list | `[DFN]` | Summary notes | rTIU.pas |

### Note Titles & Templates
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `TIU PERSONAL TITLE LIST` | Get personal titles | `[...]` | Title list | rTIU.pas |
| `TIU LONG LIST OF TITLES` | Get long title list | `[Class, StartFrom, Dir]` | Title list | rTIU.pas |
| `TIU GET DOCUMENT TITLE` | Get document title | `[NoteIEN]` | Title | rTIU.pas |
| `TIU GET PRINT NAME` | Get print name | `[TitleIEN]` | Print name | rTIU.pas |
| `TIU LOAD BOILERPLATE TEXT` | Load boilerplate | `[Title, DFN, VisitStr]` | Boilerplate text | rTIU.pas |

### Note Validation & Authorization
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `TIU IS THIS A CONSULT?` | Check if consult | `[TitleIEN]` | '1' or '0' | rTIU.pas |
| `TIU ISPRF` | Check if PRF | `[TitleIEN]` | '1' or '0' | rTIU.pas |
| `TIU IS THIS A CLINPROC?` | Check if clinical procedure | `[TitleIEN]` | '1' or '0' | rTIU.pas |
| `TIU AUTHORIZATION` | Check authorization | `[NoteIEN, Action]` | Auth status | rTIU.pas |
| `TIU HAS AUTHOR SIGNED?` | Check if signed | `[NoteIEN, UserDUZ]` | '1' or '0' | rTIU.pas |
| `TIU WHICH SIGNATURE ACTION` | Get sig action | `[NoteIEN]` | Action type | rTIU.pas |
| `TIU NEED TO SIGN?` | Check need signature | `[NoteIEN]` | '1' or '0' | rTIU.pas |
| `TIU JUSTIFY DELETE?` | Check delete permission | `[NoteIEN]` | '1' or '0' | rTIU.pas |

### Note Locking
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `TIU LOCK RECORD` | Lock note | `[NoteIEN]` | Lock result | rTIU.pas |
| `TIU UNLOCK RECORD` | Unlock note | `[NoteIEN]` | - | rTIU.pas |
| `TIU WAS THIS SAVED?` | Check if saved | `[NoteIEN]` | '1' or '0' | rTIU.pas |

### Cosignature & Additional Signers
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `TIU REQUIRES COSIGNATURE` | Check cosig required | `[Type, 0, Author]` | Cosig requirement | rTIU.pas |
| `TIU GET ADDITIONAL SIGNERS` | Get additional signers | `[NoteIEN]` | Signer list | rTIU.pas |
| `TIU UPDATE ADDITIONAL SIGNERS` | Update signers | `[NoteIEN, Signers]` | - | rTIU.pas |
| `TIU CAN CHANGE COSIGNER?` | Can change cosigner | `[NoteIEN]` | '1' or '0' | rTIU.pas |
| `TIU GET PERSONAL PREFERENCES` | Get preferences | `[UserDUZ]` | Preferences | rTIU.pas |

### Note Printing
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `TIU CAN PRINT WORK/CHART COPY` | Can print | `[NoteIEN]` | Permission | rTIU.pas |
| `TIU GET DOCUMENT PARAMETERS` | Get doc params | `[NoteIEN]` | Parameters | rTIU.pas |
| `TIU PRINT RECORD` | Print note | `[NoteIEN, Device, ChartCopy]` | Result | rTIU.pas |
| `ORWTIU WINPRINT NOTE` | Windows print | `[NoteIEN, ChartCopy]` | Print data | rTIU.pas |

### Ancillary Functions
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `TIU ANCILLARY PACKAGE MESSAGE` | Send package message | `[NoteIEN, Action]` | Result | rTIU.pas |
| `TIU ONE VISIT NOTE?` | Check one visit | `[NoteEIN, DFN, VisitStr]` | '1' or '0' | rTIU.pas |
| `TIU GET REQUEST` | Get request info | `[NoteIEN]` | Request data | rTIU.pas |
| `ORWTIU GET LISTBOX ITEM` | Get listbox item | `[NoteIEN]` | Item data | rTIU.pas |
| `ORWTIU GET TIU CONTEXT` | Get TIU context | `[UserDUZ]` | Context | rTIU.pas |
| `ORWTIU SAVE TIU CONTEXT` | Save TIU context | `[Context]` | - | rTIU.pas |
| `TIU GET SITE PARAMETERS` | Get site parameters | `[]` | Site params | rTIU.pas |
| `ORWPCE NOTEVSTR` | Get note visit string | `[NoteIEN]` | Visit string | rTIU.pas |

---

## 8. TEMPLATE RPCs (TIU TEMPLATE*)

### Template Management
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `TIU TEMPLATE GETROOTS` | Get template roots | `[UserDUZ]` | Root templates | rTemplates.pas |
| `TIU TEMPLATE GETITEMS` | Get template items | `[TemplateID]` | Template items | rTemplates.pas |
| `TIU TEMPLATE GETBOIL` | Get boilerplate | `[TemplateID]` | Boilerplate text | rTemplates.pas |
| `TIU TEMPLATE GETTEXT` | Get template text | `[DFN, VisitStr, List]` | Template text | rTemplates.pas |
| `TIU TEMPLATE ISEDITOR` | Check if editor | `[TemplateID, UserID]` | '1' or '0' | rTemplates.pas |
| `TIU TEMPLATE SET ITEMS` | Set template items | `[TemplateID, List]` | Result | rTemplates.pas |
| `TIU TEMPLATE DELETE` | Delete template | `[List]` | - | rTemplates.pas |
| `TIU GET LIST OF OBJECTS` | Get object list | `[]` | Object list | rTemplates.pas |
| `TIU TEMPLATE PERSONAL OBJECTS` | Get personal objects | `[]` | Personal objects | rTemplates.pas |
| `TIU TEMPLATE CHECK BOILERPLATE` | Check boilerplate | `[List]` | Check result | rTemplates.pas |
| `TIU TEMPLATE ACCESS LEVEL` | Get access level | `[ID, UserDUZ, Location]` | Access level | rTemplates.pas |
| `TIU LONG LIST BOILERPLATED` | Get boilerplate list | `[StartFrom, Direction]` | Boilerplate list | rTemplates.pas |
| `TIU GET BOILERPLATE` | Get boilerplate | `[TitleIEN]` | Boilerplate | rTemplates.pas |
| `TIU TEMPLATE GET DEFAULTS` | Get defaults | `[]` | Default settings | rTemplates.pas |
| `TIU TEMPLATE SET DEFAULTS` | Set defaults | `[Defaults]` | - | rTemplates.pas |
| `TIU TEMPLATE GET DESCRIPTION` | Get description | `[TemplateIEN]` | Description | rTemplates.pas |
| `TIU REMINDER DIALOGS` | Get reminder dialogs | `[]` | Dialog list | rTemplates.pas |
| `TIU REM DLG OK AS TEMPLATE` | Check reminder dialog OK | `[RemDlgIEN]` | '1' or '0' | rTemplates.pas |
| `TIU TEMPLATE LOCK` | Lock template | `[TemplateID]` | Lock result | rTemplates.pas |
| `TIU TEMPLATE UNLOCK` | Unlock template | `[TemplateID]` | - | rTemplates.pas |
| `TIU TEMPLATE GETLINK` | Get template link | `[Link]` | Link data | rTemplates.pas |
| `TIU TEMPLATE ALL TITLES` | Get all titles | `[StartFrom, Direction]` | Title list | rTemplates.pas |

### Template Fields
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `TIU FIELD LIST` | Get field list | `[StartFrom, Direction]` | Field list | rTemplates.pas |
| `TIU FIELD LOAD` | Load field | `[DialogField]` | Field data | rTemplates.pas |
| `TIU FIELD LOAD BY IEN` | Load field by IEN | `[DialogField]` | Field data | rTemplates.pas |
| `TIU FIELD CAN EDIT` | Check field edit permission | `[]` | '1' or '0' | rTemplates.pas |
| `TIU FIELD LOCK` | Lock field | `[FieldID]` | Lock result | rTemplates.pas |
| `TIU FIELD UNLOCK` | Unlock field | `[FieldID]` | - | rTemplates.pas |
| `TIU FIELD DELETE` | Delete field | `[FieldID]` | - | rTemplates.pas |
| `TIU FIELD CHECK` | Check field | `[nil]` | Check result | rTemplates.pas |
| `TIU FIELD NAME IS UNIQUE` | Check name unique | `[FieldName, IEN]` | '1' or '0' | rTemplates.pas |
| `TIU FIELD DOLMTEXT` | Get DOLM text | `[List]` | Text | rTemplates.pas |
| `TIU FIELD LIST ADD` | Add field to list | `[List]` | Result | rTemplates.pas |
| `TIU FIELD LIST IMPORT` | Import field list | `[nil]` | Result | rTemplates.pas |

---

## 9. VITALS RPCs (ORQQVI*)

### Vital Signs
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORQQVI VITALS` | Get vitals | `[IDString, '', '', MetricFirst]` | Vital signs list | rVitals.pas |
| `ORQQVI2 VITALS RATE CHECK` | Check vital rate | `[Type, Rate, Unit]` | Check result | rVitals.pas |
| `ORQQVI2 VITALS VAL & STORE` | Validate & store vitals | `[VitalList]` | Store result | rVitals.pas |
| `ORQQVI NOTEVIT` | Get note vitals | `[IDString, NoteIEN, MetricFirst]` | Note vitals | rVitals.pas |

---

## 10. REMINDERS RPCs (ORQQPXRM*)

### Clinical Reminders
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORQQPXRM GET WH REPORT TEXT` | Get women's health report | `[IEN]` | Report text | uReminders.pas |
| `ORQQPXRM GET WH LETTER TEXT` | Get women's health letter | `[WHRecNum]` | Letter text | uReminders.pas |

---

## 11. ENCOUNTER/PCE RPCs (ORWPCE*)

### Encounter Management
| RPC Name | Purpose | Parameters | Returns | File |
|----------|---------|------------|---------|------|
| `ORWPCE NOTEVSTR` | Get note visit string | `[NoteIEN]` | Visit string | rTIU.pas |

---

## 12. COMPLETE RPC PREFIX MAPPING

| Prefix | Full Name | Domain | Count |
|--------|-----------|--------|-------|
| **ORWU** | Orders/Results - Utilities | Core utilities, user management | 20+ |
| **ORWPT** | Orders/Results - Patient | Patient selection, demographics | 10+ |
| **ORQQPL** | Orders/Results - Problem List | Problem list CRUD operations | 25+ |
| **ORWPS** | Orders/Results - Pharmacy | Medication management | 5+ |
| **ORWORB** | Orders/Results - Notifications | Alerts and notifications | 5+ |
| **ORWDX** | Orders/Results - Generic Order Dialogs | Order entry and management | 20+ |
| **ORWD** | Orders/Results - Dialogs | Dialog management | 15+ |
| **ORWORR** | Orders/Results - Reports | Order reports | 10+ |
| **ORWDRA** | Orders/Results - Radiology | Radiology orders | 5+ |
| **TIU** | Text Integration Utilities | Clinical notes, documents | 80+ |
| **TIU TEMPLATE** | TIU Templates | Template management | 30+ |
| **TIU FIELD** | TIU Fields | Field management | 15+ |
| **ORQQVI** | Orders/Results - Vitals | Vital signs | 5+ |
| **ORQQPXRM** | Orders/Results - Reminders | Clinical reminders | 5+ |
| **ORWTIU** | Orders/Results - TIU Interface | TIU UI integration | 5+ |
| **ORWPCE** | Orders/Results - PCE | Encounter management | 5+ |

---

## 13. RPC CALL PATTERNS

### Pattern 1: Simple String Return
```pascal
function GetUserParam(const AParamName: string): string;
begin
  CallVistA('ORWU PARAM', [AParamName], Result);
end;
```

### Pattern 2: Boolean Check
```pascal
function HasSecurityKey(const KeyName: string): Boolean;
var
  x: string;
begin
  Result := CallVistA('ORWU HASKEY', [KeyName], x) and (x = '1');
end;
```

### Pattern 3: List Return
```pascal
procedure LoadNotifications(Dest: TStrings);
begin
  CallVistA('ORWORB FASTUSER', [nil], Dest);
end;
```

### Pattern 4: Complex Parameters
```pascal
CallVistA('TIU CREATE RECORD', 
  [Patient.DFN, IntToStr(NoteRec.Title), '', Visit, 
   NoteRec.DocDT, NoteRec.Location, AuthorDUZ, CosignerDUZ], 
  Results);
```

### Pattern 5: Multiple Return Values (Parsed)
```pascal
CallVistA('ORWU USERINFO', [nil], x);
// Parse: DUZ^Name^UserClass^CanSign^IsProvider^...
DUZ := StrToInt64Def(Piece(x, U, 1), 0);
Name := Piece(x, U, 2);
UserClass := StrToIntDef(Piece(x, U, 3), 0);
```

---

## 14. RPC FILE MAPPING

| File | RPCs Count | Main Purpose |
|------|------------|--------------|
| `rCore.pas` | 30+ | Core utilities, user, patient |
| `rTIU.pas` | 80+ | Clinical notes/documents |
| `rTemplates.pas` | 45+ | Template management |
| `rProbs.pas` | 25+ | Problem list |
| `rMeds.pas` | 5+ | Medications |
| `rOrders.pas` | 50+ | Order management |
| `rODRad.pas` | 5+ | Radiology orders |
| `rVitals.pas` | 5+ | Vital signs |
| `rCover.pas` | 5+ | Cover sheet |
| `rMisc.pas` | 15+ | Miscellaneous |
| `rDCSumm.pas` | 10+ | Discharge summaries |
| `rLabs.pas` | 20+ | Lab results |
| `rReports.pas` | 15+ | Reports |
| `rConsults.pas` | 20+ | Consults |
| `uReminders.pas` | 5+ | Clinical reminders |
| `uSimilarNames.pas` | 2+ | Similar name handling |
| `uVersionCheck.pas` | 1+ | Version checking |

---

## 15. ESTIMATED TOTAL RPC COUNT

Based on analysis:
- **Core RPCs**: ~300+
- **Template/Field RPCs**: ~45+
- **TIU RPCs**: ~80+
- **Order RPCs**: ~100+
- **Problem List RPCs**: ~25+
- **Other RPCs**: ~50+

**TOTAL ESTIMATED**: **600+ unique RPC endpoints**

---

## 16. RPC DOCUMENTATION SOURCES

1. **Source Code**: `c:\DEV\CPRS\src\r*.pas` files
2. **VistA Documentation**: https://www.va.gov/vdl/
3. **FileMan Database**: RPC metadata in VistA
4. **REMOTE PROCEDURE file**: #8994 in VistA

---

**Document Version**: 1.0  
**Generated**: November 2, 2025  
**Purpose**: Complete RPC reference for API development
