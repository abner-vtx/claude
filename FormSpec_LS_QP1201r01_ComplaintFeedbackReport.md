# Form Specification: Complaint & Feedback Report

**Master SOP:** QP-12 – Management of Complaints and Feedback  
**Form ID:** LS*QP1201r01 *(digital successor to FM QP12.01)\_  
**Form Title:** Complaint / Feedback Report  
**SharePoint List:** `LS_QP1201r01_Complaints`  
**ISO/IEC 17025:2017 Reference:** Clause 7.9 – Complaints  
**Document Status:** Draft (rev 02 — gap-analysis actions incorporated)

**Purpose:** To receive, evaluate, and resolve complaints and feedback from customers and other interested parties, and to generate objective evidence that each complaint has been acknowledged, investigated for validity, assessed for impact, and closed with the submitter notified. This form is the entry point of the quality-event chain: from here a valid complaint can branch into a Nonconforming Work investigation (QP-13) and/or a Corrective Action (QP-16), and feedback can seed an Improvement (QP-15/8.6). Feedback that does not proceed is retained as evidence of the evaluation decision.

---

## 1. Data Schema

_SharePoint List column definitions._

| Internal Name            | Data Type                                 | Required | Display Label                                         | Options / Default Value                                                                                                                                                |
| ------------------------ | ----------------------------------------- | -------- | ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `RecordID`               | Single Line Text                          | Yes      | ID #                                                  | Auto-generated `CMP{YY}{###}` (e.g., `CMP26001`), computed client-side by the app on submission. Read-only.                                                            |
| `Category`               | Choice                                    | Yes      | Category                                              | `Complaint`, `Feedback`                                                                                                                                                |
| `ReceivedThrough`        | Choice                                    | Yes      | Received Through                                      | `Phone`, `Email`, `Letter`, `Website`, `In-Person`                                                                                                                     |
| `ReceivedBy`             | Person                                    | Yes      | Received By (Personnel)                               | Current user (auto-populated)                                                                                                                                          |
| `ReceivedDate`           | Date                                      | Yes      | Date Received                                         | Today (auto-populated)                                                                                                                                                 |
| `SubmitterCompany`       | Single Line Text                          | Yes      | Company                                               | —                                                                                                                                                                      |
| `SubmitterContact`       | Single Line Text                          | No       | Contact Person                                        | —                                                                                                                                                                      |
| `SubmitterAddress`       | Multiple Lines                            | No       | Address                                               | —                                                                                                                                                                      |
| `SubmitterEmail`         | Single Line Text                          | No       | Email                                                 | —                                                                                                                                                                      |
| `SubmitterPhone`         | Single Line Text                          | No       | Phone                                                 | —                                                                                                                                                                      |
| `Description`            | Multiple Lines                            | Yes      | Description of Complaint / Feedback                   | Rich text. Free description of the event as received.                                                                                                                  |
| `IsValid`                | Choice                                    | Yes      | Is the information valid and reliable?                | `Yes`, `No`                                                                                                                                                            |
| `ValidityRationale`      | Multiple Lines                            | Yes      | Why? (from analysis)                                  | Justification for the validity decision.                                                                                                                               |
| `ValidatedBy`            | Person                                    | Yes      | Evaluated By (validity)                               | —                                                                                                                                                                      |
| `Proceeds`               | Choice                                    | Yes      | Does the complaint proceed?                           | `Yes`, `No`, `N/A (Feedback)`                                                                                                                                          |
| `ImpactAssessment`       | Multiple Lines                            | No       | Impact of the Complaint (incl. previous services)     | Required when `Proceeds == "Yes"`.                                                                                                                                     |
| `EvaluatedBy`            | Person                                    | Yes      | Performed By                                          | —                                                                                                                                                                      |
| `EvaluatorPosition`      | Single Line Text                          | Yes      | Position                                              | e.g., `Laboratory Manager`                                                                                                                                             |
| `EvaluationDate`         | Date                                      | Yes      | Date of Evaluation                                    | —                                                                                                                                                                      |
| `NCWRequired`            | Choice                                    | Yes      | Does this require a Nonconforming Work investigation? | `Yes`, `No`                                                                                                                                                            |
| `NCWRationale`           | Multiple Lines                            | Yes      | Why? (from analysis)                                  | Justification for the NCW/CA branching decision.                                                                                                                       |
| `NCWRef`                 | Lookup → `LS_QP1301r01_NonconformingWork` | No       | Nonconforming Work Report ID                          | `Not Applicable` if `NCWRequired == "No"`.                                                                                                                             |
| `CARef`                  | Lookup → `LS_QP1601r01_CorrectiveActions` | No       | Corrective Action Report ID                           | Linked if a CA is raised.                                                                                                                                              |
| `ClosingActions`         | Multiple Lines                            | No       | Actions Taken to Address the Complaint                | Numbered list of actions performed.                                                                                                                                    |
| `SubmitterNotified`      | Choice                                    | No       | Was the submitter notified of the outcome?            | `Yes`, `No`                                                                                                                                                            |
| `NotificationMeans`      | Choice                                    | No       | Means                                                 | `Phone`, `Email`, `Other`                                                                                                                                              |
| `NotificationMeansOther` | Single Line Text                          | No       | Means (other)                                         | Visible when `NotificationMeans == "Other"`.                                                                                                                           |
| `NotifiedBy`             | Person                                    | No       | Notified By / On                                      | —                                                                                                                                                                      |
| `AcknowledgementSent`    | Choice                                    | No       | Receipt acknowledged to complainant? (7.9.3)          | `Yes`, `No`, `N/A (anonymous)`                                                                                                                                         |
| `AcknowledgementDate`    | Date                                      | No       | Acknowledgement Date                                  | Timestamp receipt was acknowledged to the submitter.                                                                                                                   |
| `IndependentReviewer`    | Person                                    | No       | Outcome Reviewed/Approved By (independent)            | Individual **not involved in the original laboratory activities** who reviews/approves the outcome (7.9.6).                                                            |
| `IndependenceConfirmed`  | Choice                                    | No       | Independence confirmed?                               | `Yes – reviewer not involved in original work`, `No – single handler` (blocks closure until an independent reviewer is assigned).                                      |
| `RelatedSampleID`        | Single Line Text                          | No       | Related Sample ID                                     | Traceability.                                                                                                                                                          |
| `RelatedTestReport`      | Single Line Text                          | No       | Related Test Report #                                 | Traceability.                                                                                                                                                          |
| `RelatedMethodSOP`       | Lookup → `LS_QP1401r01_DocumentRegister`  | No       | Related Method / SOP                                  | Traceability.                                                                                                                                                          |
| `ImprovementRef`         | Lookup → `LS_QP1503r01_Improvement`       | No       | Improvement Raised                                    | Set when feedback/complaint is turned into an improvement opportunity (8.6.2).                                                                                         |
| `DueDate`                | Date                                      | No       | Target Resolution Date                                | Drives aging/escalation.                                                                                                                                               |
| `AgeDays`                | Calculated                                | No       | Age (days)                                            | `TODAY − ReceivedDate` while open. Read-only.                                                                                                                          |
| `EscalationState`        | Calculated Choice                         | No       | Escalation                                            | `On Track`, `Due Soon`, `Overdue`, `Escalated`.                                                                                                                        |
| `Status`                 | Choice                                    | Yes      | Status                                                | `New`, `Acknowledged`, `Under Evaluation`, `Proceeding – Investigation`, `Escalated to NCW`, `Escalated to CA`, `Closed – Justified`, `Closed – Resolved`, `Cancelled` |
| `MgrSignoff`             | Person                                    | No       | Laboratory Manager Sign-off                           | Captured at closing.                                                                                                                                                   |
| `QASignoff`              | Person                                    | No       | Quality Assurance Sign-off                            | Captured at closing.                                                                                                                                                   |
| `DirectorSignoff`        | Person                                    | No       | Laboratory Director Sign-off                          | Captured at closing.                                                                                                                                                   |
| **Record control**       | —                                         | —        | —                                                     | See common Record-Control block (retention, confidentiality, audit trail, e-signature) in `PlatformValidation_DataIntegrity` resources.                                |

> **Data Integrity Rule:** Once `Status` moves past `"Under Evaluation"`, the `Description` and `Category` fields become read-only to preserve the original record of what was received. Validity and proceed decisions, once signed, are appended rather than overwritten (version history retained).

---

## 2. Form Layout & Logic

### Section 01 – General Information

**Fields:** `Category`, `ReceivedThrough`, `RecordID`, `ReceivedBy`, `ReceivedDate`  
**Logic:** `RecordID`, `ReceivedBy`, and `ReceivedDate` are auto-populated and read-only. `Category` and `ReceivedThrough` render as radio buttons.

---

### Section 02 – Submitter

**Fields:** `SubmitterCompany`, `SubmitterContact`, `SubmitterAddress`, `SubmitterEmail`, `SubmitterPhone`  
**Logic:** Always active. If `Category == "Feedback"` and submission was anonymous, submitter fields may be left blank (guidance text: _"Complete as much submitter information as available; anonymous feedback is permitted."_).

---

### Section 03 – Description

**Fields:** `Description`  
**Logic:** Always active during intake. Becomes read-only after evaluation begins.  
**Guidance text:** _"Record the complaint or feedback exactly as received, including dates, references, and the nature of the concern."_

---

### Section 04 – Evaluation

**Fields:** `IsValid`, `ValidityRationale`, `ValidatedBy`, `Proceeds`, `ImpactAssessment`, `EvaluatedBy`, `EvaluatorPosition`, `EvaluationDate`  
**Logic 1:** `IsValid` and `Proceeds` render as radio buttons.  
**Logic 2:** IF `Proceeds == "Yes"`, THEN `ImpactAssessment` becomes mandatory and `Status` is set to `"Proceeding – Investigation"`.  
**Logic 3:** IF `Proceeds == "N/A (Feedback)"`, THEN hide `ImpactAssessment`; the record proceeds directly to Closing.

---

### Section 05 – Nonconforming Work & Corrective Actions

**Fields:** `NCWRequired`, `NCWRationale`, `NCWRef`, `CARef`  
**Logic 1:** `NCWRequired` renders as radio buttons with mandatory `NCWRationale`.  
**Logic 2:** IF `NCWRequired == "Yes"`, THEN display a **"Create NCW"** action button that pre-populates a new `LS_QP1301r01` record (bridging `RecordID`, `Description`, `ImpactAssessment`) and stores the returned ID in `NCWRef`; set `Status = "Escalated to NCW"`.  
**Logic 3:** IF a Corrective Action is raised (directly or via the linked NCW), store its ID in `CARef` and set `Status = "Escalated to CA"`.  
**Logic 4:** IF `NCWRequired == "No"`, `NCWRef` displays `Not Applicable`.

---

### Section 06 – Independence & Traceability _(7.9.6)_

**Fields:** `IndependentReviewer`, `IndependenceConfirmed`, `RelatedSampleID`, `RelatedTestReport`, `RelatedMethodSOP`  
**Logic 1 – Independence (7.9.6):** The outcome must be reviewed/approved by a person **not involved in the original laboratory activities** in question. `IndependentReviewer` must differ from the evaluators/handlers where the complaint concerns a test. IF `IndependenceConfirmed == "No – single handler"`, closure is blocked with the prompt: _"Assign an independent reviewer (not involved in the original work) to approve the outcome before closing."_  
**Logic 2 – Traceability:** Optional lookups link the complaint to the specific sample, test report, and method/SOP concerned.

---

### Section 07 – Improvement Feedback _(8.6.2)_

**Fields:** `ImprovementRef`  
**Logic:** For feedback (and complaints revealing improvement potential), offer **"Raise Improvement"** → creates a `LS_QP1503r01` OFI (`Source = "Customer Feedback"`) and stores it in `ImprovementRef`. Trend analysis of complaint/feedback categories feeds the Management Review (8.9.2 i/j).

---

### Section 08 – Acknowledgement, Aging & Closing

**Fields:** `AcknowledgementSent`, `AcknowledgementDate`, `ClosingActions`, `SubmitterNotified`, `NotificationMeans`, `NotificationMeansOther`, `NotifiedBy`, `DueDate`, `AgeDays`, `EscalationState`, `MgrSignoff`, `QASignoff`, `DirectorSignoff`  
**Logic 1 – Acknowledgement (7.9.3/7.9.5):** On creation for a non-anonymous submitter, Power Automate prompts/records `AcknowledgementSent` + `AcknowledgementDate` and sets `Status = "Acknowledged"`.  
**Logic 2:** IF `NotificationMeans == "Other"`, show `NotificationMeansOther`.  
**Logic 3:** Record cannot be set to `Closed – Resolved` until `ClosingActions` is populated, `SubmitterNotified == "Yes"` (unless `Category == "Feedback"`), and `IndependenceConfirmed == "Yes"` (for complaints).  
**Logic 4 – Aging:** `EscalationState = "Overdue"` when `DueDate < today` and not closed; escalates to QA.  
**Formatting:** Display `Status` with color coding – New (gray), Acknowledged (sky), Under Evaluation (blue), Proceeding (amber), Escalated to NCW/CA (red), Closed – Justified/Resolved (green), Cancelled (slate).

---

## 3. Roles & Permissions

| Role                      | Permission Level                             |
| ------------------------- | -------------------------------------------- |
| Customer Support          | Contribute (create, intake)                  |
| Laboratory Manager        | Contribute (create, edit) + Evaluate + Close |
| Quality Assurance Manager | Contribute + Approve/Sign-off                |
| Laboratory Analyst        | View                                         |
| Laboratory Director       | View + Sign-off                              |

**Approval Workflow:**

1. Complaint/feedback received → Customer Support or Lab Manager creates record → `Status = "New"` → Power Automate notifies Lab Manager and QA, records acknowledgement to submitter.
2. Lab Manager completes validity + proceed evaluation → `Status` updates per Section 04 logic.
3. IF NCW/CA required, records are branched and `Status` reflects escalation.
4. Independent reviewer approves outcome (7.9.6); closing actions completed, submitter notified, sign-offs captured → `Status = "Closed – Resolved"` (or `"Closed – Justified"` when the complaint does not proceed).

---

## 4. Integration Points

| Direction  | Target / Source                                                        | Details                                                                                                                                       |
| ---------- | ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Feeds into | `LS_QP1301r01_NonconformingWork`                                       | When `NCWRequired == "Yes"`, bridges `RecordID`, `Description`, and `ImpactAssessment` into a new NCW record; stores returned ID in `NCWRef`. |
| Feeds into | `LS_QP1601r01_CorrectiveActions`                                       | When a CA is raised from the complaint, links via `CARef`.                                                                                    |
| Feeds into | `LS_QP1503r01_Improvement`                                             | Feedback/complaint turned into an improvement opportunity (8.6.2) via `ImprovementRef`.                                                       |
| References | `LS_QP1401r01_DocumentRegister`                                        | Traceability lookup `RelatedMethodSOP`.                                                                                                       |
| Feeds into | `LS_QP1801r01_ManagementReview`                                        | Complaint volume/categories and outcomes are a management-review input (8.9.2 i/j).                                                           |
| Related    | `FM QP12.02 Customer Feedback Survey` / `FE QP12.02 Feedback Tracking` | Survey-sourced feedback is logged here with `ReceivedThrough == "Website"` or `"Email"`; tracking register is a downstream reporting view.    |
| Triggers   | Power Automate: _Complaint Intake Router_                              | On creation, notifies Lab Manager + QA and starts the SLA clock for acknowledgement.                                                          |
| Feeds into | Dashboard UI                                                           | Primary data source for the **Customer Relations** tab and the complaint metric cards.                                                        |
