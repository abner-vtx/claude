# Form Specification: Internal Audit Program (Annual Schedule)

**Master SOP:** QP-17 – Audits  
**Form ID:** LS_QP1704r01 *(digital successor to PM-05 Internal Audits Program)*  
**Form Title:** Internal Audit Program  
**SharePoint List:** `LS_QP1704r01_AuditProgram`  
**ISO/IEC 17025:2017 Reference:** Clause 8.8 – Internal Audits (programme planning)  
**Document Status:** Draft  

**Purpose:** To plan and track the annual internal audit programme — the schedule of which ISO/IEC 17025:2017 clause groups are audited in which month, distinguishing *planned* (P) from *completed* (C) coverage. The programme is the parent that individual audit events (Notification → Checklist → Report) are created against, and the register that demonstrates full-standard coverage across the audit cycle. Ad-hoc / follow-up audits requested by NCW, CA, or action-plan records are added here. This list drives the audit schedule portion of the **Audits & Reviews** tab.

---

## 1. Data Schema

### 1.1 Parent list — `LS_QP1704r01_AuditProgram` *(one record per programme year)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ProgramID` | Single Line Text | Yes | Program # | `PM05-{YYYY}` (e.g., `PM05-2026`). Read-only. |
| `Year` | Number | Yes | Programme Year | e.g., `2026`. |
| `PreparedBy` | Person | Yes | Prepared By | — |
| `ProgramBasis` | Multiple Lines | Yes | Programme Basis / Risk Rationale (8.8.2 a) | How the programme was derived — the **importance of the activities**, **changes** affecting the lab, and **results of previous audits**. Demonstrates the schedule is risk-based, not a flat annual sweep. |
| `ApprovedBy` | Person | No | Approved By | Quality Assurance Manager. |
| `ApprovalDate` | Date | No | Approval Date | — |
| `Remarks` | Multiple Lines | No | Remarks | — |
| `Status` | Choice | Yes | Status | `Draft`, `Approved`, `In Progress`, `Completed`, `Superseded` |

### 1.2 Child list — `LS_QP1704r01a_ScheduleLines` *(one row per clause group)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ProgramRef` | Lookup → `LS_QP1704r01_AuditProgram` | Yes | Parent Programme | — |
| `ClauseGroup` | Choice | Yes | ISO/IEC 17025:2017 Clause | `4.1–4.2`, `5.1–5.3`, `5.4–5.7`, `6.1–6.2`, `6.3–6.4`, `6.5–6.6`, `7.1–7.3`, `7.4–7.7`, `7.8–7.11`, `8.1–8.4`, `8.5–8.7`, `8.8–8.9` |
| `ClauseTopic` | Single Line Text | No | Topic | Human-readable topic (e.g., `Impartiality & Confidentiality`, `Corrective Actions`). Auto-filled from a reference map. |
| `PlannedMonth` | Choice | Yes | Planned Month (P) | `JAN` … `DEC` |
| `CompletedMonth` | Choice | No | Completed Month (C) | `JAN` … `DEC`; set when the clause group is audited. |
| `AuditEventRef` | Lookup → `LS_QP1701r01_AuditNotification` | No | Audit Event | The audit event that covered this clause group. |
| `ImportanceRating` | Choice | No | Importance / Risk Rating | `High`, `Medium`, `Low` — drives audit frequency for this area. |
| `SchedulingRationale` | Multiple Lines | No | Scheduling Rationale | Why this area is scheduled at this frequency/month (e.g., high customer impact, recent changes, prior findings). |
| `PriorFindingsInput` | Lookup (multi) → `LS_QP1703r01a_Findings` | No | Prior Findings Considered | Previous-audit findings that informed scheduling this area. |
| `CoverageStatus` | Choice | Yes | Coverage Status | `Planned`, `Scheduled`, `Completed`, `Deferred`, `Not Covered` (default `Planned`) |

> **Reference — Contents map (clause → topic)** used to auto-fill `ClauseTopic`: 4.1 Impartiality; 4.2 Confidentiality; 6.2 Personnel; 6.3 Facilities & Environment; 6.4 Equipment; 6.5 Metrological Traceability; 6.6 Externally Provided Products & Services; 7.1 Review of Requests; 7.2 Selection & Validation of Methods; 7.4–7.5 Handling of Samples & Technical Records; 7.6 Uncertainty; 7.7 Validity of Results; 7.8 Reporting of Results; 7.9 Complaints; 7.10 Nonconforming Work; 7.11 Control of Data & Information; 8.2–8.4 Control of Management System; 8.5–8.6 Risks, Opportunities & Improvement; 8.7 Corrective Actions; 8.8 Internal Audits.

> **Data Integrity Rule:** Each `ClauseGroup` must appear at least once per programme year with a `PlannedMonth` (full-standard coverage check). Marking `CompletedMonth` requires a linked `AuditEventRef`.

---

## 2. Form Layout & Logic

### Section 01 – Programme Header

**Fields:** `ProgramID`, `Year`, `PreparedBy`, `ProgramBasis`, `ApprovedBy`, `ApprovalDate`, `Remarks`, `Status`  
**Logic – Risk basis (8.8.2 a):** `ProgramBasis` is mandatory for approval; per-line `ImportanceRating` + `SchedulingRationale` + `PriorFindingsInput` justify each area's frequency. This pre-empts the common finding that an audit programme is not risk-based.

---

### Section 02 – Schedule Matrix *(grid — child list 1.2)*

**Fields:** per row: `ClauseGroup`, `ClauseTopic`, `PlannedMonth`, `CompletedMonth`, `CoverageStatus`, `AuditEventRef`  
**Logic 1:** Render as a 12-month matrix (clause groups as rows, months as columns) with a **P** marker on `PlannedMonth` and a **C** marker on `CompletedMonth` — mirroring the PM-05 paper grid.  
**Logic 2:** A **Coverage** indicator shows whether every clause group has at least one planned cell; gaps highlighted red.  
**Logic 3:** When an audit event (`LS_QP1701r01`) is completed for a clause group, `CompletedMonth`/`CoverageStatus` update automatically.  
**Formatting:** `CoverageStatus` color coding – Planned (slate), Scheduled (blue), Completed (green), Deferred (amber), Not Covered (red).

---

## 3. Roles & Permissions

| Role | Permission Level |
|---|---|
| Quality Assurance Manager | Full Control (owns/approves the programme) |
| Laboratory Manager | Contribute (propose schedule) + Approve |
| Auditor | View + update completion on assigned lines |
| Laboratory Analyst | View |

**Approval Workflow:** QA drafts the annual programme → Manager/QA approves → `Status = "Approved"`. As audits are executed, schedule lines are marked complete; at year end `Status = "Completed"` and the next year's programme supersedes it.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Feeds into | `LS_QP1701r01_AuditNotification` | Each scheduled audit event is created against a programme line; `AuditEventRef` links back. |
| Receives from | `LS_QP1301r01` / `LS_QP1601r01` / `LS_QP1501r01` | Follow-up audits requested by NCW, CA, or action plans (`FollowUpAuditReq == "Yes"`) are added as schedule lines. |
| Feeds into | Dashboard UI | Source for the **Audits & Reviews** schedule and the "Next Audit" metric card. |
