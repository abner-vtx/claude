# Form Specification: Actions to Address Risks & Opportunities

**Master SOP:** QP-15 – Actions to Address Risks and Opportunities  
**Form ID:** LS_QP1501r01 *(digital successor to FM QP15.01 Change Request; references FE QP15.01 FMEA Risk Assessment)*  
**Form Title:** Action Plan – Risk / Opportunity / Improvement  
**SharePoint List:** `LS_QP1501r01_ActionPlans`  
**ISO/IEC 17025:2017 Reference:** Clause 8.5 – Actions to Address Risks and Opportunities  
**Document Status:** Draft  

**Purpose:** To initiate, assess, plan, approve, and follow up actions that address risks and opportunities to the laboratory's activities and management system. The record captures the goal and rationale of a proposed change, a structured impact/risk assessment across all laboratory dimensions with a treatment decision per area, the resulting deliverables and their verification, and an effectiveness follow-up confirming whether risks were addressed and whether new risks were introduced. This list drives the **Risks & Opportunities** tab.

---

## 1. Data Schema

### 1.1 Parent list — `LS_QP1501r01_ActionPlans`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `PlanID` | Single Line Text | Yes | Plan # | Auto-generated `AARO{YY}{##}` (e.g., `AARO2601`). Read-only. |
| `Type` | Choice | Yes | Type | `Risk`, `Opportunity`, `Improvement` |
| `Initiator` | Person | Yes | Initiator | Current user (auto-populated). |
| `InitiationDate` | Date | Yes | Initiation Date | Today (auto-populated). |
| `Goal` | Multiple Lines | Yes | Action Plan / Goal | Statement of what the plan intends to achieve. |
| `Rationale` | Multiple Lines | Yes | Rationale | Why the action is worthwhile / the expected benefit. |
| `FollowUpAuditReq` | Choice | No | Is a follow-up audit required? | `Yes`, `No` |
| `FollowUpScope` | Multiple Lines | No | Follow-up Scope | Required if `FollowUpAuditReq == "Yes"`. |
| `FollowUpDate` | Date | No | Scheduled Follow-up Date | — |
| `ApprovalDecision` | Choice | No | Is the action approved? | `Approved`, `Not Approved`, `Pending` (default `Pending`) |
| `Reviewer` | Person | No | Reviewer | Sign-off. |
| `Approver` | Person | No | Approver | Sign-off. |
| `EffectivenessResult` | Choice | No | Was the action effective? | `Yes`, `No`, `Pending` |
| `EffectivenessComments` | Multiple Lines | No | Effectiveness Comments | — |
| `RisksAddressed` | Choice | No | Have risks been successfully addressed? | `Yes`, `No`, `N/A` |
| `RisksAddressedComments` | Multiple Lines | No | Comments | — |
| `NewRisksIntroduced` | Choice | No | Were new risks introduced? | `Yes`, `No` |
| `NewRisksDetail` | Multiple Lines | No | New Risks Detail | Required if `NewRisksIntroduced == "Yes"`. |
| `FMEARef` | Attachment / Hyperlink | No | FMEA Risk Assessment (FE QP15.01) | Link to the FMEA spreadsheet where quantitative scoring is used. |
| `SourceOFI` | Lookup → `LS_QP1503r01_Improvement` | No | Source OFI | Set when the plan originates from an Improvement suggestion. |
| `Source` | Choice | No | Trigger / Source | `Management Review`, `Internal Audit`, `Complaint / Feedback`, `Nonconforming Work`, `Corrective Action`, `Change / New Activity`, `Staff Proposal` — traceability for management-review input 8.9.2(m). |
| `SourceRef` | Lookup (dynamic) | No | Source Record | Link to originating audit finding / complaint / NCW / CA. |
| `RelatedMethodSOP` | Lookup → `LS_QP1401r01_DocumentRegister` | No | Related Method / SOP | Traceability. |
| `RelatedEquipmentID` | Lookup / Single Line Text | No | Related Equipment | Traceability. |
| `ResidualRiskLevel` | Choice | No | Residual Risk After Treatment | `Low`, `Medium`, `High` — assessed after the action; high residual requires approver acceptance. |
| `DueDate` | Date | No | Target Completion Date | Drives aging/escalation. |
| `AgeDays` | Calculated | No | Age (days) | `TODAY − InitiationDate` while open. Read-only. |
| `EscalationState` | Calculated Choice | No | Escalation | `On Track`, `Due Soon`, `Overdue`, `Escalated`. |
| `Status` | Choice | Yes | Status | `Initiated`, `Impact Assessment`, `Awaiting Approval`, `Approved – In Progress`, `Follow-up`, `Closed – Effective`, `Closed – Not Effective`, `Rejected` |

### 1.2 Child list — `LS_QP1501r01a_ImpactAssessment` *(one row per laboratory dimension)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `PlanRef` | Lookup → `LS_QP1501r01_ActionPlans` | Yes | Parent Plan | — |
| `Dimension` | Choice | Yes | Impact Area | `Scope & Test Methods`, `QMS`, `Personnel`, `Equipment`, `Facilities & Environment`, `Business`, `Regulations`, `Other` |
| `DimensionOther` | Single Line Text | No | Area – Other | Visible when `Dimension == "Other"`. |
| `Level` | Choice | Yes | Impact Level | `Low`, `Medium`, `High` |
| `IdentifiedRisk` | Multiple Lines | No | Identified Risk(s) | Description of the risk in that area (or "no risks identified"). |
| `Decision` | Choice | Yes | Treatment Decision | `Avoid / Eliminate`, `Change Likelihood`, `Retain`, `Transfer`, `N/A` |

### 1.3 Child list — `LS_QP1501r01b_Deliverables` *(effects on deliverables / action items)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `PlanRef` | Lookup → `LS_QP1501r01_ActionPlans` | Yes | Parent Plan | — |
| `Description` | Multiple Lines | Yes | Deliverable / Action | — |
| `Responsible` | Person | Yes | Responsible | — |
| `ScheduledDate` | Date | Yes | Schedule | Planned date. |
| `ActualDate` | Date | No | Actual Date | Completion date. |
| `VerifiedBy` | Person | No | Verified By | — |

> **Data Integrity Rule:** `Goal`, `Type`, and the impact-assessment rows lock after `ApprovalDecision == "Approved"`. High-impact areas (`Level == "High"`) with `Decision == "Retain"` require an approver comment before approval (residual-risk acceptance evidence).

---

## 2. Form Layout & Logic

### Section 01 – Initiation

**Fields:** `Type`, `Initiator`, `InitiationDate`, `PlanID`, `Goal`, `Rationale`, `Source`, `SourceRef`, `RelatedMethodSOP`, `RelatedEquipmentID`  
**Logic:** `Type` renders as radio buttons. `PlanID`, `Initiator`, `InitiationDate` auto-populated/read-only. `Source` + `SourceRef` capture what triggered the risk/opportunity (audit, complaint, NCW, CA, management review) for end-to-end traceability; traceability lookups link affected methods/equipment.

---

### Section 02 – Impact Assessment *(repeating grid — child list 1.2)*

**Fields:** per row: `Dimension`, `Level`, `IdentifiedRisk`, `Decision`; plan-level `ResidualRiskLevel`  
**Logic 1:** Present the eight dimensions as a fixed grid; each row requires a `Level` and a `Decision`.  
**Logic 2:** `Level` color-codes Low (green), Medium (amber), High (red). IF any row `Level == "High"`, prompt for FMEA (`FMEARef`) per QP-15 §5.4 (FMEA spreadsheet).  
**Logic 3 – Residual risk:** After treatment, record `ResidualRiskLevel`; `High` residual requires explicit approver acceptance (documented residual-risk evidence, proportionate to impact per 8.5.3).

---

### Section 03 – Effects on Deliverables *(repeating grid — child list 1.3)*

**Fields:** per row: `Description`, `Responsible`, `ScheduledDate`, `ActualDate`, `VerifiedBy`  
**Logic:** Add/remove rows dynamically. Overdue rows (`ScheduledDate < today` and no `ActualDate`) are flagged.

---

### Section 04 – Conclusions & Approval

**Fields:** `FollowUpAuditReq`, `FollowUpScope`, `FollowUpDate`, `ApprovalDecision`, `Reviewer`, `Approver`  
**Logic:** IF `FollowUpAuditReq == "Yes"`, `FollowUpScope` mandatory (passed to Audit Program). Approval sets `Status = "Approved – In Progress"`.

---

### Section 05 – Follow-up / Effectiveness

**Fields:** `EffectivenessResult`, `EffectivenessComments`, `RisksAddressed`, `RisksAddressedComments`, `NewRisksIntroduced`, `NewRisksDetail`  
**Logic 1:** IF `NewRisksIntroduced == "Yes"`, THEN `NewRisksDetail` mandatory and offer **"Create linked Action Plan"** to address the new risk.  
**Logic 2:** `EffectivenessResult == "Yes"` → `Status = "Closed – Effective"`; `"No"` → `Status = "Closed – Not Effective"` (prompts a new plan).  
**Formatting:** Display `Status` with color coding – Initiated (gray), Impact Assessment/Awaiting Approval (blue), Approved – In Progress (amber), Follow-up (purple), Closed – Effective (green), Closed – Not Effective / Rejected (red).

---

## 3. Roles & Permissions

| Role | Permission Level |
|---|---|
| Laboratory Analyst | Contribute (initiate) |
| Laboratory Manager | Contribute + Review |
| Quality Assurance Manager | Contribute + Approve |
| Laboratory Director | View + Approve (high-impact) |

**Approval Workflow:**  
1. Any staff member initiates a plan → `Status = "Initiated"`.  
2. Impact assessment completed → `Status = "Impact Assessment"` → `"Awaiting Approval"`.  
3. QA/Manager approves → `Status = "Approved – In Progress"`; deliverables tracked.  
4. Effectiveness follow-up completed → `Status = "Closed – Effective"` / `"Closed – Not Effective"`.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Receives from | `LS_QP1503r01_Improvement` | Approved OFIs that require a managed action are promoted into an action plan (`SourceOFI` link). |
| Feeds into | `LS_QP1704r01_AuditProgram` | When `FollowUpAuditReq == "Yes"`, passes scope/date to the audit schedule. |
| References | `FE QP15.01 FMEA Risk Assessment` | High-impact risks quantified via the FMEA spreadsheet, attached in `FMEARef`. |
| Related | `FE QP15.02 Action Plans Tracking` | Downstream tracking register / reporting view over this list. |
| Receives from | `LS_QP1601r01_CorrectiveActions` | CA "update risks & opportunities" (8.7.1 e) raises/updates a plan here. |
| Feeds into | `LS_QP1801r01_ManagementReview` | Results of risk identification are a management-review input (8.9.2 m). |
| Feeds into | Dashboard UI | Data source for the **Risks & Opportunities** tab (ID, Type, Description, Status, Action Plan). |
