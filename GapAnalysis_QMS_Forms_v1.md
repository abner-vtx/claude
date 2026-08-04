# Gap Analysis — QMS Dashboard Form Specifications

**Project:** VxLabs – Catalyst LIMS / QMS Dashboard (v05)
**Scope of review:** The 11 form specifications in `Form_Specs/`, assessed against ISO/IEC 17025:2017 and against what an accreditation-body assessor expects to see as objective evidence.
**Basis:** ISO/IEC 17025:2017 clause text (as carried in the lab's own Audit Checklist, FM QP17.02), the QP-12 to QP-17 procedures, and the record examples.
**Date:** 6 July 2026 · **Status:** Draft for review

---

## 0. Resolution status (rev 02 — after user decisions)

The user reviewed this analysis and directed the following. All items below are now reflected in the form specs / new resources.

| Gap item | Decision | Where implemented |
|---|---|---|
| Management Review record (8.9) | Build it; **hybrid list + Word/PDF minutes — CONFIRMED** | `FormSpec_LS_QP1801r01_ManagementReview` |
| Platform validation & data integrity (7.11) | Produce the resources; e-sig = named accounts + Created/Modified by **+ six enhancements ADOPTED** (items 1–3 mandatory before go-live) | `PlatformValidation_DataIntegrity_v01` |
| Corrective Action gaps (8.7.1 b/e/f) | Implement | `…QP1601…` — extent-of-condition, `RiskRef`, `DCRRef` |
| Complaint-handler independence (7.9.6) | Add | `…QP1201…` — `IndependentReviewer`, closure gate |
| NCW resumption authority + recall (7.10.1 e/f) | Add | `…QP1301…` — `ResumptionAuthorizedBy`, `ReportsAction` |
| Auditor independence + competence; risk-based programme | Add | `…QP1701…` (independence/competence), `…QP1704…` (risk basis) |
| Traceability lookups (complaints, CA, risk/improvement) | Add | `…1201/1601/1501/1503…` — sample/report/method/equipment/personnel |
| Customer-feedback-to-improvement analysis (8.6.2) | Integrate | `…QP1503…` — direct + trend paths; `…QP1201…` `ImprovementRef` |
| Due-date/aging/escalation across reactive forms | Add | `1201/1301/1601/1402/1501/1503/1703` — `DueDate`/`AgeDays`/`EscalationState` |
| NA-justification + evidence-sampled (checklist) | Add | `…QP1702…` — `NAJustification`, `EvidenceSampled` |
| Current DCR form (FM QP14.02) | Integrate | `…QP1402…` rebuilt: batch changes, change driver, 2-stage approval, issuing checklist, implementation/training |

Record-control metadata (8.4) is addressed system-wide via the reusable **Record-Control block** in the Platform Validation package, referenced by every spec. Remaining "should/nice-to-have" items (Technical Competence Evaluation form, periodic-document-review record) are noted for a later pass.

---

## 1. Executive Summary

The forms are, on the whole, **strong on the "reactive" side of the quality system** — complaints, nonconforming work, corrective actions, risk actions and audits are each captured with a clear lifecycle, sign-offs, and cross-links between processes. For those processes an assessor would find most of the objective evidence they look for.

However, the package as it stands is **not yet "assessment-ready."** The gaps fall into three bands:

- **Systemic / high-priority (must fix before a surveillance assessment).** These affect the whole system, not one form: (a) there is **no Management Review record (Clause 8.9)** anywhere in the set, yet the dashboard tab is called "Audits & *Reviews*"; (b) moving these records from signed paper into SharePoint triggers **Clause 7.11 (control of data and information) and 7.11.2 software validation** obligations that the specs do not yet address — data integrity, audit trail, access control, backup, and **electronic-signature equivalence** (the paper forms explicitly require handwritten signatures); (c) **record control per Clause 8.4** (retention, protection, amendment history) is not specified on any form.
- **Clause-specific content gaps.** A handful of individual ISO requirements are not represented as fields — most notably the corrective-action **"extent of condition"** check (8.7.1 b: *does this nonconformity exist elsewhere?*), the CA obligations to **update risks/opportunities and the management system** (8.7.1 e/f), **complaint-handler independence** (7.9.6), **authorization to resume work** (7.10.1 f), and **auditor independence/competence** (8.8).
- **Assessor-experience gaps.** Things that are not strictly "a missing field" but that make or break an audit: traceability to samples/reports/equipment/personnel, due-date and overdue/aging visibility, severity/risk grading, and trend data feeding management review.

**Bottom line:** the reactive forms are close to adequate with targeted additions; the system-level records (management review, record-control metadata, and the digital-system validation/data-integrity layer) are the real gaps an assessor would raise first.

---

## 2. How to read this document

Each finding is rated:

| Rating | Meaning |
|---|---|
| ✅ **Adequate** | Requirement is captured; an assessor would accept it. |
| 🟡 **Minor gap** | Partially captured; tighten wording or add a field. Unlikely to be a standalone finding but worth closing. |
| 🟠 **Major gap** | A specific ISO requirement or expected record is missing; a plausible audit finding. |
| 🔴 **Systemic gap** | Affects the whole system or the digital platform; highest assessor priority. |

---

## 3. Systemic / cross-cutting gaps (highest priority)

### 3.1 🔴 Management Review (Clause 8.9) — no record exists
The v05 tab is "Audits & **Reviews**," but there is no form/list for management review. Clause **8.9.2** requires *recorded* inputs covering **fifteen** specific items (a–o): changes in issues, objectives, suitability of policies/procedures, status of prior review actions, internal audit outcomes, corrective actions, external assessments, changes in work volume/type, customer and personnel feedback, complaints, effectiveness of improvements, adequacy of resources, results of risk identification, validity-of-results outcomes, and monitoring/training. Clause **8.9.3** requires recorded outputs (decisions/actions on system effectiveness, improvement, resources, change needs).
**Recommendation:** Add a **`LS_QP18xx` / `LS_QPMR` Management Review Record** (parent = review meeting; child = the 15 inputs and the output actions). It should *pull* metrics directly from the other lists (open NCWs, CA effectiveness, audit findings, complaints, OFIs, risk actions) — the dashboard already aggregates most of this. Without it, 8.9 is unauditable.

### 3.2 🔴 Digital-system validation & data integrity (Clause 7.11)
Clause **7.11.2** requires the information management system to be **validated for functionality — including configuration and any modifications — before introduction**. Clause **7.11.3** requires protection from unauthorized access/tampering, safeguarding of integrity, audit trails, backups, and environmental protection. The lab's *own* risk register (AARO record) already flagged *"Not meeting ISO 17025 requirements for software validations/verifications."*
**Not currently in any spec:**
- A **validation/verification record** for the SharePoint QMS itself (test scripts, configuration baseline, change control for future modifications).
- **Audit trail** requirements on each list (who changed what/when — SharePoint version history exists but must be *specified, retained, and protected from deletion*).
- **Access control / role-to-permission mapping** validated against confidentiality (4.2) — e.g., customer complaint data segregation.
- **Backup & recovery** and **retention** configuration.
**Recommendation:** Add a system-level "QMS Platform Validation & Data Integrity" specification (separate from the forms) and reference it from each form's Section on record control.

### 3.3 🔴 Electronic signatures & record control (Clauses 8.4, 7.11, ALCOA+)
Every source record states *"All signatures and initials require handwritten application."* The specs replace these with `Person` sign-off fields but do not define **e-signature equivalence** (attributable, intent-to-sign, tamper-evident, time-stamped) or the **record-control metadata** Clause 8.4 expects: unique ID ✅ (present), but **retention period, legibility/format, protected storage, amendment history with reason, and prevention of loss** are not specified on any form.
**Recommendation:** Add a common **"Record Control"** block to every spec (retention period, confidentiality class, e-signature method, amendment-tracking rule) and a documented e-signature policy. This is a single reusable pattern applied to all 11 lists.

### 3.4 🟠 Traceability links are inconsistent
Assessors trace a quality event to the specific samples, test reports, equipment, methods, and personnel involved. Present in places (NCW has `RelatedSample`, `TestReportNo`) but absent elsewhere (Complaints has no sample/report link; CA has no direct sample/equipment link; risk actions don't reference affected methods).
**Recommendation:** Add optional lookups (sample ID, test report #, equipment ID, method/SOP ID, personnel) to Complaints, CA, and Risk/Improvement, so any record can be traced end-to-end.

### 3.5 🟡 Timeliness, aging & escalation
Dates are captured, but "open since," due-date breaches, and escalation are only partially modeled (some grids flag overdue rows). Assessors look for evidence that events are handled *without undue delay* (8.8.2 d) and that acknowledgements are timely (7.9.5).
**Recommendation:** Add `DueDate` + computed `AgeDays`/`Overdue` to Complaints, NCW, CA, DCR, and audit findings; surface on the dashboard.

---

## 4. Per-form gap analysis

### 4.1 Complaint & Feedback Report — `LS_QP1201r01` (Clause 7.9)

| ISO 7.9 requirement | In the form? | Rating | Action |
|---|---|---|---|
| 7.9.1 receive, evaluate, decide | Yes | ✅ | — |
| 7.9.3 acknowledge receipt to complainant | Not captured | 🟠 | Add `AcknowledgementSent` + date (receipt confirmation to submitter, distinct from final outcome). |
| 7.9.4 gather & verify all info to validate | Yes (`ValidityRationale`) | ✅ | — |
| 7.9.5 progress reports + outcome to complainant | Partial (closing notification only) | 🟡 | Add optional progress-update log. |
| **7.9.6 outcome decided/approved by person NOT involved in original activities** | **Not captured** | 🟠 | Add an **independence check**: `ReviewedByIndependent` (person) + attestation that they were not involved in the original work. In the example one person (Lab Manager) did everything — a classic finding. |
| 7.9.7 formal notice of end of handling | Yes (`SubmitterNotified`) | ✅ | — |
| Link to affected reports/samples | No | 🟡 | Add sample/report lookups (see 3.4). |
| Severity/classification | No | 🟡 | Add `Severity`/`Category` grading to drive risk-based response. |

### 4.2 Nonconforming Work Report — `LS_QP1301r01` (Clause 7.10)

| ISO 7.10 requirement | In the form? | Rating | Action |
|---|---|---|---|
| 7.10.1 a) responsibilities/authorities defined | Implicit (roles) | 🟡 | Make `AuthorityForNCDecision` explicit. |
| 7.10.1 b) actions based on **risk levels** (halt/repeat/withhold reports) | Partial (immediate actions free-text) | 🟡 | Add `RiskLevel` grading and explicit `ReportsWithheld/Recalled` flag. |
| 7.10.1 c) significance + impact on previous results | Yes (`ImpactAssessment`) | ✅ | — |
| 7.10.1 d) decision on acceptability | Yes (`Proceeds`) | ✅ | — |
| 7.10.1 e) customer notified & work **recalled** | Partial (notify only) | 🟠 | Add explicit **`WorkRecalled`** action + recall scope (reports/certificates withdrawn). |
| **7.10.1 f) authority to authorize resumption of work** | **Not captured** | 🟠 | Add **`ResumptionAuthorizedBy`** + date — assessors specifically look for who cleared work to restart. |
| 7.10.3 recurrence/doubt → corrective action | Yes (`CARequired` + link) | ✅ | — |

### 4.3 Document Master List — `LS_QP1401r01` (Clause 8.3)

| ISO 8.3 requirement | In the form? | Rating | Action |
|---|---|---|---|
| 8.3.2 a) approval before issue | Yes (via DCR) | ✅ | — |
| 8.3.2 b) **periodic review** & update | Partial (`NextRevisionDate`) | 🟠 | Add a **periodic-review record** proving review occurred *even when no change resulted* (reviewer, date, outcome "no change"). A due date alone is not evidence of review. |
| 8.3.2 c) changes & current revision status identified | Yes | ✅ | — |
| 8.3.2 d) relevant versions available at point of use | Partial (`DistributionLocation`) | 🟡 | Add controlled-copy holder list / acknowledgement. |
| 8.3.2 e) uniquely identified | Yes | ✅ | — |
| 8.3.2 f) unauthorized change prevented | Partial (integrity rule) | 🟡 | Tie to platform access-control (3.2). |
| 8.3.2 g) obsolete docs prevented from unintended use | Partial (`Superseded/Obsolete` status) | 🟡 | Specify watermarking/quarantine of obsolete files. |

### 4.4 Document Change Request — `LS_QP1402r01` (Clause 8.3)
✅ Largely adequate. 🟡 Add **impact-on-training** flag (does the change require re-training/re-read acknowledgement?) and **effective-from communication** to affected staff — assessors check that changed procedures were communicated and understood.

### 4.5 Risks & Opportunities Action Plan — `LS_QP1501r01` (Clause 8.5)

| ISO 8.5 requirement | In the form? | Rating | Action |
|---|---|---|---|
| 8.5.1 address risks & opportunities | Yes | ✅ | — |
| 8.5.2 plan actions, integrate, **evaluate effectiveness** | Yes (`EffectivenessResult`) | ✅ | — |
| 8.5.3 proportionate to potential impact | Partial (Low/Med/High) | 🟡 | Add **residual risk** after treatment; embed FMEA score (S×O×D) rather than only attaching the spreadsheet. |
| Source/trigger of the risk | No | 🟡 | Add `Source` (audit, management review, complaint, change) for traceability into management review 8.9.2(m). |

### 4.6 Improvement / OFI — `LS_QP1503r01` (Clause 8.6)

| ISO 8.6 requirement | In the form? | Rating | Action |
|---|---|---|---|
| 8.6.1 identify & select opportunities, implement | Yes | ✅ | — |
| **8.6.2 seek feedback (positive & negative) from customers, analyze & use to improve** | Not captured as an input | 🟠 | Explicitly wire **customer feedback analysis** (from 1201) into improvement, and record how feedback trends are reviewed. Right now feedback is logged but not shown to be *analyzed for improvement*. |

### 4.7 Corrective Action Plan — `LS_QP1601r01` (Clause 8.7)

| ISO 8.7.1 requirement | In the form? | Rating | Action |
|---|---|---|---|
| a) react, control, correct, address consequences | Yes (immediate actions inherited from NCW) | ✅ | — |
| b) evaluate cause: review NC, **determine causes**, **determine if similar NC exist or could occur** | **Partial — root cause yes, "extent of condition" NO** | 🟠 | Add an explicit **`SimilarNCReviewed` / extent-of-condition** field: *have we checked whether this nonconformity exists elsewhere or could occur in other areas?* This is one of the most common CA findings. |
| c) implement action | Yes (action items) | ✅ | — |
| d) review effectiveness | Yes (effectiveness controls) | ✅ | — |
| **e) update risks & opportunities if necessary** | **Not captured** | 🟠 | Add link/flag to raise or update a `LS_QP1501r01` risk from the CA. |
| **f) make changes to the management system if necessary** | **Not captured** | 🟠 | Add link/flag to raise a **DCR (`LS_QP1402r01`)** when the CA requires a document/system change (the example CA literally revises PM-04 — that change should be traceable to a DCR). |
| 8.7.2 appropriate to effects | Partial | 🟡 | Add proportionality note. |

### 4.8 Audit Notification — `LS_QP1701r01` (Clause 8.8)
✅ Good coverage of scope/criteria/team/agenda. 🟠 **Auditor independence**: add an attestation that assigned auditors **do not audit their own work** (8.8 note). 🟡 Add **auditor competence** reference (link to a competence record) — assessors check auditors are qualified.

### 4.9 Audit Checklist — `LS_QP1702r01` (Clause 8.8)
✅ Strong — full-standard seeding, C/NC/NA, evidence comments, finding linkage. 🟡 Add an **"applicability" justification** when `NA` is chosen (assessors challenge NA entries), and capture **objective evidence sampled** (record IDs reviewed), not just narrative comments.

### 4.10 Audit Report — `LS_QP1703r01` (Clause 8.8)

| ISO 8.8.2 requirement | In the form? | Rating | Action |
|---|---|---|---|
| c) results reported to relevant management | Partial | 🟡 | Add `DistributedTo`/acknowledgement of report receipt by management. |
| d) correction/CA **without undue delay** | Yes (findings → NCW/CA) | ✅ | Add due-date/aging (see 3.5). |
| e) retain records of programme & results | Yes | ✅ | — |
| Finding severity/grading | Yes (`Severity`) | ✅ | — |

### 4.11 Audit Program — `LS_QP1704r01` (Clause 8.8)

| ISO 8.8.2 a) requirement | In the form? | Rating | Action |
|---|---|---|---|
| Programme considers **importance of activities, changes, and results of previous audits** | Partial (fixed clause matrix) | 🟠 | Add a **risk-based scheduling rationale**: why each area's frequency was chosen, and an input from *previous audit findings* and *changes*. A flat annual matrix without rationale invites the finding "programme not risk-based." |
| Planned intervals / full coverage | Yes (coverage check) | ✅ | — |

---

## 5. Missing forms / records (not just missing fields)

| Missing record | Clause | Priority | Note |
|---|---|---|---|
| **Management Review** record (inputs a–o, outputs) | 8.9 | 🔴 | No list exists; tab is named "Reviews." Should aggregate from all other lists. |
| **QMS Platform Validation & Data Integrity** spec | 7.11.2/7.11.3 | 🔴 | Validation of the SharePoint system, audit trail, access, backup, e-sig. |
| **Technical Competence Evaluation** (FM QP17.04, referenced in the Audit Report) | 6.2 | 🟠 | Cited in the audit report example but no spec; supports auditor & analyst competence. |
| **Periodic Document Review** record | 8.3.2 b | 🟡 | Evidence that documents were reviewed on schedule even when unchanged. |
| **Customer Feedback / Survey analysis** (FM QP12.02) | 8.6.2 | 🟡 | Feedback intake exists; the *analysis for improvement* record does not. |

---

## 6. Prioritized recommendations

**Before the next surveillance assessment (must-fix):**
1. Add the **Management Review** record (8.9) and wire it to the dashboard aggregates.
2. Produce the **platform validation & data-integrity / e-signature** specification (7.11, 8.4) and add a reusable **Record Control** block to all 11 forms.
3. Close the **Corrective Action** clause gaps: extent-of-condition (8.7.1 b), update-risk (e), and change-management/DCR link (f).
4. Add **complaint-handler independence** (7.9.6) and **NCW resumption-of-work authority + recall** (7.10.1 e/f).

**Should-fix (before build sign-off):**
5. Auditor **independence + competence** on the audit forms; **risk-based rationale** on the audit programme.
6. **Traceability lookups** (sample/report/equipment/method/personnel) across Complaints, CA, Risk/Improvement.
7. **Periodic document review** evidence; **customer-feedback-to-improvement** analysis.

**Nice-to-have (polish / assessor delight):**
8. Due-date/aging/escalation across all reactive forms.
9. Residual-risk and embedded FMEA scoring on risk actions.
10. NA-justification and evidence-sampled capture on the checklist.

---

## 7. Conclusion

Would an assessor be satisfied today? **For the reactive processes (complaints, NCW, CA, audits, risk actions), nearly — with the targeted field additions in Section 4.** For the **system as a whole, not yet**: the absence of a **management review record**, the unaddressed **digital-system validation / data-integrity / e-signature** obligations, and the missing **record-control metadata** are the findings an assessor would raise first, because they cut across every form. Addressing Sections 3 and 5 closes the structural gaps; Section 4 closes the clause-level detail. None of this requires re-architecting the specs — it is additive, and most of it reuses patterns already present in the stronger forms.

*Recommend resolving the Section 6 "must-fix" items before the v04↔v05 merge, so the merged design already carries them.*
