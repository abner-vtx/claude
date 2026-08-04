# Form Specification: Audit Checklist

**Master SOP:** QP-17 – Audits  
**Form ID:** LS_QP1702r01 *(digital successor to FM QP17.02 Audit Checklist)*  
**Form Title:** ISO/IEC 17025:2017 Audit Checklist  
**SharePoint List:** `LS_QP1702r01_AuditChecklist`  
**ISO/IEC 17025:2017 Reference:** Clause 8.8 – Internal Audits (execution / evidence)  
**Document Status:** Draft  

**Purpose:** To verify, clause by clause, the laboratory's compliance with the applicable requirements of ISO/IEC 17025:2017 during an audit, and to record the conformance judgement and supporting comments (cross-referenced to the Quality Manual and procedures) for each requirement. The checklist is seeded from a master clause template so every audit starts from the full standard; the auditor marks each line **C** (Conform), **NC** (Nonconform), or **NA** (Not Applicable). Nonconform lines become the findings carried into the Audit Report (`LS_QP1703r01`). This is the execution record behind the **Audits & Reviews** tab.

---

## 1. Data Schema

### 1.1 Parent list — `LS_QP1702r01_AuditChecklist`

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ChecklistID` | Single Line Text | Yes | Checklist ID | Auto-generated `CHK-{AuditID}` (e.g., `CHK-AUD-26-01`). Read-only. |
| `AuditRef` | Lookup → `LS_QP1701r01_AuditNotification` | Yes | Audit Event | Parent audit; inherits `AuditID`. |
| `AuditScope` | Multiple Lines | Yes | Audit Scope | Pulled from the notification. |
| `Auditor` | Person | Yes | Auditor | — |
| `TemplateVersion` | Single Line Text | Yes | Clause Template Version | Version of the master ISO clause set used to seed items (e.g., `ISO17025-2017 v1`). |
| `Status` | Choice | Yes | Status | `Not Started`, `In Progress`, `Completed`, `Reviewed` |
| `ConformCount` | Number | No | # Conform | Rollup (read-only). |
| `NonconformCount` | Number | No | # Nonconform | Rollup (read-only); drives finding generation. |
| `NACount` | Number | No | # Not Applicable | Rollup (read-only). |

### 1.2 Child list — `LS_QP1702r01a_ChecklistItems` *(one row per requirement; seeded from master template)*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `ChecklistRef` | Lookup → `LS_QP1702r01_AuditChecklist` | Yes | Parent Checklist | — |
| `ClauseNo` | Single Line Text | Yes | Clause | e.g., `4.1.1`, `6.2.5`, `7.7.2`. |
| `Section` | Choice | Yes | Section Group | `4 General`, `5 Structural`, `6 Resource`, `7 Process`, `8 Management System` |
| `Requirement` | Multiple Lines | Yes | Requirement | The standard's requirement text (seeded, read-only). |
| `IsHeader` | Yes/No | No | Heading Row? | `Yes` for section/clause headings and NOTE rows that are not scored. |
| `Conformance` | Choice | No | Conformance | `C` (Conform), `NC` (Nonconform), `NA` (Not Applicable) |
| `Comments` | Multiple Lines | No | Comments on Conformance | Evidence / QM cross-reference (e.g., `(QM 4.1.2) …`). |
| `NAJustification` | Multiple Lines | No | NA Justification | **Mandatory when `Conformance == "NA"`** — why the requirement does not apply to this laboratory's scope. |
| `EvidenceSampled` | Multiple Lines | No | Objective Evidence Sampled | Specific record IDs / documents / observations examined (e.g., `NC26003`, `LBK-2601`, `MOA-02 rev02`), not just narrative — shows what was actually checked. |
| `FindingRef` | Lookup → `LS_QP1703r01a_Findings` | No | Linked Finding | Set automatically when `Conformance == "NC"`. |
| `SortOrder` | Number | Yes | Order | Preserves standard clause order. |

> **Master clause template:** A reusable reference list (`REF_ISO17025_Clauses`) holds the full ordered set of ISO/IEC 17025:2017 requirement rows (Sections 4–8, ~400 items incl. headings/NOTES), each with `ClauseNo`, `Section`, `Requirement`, `IsHeader`, and `SortOrder`. On checklist creation, Power Automate copies this template into `LS_QP1702r01a_ChecklistItems`, so each audit begins with the complete standard.

> **Data Integrity Rule:** `Requirement`, `ClauseNo`, and `SortOrder` are read-only (seeded from template). A checklist cannot be `Completed` while any non-header item has a blank `Conformance`. Every `NC` item must have `Comments` populated before completion.

---

## 2. Form Layout & Logic

### Section 01 – Checklist Header

**Fields:** `ChecklistID`, `AuditRef`, `AuditScope`, `Auditor`, `TemplateVersion`, `Status`, rollup counts  
**Logic:** `AuditScope`/`Auditor` inherited from the notification. Rollup counts update live as items are marked.

---

### Section 02 – Clause Checklist *(grid — child list 1.2)*

**Fields:** per row: `ClauseNo`, `Requirement`, `Conformance`, `Comments`, `NAJustification`, `EvidenceSampled`  
**Logic 1:** Rendered grouped by `Section` (collapsible), preserving `SortOrder`. Header rows (`IsHeader == Yes`) render as non-scored section titles/NOTES.  
**Logic 2:** `Conformance` renders as a C / NC / NA segmented control per row. Selecting **NC** makes `Comments` mandatory and enables **"Raise Finding"**, which creates/links a `LS_QP1703r01a_Findings` row (bridging `ClauseNo` + `Comments`) and stores it in `FindingRef`.  
**Logic 3 – NA justification:** Selecting **NA** makes `NAJustification` mandatory (assessors challenge unexplained NA entries).  
**Logic 4 – Evidence sampled:** `EvidenceSampled` prompts the auditor to record the specific records/documents examined for each clause, providing an audit trail of what was actually sampled.  
**Logic 5:** Filters/quick views: *All*, *Nonconformities only*, *NA (with justification)*, *Unmarked*, by `Section`.  
**Formatting:** Row tint by conformance – C (green), NC (red), NA (slate), unmarked (white).

---

## 3. Roles & Permissions

| Role | Permission Level |
|---|---|
| Auditor / Lead Auditor | Contribute (mark conformance, comment) |
| Quality Assurance Manager | Contribute + Review |
| Laboratory Manager | View |
| Auditee | View (post-audit) |

**Approval Workflow:** Checklist generated from the notification → auditor marks each clause during the audit → `Status = "Completed"` when all items are judged → QA reviews → NC items flow to the Report as findings.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Receives from | `LS_QP1701r01_AuditNotification` | Created per audit event; inherits `AuditID`, scope, auditor. |
| Receives from | `REF_ISO17025_Clauses` | Seeded with the full ordered clause/requirement set on creation. |
| Feeds into | `LS_QP1703r01_AuditReport` | Every `NC` item generates a finding row in the report (`FindingRef`). |
| References | `LS_QP1401r01_DocumentRegister` | `Comments` cross-reference Quality Manual / procedure clauses (QM x.x). |
| Feeds into | Dashboard UI | Conformance rollups surface audit results in the **Audits & Reviews** tab. |
