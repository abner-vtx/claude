# Form Specification: Management Review Record

**Master SOP:** QP-18 – Management Reviews  
**Form ID:** LS_QP1801r01 *(digital successor to FM QP18.01 Management Review; replaces the Word→PDF report)*  
**Form Title:** Management Review Record  
**SharePoint List:** `LS_QP1801r01_ManagementReview`  
**ISO/IEC 17025:2017 Reference:** Clause 8.9 – Management Reviews (Option A)  
**Document Status:** Draft (new — closes the gap flagged in the Gap Analysis §3.1)  

**Purpose:** To plan, conduct, and record management reviews of the QMS at planned intervals — capturing the **fifteen required inputs** (8.9.2 a–o), the discussion, and the **recorded decisions and actions** (8.9.3), and tracking those actions to closure. Because every input already lives in the dashboard's lists (complaints, NCW, CA, audits, risks, improvements, documents), the review record **pulls live metrics** rather than being re-typed, and its output actions link back to the CA / DCR / Risk / OFI records that execute them. This drives the "Reviews" half of the **Audits & Reviews** tab.

---

## Implementation approach *(CONFIRMED — hybrid model adopted)*

**Decision:** the **hybrid "structured list + generated minutes" model** is adopted for management review. It keeps the familiar signed Word→PDF document while making the review data live and auditable:

1. **Structured SharePoint list (this spec)** captures the 15 inputs and the output actions as data. Inputs auto-populate from the other QMS lists (open/closed NCWs, CA effectiveness, audit findings, complaint trends, risk status, OFI outcomes) via Power Automate/rollups — so the review reflects real numbers, and **8.9.2 traceability is provable**.
2. **Auto-generated minutes** — on finalization, Power Automate merges the list data into your existing **Word management-review template** and saves a **PDF** to the controlled library as the formal, signed minuted record (`MinutesDocRef`). You keep the document you're used to; you stop re-keying data.
3. **Action tracking stays in the system** — every 8.9.3 output action is a child row linked to the CA/DCR/Risk/OFI that implements it, and "status of actions from previous reviews" (8.9.2 d) auto-fills next time.

*Alternatives considered:* (A) **pure document library** (Word/PDF only) — simplest, but inputs/actions aren't queryable and 8.9.2 d must be compiled by hand each cycle; (B) **pure list, no document** — fully live, but you lose the narrative signed minutes assessors and management like to read. The hybrid gets both. This spec is written for the hybrid; it degrades gracefully to (A) if you prefer to keep authoring in Word and only use the list for the input metrics and action tracking.

---

## 1. Data Schema

### 1.1 Parent list — `LS_QP1801r01_ManagementReview` *(one record per review)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ReviewID` | Single Line Text | Yes | Review # | Auto-generated `MR-{YY}-{##}` (e.g., `MR-26-01`). Read-only. |
| `ReviewType` | Choice | Yes | Review Type | `Scheduled`, `Ad-hoc` |
| `ReviewDate` | Date | Yes | Review Date | — |
| `PeriodCoveredFrom` | Date | Yes | Period Covered – From | — |
| `PeriodCoveredTo` | Date | Yes | Period Covered – To | — |
| `Chair` | Person | Yes | Chair (Top Management) | Typically Laboratory Director. |
| `Attendees` | Person (multi) | Yes | Attendees | — |
| `QACoordinator` | Person | Yes | QA Coordinator | Quality Assurance Manager who compiles inputs (per QM 8.9.2). |
| `SummaryConclusions` | Multiple Lines | No | Overall Suitability/Adequacy/Effectiveness Conclusion | Management's conclusion on continuing suitability, adequacy, effectiveness (8.9.1). |
| `MinutesDocRef` | Attachment / Hyperlink | No | Signed Minutes (Word/PDF) | Auto-generated minutes stored in the controlled library. |
| `Status` | Choice | Yes | Status | `Planned`, `Inputs Compiled`, `In Meeting`, `Actions Open`, `Closed` |
| **Record control** | — | — | — | See common Record-Control block in `PlatformValidation_DataIntegrity` resources. |

### 1.2 Child list — `LS_QP1801r01a_ReviewInputs` *(the 15 required inputs, 8.9.2 a–o)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ReviewRef` | Lookup → `LS_QP1801r01_ManagementReview` | Yes | Parent Review | — |
| `InputCategory` | Choice | Yes | Input (8.9.2) | `a) changes in internal/external issues`, `b) fulfilment of objectives`, `c) suitability of policies & procedures`, `d) status of actions from previous reviews`, `e) outcome of recent internal audits`, `f) corrective actions`, `g) assessments by external bodies`, `h) changes in volume/type of work`, `i) customer & personnel feedback`, `j) complaints`, `k) effectiveness of improvements`, `l) adequacy of resources`, `m) results of risk identification`, `n) outcomes of assurance of validity of results`, `o) other factors (monitoring, training)` |
| `DataSummary` | Multiple Lines | Yes | Data / Metric Summary | Auto-pulled figures + narrative (e.g., "12 NCWs, 9 closed; 3 CAs, all effective; 1 major audit finding open"). |
| `SourceLink` | Multiple Lines / Lookup | No | Source Records | Links to the underlying list(s)/records supporting the input. |
| `Discussion` | Multiple Lines | No | Discussion / Notes | Management's discussion of the input. |

### 1.3 Child list — `LS_QP1801r01b_ReviewOutputs` *(decisions & actions, 8.9.3)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ReviewRef` | Lookup → `LS_QP1801r01_ManagementReview` | Yes | Parent Review | — |
| `OutputCategory` | Choice | Yes | Output Relates To (8.9.3) | `Effectiveness of the management system & processes`, `Improvement of laboratory activities (related to requirements)`, `Provision of resources`, `Need for change` |
| `DecisionAction` | Multiple Lines | Yes | Decision / Action | — |
| `Responsible` | Person | Yes | Responsible | — |
| `DueDate` | Date | Yes | Due Date | — |
| `LinkedRecordRef` | Lookup (dynamic) | No | Linked Execution Record | → CA (`LS_QP1601r01`), DCR (`LS_QP1402r01`), Risk (`LS_QP1501r01`), or OFI (`LS_QP1503r01`) that implements the action. |
| `ActionStatus` | Choice | Yes | Status | `Open`, `In Progress`, `Closed` |
| `ClosedDate` | Date | No | Closed Date | — |

> **Data Integrity Rule:** All fifteen `InputCategory` values (a–o) must be present on each review before `Status` can advance to `"In Meeting"` (completeness gate for 8.9.2). Input (d) "status of actions from previous reviews" auto-populates from the prior review's open `ReviewOutputs`. The review cannot be `"Closed"` while any output action is `Open`/`In Progress` — or those actions carry forward to the next review as input (d).

---

## 2. Form Layout & Logic

### Section 01 – Review Header
**Fields:** `ReviewID`, `ReviewType`, `ReviewDate`, `PeriodCoveredFrom/To`, `Chair`, `Attendees`, `QACoordinator`, `Status`

### Section 02 – Inputs (8.9.2 a–o) *(grid — child list 1.2)*
**Fields:** per row: `InputCategory`, `DataSummary`, `SourceLink`, `Discussion`  
**Logic 1:** The 15 inputs are pre-created as fixed rows when the review is opened (completeness by design).  
**Logic 2 – Auto-population:** Power Automate fills `DataSummary` for data-backed inputs from the dashboard aggregates:
- (e) audit outcomes ← `LS_QP1703r01` findings; (f) corrective actions ← `LS_QP1601r01`; (i)/(j) feedback & complaints ← `LS_QP1201r01`; (k) improvements ← `LS_QP1503r01`; (m) risks ← `LS_QP1501r01`; (n) validity of results ← QC/PT data (QP-10); (d) prior-review actions ← previous `ReviewOutputs`.  
The QA Coordinator reviews/edits and adds `Discussion`.

### Section 03 – Outputs / Actions (8.9.3) *(grid — child list 1.3)*
**Fields:** per row: `OutputCategory`, `DecisionAction`, `Responsible`, `DueDate`, `LinkedRecordRef`, `ActionStatus`  
**Logic:** Each action can spawn the execution record that implements it (Raise CA / DCR / Risk / OFI) and links it. Overdue actions escalate to the Chair.

### Section 04 – Conclusion & Minutes
**Fields:** `SummaryConclusions`, `MinutesDocRef`  
**Logic:** On finalization, Power Automate generates the Word/PDF minutes from the record and stores it in the controlled library; `Status = "Actions Open"` until all outputs close, then `"Closed"`.  
**Formatting:** `Status` color coding – Planned (gray), Inputs Compiled (blue), In Meeting (indigo), Actions Open (amber), Closed (green).

---

## 3. Roles & Permissions

| Role | Permission Level |
|---|---|
| Laboratory Director (Top Management) | Chair + Approve/Sign minutes |
| Quality Assurance Manager | Full Control (compiles inputs, coordinates, drafts minutes) |
| Laboratory Manager | Contribute (inputs, actions) |
| Laboratory Analyst | View |

**Workflow:** QA compiles inputs (auto + narrative) → `Inputs Compiled` → meeting held, decisions recorded → minutes generated & signed → actions tracked to closure → `Closed`; open actions roll into the next review's input (d).

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Receives from | `LS_QP1201r01`, `LS_QP1301r01`, `LS_QP1601r01`, `LS_QP1501r01`, `LS_QP1503r01`, `LS_QP1703r01` | Auto-populates the 8.9.2 inputs (complaints, NCW, CA, risks, improvements, audit outcomes). |
| Receives from | QP-10 validity-of-results data (QC/PT) | Input (n) outcomes of assurance of the validity of results. |
| Feeds into | `LS_QP1601r01` / `LS_QP1402r01` / `LS_QP1501r01` / `LS_QP1503r01` | Output actions spawn/link CA, DCR, Risk, or OFI records that execute the decisions (8.9.3). |
| Feeds into | Controlled document library | Generated signed minutes (Word/PDF) as the formal record. |
| Feeds into | Dashboard UI | "Reviews" section of the **Audits & Reviews** tab; open management actions surface as a metric. |
