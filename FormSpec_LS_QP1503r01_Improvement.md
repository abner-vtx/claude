# Form Specification: Improvement / Opportunity for Improvement (OFI)

**Master SOP:** QP-15 – Actions to Address Risks and Opportunities *(Improvement stream)*  
**Form ID:** LS_QP1503r01  
**Form Title:** Opportunity for Improvement (OFI)  
**SharePoint List:** `LS_QP1503r01_Improvement`  
**ISO/IEC 17025:2017 Reference:** Clause 8.6 – Improvement (with 8.5 for actions arising)  
**Document Status:** Draft  

**Purpose:** To provide a low-friction intake for improvement ideas from any staff member or from management review, customer feedback, and audit outputs — and to triage each idea through review to a decision. Simple improvements are implemented and closed directly; those requiring a managed change with risk assessment are promoted into an Action Plan (`LS_QP1501r01`). This satisfies Clause 8.6's requirement to identify and select opportunities for improvement and implement actions. This list drives the **Improvement** tab.

> **Note:** ISO/IEC 17025 does not mandate a standalone OFI form; QP-15 treats *Improvement* as one of its three action-plan types. This list is introduced to match the v05 dashboard's dedicated Improvement tab and to keep idea intake lightweight, while formal, resourced improvements are handed off to `LS_QP1501r01`.

---

## 1. Data Schema

*SharePoint List column definitions.*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `OFIID` | Single Line Text | Yes | OFI # | Auto-generated `OFI{YY}{##}` (e.g., `OFI2601`). Read-only. |
| `Idea` | Single Line Text | Yes | Idea (short title) | One-line summary shown in the dashboard table. |
| `Description` | Multiple Lines | No | Description | Fuller explanation of the improvement and its expected benefit. |
| `Submitter` | Person | Yes | Submitter | Current user (auto-populated; anonymous submission optional per config). |
| `SubmittedDate` | Date | Yes | Date Submitted | Today (auto-populated). |
| `Source` | Choice | No | Source | `Staff Suggestion`, `Management Review`, `Customer Feedback`, `Feedback Trend Analysis`, `Audit Output`, `Other` |
| `SourceComplaintRef` | Lookup → `LS_QP1201r01_Complaints` | No | Source Complaint / Feedback | Set when the OFI arises from a specific piece of customer feedback (8.6.2). |
| `FeedbackTheme` | Single Line Text | No | Feedback Theme / Category | For trend-driven OFIs — the recurring theme identified across feedback (e.g., "turnaround time", "report format"). |
| `Area` | Choice | No | Affected Area | `Scope & Test Methods`, `QMS`, `Personnel`, `Equipment`, `Facilities & Environment`, `Business`, `Regulations`, `Other` |
| `Impact` | Choice | Yes | Estimated Impact | `High`, `Medium`, `Low` |
| `Status` | Choice | Yes | Status | `Submitted`, `Under Review`, `Approved`, `Implemented`, `Promoted to Action Plan`, `Deferred`, `Rejected` |
| `DecisionRationale` | Multiple Lines | No | Decision Rationale | Reviewer's justification for approve/defer/reject. |
| `ReviewedBy` | Person | No | Reviewed By | — |
| `ReviewDate` | Date | No | Review Date | — |
| `LinkedActionPlan` | Lookup → `LS_QP1501r01_ActionPlans` | No | Linked Action Plan | Set when promoted (`Status == "Promoted to Action Plan"`). Read-only. |
| `ImplementationNote` | Multiple Lines | No | Implementation Note | For simple OFIs closed directly without an action plan. |
| `ClosedDate` | Date | No | Closed Date | — |
| `DueDate` | Date | No | Target Decision Date | Drives aging/escalation. |
| `AgeDays` | Calculated | No | Age (days) | `TODAY − SubmittedDate` while open. Read-only. |
| `EscalationState` | Calculated Choice | No | Escalation | `On Track`, `Due Soon`, `Overdue`, `Escalated`. |

> **Data Integrity Rule:** `Idea`, `Description`, and `Submitter` lock after `Status` moves past `"Under Review"`. Promotion to an Action Plan is one-way: once `LinkedActionPlan` is set, the OFI is read-only and effectiveness tracking continues on the action plan.

---

## 2. Form Layout & Logic

### Section 01 – Submission

**Fields:** `Idea`, `Description`, `Submitter`, `SubmittedDate`, `Source`, `SourceComplaintRef`, `FeedbackTheme`, `Area`, `Impact`  
**Logic 1:** Minimal required fields (`Idea`, `Impact`) to encourage submission. `Submitter`/`SubmittedDate` auto-populated.  
**Logic 2 – Customer-feedback-to-improvement (8.6.2):** Two paths feed improvement from feedback — (a) *direct*: a specific complaint/feedback record raises an OFI via `SourceComplaintRef` (`Source = "Customer Feedback"`); (b) *trend*: a periodic review of feedback categories from `LS_QP1201r01` identifies recurring themes, each captured as an OFI with `Source = "Feedback Trend Analysis"` and a `FeedbackTheme`. This demonstrates feedback is not just logged but **analyzed and used to improve**, and the analysis feeds Management Review input 8.9.2(i).

---

### Section 02 – Review & Decision

**Fields:** `Status`, `DecisionRationale`, `ReviewedBy`, `ReviewDate`  
**Logic 1:** On review, reviewer sets `Status`.  
**Logic 2:** IF `Impact == "High"` OR the change needs resources/risk assessment, THEN the reviewer is prompted to **"Promote to Action Plan"**, which creates a `LS_QP1501r01` record (`Type = "Improvement"`, bridging `Idea`/`Description` into `Goal`/`Rationale`, `SourceOFI = OFIID`) and sets `Status = "Promoted to Action Plan"`.  
**Logic 3:** IF a simple improvement, THEN `Status = "Approved"` → `"Implemented"` with an `ImplementationNote` and `ClosedDate`.

---

### Section 03 – Closure

**Fields:** `ImplementationNote`, `ClosedDate`, `LinkedActionPlan`  
**Logic:** `Implemented` requires `ImplementationNote`. `Deferred`/`Rejected` require `DecisionRationale`.  
**Formatting:** Display `Status` with color coding – Submitted (gray), Under Review (orange), Approved (blue), Implemented (green), Promoted (indigo), Deferred (amber), Rejected (red). Display `Impact` colored – High (emerald), Medium (blue), Low (slate).

---

## 3. Roles & Permissions

| Role | Permission Level |
|---|---|
| Laboratory Analyst | Contribute (submit) |
| Laboratory Manager | Contribute + Review/Decide |
| Quality Assurance Manager | Contribute + Review/Approve + Promote |
| Laboratory Director | View |

**Approval Workflow:**  
1. Staff submits idea → `Status = "Submitted"` → Power Automate notifies QA/Manager.  
2. Reviewer triages → Approved / Deferred / Rejected, or Promoted to an Action Plan.  
3. Simple improvements implemented and closed; promoted ones continue on `LS_QP1501r01`.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Feeds into | `LS_QP1501r01_ActionPlans` | High-impact/resourced OFIs are promoted into managed action plans (`SourceOFI` link). |
| Receives from | `LS_QP1201r01_Complaints` | Feedback classified as an improvement idea can be logged here (`Source = "Customer Feedback"`). |
| Receives from | `LS_QP1703r01_AuditReport` | Improvement opportunities / "weak points" from audits can seed OFIs (`Source = "Audit Output"`). |
| Receives from | `LS_QP1201r01_Complaints` (trend) | Periodic feedback-category analysis creates trend-driven OFIs (`Source = "Feedback Trend Analysis"`). |
| Feeds into | `LS_QP1801r01_ManagementReview` | Effectiveness of improvements + customer feedback are management-review inputs (8.9.2 i/k). |
| Feeds into | Dashboard UI | Data source for the **Improvement** tab (OFI #, Idea, Submitter, Status, Impact). |
