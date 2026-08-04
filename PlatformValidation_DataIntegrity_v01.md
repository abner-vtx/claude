# QMS SharePoint Platform — Validation & Data-Integrity Package

**Project:** VxLabs – Catalyst LIMS / QMS Dashboard
**Applies to:** The SharePoint site, lists (`LS_QP…`), forms, and Power Automate flows that constitute the digital QMS.
**ISO/IEC 17025:2017 basis:** Clause **7.11** (Control of data and information management), Clause **8.4** (Control of records), supported by 7.5 (technical records) and 8.3 (documents).
**Status:** Draft for review · **Rev:** 01

> **Why this exists.** Moving the QMS from signed paper into SharePoint makes the SharePoint site a *laboratory information management system* under Clause 7.11. Clause **7.11.2** requires it to be **validated for functionality — including configuration and modifications — before introduction**, and **7.11.3** requires it to be protected (access control, integrity, audit trail, backup). Your own risk register (AARO2501) already flagged *"not meeting ISO 17025 requirements for software validations/verifications."* This package is the evidence an assessor will ask for, plus the reusable **Record-Control block** every form spec references.

This package contains five parts:
1. Validation Plan (risk-based / CSV-lite)
2. Requirements & Traceability
3. Test Protocol (IQ / OQ / PQ) — templates
4. Data-Integrity & Security Controls (ALCOA+)
5. Electronic-Signature approach — assessment of your current method + recommendations
   — and the **Record-Control block** (Appendix A) referenced by all form specs.

---

## Part 1 — Validation Plan

### 1.1 Scope & approach
A **risk-based, CSV-lite** validation is appropriate: SharePoint/M365 is a vendor-validated commercial platform (Microsoft maintains platform-level validation), so Vertex validates its **configuration and use** — the lists, columns, form logic, permissions, and Power Automate flows it has built — not the underlying platform code. This mirrors GAMP category 4/5 (configured/custom) handling.

### 1.2 Validation lifecycle & deliverables

| Phase | Deliverable | What it proves |
|---|---|---|
| Plan | This Validation Plan | Scope, approach, roles, acceptance criteria. |
| Specify | User Requirements (Part 2) + the Form Specs (`FormSpec_LS_QP…`) | What the system must do. The 12 form specs **are** the functional/configuration spec. |
| Build | Configuration baseline record | The as-built list/column/flow/permission configuration is documented and under change control. |
| Verify | Test Protocol IQ/OQ/PQ (Part 3), executed with evidence | The system works as specified in the production tenant. |
| Release | Validation Summary Report + sign-off | Documented decision that the system is fit for use. |
| Maintain | Periodic review + change control | Modifications are re-verified (7.11.2 "and any modifications"). |

### 1.3 Roles
Validation Lead (QA Manager), System Owner (Lab Manager), Tester(s) independent of build where practical, Approver (Laboratory Director). Records retained per Appendix A.

### 1.4 Acceptance criteria
All requirements traced and tested; all High-risk requirements pass with evidence; no open critical defects; data-integrity controls (Part 4) verified operational.

---

## Part 2 — Requirements & Traceability

Maintain a **Requirements Traceability Matrix (RTM)** linking each requirement → form spec section → test case → result. Requirement sources:

| Req group | Source | Example requirements |
|---|---|---|
| Functional (per process) | Each `FormSpec_LS_QP…` §1–§2 | Fields, conditional logic, status workflow, auto-numbering, cross-list bridging. |
| Data control (7.11) | This package Part 4 | Access control, audit trail, backup, calculation/transfer checks. |
| Record control (8.4) | Appendix A | Retention, protection, amendment history, legibility. |
| Workflow integrity | Form specs §3 | Approvals routed correctly; permissions enforce role matrix. |

> **Tip:** the RTM is a spreadsheet (`RTM_QMS_Platform.xlsx`) — one row per testable requirement. This is the single artifact an assessor traces during a records review.

---

## Part 3 — Test Protocol (IQ / OQ / PQ)

### 3.1 IQ — Installation/Configuration Qualification
Verify and screenshot the as-built configuration against the baseline: site/lists exist with correct internal names & data types; choice options match specs; lookups resolve to correct target lists; permission groups created and mapped to the role matrix; Power Automate flows deployed and enabled; time zone/regional settings correct; versioning enabled on every list; recycle-bin/retention configured.

### 3.2 OQ — Operational Qualification (function works as specified)
Scripted test cases per list. Representative cases:

| # | List | Test | Expected |
|---|---|---|---|
| OQ-01 | 1201 Complaints | Create complaint | `CMP{YY}###` auto-assigned; Status `New`; Lab Manager + QA notified. |
| OQ-02 | 1201 | Set `Proceeds = Yes` | `ImpactAssessment` becomes mandatory; cannot save empty. |
| OQ-03 | 1201 | Attempt close without independent reviewer | Blocked (7.9.6 gate). |
| OQ-04 | 1301 NCW | `WorkHalted = Halted`, attempt close without `ResumptionAuthorizedBy` | Blocked (7.10.1 f gate). |
| OQ-05 | 1601 CA | `MSChangeRequired = Yes`, click Raise DCR | Creates linked `LS_QP1402r01`, `DCRRef` populated. |
| OQ-06 | 1601 CA | Attempt close with extent-of-condition blank | Blocked (8.7.1 b gate). |
| OQ-07 | 1402 DCR | Complete issuing checklist | Register (1401) create/revise/supersede executes correctly. |
| OQ-08 | 1702 Checklist | New checklist | Seeded with full `REF_ISO17025_Clauses` set in correct order. |
| OQ-09 | 1702 | Mark item NC | Finding auto-created in 1703; `FindingRef` linked. |
| OQ-10 | 1801 MR | Open review | 15 input rows (a–o) pre-created; input (d) pulls prior open actions. |
| OQ-11 | Permissions | Analyst attempts QA-only approve | Denied per role matrix. |
| OQ-12 | Auto-number | Create two records same year | Sequence increments, no collision (concurrency). |

### 3.3 PQ — Performance Qualification (real users, real process)
Run each end-to-end scenario with actual users in production: a complaint → NCW → CA → DCR chain; a full audit (Program → Notification → Checklist → Report → findings → CA); a management review cycle. Confirm data integrity, notifications, and generated documents. Retain executed scripts with evidence (screenshots, record IDs).

---

## Part 4 — Data-Integrity & Security Controls (ALCOA+)

Clause 7.11.3 requires protection from unauthorized access/tampering, integrity safeguards, and backup. Map controls to **ALCOA+** (Attributable, Legible, Contemporaneous, Original, Accurate + Complete, Consistent, Enduring, Available):

| Control | Requirement | Configuration in SharePoint/M365 |
|---|---|---|
| **Access control** | 7.11.3, 4.2 confidentiality | Entra ID authentication; **MFA** enforced; least-privilege SharePoint groups mapped to the role matrix; customer-complaint data segregated so customers/assessors see only permitted items; no shared/generic accounts. |
| **Audit trail** | 7.11.3, ALCOA (Attributable/Enduring) | **List versioning enabled** on every list (captures who/what/when); version history **retention** set and protected from user deletion; consider immutable/retention-label policy so trails cannot be purged. |
| **Amendment control** | 8.4.2 | Records lock (read-only) after the status gates defined in each spec; changes after sign create a new version with the prior retained (never overwrite). |
| **Backup & recovery** | 7.11.3 | M365 backup/retention policy documented; recycle-bin + retention labels; periodic restore test evidenced. |
| **Calculation & transfer checks** | 7.11.6 | Any computed columns / flow data transfers (auto-numbering, cross-list bridging, rollups) verified in OQ; spot-check reconciliation. |
| **Time integrity** | ALCOA (Contemporaneous) | Server time (UTC) with correct regional display; users cannot back-date system timestamps (`Created`/`Modified`). |
| **Availability** | 7.11.1 | Documented access for authorized staff; offline/continuity note if the tenant is unavailable. |
| **External provider** | 7.11.4 | Microsoft is the off-site operator; retain the statement that platform requirements (security, availability) are met via the M365 service agreement. |

---

## Part 5 — Electronic-Signature Approach

### 5.1 Your current method — assessment
You are using **individual named accounts ("personalized emails")** plus SharePoint's built-in **`Created by` / `Modified by`** system fields. Assessment against e-signature expectations:

| Attribute | Met by current method? | Note |
|---|---|---|
| **Attributable** to a unique individual | ✅ Yes | Named Entra ID account; no shared logins (must be enforced). |
| **Contemporaneous / time-stamped** | ✅ Yes | `Created`/`Modified` timestamps, server-controlled. |
| **Tamper-evident** | 🟡 Partial | Version history shows changes *if versioning is on and retained*; otherwise weak. |
| **Authenticated** | 🟡 Partial | Login authenticates; strengthen with **MFA**. |
| **Intent / meaning of signature** | 🟠 Gap | `Modified by` records *who last edited*, not *"I approve."* An edit is not a signature. |
| **Record locked after signing** | 🟠 Gap | If a record stays editable, `Modified by` keeps changing and the "signature" is not fixed. |

### 5.2 Enhancements — **ADOPTED** (to make it defensible)

> **Decision:** all six enhancements below are adopted. Items 1–3 (explicit approval action, record locking after signing, MFA + no shared accounts) are **mandatory before go-live**; items 4–6 (retained audit trail, signature manifestation on PDFs, documented policy) accompany the build. These become validation requirements in the RTM and OQ test cases.

1. **Explicit sign action = intent.** Replace "Modified by = signature" with a deliberate **approval step** (a Power Automate Approval, or a "Sign/Approve" button) that stamps a dedicated `ApprovedBy` (Person) + `ApprovedDate` + records the **meaning** (Reviewed / Approved / Authorized). Store these as their own columns — that is the signature, distinct from incidental edits.
2. **Lock after signing.** On approval, set the record (or the signed fields) read-only via permissions/flow so the signed state is fixed; further changes require a new version with reason (8.4.2), preserving the prior.
3. **MFA + no shared accounts.** Enforce MFA on all QMS users; prohibit generic/service accounts for any signing action. Document this in the SOP.
4. **Retain the audit trail.** Turn on versioning everywhere and apply a retention policy so version history (the tamper-evidence) cannot be deleted for the record's retention period.
5. **Signature manifestation on outputs.** When generating PDFs (e.g., management-review minutes, audit reports), render the signer's printed name, role, date, and meaning so the signed intent is visible on the human-readable record.
6. **Document the policy.** A short "Electronic Records & Signatures" statement in QP-14 (or a standalone policy) defining the above makes the approach auditable — assessors accept e-signatures when the *policy and controls* are documented, even without a 21 CFR Part 11-style system (which 17025 does not mandate).

**Conclusion:** your foundation (named accounts + system fields) is reasonable and, with items 1–6 above — chiefly an explicit approval action, record locking, MFA, and retained versioning — becomes a **defensible electronic-signature control** for an internal ISO 17025 QMS.

---

## Appendix A — Record-Control Block *(reusable; referenced by every form spec)*

Add this control set to each `LS_QP…` list (as columns and/or documented list settings):

| Control | Setting |
|---|---|
| **Unique ID** | Auto-generated per spec (e.g., `CMP26001`). |
| **Retention period** | Define per record type (e.g., quality records retained ≥ one accreditation cycle / per QP-14; default 6 years unless specified). Enforced via retention label. |
| **Confidentiality class** | `Public` / `Internal` / `Customer-Confidential` — drives permissions (4.2). |
| **Audit trail** | List versioning ON; version retention ≥ record retention; deletion restricted. |
| **Amendment rule** | Post-sign fields read-only; changes = new version with reason; originals retained (8.4.2). |
| **Legibility/format** | Human-readable in-app + exportable PDF for the signed/minuted record. |
| **Protection/backup** | M365 retention + recycle bin; periodic restore test. |
| **E-signature** | Explicit `ApprovedBy` + `ApprovedDate` + meaning (Part 5). |

> Each form spec references this block via the line *"See common Record-Control block … in `PlatformValidation_DataIntegrity` resources."* Applying it uniformly closes the Clause 8.4 record-control gap across all 12 lists at once.

---

## Suggested build artifacts (to produce next, when we build)
- `RTM_QMS_Platform.xlsx` — requirements traceability matrix.
- `Validation_Protocol_IQ_OQ_PQ.xlsx/.docx` — executable test scripts (from Part 3).
- `ConfigurationBaseline.md` — as-built list/column/flow/permission inventory.
- `ElectronicRecords_Signatures_Policy.md` — the Part 5 policy statement (or a section added to QP-14).
