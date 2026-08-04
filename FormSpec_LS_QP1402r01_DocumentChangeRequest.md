# Form Specification: Document Change Request (DCR)

**Master SOP:** QP-14 – Control of Management System Documents  
**Form ID:** LS_QP1402r01 _(digital successor to FM QP14.02 Document Change Request)_  
**Form Title:** Document Change Request  
**SharePoint List:** `LS_QP1402r01_ChangeRequests`  
**ISO/IEC 17025:2017 Reference:** Clause 8.3 – Control of Management System Documents (Option A)  
**Document Status:** Draft (rev. to match FM QP14.02 paper form)

**Purpose:** To request, review, approve, issue, and record the implementation of the creation, revision, or withdrawal of controlled documents. Modeled on the lab's actual FM QP14.02, a single DCR may govern a **batch of documents** changed together (e.g., a scheduled 2-year QMS revision cycle affecting the whole document set) or a single document. The form carries a **change driver** (linking the change to its Improvement / Preventive Action / Nonconforming Work origin), a **two-stage approval** (Technical + Quality Assurance), an **issuing checklist** (master-list update, removal of the prior revision, distribution), and a **document-implementation / training record** proving affected staff were briefed on the change. Every change to the Master List of Documents (`LS_QP1401r01`) originates here. This list drives the **Change Management (DCR)** tab.

---

## 1. Data Schema

### 1.1 Parent list — `LS_QP1402r01_ChangeRequests`

| Internal Name             | Data Type         | Required | Display Label                             | Options / Default Value                                                                                                                                                                       |
| ------------------------- | ----------------- | -------- | ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `DCRNumber`               | Single Line Text  | Yes      | DCR #                                     | Auto-generated `DCR-{YY}{###}` (e.g., `DCR-26001`). Read-only.                                                                                                                                |
| `RequestTitle`            | Single Line Text  | Yes      | Document / Request Title                  | Existing document (Title, ID, Rev) or, for new documents, the proposed title. For a batch, a description of the change set (e.g., _"Revision of the quality system for a 2-year period"_).    |
| `RequestType`             | Choice            | Yes      | Type of Request                           | `New Document`, `Revision`, `Withdrawal`                                                                                                                                                      |
| `ChangeDriver`            | Choice            | Yes      | Change Driver                             | `Improvement`, `Preventive Action`, `Nonconforming Work`, `Other`                                                                                                                             |
| `ChangeDriverOther`       | Single Line Text  | No       | Change Driver – Other                     | Visible when `ChangeDriver == "Other"` (e.g., _"Scheduled 2-year revision"_).                                                                                                                 |
| `SourceRef`               | Lookup (dynamic)  | No       | Source Record                             | Traceability link to the originating record: → `LS_QP1503r01_Improvement` (Improvement), `LS_QP1601r01_CorrectiveActions` (Preventive/Corrective), or `LS_QP1301r01_NonconformingWork` (NCW). |
| `RequestedBy`             | Person            | Yes      | Requested By                              | Current user (auto-populated).                                                                                                                                                                |
| `RequestDate`             | Date              | Yes      | Date of Request                           | Today (auto-populated).                                                                                                                                                                       |
| `ProposedChangeRationale` | Multiple Lines    | Yes      | Proposed Change and Rationale             | Description and justification of the change.                                                                                                                                                  |
| `TechDecision`            | Choice            | No       | Technical Decision                        | `Approved`, `Rejected`, `Approved with Conditions`                                                                                                                                            |
| `TechComments`            | Multiple Lines    | No       | Technical Comments                        | Mandatory if `Rejected` or `Approved with Conditions`.                                                                                                                                        |
| `TechApprover`            | Person            | No       | Technical Approver                        | Read-only after sign.                                                                                                                                                                         |
| `TechApprovalDate`        | Date              | No       | Technical Approval Date                   | Read-only.                                                                                                                                                                                    |
| `QADecision`              | Choice            | No       | Quality Assurance Decision                | `Approved`, `Rejected`, `Approved with Conditions`                                                                                                                                            |
| `QAComments`              | Multiple Lines    | No       | QA Comments                               | Mandatory if `Rejected` or `Approved with Conditions`.                                                                                                                                        |
| `QAApprover`              | Person            | No       | QA Approver                               | Read-only after sign.                                                                                                                                                                         |
| `QAApprovalDate`          | Date              | No       | QA Approval Date                          | Read-only.                                                                                                                                                                                    |
| `IssueMasterListUpdated`  | Choice            | No       | Issuing – Update Master List of Documents | `Completed`, `N/A`                                                                                                                                                                            |
| `IssueRemovePrevRev`      | Choice            | No       | Issuing – Remove Previous Revision        | `Completed`, `N/A`                                                                                                                                                                            |
| `IssueDistributeNewRev`   | Choice            | No       | Issuing – Distribute New Revision         | `Completed`, `N/A`                                                                                                                                                                            |
| `IssuedBy`                | Person            | No       | Issued / Distributed By                   | QA performing the issuing checklist.                                                                                                                                                          |
| `IssueDate`               | Date              | No       | Issue Date                                | —                                                                                                                                                                                             |
| `ImplResponsible`         | Person            | No       | Implementation Responsible                | —                                                                                                                                                                                             |
| `ImplScheduledDate`       | Date              | No       | Implementation Scheduled Date             | —                                                                                                                                                                                             |
| `ImplActualDate`          | Date              | No       | Implementation Actual Date                | —                                                                                                                                                                                             |
| `ImplComments`            | Multiple Lines    | No       | Implementation Comments                   | —                                                                                                                                                                                             |
| `Implementer`             | Person            | No       | Implementer Sign-off                      | —                                                                                                                                                                                             |
| `Supervisor`              | Person            | No       | Supervisor Sign-off                       | —                                                                                                                                                                                             |
| `Stage`                   | Choice            | Yes      | Stage                                     | `Draft`, `Technical Review`, `QA Review`, `Approved – Pending Issue`, `Issued`, `Implementation`, `Closed`, `Rejected`                                                                        |
| `DueDate`                 | Date              | No       | Target Completion Date                    | Drives aging/escalation (see §2.7).                                                                                                                                                           |
| `AgeDays`                 | Calculated        | No       | Age (days)                                | `TODAY − RequestDate` while open. Read-only.                                                                                                                                                  |
| `EscalationState`         | Calculated Choice | No       | Escalation                                | `On Track`, `Due Soon`, `Overdue`, `Escalated`.                                                                                                                                               |
| **Record control**        | —                 | —        | —                                         | See common Record-Control block (retention, confidentiality, audit trail, e-signature) in `PlatformValidation_DataIntegrity` resources.                                                       |

### 1.2 Child list — `LS_QP1402r01a_AffectedDocuments` _(Deliverables / effect on other documents)_

| Internal Name    | Data Type                                | Required | Display Label           | Options / Default Value                                                                       |
| ---------------- | ---------------------------------------- | -------- | ----------------------- | --------------------------------------------------------------------------------------------- |
| `DCRRef`         | Lookup → `LS_QP1402r01_ChangeRequests`   | Yes      | Parent DCR              | —                                                                                             |
| `DocRef`         | Lookup → `LS_QP1401r01_DocumentRegister` | No       | Document                | Existing document affected; blank for a brand-new document.                                   |
| `DocName`        | Single Line Text                         | Yes      | Name and Identification | Title + ID (e.g., `QM – ISO/IEC 17025:2017 Quality Manual`, `FM QP16.04 Five Whys Analysis`). |
| `Action`         | Choice                                   | Yes      | Action                  | `Create`, `Revise`, `Withdraw`                                                                |
| `TargetRevision` | Single Line Text                         | Yes      | Revision                | Target revision (e.g., `03`).                                                                 |
| `ScheduledDate`  | Date                                     | Yes      | Scheduled Date          | —                                                                                             |
| `ActualDate`     | Date                                     | No       | Actual Date             | Completion date for that document.                                                            |

### 1.3 Child list — `LS_QP1402r01b_ImplementationAttendants` _(training / awareness record)_

| Internal Name      | Data Type                              | Required | Display Label              | Options / Default Value                         |
| ------------------ | -------------------------------------- | -------- | -------------------------- | ----------------------------------------------- |
| `DCRRef`           | Lookup → `LS_QP1402r01_ChangeRequests` | Yes      | Parent DCR                 | —                                               |
| `Attendant`        | Person                                 | Yes      | Attendant                  | Staff briefed on / trained in the change.       |
| `Position`         | Single Line Text                       | Yes      | Position                   | —                                               |
| `AcknowledgedDate` | Date                                   | No       | Acknowledged / Signed Date | E-signature = attendant's `Person` + timestamp. |

> **Data Integrity Rule:** `RequestType`, `ChangeDriver`, `RequestTitle`, and the affected-documents list lock after `Stage` moves past `"Technical Review"`. A DCR cannot reach `"Issued"` without both `TechDecision` and `QADecision == "Approved"` (or `"Approved with Conditions"` with resolved conditions). The register (`LS_QP1401r01`) is updated only when the issuing checklist is completed.

---

## 2. Form Layout & Logic

### 2.1 Section 01 – Requester

**Fields:** `RequestTitle`, `RequestType`, `ChangeDriver`, `ChangeDriverOther`, `SourceRef`, `RequestedBy`, `RequestDate`, `ProposedChangeRationale`  
**Logic 1:** `RequestType` and `ChangeDriver` render as radio buttons.  
**Logic 2:** IF `ChangeDriver == "Nonconforming Work"` → `SourceRef` filters to open NCW records; `"Preventive Action"` → CA records; `"Improvement"` → OFI records. This makes every document change traceable to its trigger and satisfies the CA obligation to "make changes to the management system" (8.7.1 f).  
**Logic 3:** IF `ChangeDriver == "Other"`, show `ChangeDriverOther`.

---

### 2.2 Section 02 – Deliverables & Affected Documents _(grid — child list 1.2)_

**Fields:** per row: `DocName`, `DocRef`, `Action`, `TargetRevision`, `ScheduledDate`, `ActualDate`  
**Logic:** Supports a single document or a **batch** (many rows). Each row auto-suggests `TargetRevision` (current + 1) from `DocRef`. Overdue rows (`ScheduledDate < today`, no `ActualDate`) flagged. On issue, each row becomes a create/revise/withdraw operation on the register.

---

### 2.3 Section 03 – Technical Reviewing & Approval

**Fields:** `TechDecision`, `TechComments`, `TechApprover`, `TechApprovalDate`  
**Logic:** `TechDecision` radio (Approved / Rejected / Approved with Conditions). `Rejected` / `Approved with Conditions` require `TechComments`. Sign stamps `TechApprover` + date.

---

### 2.4 Section 04 – Quality Assurance Reviewing & Approval

**Fields:** `QADecision`, `QAComments`, `QAApprover`, `QAApprovalDate`  
**Logic:** Same pattern as Technical. Both approvals required before issue.

---

### 2.5 Section 05 – Issuing of Document _(checklist)_

**Fields:** `IssueMasterListUpdated`, `IssueRemovePrevRev`, `IssueDistributeNewRev`, `IssuedBy`, `IssueDate`  
**Logic:** Each checklist item is `Completed` / `N/A` with QA/distributed-to sign-off. Completing the checklist triggers the register update (create/revise/supersede/obsolete per affected-document rows) — replacing the paper FM QP14.01 Document Distribution log.

---

### 2.6 Section 06 – Document Implementation _(training/awareness — grid child list 1.3)_

**Fields:** `ImplResponsible`, `ImplScheduledDate`, `ImplActualDate`, attendants grid (`Attendant`, `Position`, `AcknowledgedDate`), `ImplComments`, `Implementer`, `Supervisor`  
**Logic:** Records that affected personnel were briefed/trained on the change (closes the "communication of changed procedures" expectation, 8.3/6.2). `Stage = "Closed"` requires `ImplActualDate` and at least the required attendants acknowledged (configurable).

---

### 2.7 Aging & Escalation _(cross-cutting)_

**Fields:** `DueDate`, `AgeDays`, `EscalationState`  
**Logic:** `EscalationState` = `Overdue` when `DueDate < today` and `Stage` not `Closed`/`Rejected`; `Due Soon` within N days; Power Automate escalates overdue DCRs to QA. Surfaced on the dashboard "Pending DCRs" card.  
**Formatting:** `Stage` color coding – Draft (gray), Technical/QA Review (orange), Approved (indigo), Issued (blue), Implementation (amber), Closed (green), Rejected (red).

---

## 3. Roles & Permissions

| Role                      | Permission Level                                              |
| ------------------------- | ------------------------------------------------------------- |
| Laboratory Analyst        | Contribute (create request)                                   |
| Laboratory Manager        | Contribute + Technical Review/Approve                         |
| Quality Assurance Manager | Contribute + QA Approve + Issue (applies changes to register) |
| Laboratory Director       | Approve (Policies/Manuals)                                    |

**Approval Workflow:**

1. Requester submits DCR (single or batch) → `Stage = "Technical Review"`.
2. Technical approver decides → `Stage = "QA Review"`.
3. QA approves → `Stage = "Approved – Pending Issue"` → issuing checklist completed → `Stage = "Issued"` (register updated).
4. Implementation/training recorded → `Stage = "Closed"`. Rejection at either stage → `Stage = "Rejected"` with mandatory comments.

---

## 4. Integration Points

| Direction     | Target / Source                                                                                                                                               | Details                                                                                                                 |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Receives from | `LS_QP1601r01_CorrectiveActions`                                                                                                                              | CA "make changes to management system" (8.7.1 f) raises a DCR (`ChangeDriver = "Preventive Action"`, `SourceRef` link). |
| Receives from | `LS_QP1301r01_NonconformingWork`                                                                                                                              | NCW-driven document changes (`ChangeDriver = "Nonconforming Work"`).                                                    |
| Receives from | `LS_QP1503r01_Improvement`                                                                                                                                    | Improvement-driven changes (`ChangeDriver = "Improvement"`).                                                            |
| Feeds into    | `LS_QP1401r01_DocumentRegister`                                                                                                                               | On issuing, creates/revises/withdraws each affected-document record; supersedes prior revisions.                        |
| Triggers      | Power Automate: _Register Update on Issue_ + _Overdue Escalation_; DCR numbering is computed client-side by the app on submission (not a Power Automate flow) | —                                                                                                                       |
| Feeds into    | Dashboard UI                                                                                                                                                  | Data source for the **Change Management** tab and "Pending DCRs" metric card.                                           |
