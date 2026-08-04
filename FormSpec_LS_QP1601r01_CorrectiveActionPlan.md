# Form Specification: Corrective Action Plan

**Master SOP:** QP-16 – Corrective Actions  
**Form ID:** LS_QP1601r01 *(digital successor to FM QP16.01 Corrective Action Plan; incorporates FM QP16.02 Brainstorm, FM QP16.03 Fishbone, FM QP16.04 Five Whys)*  
**Form Title:** Corrective Action Plan  
**SharePoint List:** `LS_QP1601r01_CorrectiveActions`  
**ISO/IEC 17025:2017 Reference:** Clause 8.7 – Corrective Actions  
**Document Status:** Draft  

**Purpose:** To react to a nonconformity, control and correct it, determine its root cause(s), and implement actions that eliminate the cause and prevent recurrence — then verify that those actions were effective. The record captures the problem statement and its source nonconformance, the participants, the root-cause analysis (via the QP-16 tools), the corrective/preventive action plan with owners and dates, the effectiveness-monitoring controls, and closing with review/approval. This list drives the **Corrective Actions** tab.

---

## 1. Data Schema

### 1.1 Parent list — `LS_QP1601r01_CorrectiveActions`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `CARID` | Single Line Text | Yes | Corrective Action Plan # | Auto-generated `CAR{YY}{###}` (e.g., `CAR26001`). Read-only. |
| `RecordedBy` | Person | Yes | Recorded By | Current user (auto-populated). |
| `RecordedDate` | Date | Yes | Date | Today (auto-populated). |
| `ProblemStatement` | Multiple Lines | Yes | What went wrong and needs to be corrected? | Description of the nonconformity being addressed. |
| `ReferenceNC` | Lookup → `LS_QP1301r01_NonconformingWork` | No | Reference Nonconformance | Source NCW (`NC{YY}{###}`). May also originate from a complaint or audit finding. |
| `SourceType` | Choice | Yes | Source | `Nonconforming Work`, `Complaint`, `Audit Finding`, `Management Review`, `Other` |
| `RootCauseIdentified` | Choice | Yes | Was the root cause identified? | `Yes`, `No` |
| `RootCause` | Multiple Lines | Yes | Root Cause | The determined root cause(s). Required when `RootCauseIdentified == "Yes"`. |
| `RCAToolUsed` | Choice (multi) | No | Root-Cause Tool(s) Used | `Brainstorm (FM QP16.02)`, `Fishbone / Ishikawa (FM QP16.03)`, `Five Whys (FM QP16.04)` |
| `RCAEvidence` | Attachment / Multiple Lines | No | RCA Evidence | Attached diagram/analysis + its record ID. |
| `SimilarNCReviewed` | Choice | Yes | **Extent of condition** — do similar nonconformities exist or could they occur elsewhere? (8.7.1 b) | `Yes – found elsewhere`, `Yes – could occur elsewhere`, `No` |
| `ExtentOfConditionFindings` | Multiple Lines | No | Extent-of-Condition Findings | Where the check looked (other methods, areas, instruments, time periods) and what was found. Required unless `SimilarNCReviewed == "No"`, with rationale. |
| `ExtentActionsRef` | Lookup (multi) → `LS_QP1601r01b_ActionItems` / other CAs | No | Extension Actions | Additional actions or CAs raised to address the nonconformity where it exists/could occur elsewhere. |
| `PlanNarrative` | Multiple Lines | Yes | Actions to Correct & Prevent Recurrence | Overview of the corrective/preventive strategy. |
| `NotifyCustomer` | Choice | No | Is it necessary to notify the customer? | `Yes`, `No` |
| `NotifiedBy` | Person | No | Notified By | — |
| `NotifyDate` | Date | No | Date of Notification | — |
| `FollowUpAuditReq` | Choice | No | Is a follow-up audit required? | `Yes`, `No` |
| `FollowUpScope` | Multiple Lines | No | Follow-up Scope | Required if `FollowUpAuditReq == "Yes"`. |
| `FollowUpDate` | Date | No | Follow-up Date | — |
| `Conclusions` | Multiple Lines | No | Conclusions and/or Recommendations | — |
| `RiskUpdateRequired` | Choice | Yes | Update risks & opportunities? (8.7.1 e) | `Yes`, `No` |
| `RiskRef` | Lookup → `LS_QP1501r01_ActionPlans` | No | Risk / Opportunity Updated or Raised | Required when `RiskUpdateRequired == "Yes"`; links the new/updated risk action plan. |
| `MSChangeRequired` | Choice | Yes | Make changes to the management system? (8.7.1 f) | `Yes`, `No` |
| `DCRRef` | Lookup → `LS_QP1402r01_ChangeRequests` | No | Document Change Request | Required when `MSChangeRequired == "Yes"`; links the DCR that revises the affected document(s). |
| `RelatedSampleID` | Single Line Text | No | Related Sample ID | Traceability (if the NC involved a specific sample). |
| `RelatedTestReport` | Single Line Text | No | Related Test Report # | Traceability. |
| `RelatedEquipmentID` | Lookup / Single Line Text | No | Related Equipment | Traceability (instrument involved). |
| `RelatedMethodSOP` | Lookup → `LS_QP1401r01_DocumentRegister` | No | Related Method / SOP | Traceability (method or procedure involved). |
| `RelatedPersonnel` | Person (multi) | No | Related Personnel | Traceability (staff involved), used carefully re: impartiality. |
| `DueDate` | Date | No | Target Closure Date | Drives aging/escalation. |
| `AgeDays` | Calculated | No | Age (days) | `TODAY − RecordedDate` while open. Read-only. |
| `EscalationState` | Calculated Choice | No | Escalation | `On Track`, `Due Soon`, `Overdue`, `Escalated`. |
| `Status` | Choice | Yes | Status | `Initiated`, `Root Cause`, `Action Planning`, `In Progress`, `Verification`, `Closed – Effective`, `Closed – Not Effective`, `Cancelled` |
| `ReviewedBy` | Person | No | Reviewed By | Captured at closing. |
| `ApprovedBy` | Person | No | Approved By | Captured at closing. |
| `ClosingDate` | Date | No | Date of Closing | — |
| **Record control** | — | — | — | See common Record-Control block (retention, confidentiality, audit trail, e-signature) in `PlatformValidation_DataIntegrity` resources. |

### 1.2 Child list — `LS_QP1601r01a_Participants`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `CARRef` | Lookup → `LS_QP1601r01_CorrectiveActions` | Yes | Parent CA | — |
| `Participant` | Person | Yes | Name | — |
| `Position` | Single Line Text | Yes | Position | — |

### 1.3 Child list — `LS_QP1601r01b_ActionItems`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `CARRef` | Lookup → `LS_QP1601r01_CorrectiveActions` | Yes | Parent CA | — |
| `ActionItem` | Multiple Lines | Yes | Action Item | — |
| `Responsible` | Person | Yes | Responsible | — |
| `ScheduledDate` | Date | Yes | Scheduled Date | — |
| `ActualDate` | Date | No | Actual Date | Completion date. |
| `VerifiedBy` | Person | No | Verified By | — |

### 1.4 Child list — `LS_QP1601r01c_EffectivenessControls`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `CARRef` | Lookup → `LS_QP1601r01_CorrectiveActions` | Yes | Parent CA | — |
| `Control` | Multiple Lines | Yes | Control | Verification control established. |
| `Responsible` | Person | Yes | Responsible | — |
| `ReviewDate` | Date | Yes | Review Date | Planned verification date. |
| `ActualDate` | Date | No | Actual Date | — |
| `Effectiveness` | Choice | No | Effectiveness | `Effective`, `Not Effective`, `Pending` |

> **Data Integrity Rule:** `ProblemStatement` and `ReferenceNC` lock after `Status` moves past `"Root Cause"`. The CA cannot reach `"Closed – Effective"` until every `EffectivenessControls` row has `Effectiveness == "Effective"` (or a documented rationale for any exception).

---

## 2. Form Layout & Logic

### Section 01 – Problem Statement

**Fields:** `RecordedBy`, `RecordedDate`, `CARID`, `ProblemStatement`, `SourceType`, `ReferenceNC`, `RootCauseIdentified`, `RootCause`  
**Logic 1:** IF opened from an NCW (Section 05 of `LS_QP1301r01`), `ReferenceNC`, `ProblemStatement`, and `SourceType = "Nonconforming Work"` are pre-populated.  
**Logic 2:** `RootCauseIdentified` radio; IF `Yes`, `RootCause` mandatory.

---

### Section 02 – Root Cause Analysis

**Fields:** `RCAToolUsed`, `RCAEvidence`, `SimilarNCReviewed`, `ExtentOfConditionFindings`, `ExtentActionsRef`  
**Logic 1:** Multi-select the tool(s) applied per QP-16 §5.5. Each selected tool prompts for its evidence/record ID (Brainstorm, Fishbone, or Five Whys). Guidance: *"Attach the completed analysis and cite its record ID."*  
**Logic 2 – Extent of condition (8.7.1 b):** `SimilarNCReviewed` is mandatory. IF `"Yes – found elsewhere"` or `"Yes – could occur elsewhere"`, THEN `ExtentOfConditionFindings` is mandatory and the form prompts to add **extension actions** (extra action items, or a **"Raise related CA"** for other areas) captured in `ExtentActionsRef`. IF `"No"`, a short rationale is required in `ExtentOfConditionFindings`. Guidance: *"Check whether this nonconformity exists, or could occur, in other methods, instruments, shifts, or time periods — not just where it was found."*

---

### Section 03 – Participants *(repeating grid — child list 1.2)*

**Fields:** per row: `Participant`, `Position`  
**Logic:** Add/remove participants who contributed to the RCA/plan.

---

### Section 04 – Corrective Action Plan *(repeating grid — child list 1.3)*

**Fields:** `PlanNarrative`; per row: `ActionItem`, `Responsible`, `ScheduledDate`, `ActualDate`, `VerifiedBy`  
**Logic:** Overdue action items (`ScheduledDate < today`, no `ActualDate`) flagged. Completion of all items advances `Status` to `"Verification"`.

---

### Section 05 – Follow-up & Monitoring of Effectiveness *(repeating grid — child list 1.4)*

**Fields:** per row: `Control`, `Responsible`, `ReviewDate`, `ActualDate`, `Effectiveness`  
**Logic:** `Effectiveness` renders as radio (Effective / Not Effective). Any `Not Effective` prevents `"Closed – Effective"` and prompts a new/revised action.

---

### Section 06 – Systemic Follow-through *(8.7.1 e & f)*

**Fields:** `RiskUpdateRequired`, `RiskRef`, `MSChangeRequired`, `DCRRef`  
**Logic 1 – Update risks & opportunities (8.7.1 e):** `RiskUpdateRequired` mandatory. IF `Yes`, offer **"Update / Raise Risk"** which links or creates a `LS_QP1501r01` action plan (`RiskRef`).  
**Logic 2 – Change the management system (8.7.1 f):** `MSChangeRequired` mandatory. IF `Yes`, offer **"Raise DCR"** which creates a `LS_QP1402r01` Document Change Request (`ChangeDriver = "Preventive Action"`, `SourceRef = CARID`) and stores it in `DCRRef`. *In the reference example, the CA revises PM-04 — that revision must be traceable to a DCR rather than made informally.*  
**Logic 3:** The CA cannot reach `"Closed – Effective"` while `RiskUpdateRequired`/`MSChangeRequired == "Yes"` but the corresponding `RiskRef`/`DCRRef` is empty or its linked record is still open.

---

### Section 07 – Closing

**Fields:** `NotifyCustomer`, `NotifiedBy`, `NotifyDate`, `FollowUpAuditReq`, `FollowUpScope`, `FollowUpDate`, `Conclusions`, traceability fields, `DueDate`/aging, `ReviewedBy`, `ApprovedBy`, `ClosingDate`  
**Logic:** IF `FollowUpAuditReq == "Yes"`, `FollowUpScope` mandatory (passed to Audit Program). Closure requires `ReviewedBy` + `ApprovedBy`. Traceability lookups (`RelatedSampleID`, `RelatedTestReport`, `RelatedEquipmentID`, `RelatedMethodSOP`, `RelatedPersonnel`) link the CA to the specific items involved. `EscalationState` drives overdue notifications to QA.  
**Formatting:** Display `Status` with color coding – Initiated (gray), Root Cause/Action Planning (blue), In Progress (amber), Verification (indigo), Closed – Effective (green), Closed – Not Effective / Cancelled (red).

---

## 3. Roles & Permissions

| Role | Permission Level |
|---|---|
| Laboratory Analyst | Contribute (action-item execution) |
| Laboratory Manager | Contribute (create, edit, own) |
| Quality Assurance Manager | Contribute + Verify + Approve |
| Laboratory Director | View + Approve (as delegated) |

**Approval Workflow:**  
1. CA initiated (from NCW/complaint/audit or directly) → `Status = "Initiated"`.  
2. Root cause determined → action plan built → `Status = "In Progress"`.  
3. Actions completed → effectiveness verified → `Status = "Verification"`.  
4. QA verifies effectiveness, reviewer/approver sign → `Status = "Closed – Effective"`.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Receives from | `LS_QP1301r01_NonconformingWork` | Primary source: NCW with `CARequired == "Yes"` spawns this record (bridges `RecordID` → `ReferenceNC`). |
| Receives from | `LS_QP1201r01_Complaints` | A complaint may raise a CA directly (`SourceType = "Complaint"`). |
| Receives from | `LS_QP1703r01_AuditReport` | Audit findings requiring corrective action link here (`SourceType = "Audit Finding"`). |
| Feeds into | `LS_QP1704r01_AuditProgram` | When `FollowUpAuditReq == "Yes"`, passes scope to the audit schedule. |
| Feeds into | `LS_QP1501r01_ActionPlans` | 8.7.1 e — updates/raises a risk & opportunity action (`RiskRef`). |
| Feeds into | `LS_QP1402r01_ChangeRequests` | 8.7.1 f — raises a DCR to change the management system/documents (`DCRRef`, `ChangeDriver = "Preventive Action"`). |
| Writes back | `LS_QP1301r01_NonconformingWork` | On `"Verification"`/`"Closed – Effective"`, updates the source NCW's `CARef` status gate to permit NCW closure. |
| References | `LS_QP1401r01_DocumentRegister` | Traceability lookups (`RelatedMethodSOP`) and extent-of-condition scoping. |
| Feeds into | Dashboard UI | Data source for the **Corrective Actions** tab and the "Open CAPAs" metric card. |
