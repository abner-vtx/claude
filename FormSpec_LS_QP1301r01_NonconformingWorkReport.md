# Form Specification: Nonconforming Work Report

**Master SOP:** QP-13 – Management of Nonconforming Work  
**Form ID:** LS_QP1301r01 *(digital successor to FM QP13.01)*  
**Form Title:** Nonconforming Work Report  
**SharePoint List:** `LS_QP1301r01_NonconformingWork`  
**ISO/IEC 17025:2017 Reference:** Clause 7.10 – Nonconforming Work  
**Document Status:** Draft  

**Purpose:** To identify, record, evaluate, and control work that does not conform to the laboratory's procedures or to agreed customer requirements, and to decide and document what action is taken (immediate containment, customer notification, and — where a systemic cause exists — escalation to Corrective Action per QP-16). The record captures the full 7.10 lifecycle: detection, validation, impact assessment, immediate actions, the corrective-action decision, root-cause linkage, and closing with review/approval.

---

## 1. Data Schema

*SharePoint List column definitions.*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `RecordID` | Single Line Text | Yes | Nonconformance # | Auto-generated `NC{YY}{###}` (e.g., `NC26003`). Read-only. |
| `ReportedBy` | Person | Yes | Reported / Recorded By | Current user (auto-populated). |
| `ReportedDate` | Date | Yes | Date | Today (auto-populated). |
| `ExternallyDetected` | Yes/No | Yes | Externally Detected? | Default `No`. Gates the external-source subsection. |
| `ExtReportedBy` | Single Line Text | No | External – Reported By | Required if `ExternallyDetected == Yes`. |
| `ExtReporterEmail` | Single Line Text | No | External – Email | — |
| `ExtDateReported` | Date | No | External – Date Reported | — |
| `ExtCompany` | Single Line Text | No | External – Company | — |
| `ExtAddress` | Multiple Lines | No | External – Address | — |
| `NCCategory` | Choice (multi-select) | Yes | Category of the Nonconformance | `Procedural`, `Instrumentation & Equipment`, `Documentation & Record Keeping`, `Sample Handling`, `Personnel Training & Competence`, `Quality Control`, `Environmental Conditions`, `Reporting Errors (Test Reports)`, `Supplier Related`, `Safety`, `Other` |
| `NCCategoryOther` | Single Line Text | No | Category – Other | Visible when `Other` is selected. |
| `RelatedSample` | Single Line Text | No | Related Sample (if applicable) | `N/A` default. |
| `InternalID` | Single Line Text | No | Internal ID # | — |
| `TestReportNo` | Single Line Text | No | Test Report # | — |
| `Description` | Multiple Lines | Yes | Description of Nonconforming Work | Full narrative of the nonconformance. |
| `OccurredDate` | Date | Yes | Date When the NC Occurred | — |
| `EvidenceAttached` | Multiple Lines / Attachments | No | Evidence Attached | Description + file attachments. |
| `IsValid` | Choice | Yes | Is the information valid and reliable? | `Yes`, `No` |
| `Proceeds` | Choice | Yes | Does the NC proceed? | `Yes`, `No` |
| `ValidationRationale` | Multiple Lines | Yes | Why? (from analysis) | Justification citing the relevant clause/procedure. |
| `ImpactAssessment` | Multiple Lines | Yes | Impact of the NC (incl. previous services) | Required when `Proceeds == "Yes"`. |
| `EvaluatedBy` | Person | Yes | Personnel That Evaluated the NC | — |
| `EvaluatorPosition` | Single Line Text | Yes | Position | — |
| `EvaluationDate` | Date | Yes | Date of Evaluation | — |
| `CustomerNotifyReqEval` | Choice | Yes | Is it necessary to notify the customer? (evaluation) | `Yes`, `No` |
| `CustomerNotifiedByEval` | Person | No | Notified By (Personnel) | — |
| `CustomerNotifyDateEval` | Date | No | Date of Notification | — |
| `ImmediateActions` | Multiple Lines | Yes | Immediate Actions to Address the NC | Numbered containment/correction actions. |
| `ImmediateEvidence` | Multiple Lines / Attachments | No | Evidence Attached (immediate actions) | — |
| `ImmediateResponsible` | Person | Yes | Responsible (immediate actions) | — |
| `ImmediateActionDate` | Date | Yes | Date (immediate actions) | — |
| `RiskLevel` | Choice | Yes | Risk Level of the NC (7.10.1 b) | `High`, `Medium`, `Low` (drives whether work is halted and reports withheld). |
| `WorkHalted` | Choice | Yes | Was work halted / repeated? | `Halted`, `Repeated`, `Continued (justified)` |
| `ReportsAction` | Choice | Yes | Reports / certificates action (7.10.1 e) | `None required`, `Reports withheld`, `Reports recalled`, `Certificates withdrawn` |
| `RecallScope` | Multiple Lines | No | Recall / Withholding Scope | Required unless `ReportsAction == "None required"`; which reports/customers/date-range are affected. |
| `ResumptionAuthorizedBy` | Person | No | Authority for Resumption of Work (7.10.1 f) | The individual authorized to release work to resume. Mandatory before closure when `WorkHalted == "Halted"`. |
| `ResumptionAuthorizedDate` | Date | No | Resumption Authorized Date | — |
| `ResumptionConditions` | Multiple Lines | No | Conditions for Resumption | Any conditions attached to resuming work. |
| `CARequired` | Choice | Yes | Is Corrective Action required? | `Yes`, `No` |
| `CARationale` | Multiple Lines | Yes | Rationale (per ISO/IEC 17025:2017 §8.7) | Justification for the CA decision. |
| `CARef` | Lookup → `LS_QP1601r01_CorrectiveActions` | No | Corrective Action Reference | `CAR{YY}{###}`; linked when `CARequired == "Yes"`. |
| `RootCauseRef` | Lookup → `LS_QP1601r01_CorrectiveActions` (RCA subrecord) | No | Root Cause Analysis Reference | Fishbone / Brainstorm / 5-Whys record ID. |
| `CustomerNotifyReqClose` | Choice | No | Notify customer? (closing) | `Yes`, `No` |
| `FollowUpAuditReq` | Choice | No | Is a follow-up audit required? | `Yes`, `No` |
| `FollowUpScope` | Multiple Lines | No | Follow-up Scope | Required if `FollowUpAuditReq == "Yes"`. |
| `FollowUpDate` | Date | No | Follow-up Date | — |
| `RelatedMethodSOP` | Lookup → `LS_QP1401r01_DocumentRegister` | No | Related Method / SOP | Traceability. |
| `RelatedEquipmentID` | Lookup / Single Line Text | No | Related Equipment | Traceability. |
| `DueDate` | Date | No | Target Closure Date | Drives aging/escalation. |
| `AgeDays` | Calculated | No | Age (days) | `TODAY − ReportedDate` while open. Read-only. |
| `EscalationState` | Calculated Choice | No | Escalation | `On Track`, `Due Soon`, `Overdue`, `Escalated`. |
| `Status` | Choice | Yes | Status | `Logged`, `Under Validation`, `Impact Assessment`, `Immediate Actions`, `Escalated to CA`, `Root Cause`, `Awaiting Closure`, `Closed`, `Cancelled` |
| `ReviewedBy` | Person | No | Reviewed By | Captured at closing. |
| `ApprovedBy` | Person | No | Approved By | Captured at closing. |
| `ClosingDate` | Date | No | Date of Closing | — |

> **Data Integrity Rule:** After validation is signed (`Status` past `"Under Validation"`), `Description`, `NCCategory`, and `OccurredDate` become read-only. The `CARequired` decision and its rationale are mandatory before the record can reach `"Awaiting Closure"`.

---

## 2. Form Layout & Logic

### Section 01 – Reporting the Nonconforming Work

**Fields:** `ReportedBy`, `ReportedDate`, `RecordID`, `ExternallyDetected`, `ExtReportedBy`, `ExtReporterEmail`, `ExtDateReported`, `ExtCompany`, `ExtAddress`  
**Logic:** `ExternallyDetected` toggles the external-source subsection. IF `No`, hide and null the external fields (mirrors the paper form's "otherwise cancel the section").

---

### Section 02 – Description of the Nonconforming Work

**Fields:** `NCCategory`, `NCCategoryOther`, `RelatedSample`, `InternalID`, `TestReportNo`, `Description`, `OccurredDate`, `EvidenceAttached`  
**Logic 1:** `NCCategory` renders as a checkbox grid (multi-select). IF `Other` selected, show `NCCategoryOther`.  
**Logic 2:** `RelatedSample`, `InternalID`, `TestReportNo` accept `N/A` when the NC is not sample-specific.

---

### Section 03 – Validation of Nonconformance

**Fields:** `IsValid`, `Proceeds`, `ValidationRationale`, `ImpactAssessment`, `EvaluatedBy`, `EvaluatorPosition`, `EvaluationDate`, `CustomerNotifyReqEval`, `CustomerNotifiedByEval`, `CustomerNotifyDateEval`  
**Logic 1:** `IsValid` and `Proceeds` render as radio buttons.  
**Logic 2:** IF `Proceeds == "No"`, THEN `ImpactAssessment` and downstream sections collapse; the record proceeds to closing as a justified non-proceed.  
**Logic 3:** IF `CustomerNotifyReqEval == "Yes"`, THEN `CustomerNotifiedByEval` and `CustomerNotifyDateEval` become mandatory before closing.

---

### Section 04 – Immediate Actions, Containment & Resumption

**Fields:** `ImmediateActions`, `ImmediateEvidence`, `ImmediateResponsible`, `ImmediateActionDate`, `RiskLevel`, `WorkHalted`, `ReportsAction`, `RecallScope`, `ResumptionAuthorizedBy`, `ResumptionAuthorizedDate`, `ResumptionConditions`  
**Logic 1 – Risk-based action (7.10.1 b):** `RiskLevel` drives prompts — `High` suggests `WorkHalted = "Halted"` and review of issued reports.  
**Logic 2 – Recall/withholding (7.10.1 e):** IF `ReportsAction != "None required"`, `RecallScope` is mandatory and a note is passed to Customer Support / the affected customers.  
**Logic 3 – Resumption of work (7.10.1 f):** IF `WorkHalted == "Halted"`, the NCW **cannot be closed** until `ResumptionAuthorizedBy` + `ResumptionAuthorizedDate` are recorded — the defined authority explicitly releases work to resume. Guidance: *"Only the person with defined authority may authorize resumption; record any conditions."*

---

### Section 05 – Corrective Action Decision

**Fields:** `CARequired`, `CARationale`, `CARef`, `RootCauseRef`  
**Logic 1:** `CARequired` renders as radio buttons; `CARationale` mandatory (cite §8.7 evaluation).  
**Logic 2:** IF `CARequired == "Yes"`, THEN show a **"Create Corrective Action"** button that spawns a new `LS_QP1601r01` record (bridging `RecordID` into its `ReferenceNC`), stores the returned `CAR` in `CARef`, and sets `Status = "Escalated to CA"`.  
**Logic 3:** Root-cause tools (Fishbone / Brainstorm / 5-Whys per QP-16) are performed on the CA record; `RootCauseRef` links back to that analysis.

---

### Section 06 – Closing

**Fields:** `CustomerNotifyReqClose`, `FollowUpAuditReq`, `FollowUpScope`, `FollowUpDate`, `ReviewedBy`, `ApprovedBy`, `ClosingDate`  
**Logic 1:** IF `FollowUpAuditReq == "Yes"`, THEN `FollowUpScope` is mandatory and a note is passed to the Audit Program (`LS_QP1704r01`).  
**Logic 2:** Closure requires `ReviewedBy` and `ApprovedBy`. IF `CARequired == "Yes"`, the NCW cannot be `Closed` until the linked CA reaches at least `"Verification"` status (configurable gate).  
**Formatting:** Display `Status` with color coding – Logged (gray), Under Validation/Impact (blue), Immediate Actions (amber), Escalated to CA / Root Cause (red), Awaiting Closure (purple), Closed (green).

---

## 3. Roles & Permissions

| Role | Permission Level |
|---|---|
| Laboratory Analyst | Contribute (create/report) |
| Laboratory Manager | Contribute (create, edit) + Evaluate + Approve |
| Quality Assurance Manager | Contribute + Review/Approve closing |
| Laboratory Director | View + Approve (as delegated) |
| Customer Support | View (for customer-notification coordination) |

**Approval Workflow:**  
1. Detector logs NCW → `Status = "Logged"` → Power Automate notifies Lab Manager + QA.  
2. Lab Manager validates and assesses impact → immediate actions recorded.  
3. CA decision made; if required, CA record spawned and `Status = "Escalated to CA"`.  
4. Reviewed and approved at closing → `Status = "Closed"`.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Receives from | `LS_QP1201r01_Complaints` | A valid complaint requiring investigation bridges `RecordID`, `Description`, `ImpactAssessment` into this list. |
| Receives from | `LS_QP1703r01_AuditReport` | Audit findings classified as nonconforming work create NCW records (finding → NCW link). |
| Feeds into | `LS_QP1601r01_CorrectiveActions` | When `CARequired == "Yes"`, spawns a CA record and links via `CARef` / `RootCauseRef`. |
| Feeds into | `LS_QP1704r01_AuditProgram` | When `FollowUpAuditReq == "Yes"`, passes scope to the audit schedule. |
| Related | `FE QP13.01 Nonconforming Work Tracking` | Downstream annual tracking register / reporting view over this list. |
| Feeds into | `LS_QP1801r01_ManagementReview` | NCW counts/trends and any recalls are a management-review input (8.9.2). |
| Feeds into | Dashboard UI | Primary data source for the **Nonconforming Work** tab and the "Open NCWs" metric card. |
