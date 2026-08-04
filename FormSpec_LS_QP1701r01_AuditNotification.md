# Form Specification: Audit Notification & Plan

**Master SOP:** QP-17 – Audits  
**Form ID:** LS_QP1701r01 *(digital successor to FM QP17.01 Audit Notification)*  
**Form Title:** Audit Notification & Plan  
**SharePoint List:** `LS_QP1701r01_AuditNotification`  
**ISO/IEC 17025:2017 Reference:** Clause 8.8 – Internal Audits (notification & planning)  
**Document Status:** Draft  

**Purpose:** To formally notify the auditee(s) of a scheduled audit and to document the audit event's objectives, scope, criteria, team, methodology, and day-by-day agenda. This record is the **audit event anchor**: it is created against a line of the Audit Programme (`LS_QP1704r01`) and carries the `AuditID` that the Checklist (`LS_QP1702r01`) and Report (`LS_QP1703r01`) reference. This list drives the individual-audit rows in the **Audits & Reviews** tab.

---

## 1. Data Schema

### 1.1 Parent list — `LS_QP1701r01_AuditNotification`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `AuditID` | Single Line Text | Yes | Audit ID | Auto-generated `AUD-{YY}-{##}` (e.g., `AUD-26-01`). Read-only. Shared key across Checklist and Report. |
| `ProgramLineRef` | Lookup → `LS_QP1704r01a_ScheduleLines` | No | Programme Line | The scheduled programme line this audit fulfils. |
| `AuditType` | Choice | Yes | Audit Type | `Internal – Scheduled`, `Internal – Follow-up`, `Vendor / External Provider` |
| `AuditStartDate` | Date | Yes | Audit Start Date | — |
| `AuditEndDate` | Date | Yes | Audit End Date | — |
| `Objectives` | Multiple Lines | Yes | Audit Objectives | — |
| `Scope` | Multiple Lines | Yes | Scope of the Audit | — |
| `Criteria` | Multiple Lines | Yes | Audit Criteria | e.g., `ISO/IEC 17025:2017`, `Vertex QMS`. |
| `AuditTeam` | Person (multi) | Yes | Audit Team | Lead + members. |
| `Auditees` | Person (multi) | No | Auditee(s) | Notified parties. |
| `AuditorIndependence` | Choice | Yes | Auditor Independence (8.8.2) | `Confirmed – auditors do not audit their own work`, `Conflict noted – see notes` |
| `IndependenceNotes` | Multiple Lines | No | Independence Notes | Required if `Conflict noted`; how independence is preserved (e.g., reassignment, second reviewer). |
| `AuditorCompetenceRef` | Lookup / Attachment | No | Auditor Competence Evidence | Link to the auditor's competence record (FM QP17.04 Technical Competence Evaluation / training record) demonstrating qualification to audit the scope. |
| `Methodology` | Multiple Lines | Yes | Audit Methodology | Document review, observation, interviews, records/equipment verification, etc. |
| `PreparedBy` | Person | Yes | Prepared By | — |
| `ManagerAck` | Person | No | Laboratory Manager (acknowledgement) | — |
| `NotificationDate` | Date | Yes | Notification Date | — |
| `Status` | Choice | Yes | Status | `Draft`, `Notified`, `Scheduled`, `In Progress`, `Completed`, `Cancelled` |

### 1.2 Child list — `LS_QP1701r01a_AuditAgenda` *(day-by-day plan)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `AuditRef` | Lookup → `LS_QP1701r01_AuditNotification` | Yes | Parent Audit | — |
| `Day` | Number | Yes | Day # | 1, 2, … |
| `AgendaDate` | Date | Yes | Date | — |
| `TimeSlot` | Single Line Text | Yes | Time | e.g., `09:15 – 13:00`. |
| `Activity` | Multiple Lines | Yes | Activities | Clause groups / activities covered in the slot. |
| `Auditor` | Person (multi) | Yes | Auditor | Assigned auditor(s). |

> **Data Integrity Rule:** `AuditID` is immutable once created. `Objectives`, `Scope`, and `Criteria` lock after `Status == "Notified"` to preserve the notified terms. `AuditEndDate >= AuditStartDate`.

---

## 2. Form Layout & Logic

### Section 01 – Notification Header

**Fields:** `AuditID`, `ProgramLineRef`, `AuditType`, `AuditStartDate`, `AuditEndDate`, `Objectives`, `Scope`, `Criteria`, `AuditTeam`, `Auditees`, `AuditorIndependence`, `IndependenceNotes`, `AuditorCompetenceRef`, `Methodology`, `PreparedBy`, `ManagerAck`, `NotificationDate`  
**Logic 1:** When created from a programme line, `Scope`/`Criteria`/dates pre-populate from `LS_QP1704r01`. On `Status = "Notified"`, Power Automate emails the audit team and auditees.  
**Logic 2 – Independence & competence (8.8.2):** `AuditorIndependence` must be `Confirmed` before the audit can move to `In Progress`; if any team member would audit their own work, `Conflict noted` requires `IndependenceNotes` describing the mitigation. `AuditorCompetenceRef` evidences the auditor is qualified for the scope. Guidance: *"Auditors shall not audit their own work."*

---

### Section 02 – Audit Plan / Agenda *(repeating grid — child list 1.2)*

**Fields:** per row: `Day`, `AgendaDate`, `TimeSlot`, `Activity`, `Auditor`  
**Logic:** Grouped by `Day`; supports multi-day audits (e.g., Day 1 management/QMS clauses, Day 2 technical clauses). A **"Generate Checklist"** action creates the linked `LS_QP1702r01` seeded to the agenda's clause coverage.  
**Formatting:** `Status` color coding – Draft (gray), Notified (blue), Scheduled (indigo), In Progress (amber), Completed (green), Cancelled (red).

---

## 3. Roles & Permissions

| Role | Permission Level |
|---|---|
| Quality Assurance Manager | Contribute + Approve |
| Auditor / Lead Auditor | Contribute (prepare, agenda) |
| Laboratory Manager | View + Acknowledge |
| Auditee (Analyst/Manager) | View |

**Approval Workflow:** Auditor/QA prepares the notification against a programme line → `Status = "Notified"` (auditees informed) → audit executed (`In Progress`) → `Completed` once the Report is closed.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Receives from | `LS_QP1704r01_AuditProgram` | Created against a scheduled programme line; pulls scope/criteria/dates. |
| Feeds into | `LS_QP1702r01_AuditChecklist` | "Generate Checklist" seeds a checklist keyed to this `AuditID`. |
| Feeds into | `LS_QP1703r01_AuditReport` | The report references this `AuditID`, team, auditees, scope, and plan followed. |
| Writes back | `LS_QP1704r01a_ScheduleLines` | On completion, updates the programme line's `CompletedMonth`/`CoverageStatus`. |
| Feeds into | Dashboard UI | Source for the **Audits & Reviews** tab (Audit ID, Scope, Lead, Date, Status). |
