# QMS Dashboard – Form Specifications Index

**Project:** VxLabs – Catalyst LIMS / QMS Dashboard (v05 core prototype)  
**Phase:** Planning – form specifications for each v05 section  
**Convention:** `LS_QP{SOP}{form}r{rev}` (aligned to Vertex's own `FM/FE/PM QPxx.yy` numbering)  
**Template:** matches `Example_form_Specs/` (Header → Purpose → §1 Data Schema → §2 Layout & Logic → §3 Roles → §4 Integration)

Twelve specifications cover every form-bearing section of the v05 dashboard (all tabs except the read-only Dashboard), plus a platform validation/data-integrity package. Each is *enriched*: schema derived from the record example, then extended with conditional logic, roles/permissions, integration points, and ISO/IEC 17025:2017 clause references, and grounded in the governing QP SOP.

**Revision note (rev 02):** Incorporates the user's decisions on the Gap Analysis — Corrective Action gaps closed (extent-of-condition, update-risk, DCR link), complaint-handler independence, NCW resumption/recall, auditor independence & competence, risk-based audit programme, traceability lookups, customer-feedback-to-improvement, due-date/aging across reactive forms, NA-justification on the checklist, a new **Management Review** spec (8.9), a **Platform Validation & Data-Integrity** package (7.11/8.4), and the DCR spec rebuilt to match the real FM QP14.02 form.

## Specifications

| # | Spec file | Primary list | v05 tab | Master SOP | Source record | ISO clause |
|---|---|---|---|---|---|---|
| 1 | `FormSpec_LS_QP1201r01_ComplaintFeedbackReport` | `LS_QP1201r01_Complaints` | Customer Relations | QP-12 (FM QP12.01) | Complaint_Example_01 | 7.9 |
| 2 | `FormSpec_LS_QP1301r01_NonconformingWorkReport` | `LS_QP1301r01_NonconformingWork` | Nonconforming Work | QP-13 (FM QP13.01) | Nonconforming_Work_Example_01 | 7.10 |
| 3 | `FormSpec_LS_QP1401r01_DocumentMasterList` | `LS_QP1401r01_DocumentRegister` | Control of Documents | QP-14 (FE QP14.01) | — (register) | 8.3 |
| 4 | `FormSpec_LS_QP1402r01_DocumentChangeRequest` | `LS_QP1402r01_ChangeRequests` | Change Management | QP-14 (FM QP14.02) | Document_Change_Request_Example_01 | 8.3 |
| 5 | `FormSpec_LS_QP1501r01_RisksOpportunitiesActionPlan` | `LS_QP1501r01_ActionPlans` | Risks & Opportunities | QP-15 (FM QP15.01) | Action_to_Address_R&O_Example_01 | 8.5 |
| 6 | `FormSpec_LS_QP1503r01_Improvement` | `LS_QP1503r01_Improvement` | Improvement | QP-15 | — (v05 OFI tab) | 8.6 |
| 7 | `FormSpec_LS_QP1601r01_CorrectiveActionPlan` | `LS_QP1601r01_CorrectiveActions` | Corrective Actions | QP-16 (FM QP16.01) | Corrective_Action_Example_01 | 8.7 |
| 8 | `FormSpec_LS_QP1701r01_AuditNotification` | `LS_QP1701r01_AuditNotification` | Audits & Reviews | QP-17 (FM QP17.01) | Audit_Notification_Example_01 | 8.8 |
| 9 | `FormSpec_LS_QP1702r01_AuditChecklist` | `LS_QP1702r01_AuditChecklist` | Audits & Reviews | QP-17 (FM QP17.02) | Audit_Checklist_Example_01 | 8.8 |
| 10 | `FormSpec_LS_QP1703r01_AuditReport` | `LS_QP1703r01_AuditReport` | Audits & Reviews | QP-17 (FM QP17.03) | Audit_Report_Example | 8.8 |
| 11 | `FormSpec_LS_QP1704r01_AuditProgram` | `LS_QP1704r01_AuditProgram` | Audits & Reviews | QP-17 (PM-05) | Audit_Program_Example_01 | 8.8 |
| 12 | `FormSpec_LS_QP1801r01_ManagementReview` | `LS_QP1801r01_ManagementReview` | Audits & Reviews | QP-18 (FM QP18.01) | — (new; Word→PDF) | 8.9 |

**Platform resource (not a form):** `PlatformValidation_DataIntegrity_v01` — SharePoint QMS validation plan, IQ/OQ/PQ protocol, ALCOA+ data-integrity controls, e-signature assessment & recommendations, and the reusable Record-Control block (Clauses 7.11 & 8.4).

## Data-flow map (how the lists connect)

```
Complaints (1201) ──┐
                    ├──► Nonconforming Work (1301) ──► Corrective Actions (1601)
Audit Report (1703)─┘            ▲                              │
     ▲                          │  (findings)                  ▼
     │                          └──────────────────────► writes back NCW close-gate
Audit Checklist (1702) ─(NC items)─► Audit Report (1703)
     ▲                                   │
Audit Notification (1701) ◄── Audit Program (1704)   └─(weak points)─► Improvement (1503)
                                                                            │
Improvement (1503) ──(promote)──► Risks & Opportunities Action Plans (1501) ◄┘
Doc Change Request (1402) ──(on effectiveness)──► Document Register (1401) ──► lookups for all lists
```

## Supporting / child lists introduced

- `LS_QP1402r01a_AffectedDocuments`, `…b_ImplementationAttendants` (Document Change Request)
- `LS_QP1501r01a_ImpactAssessment`, `LS_QP1501r01b_Deliverables` (Risks & Opportunities)
- `LS_QP1601r01a_Participants`, `…b_ActionItems`, `…c_EffectivenessControls` (Corrective Actions)
- `LS_QP1701r01a_AuditAgenda` (Audit Notification)
- `LS_QP1702r01a_ChecklistItems` + `REF_ISO17025_Clauses` master template (Audit Checklist)
- `LS_QP1703r01a_Findings` (Audit Report)
- `LS_QP1704r01a_ScheduleLines` (Audit Program)
- `LS_QP1801r01a_ReviewInputs` (8.9.2 a–o), `…b_ReviewOutputs` (8.9.3) (Management Review)

## Open points for review

1. **ID prefixes** carried over from the records (`CMP`, `NC`, `CAR`, `AARO`, `OFI`, `DCR`, `AUD`, `MR`) — confirm the year format (`{YY}` vs `{YYYY}`) and sequence width to standardize.
2. **Improvement (1503)** kept as a separate list to match the v05 tab; QP-15 treats *Improvement* as an action-plan type, and 1503 promotes to 1501 for resourced work. Confirm this split is acceptable.
3. **v04 elements** to be merged into v05 are still to be defined (per project brief) — the "must-fix" gap items are now baked in ahead of the merge.
4. **Related tracking registers** (`FE QP12.02`, `FE QP13.01`, `FE QP15.02`) are treated as reporting views over the primary lists rather than separate forms — confirm.
5. **Roles** use five personas (Lab Manager, QA Manager, Lab Director, Lab Analyst, Customer Support) derived from the SOPs; map these to actual SharePoint groups before build.
6. ~~**Management Review (1801)** — confirm the hybrid approach.~~ ✅ **CONFIRMED** — hybrid (structured list + auto-generated Word/PDF minutes) adopted.
7. ~~**E-signature** — confirm intent to adopt the six enhancements.~~ ✅ **ADOPTED** — named accounts + `Created/Modified by` plus the six enhancements (Platform Validation Part 5); items 1–3 (explicit approval action, record locking, MFA) mandatory before go-live.
