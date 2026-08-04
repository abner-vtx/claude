# Form Specification: Audit Report

**Master SOP:** QP-17 – Audits  
**Form ID:** LS_QP1703r01 *(digital successor to FM QP17.03 Audit Report)*  
**Form Title:** Audit Report  
**SharePoint List:** `LS_QP1703r01_AuditReport`  
**ISO/IEC 17025:2017 Reference:** Clause 8.8 – Internal Audits (reporting of results)  
**Document Status:** Draft  

**Purpose:** To document the outcome of an audit event — the team, auditees, objectives/criteria followed, strong and weak points identified, and the itemized findings (nonconformities) with their clause reference, required corrective action, responsible person, proposed closing date, and confirmation of closing. The report is where nonconformities become actionable: each finding can spawn a Nonconforming Work record (`LS_QP1301r01`) and/or a Corrective Action (`LS_QP1601r01`), and improvement points can seed OFIs (`LS_QP1503r01`). This closes the audit portion of the **Audits & Reviews** tab.

---

## 1. Data Schema

### 1.1 Parent list — `LS_QP1703r01_AuditReport`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ReportID` | Single Line Text | Yes | Report ID | Auto-generated `RPT-{AuditID}` (e.g., `RPT-AUD-26-01`). Read-only. |
| `AuditRef` | Lookup → `LS_QP1701r01_AuditNotification` | Yes | Audit Event | Parent audit; inherits `AuditID`. |
| `ChecklistRef` | Lookup → `LS_QP1702r01_AuditChecklist` | No | Source Checklist | The executed checklist supplying findings. |
| `ExecutionDates` | Single Line Text | Yes | Audit Execution Date(s) | e.g., `3/30/2026 and 3/31/2026`. |
| `Objectives` | Multiple Lines | Yes | Audit Objectives & Criteria Followed | — |
| `Scope` | Multiple Lines | Yes | Audit Scope | — |
| `PlanFollowed` | Multiple Lines | No | Audit Plan Followed | Day-by-day clause coverage actually executed. |
| `CriteriaReference` | Single Line Text | Yes | Criteria / Reference | e.g., `ISO 17025:2017 and Laboratory QMS`. |
| `WeakPoints` | Multiple Lines | No | Weak Points | Improvement opportunities identified. |
| `StrongPoints` | Multiple Lines | No | Strong Points | Positive observations. |
| `LeadAuditor` | Person | Yes | Lead Auditor | Signs the closing. |
| `ClosingDate` | Date | No | Date of Closing (Audit) | Set when all findings are confirmed closed. |
| `Status` | Choice | Yes | Status | `Draft`, `Issued`, `Findings Open`, `Findings In Progress`, `Closed`, `Cancelled` |

### 1.2 Child list — `LS_QP1703r01a_Findings`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ReportRef` | Lookup → `LS_QP1703r01_AuditReport` | Yes | Parent Report | — |
| `FindingNo` | Number | Yes | No. | Sequential finding number. |
| `Description` | Multiple Lines | Yes | Description of Finding / Nonconforming Work | — |
| `ClauseReference` | Single Line Text | Yes | Clause / Reference | e.g., `ISO/IEC 17025 §7.7.2`. |
| `CorrectiveActionText` | Multiple Lines | No | Corrective Action (rationale / plan) | Summary/rationale per §8.7. |
| `Responsible` | Person | No | Responsible | Owner of the closing action. |
| `ProposedClosingDate` | Date | No | Proposed Date of Closing | Due date for the finding; drives aging. |
| `ConfirmationOfClosing` | Date | No | Confirmation of Closing | Actual closing date. |
| `AgeDays` | Calculated | No | Age (days) | `TODAY − report ExecutionDate` while open. Read-only. |
| `Overdue` | Calculated Yes/No | No | Overdue | `Yes` when `ProposedClosingDate < today` and `FindingStatus != "Closed"`; escalates per 8.8.2 d ("without undue delay"). |
| `Severity` | Choice | No | Severity | `Major`, `Minor`, `Observation` |
| `NCWRef` | Lookup → `LS_QP1301r01_NonconformingWork` | No | Linked NCW | Set if the finding is escalated to nonconforming work. |
| `CARef` | Lookup → `LS_QP1601r01_CorrectiveActions` | No | Linked Corrective Action | Set if a CA is raised. |
| `FindingStatus` | Choice | Yes | Finding Status | `Open`, `Action Assigned`, `In Progress`, `Closed` |

> **Data Integrity Rule:** `Objectives`, `Scope`, `CriteriaReference` lock after `Status == "Issued"`. The report cannot be `Closed` until every finding has `FindingStatus == "Closed"` with a `ConfirmationOfClosing` date. Findings sourced from the checklist inherit `ClauseReference` and cannot have it blanked.

---

## 2. Form Layout & Logic

### Section 01 – Report Header

**Fields:** `ReportID`, `AuditRef`, `ChecklistRef`, `ExecutionDates`, `LeadAuditor`  
**Logic:** Team, auditees, scope, and plan pre-populate from the linked notification (`LS_QP1701r01`). *(Audit Team and Auditee rosters are stored on the notification and displayed read-only here.)*

---

### Section 02 – Objectives, Criteria & Improvement

**Fields:** `Objectives`, `Scope`, `PlanFollowed`, `CriteriaReference`, `WeakPoints`, `StrongPoints`  
**Logic:** `WeakPoints` offers **"Create OFI"** to seed an improvement record (`LS_QP1503r01`, `Source = "Audit Output"`).

---

### Section 03 – Findings *(repeating grid — child list 1.2)*

**Fields:** per row: `FindingNo`, `Description`, `ClauseReference`, `Severity`, `CorrectiveActionText`, `Responsible`, `ProposedClosingDate`, `ConfirmationOfClosing`, `FindingStatus`, `NCWRef`, `CARef`  
**Logic 1:** Findings auto-populate from `NC` items on the linked checklist; additional findings can be added manually.  
**Logic 2:** Each finding offers **"Raise NCW"** (creates `LS_QP1301r01`, stores `NCWRef`) and/or **"Raise Corrective Action"** (creates `LS_QP1601r01`, stores `CARef`).  
**Logic 3:** `FindingStatus` advances to `Closed` when the linked NCW/CA is closed and `ConfirmationOfClosing` is set.  
**Formatting:** `FindingStatus` color coding – Open (red), Action Assigned (amber), In Progress (blue), Closed (green). `Severity` – Major (red), Minor (amber), Observation (slate).

---

### Section 04 – Closing

**Fields:** `LeadAuditor`, `ClosingDate`, `Status`  
**Logic:** Report `Status = "Closed"` requires all findings closed and `LeadAuditor` sign-off; writes completion back to the audit event and programme line.  
**Formatting:** `Status` color coding – Draft (gray), Issued (blue), Findings Open (red), Findings In Progress (amber), Closed (green), Cancelled (slate).

---

## 3. Roles & Permissions

| Role | Permission Level |
|---|---|
| Lead Auditor | Contribute (author, findings) + Sign-off |
| Quality Assurance Manager | Contribute + Approve + track findings |
| Laboratory Manager | View + own assigned findings |
| Auditee (Analyst/Manager) | View + execute assigned finding actions |

**Approval Workflow:** Lead Auditor drafts the report from the completed checklist → `Status = "Issued"` → findings assigned and worked (NCW/CA raised) → all findings closed → Lead Auditor signs → `Status = "Closed"`.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Receives from | `LS_QP1701r01_AuditNotification` | Inherits `AuditID`, team, auditees, scope, plan. |
| Receives from | `LS_QP1702r01_AuditChecklist` | `NC` items populate the findings grid. |
| Feeds into | `LS_QP1301r01_NonconformingWork` | Findings escalated to NCW (`NCWRef`). |
| Feeds into | `LS_QP1601r01_CorrectiveActions` | Findings requiring corrective action (`CARef`, `SourceType = "Audit Finding"`). |
| Feeds into | `LS_QP1503r01_Improvement` | Weak points / improvement opportunities seed OFIs. |
| Writes back | `LS_QP1704r01_AuditProgram` | On closure, marks the programme line completed. |
| Feeds into | Dashboard UI | Completed-audit results and open findings in the **Audits & Reviews** tab. |
