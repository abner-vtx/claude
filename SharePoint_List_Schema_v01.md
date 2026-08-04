# SharePoint List Schema — Creation Reference

**Purpose:** A flattened, creation-focused companion to `Form_Specs/*.md`. Where the Form Specs explain *why* a field exists (clause, workflow logic, roles), this document exists purely to answer *"what do I click when creating this list in SharePoint?"* — every list, every column, its type, whether it's required, and its settings/default value, in one place.

**Source of truth:** `Form_Specs/*.md` (12 form specs + 2 SOP support-list specs) and `Form_Specs/PlatformValidation_DataIntegrity_v01.md` Appendix A (Record-Control block). If this document and a Form Spec ever disagree, the Form Spec wins — re-sync this file.

**Scope:** 28 lists total — 12 main record lists, 13 child lists, 1 reference/template list, 2 S2 support lists.

---

## 0. Shared pattern — the Record-Control block

Per `PlatformValidation_DataIntegrity_v01.md` Appendix A, every **main record list** (not child lists, except where noted) gets this column set added, plus the list-level settings below. It's written once here; each list section just says **"+ Record-Control block."**

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `RetentionPeriod` | Choice | No | Retention Period | e.g., `6 years`, `Per accreditation cycle`, `Permanent` — set per record type per QP-14. |
| `ConfidentialityClass` | Choice | Yes | Confidentiality | `Public`, `Internal`, `Customer-Confidential` — drives permissions (4.2). Default `Internal`. |
| `ApprovedBy` | Person | No | Approved / Signed By | The explicit e-signature action — distinct from `Modified By`. Captured on a deliberate approve/sign step, not on every edit. |
| `ApprovedDate` | Date | No | Approved / Signed Date | Paired with `ApprovedBy`. |
| `SignatureMeaning` | Choice | No | Signature Meaning | `Reviewed`, `Approved`, `Authorized` — what the signature attests to. |

**List-level settings (apply to every main list):**
- **Versioning:** On (major versions), version history retention ≥ the list's retention period.
- **Amendment rule:** Fields lock (read-only via permissions/flow) after the signature step recorded in `ApprovedBy`/`ApprovedDate`; further changes create a new version with a reason, never overwrite.
- **Attachments:** Enabled where a spec calls for `Attachment / Hyperlink` columns.

---

## 0.1 Implementation corrections (post-review — apply these instead of the literal Form Spec wording)

Three patterns recur across multiple lists where the Form Specs describe *intent* rather than an actual SharePoint feature. Fixed once here; every affected field below is annotated at its actual location.

### a) "Dynamic" lookups don't exist in SharePoint — split into parallel typed lookups

A native Lookup column is locked to one target list at creation time. Three fields were specified as pointing to a *different* list depending on another field's value — that's not buildable as one column. Fix: replace each with **one real Lookup column per possible target**, only one populated per record:

| Original field | List | Becomes |
|---|---|---|
| `SourceRef` | `LS_QP1402r01_ChangeRequests` (DCR) | `SourceRefOFI` (→ `LS_QP1503r01_Improvement`), `SourceRefCA` (→ `LS_QP1601r01_CorrectiveActions`), `SourceRefNCW` (→ `LS_QP1301r01_NonconformingWork`) |
| `SourceRef` | `LS_QP1501r01_ActionPlans` (Risks) | `SourceRefFinding` (→ `LS_QP1703r01a_Findings`), `SourceRefComplaint` (→ `LS_QP1201r01_Complaints`), `SourceRefNCW` (→ `LS_QP1301r01_NonconformingWork`), `SourceRefCA` (→ `LS_QP1601r01_CorrectiveActions`) |
| `LinkedRecordRef` | `LS_QP1801r01b_ReviewOutputs` (Mgmt Review) | `LinkedRecordRefCA` (→ `LS_QP1601r01_CorrectiveActions`), `LinkedRecordRefDCR` (→ `LS_QP1402r01_ChangeRequests`), `LinkedRecordRefRisk` (→ `LS_QP1501r01_ActionPlans`), `LinkedRecordRefOFI` (→ `LS_QP1503r01_Improvement`) |

The app shows/hides the relevant one of the set based on the record's driver/category field (`ChangeDriver`, `Source`, `OutputCategory`).

### b) `TODAY()`-based fields are not stored SharePoint columns — compute them in the app

SharePoint's native Calculated column type only recalculates when the item itself is edited — a formula like `TODAY() − ReceivedDate` goes stale for any record nobody touches, which defeats the point of an aging/escalation indicator. Same root problem applies to rollup counts (`ConformCount` etc.) — SharePoint has no native rollup-across-child-list column type either. Fix: **don't create these as SharePoint columns at all.** The app computes them at render time from the real stored fields it already has (`ReceivedDate`/`DueDate`, or a live count of child-list rows). They're listed below only so their meaning is documented, marked `— (app-computed)` in place of a SharePoint data type.

### c) `Attachment / Hyperlink` was ambiguous — resolved per field

SharePoint has two distinct mechanisms: **native list Attachments** (the paperclip icon, a list-wide toggle, no dedicated column — for open-ended/variable supporting evidence) vs. a **Hyperlink or Picture column** (a real, named column pointing at one specific file in a document library — for a single identifiable document). Each field below is now marked with the actual mechanism to use.

---

## 1. S1 · Dashboard & Governance

### 1.1 `LS_QP1801r01_ManagementReview` *(one record per review)*

+ Record-Control block (§0)

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ReviewID` | Single Line Text | Yes | Review # | `MR-{YY}-{##}` (e.g., `MR-26-01`) — computed client-side by the app: query the current max sequence number for the year, +1, written on save. Read-only in the UI. |
| `ReviewType` | Choice | Yes | Review Type | `Scheduled`, `Ad-hoc` |
| `ReviewDate` | Date | Yes | Review Date | — |
| `PeriodCoveredFrom` | Date | Yes | Period Covered – From | — |
| `PeriodCoveredTo` | Date | Yes | Period Covered – To | — |
| `Chair` | Person | Yes | Chair (Top Management) | Typically Laboratory Director. |
| `Attendees` | Person (multi) | Yes | Attendees | — |
| `QACoordinator` | Person | Yes | QA Coordinator | — |
| `SummaryConclusions` | Multiple Lines | No | Suitability/Adequacy/Effectiveness Conclusion | — |
| `MinutesDocRef` | Hyperlink or Picture | No | Signed Minutes (Word/PDF) | Points to the one auto-generated file in the controlled document library — see §0.1c. |
| `Status` | Choice | Yes | Status | `Planned`, `Inputs Compiled`, `In Meeting`, `Actions Open`, `Closed` |

**Settings:** `ReviewID` should be set **Enforce unique values**. Indexed columns: `Status`, `ReviewDate`.

#### Child — `LS_QP1801r01a_ReviewInputs` *(15 fixed rows per review, 8.9.2 a–o)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ReviewRef` | Lookup → `LS_QP1801r01_ManagementReview` | Yes | Parent Review | — |
| `InputCategory` | Choice | Yes | Input (8.9.2) | 15 fixed values `a)`–`o)` — see spec for full text |
| `DataSummary` | Multiple Lines | Yes | Data / Metric Summary | — |
| `SourceLink` | Multiple Lines / Lookup | No | Source Records | — |
| `Discussion` | Multiple Lines | No | Discussion / Notes | — |

#### Child — `LS_QP1801r01b_ReviewOutputs` *(decisions & actions, 8.9.3)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ReviewRef` | Lookup → `LS_QP1801r01_ManagementReview` | Yes | Parent Review | — |
| `OutputCategory` | Choice | Yes | Output Relates To | `Effectiveness of the management system & processes`, `Improvement of laboratory activities`, `Provision of resources`, `Need for change` |
| `DecisionAction` | Multiple Lines | Yes | Decision / Action | — |
| `Responsible` | Person | Yes | Responsible | — |
| `DueDate` | Date | Yes | Due Date | — |
| `LinkedRecordRefCA` | Lookup → `LS_QP1601r01_CorrectiveActions` | No | Linked Corrective Action | See §0.1a — only one of these 4 populated per row. |
| `LinkedRecordRefDCR` | Lookup → `LS_QP1402r01_ChangeRequests` | No | Linked Document Change Request | — |
| `LinkedRecordRefRisk` | Lookup → `LS_QP1501r01_ActionPlans` | No | Linked Risk / Opportunity Action | — |
| `LinkedRecordRefOFI` | Lookup → `LS_QP1503r01_Improvement` | No | Linked Improvement | — |
| `ActionStatus` | Choice | Yes | Status | `Open`, `In Progress`, `Closed` |
| `ClosedDate` | Date | No | Closed Date | — |

---

## 2. S2 · Document Control & Compliance Map

### 2.1 `LS_QP1401r01_DocumentRegister`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `DocID` | Single Line Text | Yes | Document ID | Unique. Per QP-14 §5.5 (e.g., `QP-14`, `LP-01`, `FM QP16.01`). |
| `Title` | Single Line Text | Yes | Title | — |
| `DocType` | Choice | Yes | Type of Document | `Policy`, `Quality Manual`, `Quality Management Procedure (QP)`, `Laboratory Procedure (LP)`, `Equipment Use Procedure (EP)`, `Quick Reference Guide (QRG)`, `Method of Analysis (TM/MOA)`, `Calculation Spreadsheet (SP)`, `Program (PM)`, `Form (FM)`, `Electronic Form (FE)`, `Logbook (LBK)` |
| `Tier` | Choice | Yes | Hierarchy Tier | `Tier 1 – Policies`, `Tier 2 – Manuals`, `Tier 3 – SOPs/Procedures`, `Tier 4 – Forms/Records` |
| `Department` | Choice | Yes | Department | `QA`, `Chemistry`, `Microbiology`, `Management`, `All` |
| `Revision` | Single Line Text | Yes | Revision / Version | Starts `01`. |
| `Status` | Choice | Yes | Status | `Draft`, `Under Review`, `Approved / Effective`, `Superseded`, `Obsolete` |
| `EffectiveDate` | Date | No | Effective Date | Set on approval. |
| `NextRevisionDate` | Date | No | Next Revision Date | — |
| `TemplateUsed` | Choice | No | Template Used | `TMP-SOP`, `TMP-FM`, `TMP-TM`, `N/A` |
| `Owner` | Person | Yes | Document Owner | — |
| `ApprovedBy` | Person | No | Approved By | *(also present via §0 — same field, don't duplicate)* |
| `ParentDocID` | Lookup → self | No | Parent Document | Self-lookup, builds hierarchy tree. |
| `RelatedDocs` | Lookup (multi) → self | No | Related Documents | — |
| `DistributionLocation` | Multiple Lines | No | Distribution / Storage Location | — |
| `IsExternal` | Yes/No | No | External Document? | Default `No`. |
| `ExternalSource` | Single Line Text | No | External Source / Issuer | Required if `IsExternal == Yes`. |
| `FileRef` | Hyperlink or Picture | No | Controlled File | Points to the one approved master file in a document library — see §0.1c. |
| `LinkedDCR` | Lookup → `LS_QP1402r01_ChangeRequests` | No | Originating / Last DCR | Read-only. |

**Settings:** `DocID` should be set **Enforce unique values**. Indexed columns: `Status`, `DocType`, `Tier`, `ParentDocID`. Direct edits to `DocID`/`Revision`/`Status`/`EffectiveDate` should be blocked outside the DCR workflow (permission/flow enforced, not a native column setting).

### 2.2 `LS_QP1402r01_ChangeRequests`

+ Record-Control block (§0)

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `DCRNumber` | Single Line Text | Yes | DCR # | `DCR-{YY}{###}` — computed client-side by the app: query the current max sequence number for the year, +1, written on save. Read-only in the UI. |
| `RequestTitle` | Single Line Text | Yes | Document / Request Title | — |
| `RequestType` | Choice | Yes | Type of Request | `New Document`, `Revision`, `Withdrawal` |
| `ChangeDriver` | Choice | Yes | Change Driver | `Improvement`, `Preventive Action`, `Nonconforming Work`, `Other` |
| `ChangeDriverOther` | Single Line Text | No | Change Driver – Other | Visible when `ChangeDriver == "Other"`. |
| `SourceRefOFI` | Lookup → `LS_QP1503r01_Improvement` | No | Source Improvement | See §0.1a — only one of these 3 populated per row, based on `ChangeDriver`. |
| `SourceRefCA` | Lookup → `LS_QP1601r01_CorrectiveActions` | No | Source Corrective Action | — |
| `SourceRefNCW` | Lookup → `LS_QP1301r01_NonconformingWork` | No | Source Nonconforming Work | — |
| `RequestedBy` | Person | Yes | Requested By | Auto-populated. |
| `RequestDate` | Date | Yes | Date of Request | Auto-populated (today). |
| `ProposedChangeRationale` | Multiple Lines | Yes | Proposed Change and Rationale | — |
| `TechDecision` | Choice | No | Technical Decision | `Approved`, `Rejected`, `Approved with Conditions` |
| `TechComments` | Multiple Lines | No | Technical Comments | Mandatory if Rejected/Conditions. |
| `TechApprover` | Person | No | Technical Approver | Read-only after sign. |
| `TechApprovalDate` | Date | No | Technical Approval Date | Read-only. |
| `QADecision` | Choice | No | Quality Assurance Decision | `Approved`, `Rejected`, `Approved with Conditions` |
| `QAComments` | Multiple Lines | No | QA Comments | Mandatory if Rejected/Conditions. |
| `QAApprover` | Person | No | QA Approver | Read-only after sign. |
| `QAApprovalDate` | Date | No | QA Approval Date | Read-only. |
| `IssueMasterListUpdated` | Choice | No | Issuing – Update Master List | `Completed`, `N/A` |
| `IssueRemovePrevRev` | Choice | No | Issuing – Remove Previous Revision | `Completed`, `N/A` |
| `IssueDistributeNewRev` | Choice | No | Issuing – Distribute New Revision | `Completed`, `N/A` |
| `IssuedBy` | Person | No | Issued / Distributed By | — |
| `IssueDate` | Date | No | Issue Date | — |
| `ImplResponsible` | Person | No | Implementation Responsible | — |
| `ImplScheduledDate` | Date | No | Implementation Scheduled Date | — |
| `ImplActualDate` | Date | No | Implementation Actual Date | — |
| `ImplComments` | Multiple Lines | No | Implementation Comments | — |
| `Implementer` | Person | No | Implementer Sign-off | — |
| `Supervisor` | Person | No | Supervisor Sign-off | — |
| `Stage` | Choice | Yes | Stage | `Draft`, `Technical Review`, `QA Review`, `Approved – Pending Issue`, `Issued`, `Implementation`, `Closed`, `Rejected` |
| `DueDate` | Date | No | Target Completion Date | — |
| `AgeDays` | — (app-computed, see §0.1b) | No | Age (days) | `TODAY − RequestDate` while open. Not a stored column. |
| `EscalationState` | — (app-computed, see §0.1b) | No | Escalation | `On Track`, `Due Soon`, `Overdue`, `Escalated`. Not a stored column. |

**Settings:** `DCRNumber` should be set **Enforce unique values**. Indexed columns: `Stage`, `DueDate`.

#### Child — `LS_QP1402r01a_AffectedDocuments`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `DCRRef` | Lookup → `LS_QP1402r01_ChangeRequests` | Yes | Parent DCR | — |
| `DocRef` | Lookup → `LS_QP1401r01_DocumentRegister` | No | Document | Blank for a brand-new document. |
| `DocName` | Single Line Text | Yes | Name and Identification | — |
| `Action` | Choice | Yes | Action | `Create`, `Revise`, `Withdraw` |
| `TargetRevision` | Single Line Text | Yes | Revision | — |
| `ScheduledDate` | Date | Yes | Scheduled Date | — |
| `ActualDate` | Date | No | Actual Date | — |

#### Child — `LS_QP1402r01b_ImplementationAttendants`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `DCRRef` | Lookup → `LS_QP1402r01_ChangeRequests` | Yes | Parent DCR | — |
| `Attendant` | Person | Yes | Attendant | — |
| `Position` | Single Line Text | Yes | Position | — |
| `AcknowledgedDate` | Date | No | Acknowledged / Signed Date | — |

### 2.3 `LS_SOPProcessSteps`

| Internal Name | Data Type | Required | Display Label | Options / Notes |
|---|---|---|---|---|
| `SOPRef` | Lookup → `LS_QP1401r01_DocumentRegister` (`DocID`) | Yes | SOP | — |
| `StepNumber` | Single Line Text | Yes | Step # | e.g. `5.1`, `8.3`. |
| `StepTitle` | Single Line Text | Yes | Step Title | — |
| `StepOrder` | Number | Yes | Order | Sort sequence within SOP. |
| `StepSummary` | Multiple Lines | No | Summary | — |
| `FormsReferenced` | Multiple Lines | No | Forms | Form/record IDs, semicolon-separated. |
| `ResponsibleRole` | Choice | No | Responsible | `Laboratory Director`, `Laboratory Manager`, `Quality Assurance Manager`, `Laboratory Analyst`, `Customer Support`, `Personnel` |
| `ClauseRef` | Single Line Text | No | ISO Clause | Not yet populated. |
| `Notes` | Multiple Lines | No | Notes | — |

**Settings:** Indexed column: `SOPRef` (filtered by SOP on every SOP-viewer load). Seed from `SOP_Data/ProcessSteps_seed.csv` (209 rows).

### 2.4 `LS_SOPRelationships`

| Internal Name | Data Type | Required | Display Label | Options / Notes |
|---|---|---|---|---|
| `SourceSOP` | Lookup → `LS_QP1401r01_DocumentRegister` (`DocID`) | Yes | Source | — |
| `TargetSOP` | Lookup → `LS_QP1401r01_DocumentRegister` (`DocID`) | Yes | Target | — |
| `RelationshipType` | Choice | Yes | Type | `Governs`, `Governed by`, `References` (default), `Feeds into`, `Uses form` |
| `MentionCount` | Number | No | Weight | Edge thickness. |
| `Description` | Multiple Lines | No | Description | — |
| `Directional` | Yes/No | No | Directional | Default `Yes`. |

**Settings:** Seed from `SOP_Data/SOPRelationships_seed.csv` (53 edges). Node styling comes from the register (`DocType`/`Tier`), not this list.

---

## 3. S3 · Quality Operations

### 3.1 `LS_QP1201r01_Complaints`

+ Record-Control block (§0)

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `RecordID` | Single Line Text | Yes | ID # | `CMP{YY}{###}` — computed client-side by the app: query the current max sequence number for the year, +1, written on save. Read-only in the UI. |
| `Category` | Choice | Yes | Category | `Complaint`, `Feedback` |
| `ReceivedThrough` | Choice | Yes | Received Through | `Phone`, `Email`, `Letter`, `Website`, `In-Person` |
| `ReceivedBy` | Person | Yes | Received By | Auto-populated. |
| `ReceivedDate` | Date | Yes | Date Received | Auto-populated (today). |
| `SubmitterCompany` | Single Line Text | Yes | Company | — |
| `SubmitterContact` | Single Line Text | No | Contact Person | — |
| `SubmitterAddress` | Multiple Lines | No | Address | — |
| `SubmitterEmail` | Single Line Text | No | Email | — |
| `SubmitterPhone` | Single Line Text | No | Phone | — |
| `Description` | Multiple Lines | Yes | Description of Complaint / Feedback | Rich text. |
| `IsValid` | Choice | Yes | Is the information valid and reliable? | `Yes`, `No` |
| `ValidityRationale` | Multiple Lines | Yes | Why? (from analysis) | — |
| `ValidatedBy` | Person | Yes | Evaluated By (validity) | — |
| `Proceeds` | Choice | Yes | Does the complaint proceed? | `Yes`, `No`, `N/A (Feedback)` |
| `ImpactAssessment` | Multiple Lines | No | Impact of the Complaint | Required when `Proceeds == "Yes"`. |
| `EvaluatedBy` | Person | Yes | Performed By | — |
| `EvaluatorPosition` | Single Line Text | Yes | Position | — |
| `EvaluationDate` | Date | Yes | Date of Evaluation | — |
| `NCWRequired` | Choice | Yes | Requires NCW investigation? | `Yes`, `No` |
| `NCWRationale` | Multiple Lines | Yes | Why? (from analysis) | — |
| `NCWRef` | Lookup → `LS_QP1301r01_NonconformingWork` | No | NCW Report ID | `Not Applicable` if `NCWRequired == "No"`. |
| `CARef` | Lookup → `LS_QP1601r01_CorrectiveActions` | No | Corrective Action Report ID | — |
| `ClosingActions` | Multiple Lines | No | Actions Taken to Address the Complaint | — |
| `SubmitterNotified` | Choice | No | Submitter notified of outcome? | `Yes`, `No` |
| `NotificationMeans` | Choice | No | Means | `Phone`, `Email`, `Other` |
| `NotificationMeansOther` | Single Line Text | No | Means (other) | Visible when `Other`. |
| `NotifiedBy` | Person | No | Notified By / On | — |
| `AcknowledgementSent` | Choice | No | Receipt acknowledged? (7.9.3) | `Yes`, `No`, `N/A (anonymous)` |
| `AcknowledgementDate` | Date | No | Acknowledgement Date | — |
| `IndependentReviewer` | Person | No | Outcome Reviewed/Approved By (independent) | 7.9.6. |
| `IndependenceConfirmed` | Choice | No | Independence confirmed? | `Yes – reviewer not involved in original work`, `No – single handler` |
| `RelatedSampleID` | Single Line Text | No | Related Sample ID | — |
| `RelatedTestReport` | Single Line Text | No | Related Test Report # | — |
| `RelatedMethodSOP` | Lookup → `LS_QP1401r01_DocumentRegister` | No | Related Method / SOP | — |
| `ImprovementRef` | Lookup → `LS_QP1503r01_Improvement` | No | Improvement Raised | — |
| `DueDate` | Date | No | Target Resolution Date | — |
| `AgeDays` | — (app-computed, see §0.1b) | No | Age (days) | `TODAY − ReceivedDate` while open. Not a stored column. |
| `EscalationState` | — (app-computed, see §0.1b) | No | Escalation | `On Track`, `Due Soon`, `Overdue`, `Escalated`. Not a stored column. |
| `Status` | Choice | Yes | Status | `New`, `Acknowledged`, `Under Evaluation`, `Proceeding – Investigation`, `Escalated to NCW`, `Escalated to CA`, `Closed – Justified`, `Closed – Resolved`, `Cancelled` |
| `MgrSignoff` | Person | No | Laboratory Manager Sign-off | — |
| `QASignoff` | Person | No | Quality Assurance Sign-off | — |
| `DirectorSignoff` | Person | No | Laboratory Director Sign-off | — |

**Settings:** `RecordID` should be set **Enforce unique values**. Indexed columns: `Status`, `DueDate`, `NCWRef`, `CARef`.

### 3.2 `LS_QP1301r01_NonconformingWork`

+ Record-Control block (§0)

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `RecordID` | Single Line Text | Yes | Nonconformance # | `NC{YY}{###}` — computed client-side by the app: query the current max sequence number for the year, +1, written on save. Read-only in the UI. |
| `ReportedBy` | Person | Yes | Reported / Recorded By | Auto-populated. |
| `ReportedDate` | Date | Yes | Date | Auto-populated. |
| `ExternallyDetected` | Yes/No | Yes | Externally Detected? | Default `No`. |
| `ExtReportedBy` | Single Line Text | No | External – Reported By | Required if `ExternallyDetected == Yes`. |
| `ExtReporterEmail` | Single Line Text | No | External – Email | — |
| `ExtDateReported` | Date | No | External – Date Reported | — |
| `ExtCompany` | Single Line Text | No | External – Company | — |
| `ExtAddress` | Multiple Lines | No | External – Address | — |
| `NCCategory` | Choice (multi-select) | Yes | Category of the Nonconformance | `Procedural`, `Instrumentation & Equipment`, `Documentation & Record Keeping`, `Sample Handling`, `Personnel Training & Competence`, `Quality Control`, `Environmental Conditions`, `Reporting Errors (Test Reports)`, `Supplier Related`, `Safety`, `Other` |
| `NCCategoryOther` | Single Line Text | No | Category – Other | — |
| `RelatedSample` | Single Line Text | No | Related Sample | Default `N/A`. |
| `InternalID` | Single Line Text | No | Internal ID # | — |
| `TestReportNo` | Single Line Text | No | Test Report # | — |
| `Description` | Multiple Lines | Yes | Description of Nonconforming Work | — |
| `OccurredDate` | Date | Yes | Date When the NC Occurred | — |
| `EvidenceAttached` | Multiple Lines | No | Evidence Attached | Text description; the actual files use native list Attachments — see §0.1c. |
| `IsValid` | Choice | Yes | Is the information valid and reliable? | `Yes`, `No` |
| `Proceeds` | Choice | Yes | Does the NC proceed? | `Yes`, `No` |
| `ValidationRationale` | Multiple Lines | Yes | Why? (from analysis) | — |
| `ImpactAssessment` | Multiple Lines | Yes | Impact of the NC | Required when `Proceeds == "Yes"`. |
| `EvaluatedBy` | Person | Yes | Personnel That Evaluated the NC | — |
| `EvaluatorPosition` | Single Line Text | Yes | Position | — |
| `EvaluationDate` | Date | Yes | Date of Evaluation | — |
| `CustomerNotifyReqEval` | Choice | Yes | Notify customer? (evaluation) | `Yes`, `No` |
| `CustomerNotifiedByEval` | Person | No | Notified By | — |
| `CustomerNotifyDateEval` | Date | No | Date of Notification | — |
| `ImmediateActions` | Multiple Lines | Yes | Immediate Actions to Address the NC | — |
| `ImmediateEvidence` | Multiple Lines | No | Evidence Attached (immediate actions) | Text description; the actual files use native list Attachments — see §0.1c. |
| `ImmediateResponsible` | Person | Yes | Responsible (immediate actions) | — |
| `ImmediateActionDate` | Date | Yes | Date (immediate actions) | — |
| `RiskLevel` | Choice | Yes | Risk Level of the NC (7.10.1 b) | `High`, `Medium`, `Low` |
| `WorkHalted` | Choice | Yes | Was work halted / repeated? | `Halted`, `Repeated`, `Continued (justified)` |
| `ReportsAction` | Choice | Yes | Reports/certificates action (7.10.1 e) | `None required`, `Reports withheld`, `Reports recalled`, `Certificates withdrawn` |
| `RecallScope` | Multiple Lines | No | Recall / Withholding Scope | Required unless `ReportsAction == "None required"`. |
| `ResumptionAuthorizedBy` | Person | No | Authority for Resumption (7.10.1 f) | Mandatory before closure if `WorkHalted == "Halted"`. |
| `ResumptionAuthorizedDate` | Date | No | Resumption Authorized Date | — |
| `ResumptionConditions` | Multiple Lines | No | Conditions for Resumption | — |
| `CARequired` | Choice | Yes | Is Corrective Action required? | `Yes`, `No` |
| `CARationale` | Multiple Lines | Yes | Rationale (§8.7) | — |
| `CARef` | Lookup → `LS_QP1601r01_CorrectiveActions` | No | Corrective Action Reference | — |
| `RootCauseRef` | Lookup → `LS_QP1601r01_CorrectiveActions` (RCA subrecord) | No | Root Cause Analysis Reference | — |
| `CustomerNotifyReqClose` | Choice | No | Notify customer? (closing) | `Yes`, `No` |
| `FollowUpAuditReq` | Choice | No | Follow-up audit required? | `Yes`, `No` |
| `FollowUpScope` | Multiple Lines | No | Follow-up Scope | Required if `Yes`. |
| `FollowUpDate` | Date | No | Follow-up Date | — |
| `RelatedMethodSOP` | Lookup → `LS_QP1401r01_DocumentRegister` | No | Related Method / SOP | — |
| `RelatedEquipmentID` | Lookup / Single Line Text | No | Related Equipment | — |
| `DueDate` | Date | No | Target Closure Date | — |
| `AgeDays` | — (app-computed, see §0.1b) | No | Age (days) | `TODAY − ReportedDate` while open. Not a stored column. |
| `EscalationState` | — (app-computed, see §0.1b) | No | Escalation | `On Track`, `Due Soon`, `Overdue`, `Escalated`. Not a stored column. |
| `Status` | Choice | Yes | Status | `Logged`, `Under Validation`, `Impact Assessment`, `Immediate Actions`, `Escalated to CA`, `Root Cause`, `Awaiting Closure`, `Closed`, `Cancelled` |
| `ReviewedBy` | Person | No | Reviewed By | — |
| `ApprovedBy` | Person | No | Approved By | *(also present via §0)* |
| `ClosingDate` | Date | No | Date of Closing | — |

**Settings:** `RecordID` should be set **Enforce unique values**. Indexed columns: `Status`, `DueDate`, `CARef`.

### 3.3 `LS_QP1601r01_CorrectiveActions`

+ Record-Control block (§0)

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `CARID` | Single Line Text | Yes | Corrective Action Plan # | `CAR{YY}{###}` — computed client-side by the app: query the current max sequence number for the year, +1, written on save. Read-only in the UI. |
| `RecordedBy` | Person | Yes | Recorded By | Auto-populated. |
| `RecordedDate` | Date | Yes | Date | Auto-populated. |
| `ProblemStatement` | Multiple Lines | Yes | What went wrong and needs correcting? | — |
| `ReferenceNC` | Lookup → `LS_QP1301r01_NonconformingWork` | No | Reference Nonconformance | — |
| `SourceType` | Choice | Yes | Source | `Nonconforming Work`, `Complaint`, `Audit Finding`, `Management Review`, `Other` |
| `RootCauseIdentified` | Choice | Yes | Was the root cause identified? | `Yes`, `No` |
| `RootCause` | Multiple Lines | Yes | Root Cause | Required when `RootCauseIdentified == "Yes"`. |
| `RCAToolUsed` | Choice (multi) | No | Root-Cause Tool(s) Used | `Brainstorm (FM QP16.02)`, `Fishbone / Ishikawa (FM QP16.03)`, `Five Whys (FM QP16.04)` |
| `RCAEvidence` | Multiple Lines | No | RCA Evidence | Text description (which tool, record ID); the actual files use native list Attachments — see §0.1c. |
| `SimilarNCReviewed` | Choice | Yes | Extent of condition (8.7.1 b) | `Yes – found elsewhere`, `Yes – could occur elsewhere`, `No` |
| `ExtentOfConditionFindings` | Multiple Lines | No | Extent-of-Condition Findings | Required unless `SimilarNCReviewed == "No"`. |
| `ExtentActionsRef` | Lookup (multi) → `LS_QP1601r01b_ActionItems` / other CAs | No | Extension Actions | — |
| `PlanNarrative` | Multiple Lines | Yes | Actions to Correct & Prevent Recurrence | — |
| `NotifyCustomer` | Choice | No | Notify customer? | `Yes`, `No` |
| `NotifiedBy` | Person | No | Notified By | — |
| `NotifyDate` | Date | No | Date of Notification | — |
| `FollowUpAuditReq` | Choice | No | Follow-up audit required? | `Yes`, `No` |
| `FollowUpScope` | Multiple Lines | No | Follow-up Scope | Required if `Yes`. |
| `FollowUpDate` | Date | No | Follow-up Date | — |
| `Conclusions` | Multiple Lines | No | Conclusions and/or Recommendations | — |
| `RiskUpdateRequired` | Choice | Yes | Update risks & opportunities? (8.7.1 e) | `Yes`, `No` |
| `RiskRef` | Lookup → `LS_QP1501r01_ActionPlans` | No | Risk / Opportunity Updated or Raised | Required when `Yes`. |
| `MSChangeRequired` | Choice | Yes | Make changes to management system? (8.7.1 f) | `Yes`, `No` |
| `DCRRef` | Lookup → `LS_QP1402r01_ChangeRequests` | No | Document Change Request | Required when `Yes`. |
| `RelatedSampleID` | Single Line Text | No | Related Sample ID | — |
| `RelatedTestReport` | Single Line Text | No | Related Test Report # | — |
| `RelatedEquipmentID` | Lookup / Single Line Text | No | Related Equipment | — |
| `RelatedMethodSOP` | Lookup → `LS_QP1401r01_DocumentRegister` | No | Related Method / SOP | — |
| `RelatedPersonnel` | Person (multi) | No | Related Personnel | — |
| `DueDate` | Date | No | Target Closure Date | — |
| `AgeDays` | — (app-computed, see §0.1b) | No | Age (days) | `TODAY − RecordedDate` while open. Not a stored column. |
| `EscalationState` | — (app-computed, see §0.1b) | No | Escalation | `On Track`, `Due Soon`, `Overdue`, `Escalated`. Not a stored column. |
| `Status` | Choice | Yes | Status | `Initiated`, `Root Cause`, `Action Planning`, `In Progress`, `Verification`, `Closed – Effective`, `Closed – Not Effective`, `Cancelled` |
| `ReviewedBy` | Person | No | Reviewed By | — |
| `ApprovedBy` | Person | No | Approved By | *(also present via §0)* |
| `ClosingDate` | Date | No | Date of Closing | — |

**Settings:** `CARID` should be set **Enforce unique values**. Indexed columns: `Status`, `DueDate`, `ReferenceNC`.

#### Child — `LS_QP1601r01a_Participants`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `CARRef` | Lookup → `LS_QP1601r01_CorrectiveActions` | Yes | Parent CA | — |
| `Participant` | Person | Yes | Name | — |
| `Position` | Single Line Text | Yes | Position | — |

#### Child — `LS_QP1601r01b_ActionItems`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `CARRef` | Lookup → `LS_QP1601r01_CorrectiveActions` | Yes | Parent CA | — |
| `ActionItem` | Multiple Lines | Yes | Action Item | — |
| `Responsible` | Person | Yes | Responsible | — |
| `ScheduledDate` | Date | Yes | Scheduled Date | — |
| `ActualDate` | Date | No | Actual Date | — |
| `VerifiedBy` | Person | No | Verified By | — |

#### Child — `LS_QP1601r01c_EffectivenessControls`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `CARRef` | Lookup → `LS_QP1601r01_CorrectiveActions` | Yes | Parent CA | — |
| `Control` | Multiple Lines | Yes | Control | — |
| `Responsible` | Person | Yes | Responsible | — |
| `ReviewDate` | Date | Yes | Review Date | — |
| `ActualDate` | Date | No | Actual Date | — |
| `Effectiveness` | Choice | No | Effectiveness | `Effective`, `Not Effective`, `Pending` |

### 3.4 `LS_QP1501r01_ActionPlans`

+ Record-Control block (§0)

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `PlanID` | Single Line Text | Yes | Plan # | `AARO{YY}{##}` — computed client-side by the app: query the current max sequence number for the year, +1, written on save. Read-only in the UI. |
| `Type` | Choice | Yes | Type | `Risk`, `Opportunity`, `Improvement` |
| `Initiator` | Person | Yes | Initiator | Auto-populated. |
| `InitiationDate` | Date | Yes | Initiation Date | Auto-populated. |
| `Goal` | Multiple Lines | Yes | Action Plan / Goal | — |
| `Rationale` | Multiple Lines | Yes | Rationale | — |
| `FollowUpAuditReq` | Choice | No | Follow-up audit required? | `Yes`, `No` |
| `FollowUpScope` | Multiple Lines | No | Follow-up Scope | Required if `Yes`. |
| `FollowUpDate` | Date | No | Scheduled Follow-up Date | — |
| `ApprovalDecision` | Choice | No | Is the action approved? | `Approved`, `Not Approved`, `Pending` (default `Pending`) |
| `Reviewer` | Person | No | Reviewer | — |
| `Approver` | Person | No | Approver | — |
| `EffectivenessResult` | Choice | No | Was the action effective? | `Yes`, `No`, `Pending` |
| `EffectivenessComments` | Multiple Lines | No | Effectiveness Comments | — |
| `RisksAddressed` | Choice | No | Risks successfully addressed? | `Yes`, `No`, `N/A` |
| `RisksAddressedComments` | Multiple Lines | No | Comments | — |
| `NewRisksIntroduced` | Choice | No | New risks introduced? | `Yes`, `No` |
| `NewRisksDetail` | Multiple Lines | No | New Risks Detail | Required if `Yes`. |
| `FMEARef` | Hyperlink or Picture | No | FMEA Risk Assessment | Points to the one FMEA spreadsheet in a document library — see §0.1c. |
| `SourceOFI` | Lookup → `LS_QP1503r01_Improvement` | No | Source OFI | — |
| `Source` | Choice | No | Trigger / Source | `Management Review`, `Internal Audit`, `Complaint / Feedback`, `Nonconforming Work`, `Corrective Action`, `Change / New Activity`, `Staff Proposal` |
| `SourceRefFinding` | Lookup → `LS_QP1703r01a_Findings` | No | Source Audit Finding | See §0.1a — only one of these 4 populated per row, based on `Source`. |
| `SourceRefComplaint` | Lookup → `LS_QP1201r01_Complaints` | No | Source Complaint | — |
| `SourceRefNCW` | Lookup → `LS_QP1301r01_NonconformingWork` | No | Source Nonconforming Work | — |
| `SourceRefCA` | Lookup → `LS_QP1601r01_CorrectiveActions` | No | Source Corrective Action | — |
| `RelatedMethodSOP` | Lookup → `LS_QP1401r01_DocumentRegister` | No | Related Method / SOP | — |
| `RelatedEquipmentID` | Lookup / Single Line Text | No | Related Equipment | — |
| `ResidualRiskLevel` | Choice | No | Residual Risk After Treatment | `Low`, `Medium`, `High` |
| `DueDate` | Date | No | Target Completion Date | — |
| `AgeDays` | — (app-computed, see §0.1b) | No | Age (days) | `TODAY − InitiationDate` while open. Not a stored column. |
| `EscalationState` | — (app-computed, see §0.1b) | No | Escalation | `On Track`, `Due Soon`, `Overdue`, `Escalated`. Not a stored column. |
| `Status` | Choice | Yes | Status | `Initiated`, `Impact Assessment`, `Awaiting Approval`, `Approved – In Progress`, `Follow-up`, `Closed – Effective`, `Closed – Not Effective`, `Rejected` |

**Settings:** `PlanID` should be set **Enforce unique values**. Indexed columns: `Status`, `Type`, `DueDate`.

#### Child — `LS_QP1501r01a_ImpactAssessment`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `PlanRef` | Lookup → `LS_QP1501r01_ActionPlans` | Yes | Parent Plan | — |
| `Dimension` | Choice | Yes | Impact Area | `Scope & Test Methods`, `QMS`, `Personnel`, `Equipment`, `Facilities & Environment`, `Business`, `Regulations`, `Other` |
| `DimensionOther` | Single Line Text | No | Area – Other | — |
| `Level` | Choice | Yes | Impact Level | `Low`, `Medium`, `High` |
| `IdentifiedRisk` | Multiple Lines | No | Identified Risk(s) | — |
| `Decision` | Choice | Yes | Treatment Decision | `Avoid / Eliminate`, `Change Likelihood`, `Retain`, `Transfer`, `N/A` |

#### Child — `LS_QP1501r01b_Deliverables`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `PlanRef` | Lookup → `LS_QP1501r01_ActionPlans` | Yes | Parent Plan | — |
| `Description` | Multiple Lines | Yes | Deliverable / Action | — |
| `Responsible` | Person | Yes | Responsible | — |
| `ScheduledDate` | Date | Yes | Schedule | — |
| `ActualDate` | Date | No | Actual Date | — |
| `VerifiedBy` | Person | No | Verified By | — |

### 3.5 `LS_QP1503r01_Improvement`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `OFIID` | Single Line Text | Yes | OFI # | `OFI{YY}{##}` — computed client-side by the app: query the current max sequence number for the year, +1, written on save. Read-only in the UI. |
| `Idea` | Single Line Text | Yes | Idea (short title) | — |
| `Description` | Multiple Lines | No | Description | — |
| `Submitter` | Person | Yes | Submitter | Auto-populated; anonymous optional per config. |
| `SubmittedDate` | Date | Yes | Date Submitted | Auto-populated. |
| `Source` | Choice | No | Source | `Staff Suggestion`, `Management Review`, `Customer Feedback`, `Feedback Trend Analysis`, `Audit Output`, `Other` |
| `SourceComplaintRef` | Lookup → `LS_QP1201r01_Complaints` | No | Source Complaint / Feedback | — |
| `FeedbackTheme` | Single Line Text | No | Feedback Theme / Category | — |
| `Area` | Choice | No | Affected Area | `Scope & Test Methods`, `QMS`, `Personnel`, `Equipment`, `Facilities & Environment`, `Business`, `Regulations`, `Other` |
| `Impact` | Choice | Yes | Estimated Impact | `High`, `Medium`, `Low` |
| `Status` | Choice | Yes | Status | `Submitted`, `Under Review`, `Approved`, `Implemented`, `Promoted to Action Plan`, `Deferred`, `Rejected` |
| `DecisionRationale` | Multiple Lines | No | Decision Rationale | — |
| `ReviewedBy` | Person | No | Reviewed By | — |
| `ReviewDate` | Date | No | Review Date | — |
| `LinkedActionPlan` | Lookup → `LS_QP1501r01_ActionPlans` | No | Linked Action Plan | Read-only once set. |
| `ImplementationNote` | Multiple Lines | No | Implementation Note | — |
| `ClosedDate` | Date | No | Closed Date | — |
| `DueDate` | Date | No | Target Decision Date | — |
| `AgeDays` | — (app-computed, see §0.1b) | No | Age (days) | `TODAY − SubmittedDate` while open. Not a stored column. |
| `EscalationState` | — (app-computed, see §0.1b) | No | Escalation | `On Track`, `Due Soon`, `Overdue`, `Escalated`. Not a stored column. |

**Settings:** `OFIID` should be set **Enforce unique values**. Indexed columns: `Status`, `Source`.

### 3.6 `LS_QP1701r01_AuditNotification`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `AuditID` | Single Line Text | Yes | Audit ID | `AUD-{YY}-{##}` — computed client-side by the app: query the current max sequence number for the year, +1, written on save. Read-only in the UI. Shared key across Checklist/Report. |
| `ProgramLineRef` | Lookup → `LS_QP1704r01a_ScheduleLines` | No | Programme Line | — |
| `AuditType` | Choice | Yes | Audit Type | `Internal – Scheduled`, `Internal – Follow-up`, `Vendor / External Provider` |
| `AuditStartDate` | Date | Yes | Audit Start Date | — |
| `AuditEndDate` | Date | Yes | Audit End Date | Must be ≥ `AuditStartDate`. |
| `Objectives` | Multiple Lines | Yes | Audit Objectives | — |
| `Scope` | Multiple Lines | Yes | Scope of the Audit | — |
| `Criteria` | Multiple Lines | Yes | Audit Criteria | — |
| `AuditTeam` | Person (multi) | Yes | Audit Team | — |
| `Auditees` | Person (multi) | No | Auditee(s) | — |
| `AuditorIndependence` | Choice | Yes | Auditor Independence (8.8.2) | `Confirmed – auditors do not audit their own work`, `Conflict noted – see notes` |
| `IndependenceNotes` | Multiple Lines | No | Independence Notes | Required if `Conflict noted`. |
| `AuditorCompetenceRef` | Hyperlink or Picture | No | Auditor Competence Evidence | Points to the competence/training record file — see §0.1c. No dedicated competence-tracking list exists in this schema yet. |
| `Methodology` | Multiple Lines | Yes | Audit Methodology | — |
| `PreparedBy` | Person | Yes | Prepared By | — |
| `ManagerAck` | Person | No | Laboratory Manager (acknowledgement) | — |
| `NotificationDate` | Date | Yes | Notification Date | — |
| `Status` | Choice | Yes | Status | `Draft`, `Notified`, `Scheduled`, `In Progress`, `Completed`, `Cancelled` |

**Settings:** `AuditID` should be set **Enforce unique values** and is immutable once created. Indexed columns: `Status`, `AuditStartDate`.

#### Child — `LS_QP1701r01a_AuditAgenda`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `AuditRef` | Lookup → `LS_QP1701r01_AuditNotification` | Yes | Parent Audit | — |
| `Day` | Number | Yes | Day # | 1, 2, … |
| `AgendaDate` | Date | Yes | Date | — |
| `TimeSlot` | Single Line Text | Yes | Time | e.g. `09:15 – 13:00` |
| `Activity` | Multiple Lines | Yes | Activities | — |
| `Auditor` | Person (multi) | Yes | Auditor | — |

### 3.7 `LS_QP1702r01_AuditChecklist`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ChecklistID` | Single Line Text | Yes | Checklist ID | `CHK-{AuditID}` — computed client-side by the app (simple string concatenation off the parent `AuditID`, no sequence lookup needed). Read-only in the UI. |
| `AuditRef` | Lookup → `LS_QP1701r01_AuditNotification` | Yes | Audit Event | — |
| `AuditScope` | Multiple Lines | Yes | Audit Scope | Pulled from notification. |
| `Auditor` | Person | Yes | Auditor | — |
| `TemplateVersion` | Single Line Text | Yes | Clause Template Version | e.g. `ISO17025-2017 v1`. |
| `Status` | Choice | Yes | Status | `Not Started`, `In Progress`, `Completed`, `Reviewed` |
| `ConformCount` | — (app-computed, see §0.1b) | No | # Conform | Live count of `ChecklistItems` rows where `Conformance == "C"`. Not a stored column. |
| `NonconformCount` | — (app-computed, see §0.1b) | No | # Nonconform | Live count where `Conformance == "NC"`. Not a stored column. |
| `NACount` | — (app-computed, see §0.1b) | No | # Not Applicable | Live count where `Conformance == "NA"`. Not a stored column. |

**Settings:** `ChecklistID` should be set **Enforce unique values** (derived from `AuditRef`, so uniqueness holds naturally as long as one checklist exists per audit). Indexed column: `AuditRef`.

#### Child — `LS_QP1702r01a_ChecklistItems` *(seeded from `REF_ISO17025_Clauses` on creation, ~400 rows)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ChecklistRef` | Lookup → `LS_QP1702r01_AuditChecklist` | Yes | Parent Checklist | — |
| `ClauseNo` | Single Line Text | Yes | Clause | e.g. `4.1.1`. Read-only (seeded). |
| `Section` | Choice | Yes | Section Group | `4 General`, `5 Structural`, `6 Resource`, `7 Process`, `8 Management System` |
| `Requirement` | Multiple Lines | Yes | Requirement | Seeded, read-only. |
| `IsHeader` | Yes/No | No | Heading Row? | `Yes` for non-scored section/NOTE rows. |
| `Conformance` | Choice | No | Conformance | `C`, `NC`, `NA` |
| `Comments` | Multiple Lines | No | Comments on Conformance | Mandatory when `Conformance == "NC"`. |
| `NAJustification` | Multiple Lines | No | NA Justification | Mandatory when `Conformance == "NA"`. |
| `EvidenceSampled` | Multiple Lines | No | Objective Evidence Sampled | Record IDs/documents examined. |
| `FindingRef` | Lookup → `LS_QP1703r01a_Findings` | No | Linked Finding | Auto-set when `Conformance == "NC"`. |
| `SortOrder` | Number | Yes | Order | Read-only (seeded). |

**Settings:** Indexed columns: `ChecklistRef`, `Section`, `Conformance`. **~400 rows per checklist** — expect this to be the list most likely to approach SharePoint's 5,000-item view threshold as audits accumulate; plan indexed/filtered views accordingly (per the App Guide's note on `__next` pagination).

#### Reference/template — `REF_ISO17025_Clauses` *(one master row set, copied into each new checklist)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ClauseNo` | Single Line Text | Yes | Clause | e.g. `4.1.1`, `6.2.5`, `7.7.2` |
| `Section` | Choice | Yes | Section Group | `4 General`, `5 Structural`, `6 Resource`, `7 Process`, `8 Management System` |
| `Requirement` | Multiple Lines | Yes | Requirement | Full ISO/IEC 17025:2017 requirement text. |
| `IsHeader` | Yes/No | No | Heading Row? | `Yes` for section headings / NOTE rows. |
| `SortOrder` | Number | Yes | Order | Preserves standard clause order. |

**Settings:** ~400 rows (Sections 4–8, incl. headings/NOTES). This list is **read-only reference data** — the app copies it into `LS_QP1702r01a_ChecklistItems` client-side (REST `$batch`, ~4 batches for 400 rows) at the moment a new checklist is created, avoiding the polling delay a Power Automate trigger would introduce; it is never edited by users.

### 3.8 `LS_QP1703r01_AuditReport`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ReportID` | Single Line Text | Yes | Report ID | `RPT-{AuditID}` — computed client-side by the app (simple string concatenation off the parent `AuditID`, no sequence lookup needed). Read-only in the UI. |
| `AuditRef` | Lookup → `LS_QP1701r01_AuditNotification` | Yes | Audit Event | — |
| `ChecklistRef` | Lookup → `LS_QP1702r01_AuditChecklist` | No | Source Checklist | — |
| `ExecutionDates` | Single Line Text | Yes | Audit Execution Date(s) | — |
| `Objectives` | Multiple Lines | Yes | Audit Objectives & Criteria Followed | — |
| `Scope` | Multiple Lines | Yes | Audit Scope | — |
| `PlanFollowed` | Multiple Lines | No | Audit Plan Followed | — |
| `CriteriaReference` | Single Line Text | Yes | Criteria / Reference | — |
| `WeakPoints` | Multiple Lines | No | Weak Points | — |
| `StrongPoints` | Multiple Lines | No | Strong Points | — |
| `LeadAuditor` | Person | Yes | Lead Auditor | — |
| `ClosingDate` | Date | No | Date of Closing (Audit) | — |
| `Status` | Choice | Yes | Status | `Draft`, `Issued`, `Findings Open`, `Findings In Progress`, `Closed`, `Cancelled` |

**Settings:** `ReportID` should be set **Enforce unique values** (derived from `AuditRef`, same rationale as `ChecklistID`). Indexed column: `Status`.

#### Child — `LS_QP1703r01a_Findings`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ReportRef` | Lookup → `LS_QP1703r01_AuditReport` | Yes | Parent Report | — |
| `FindingNo` | Number | Yes | No. | Sequential. |
| `Description` | Multiple Lines | Yes | Description of Finding / NC | — |
| `ClauseReference` | Single Line Text | Yes | Clause / Reference | — |
| `CorrectiveActionText` | Multiple Lines | No | Corrective Action (rationale/plan) | — |
| `Responsible` | Person | No | Responsible | — |
| `ProposedClosingDate` | Date | No | Proposed Date of Closing | — |
| `ConfirmationOfClosing` | Date | No | Confirmation of Closing | — |
| `AgeDays` | — (app-computed, see §0.1b) | No | Age (days) | Not a stored column. |
| `Overdue` | — (app-computed, see §0.1b) | No | Overdue | `Yes` when `ProposedClosingDate < today` and not closed. Not a stored column. |
| `Severity` | Choice | No | Severity | `Major`, `Minor`, `Observation` |
| `NCWRef` | Lookup → `LS_QP1301r01_NonconformingWork` | No | Linked NCW | — |
| `CARef` | Lookup → `LS_QP1601r01_CorrectiveActions` | No | Linked Corrective Action | — |
| `FindingStatus` | Choice | Yes | Finding Status | `Open`, `Action Assigned`, `In Progress`, `Closed` |

**Settings:** Indexed columns: `FindingStatus`, `Severity`, `ProposedClosingDate` (`Overdue` is app-computed, see §0.1b — not a stored column, so it can't be indexed).

### 3.9 `LS_QP1704r01_AuditProgram` *(one record per programme year)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ProgramID` | Single Line Text | Yes | Program # | `PM05-{YYYY}` — computed client-side by the app from the selected `Year`, written on save. Read-only in the UI. |
| `Year` | Number | Yes | Programme Year | — |
| `PreparedBy` | Person | Yes | Prepared By | — |
| `ProgramBasis` | Multiple Lines | Yes | Programme Basis / Risk Rationale (8.8.2 a) | — |
| `ApprovedBy` | Person | No | Approved By | — |
| `ApprovalDate` | Date | No | Approval Date | — |
| `Remarks` | Multiple Lines | No | Remarks | — |
| `Status` | Choice | Yes | Status | `Draft`, `Approved`, `In Progress`, `Completed`, `Superseded` |

**Settings:** `ProgramID` should be set **Enforce unique values**. Indexed column: `Year`.

#### Child — `LS_QP1704r01a_ScheduleLines` *(one row per clause group per year)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ProgramRef` | Lookup → `LS_QP1704r01_AuditProgram` | Yes | Parent Programme | — |
| `ClauseGroup` | Choice | Yes | ISO/IEC 17025:2017 Clause | `4.1–4.2`, `5.1–5.3`, `5.4–5.7`, `6.1–6.2`, `6.3–6.4`, `6.5–6.6`, `7.1–7.3`, `7.4–7.7`, `7.8–7.11`, `8.1–8.4`, `8.5–8.7`, `8.8–8.9` |
| `ClauseTopic` | Single Line Text | No | Topic | Auto-filled from a reference map (see spec). |
| `PlannedMonth` | Choice | Yes | Planned Month (P) | `JAN`…`DEC` |
| `CompletedMonth` | Choice | No | Completed Month (C) | `JAN`…`DEC` |
| `AuditEventRef` | Lookup → `LS_QP1701r01_AuditNotification` | No | Audit Event | — |
| `ImportanceRating` | Choice | No | Importance / Risk Rating | `High`, `Medium`, `Low` |
| `SchedulingRationale` | Multiple Lines | No | Scheduling Rationale | — |
| `PriorFindingsInput` | Lookup (multi) → `LS_QP1703r01a_Findings` | No | Prior Findings Considered | — |
| `CoverageStatus` | Choice | Yes | Coverage Status | `Planned`, `Scheduled`, `Completed`, `Deferred`, `Not Covered` (default `Planned`) |

**Settings:** Indexed columns: `ProgramRef`, `ClauseGroup`, `CoverageStatus`. Each `ClauseGroup` must appear at least once per programme year (data-integrity rule, not a native list setting — enforce via validation/flow).

---

## 4. Quick reference — list count by subsystem

| Subsystem | Main lists | Child lists | Support/reference lists |
|---|---|---|---|
| S1 Dashboard & Governance | 1 (Management Review) | 2 | — |
| S2 Document Control | 2 (Register, DCR) | 2 | 2 (SOP Process Steps, SOP Relationships) |
| S3 Quality Operations | 9 (Complaints, NCW, CA, Risks, Improvement, Audit ×4) | 9 | 1 (`REF_ISO17025_Clauses`) |
| **Total** | **12** | **13** | **3** |

**28 lists overall.**

---

## 5. Creation order — all 28 lists, dependency-resolved

This is a strict build order: every list appears **after** every other list its own columns have a Lookup pointing to — so at the moment you create each one, every Lookup target already exists, with the 9 unavoidable exceptions noted below (the data model has real circular references — e.g. NCW↔CA, Complaints↔Improvement — no linear order eliminates every one of them; these are deferred to a short second pass instead of blocking the whole sequence).

1. `LS_QP1401r01_DocumentRegister`
2. `LS_SOPProcessSteps`
3. `LS_SOPRelationships`
4. `REF_ISO17025_Clauses`
5. `LS_QP1301r01_NonconformingWork`
6. `LS_QP1601r01_CorrectiveActions`
7. `LS_QP1601r01a_Participants`
8. `LS_QP1601r01b_ActionItems`
9. `LS_QP1601r01c_EffectivenessControls`
10. `LS_QP1704r01_AuditProgram`
11. `LS_QP1704r01a_ScheduleLines`
12. `LS_QP1701r01_AuditNotification`
13. `LS_QP1701r01a_AuditAgenda`
14. `LS_QP1702r01_AuditChecklist`
15. `LS_QP1702r01a_ChecklistItems`
16. `LS_QP1703r01_AuditReport`
17. `LS_QP1703r01a_Findings`
18. `LS_QP1201r01_Complaints`
19. `LS_QP1503r01_Improvement`
20. `LS_QP1501r01_ActionPlans`
21. `LS_QP1501r01a_ImpactAssessment`
22. `LS_QP1501r01b_Deliverables`
23. `LS_QP1402r01_ChangeRequests`
24. `LS_QP1402r01a_AffectedDocuments`
25. `LS_QP1402r01b_ImplementationAttendants`
26. `LS_QP1801r01_ManagementReview`
27. `LS_QP1801r01a_ReviewInputs`
28. `LS_QP1801r01b_ReviewOutputs`

**Deferred columns (add these in a short second pass, once their target list exists — everything else on each list can be created immediately, in full, at its position above):**

| Column | On list | Created at step | Add once available (step) |
|---|---|---|---|
| `CARef`, `RootCauseRef` | `LS_QP1301r01_NonconformingWork` | 5 | after step 6 (`LS_QP1601r01_CorrectiveActions`) |
| `AuditEventRef` | `LS_QP1704r01a_ScheduleLines` | 11 | after step 12 (`LS_QP1701r01_AuditNotification`) |
| `PriorFindingsInput` | `LS_QP1704r01a_ScheduleLines` | 11 | after step 17 (`LS_QP1703r01a_Findings`) |
| `FindingRef` | `LS_QP1702r01a_ChecklistItems` | 15 | after step 17 (`LS_QP1703r01a_Findings`) |
| `ImprovementRef` | `LS_QP1201r01_Complaints` | 18 | after step 19 (`LS_QP1503r01_Improvement`) |
| `LinkedActionPlan` | `LS_QP1503r01_Improvement` | 19 | after step 20 (`LS_QP1501r01_ActionPlans`) |
| `RiskRef` | `LS_QP1601r01_CorrectiveActions` | 6 | after step 20 (`LS_QP1501r01_ActionPlans`) |
| `DCRRef` | `LS_QP1601r01_CorrectiveActions` | 6 | after step 23 (`LS_QP1402r01_ChangeRequests`) |
| `LinkedDCR` | `LS_QP1401r01_DocumentRegister` | 1 | after step 23 (`LS_QP1402r01_ChangeRequests`) |

Everything else — including all of `LS_QP1501r01_ActionPlans`'s and `LS_QP1402r01_ChangeRequests`'s split lookup columns from §0.1a, and all of `LS_QP1801r01b_ReviewOutputs`'s — has its target already built by the time it's created in this order, so no further deferral is needed anywhere else.
