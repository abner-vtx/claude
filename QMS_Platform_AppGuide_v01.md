# QMS Platform — App Guide & Development Roadmap

**Audience:** Lab Manager + Tech Lead — onboarding read before development starts.
**Source app reviewed:** `QMS_Dashboard/QMS_Platform_v5.1.html` (current prototype; see §2 for why this one and not the other version files in this folder).
**Companion documents** (read after this one, for depth): `QMS_Platform_Architecture_v01.md` (subsystem design), `Form_Specs/GapAnalysis_QMS_Forms_v1.md` (ISO gap list), `Form_Specs/*.md` (per-list field-level spec, 12 files), `Form_Specs/PlatformValidation_DataIntegrity_v01.md` (validation/e-signature requirements), `Form_Specs/README_FormSpecs_Index.md` (index + data-flow map).

---

## 1. What this app is for

The QMS Platform is the digital replacement for Vertex Analytical's paper-and-Word ISO/IEC 17025:2017 quality management system. It's meant to be **one SharePoint site** covering the full "reactive quality event" chain — complaints, nonconforming work, corrective actions, risks/opportunities, improvement ideas, internal audits, document control, and management review — plus a read-only "how do I do X" guidance layer for lab staff. Every record type maps to an existing paper form (`FM QP##.##`) or register (`FE QP##.##`) the lab already uses; the platform doesn't invent new processes, it digitizes the existing ones and links them together so an accreditation assessor can trace a complaint all the way through to the corrective action and document change it caused.

It is meant to end up as **one SharePoint-hosted `.aspx` page**, the same way `TestResultsReporting.aspx` and `ReceivedSamples.aspx` already work in production — a single file, reading and writing SharePoint lists via the REST API, with no separate backend.

---

## 2. Current state — what exists today

There is **no ASPX yet**. What exists is a **static HTML prototype**, `QMS_Platform_v5.1.html`, sitting in this folder. It is the newest of several version files in `0_Vertex_LIMS_Projects` (older ones — v03/v04/an abandoned Tailwind rewrite/an earlier "v0.5" build — are superseded; v5.1 is the one to build from).

**Important:** this prototype was built _before_ the Gap Analysis decisions below were finalized in the form specs, and was never updated to match. Do not treat it as "the design, just needs wiring" — several sections need to be rebuilt against the current specs, not just connected to SharePoint. Section 5 below is precise about what's missing.

The prototype is:

- A single HTML file, no server code, no `.aspx` directive.
- **Zero SharePoint connectivity.** No `fetch()`, no `_api/web/lists` calls anywhere.
- Backed by **one embedded JSON blob** (`<script id="lists" type="application/json">`) baked into the page — everything you see is rendered client-side from this static object, not from any live list.
- **Not persistent.** The two record-creation modals (Complaint, Document Change Request) have Save/Submit buttons wired to a stub:
  ```js
  window.demoSave = function (id) {
    closeModal(id);
    showAlert(
      "info",
      "Prototype: the built page saves this to the SharePoint list and routes approvals via Power Automate.",
    );
  };
  ```
  Every other "New" button (NCW, CA, Risk, OFI, Audit) calls an even simpler stub, `demoNew()`, which just pops an informational alert. Nothing is ever saved anywhere.

---

## 3. How the app is organized today

Top-level navigation is four tabs (`data-tab`), matching the architecture's four subsystems:

| Tab           | Sub-tabs (as built)                                                                               | Subsystem                              |
| ------------- | ------------------------------------------------------------------------------------------------- | -------------------------------------- |
| **Dashboard** | — (single view)                                                                                   | S1 · Dashboard & Governance            |
| **Docs**      | Document Register, SOP Viewer, Relationships Network, Clause-to-Clause Map, Change Requests (DCR) | S2 · Document Control & Compliance Map |
| **Ops**       | Complaints, Nonconforming Work, Corrective Actions, Risks & Opportunities, Improvement, Audits    | S3 · Quality Operations                |
| **Compass**   | Activity search → guidance cards                                                                  | S4 · Lab Compass                       |

Everything under **Ops** is driven by one generic renderer (`renderOps()`) fed by a config object (`OPS_META`) — each entry names which key in the JSON blob to read, the table columns, the ISO clause, and whether "+ New" opens a real modal or just the `demoNew()` stub. Only Complaints and DCR have an actual modal; NCW/CA/Risks/OFI/Audits currently have no data-entry form at all, just a table shell.

---

## 4. How it technically works (client-side only, today)

1. Page load parses the embedded JSON (`SP.items('<key>')` is a helper that reads an array out of that object by key).
2. `switchTab()` / `switchSub()` toggle CSS classes to show/hide the relevant `<div>` — no navigation, no page reload, no URL routing.
3. Each `render*()` function (`renderDashboard`, `renderRegister`, `renderSopList`, `renderClauseMatrix`, `renderOps`, `renderCompass`, `drawNetwork`) reads its slice of the JSON and builds HTML strings.
4. The SOP Relationships Network is a hand-rolled `<canvas>`/force-layout renderer (`layoutNetwork`/`drawNetwork`/`netClick`) — no external graph library, consistent with the "self-contained page" rule the SOP data spec calls out.
5. There is no auth, no digest token handling, no error handling for a failed list read — because there are no list reads.

---

## 5. Section-by-section: what's real, what's a shell, what's missing entirely

| Section                              | State in prototype                                                                                                                                                                                 | Seed data present?                       |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| **Dashboard** (S1)                   | Renders KPI counts from the static JSON (`register`, `steps`, etc.)                                                                                                                                | Yes — derived from the 33-doc register   |
| **Document Register** (S2)           | Full table renderer                                                                                                                                                                                | Yes — 33 rows                            |
| **SOP Viewer** (S2)                  | Renders per-SOP process steps                                                                                                                                                                      | Yes — 209 rows across 30 procedures      |
| **Relationships Network** (S2)       | Full interactive canvas graph                                                                                                                                                                      | Yes — 54 edges                           |
| **Clause-to-Clause Map** (S2)        | Renders a matrix                                                                                                                                                                                   | Yes — 18 rows / 20 columns               |
| **Change Requests / DCR** (S2)       | Table shell + **one real modal** (`m-dcr`)                                                                                                                                                         | 2 demo rows only; Submit is a stub       |
| **Complaints** (S3)                  | Table shell + **one real modal** (`m-cmp`)                                                                                                                                                         | 2 demo rows only; Save is a stub         |
| **Nonconforming Work** (S3)          | Table shell only, **no form**                                                                                                                                                                      | 2 demo rows only; "+New" is a bare alert |
| **Corrective Actions** (S3)          | Table shell only, **no form**                                                                                                                                                                      | 2 demo rows only                         |
| **Risks & Opportunities** (S3)       | Table shell only, **no form**                                                                                                                                                                      | 2 demo rows only                         |
| **Improvement / OFI** (S3)           | Table shell only, **no form**                                                                                                                                                                      | 2 demo rows only                         |
| **Audits** (S3)                      | **One flat table** — Notification, Checklist, Report, and Program are four distinct lists in the spec; the prototype shows none of that structure, just an "Audit ID / Scope / Status / Date" list | 2 demo rows only                         |
| **Management Review** (S1, per spec) | **Does not exist in the prototype at all** — no tab, no view, nothing                                                                                                                              | —                                        |
| **Lab Compass** (S4)                 | Activity search + guidance cards, functional                                                                                                                                                       | Yes — 4 activities / 8 task cards        |

**Read this table as the actual build list.** Complaints and DCR are the closest to "done" (real forms, just not wired). Everything else in Ops needs both its data-entry form built from the corresponding spec _and_ its SharePoint wiring. Management Review needs to be built from scratch — form, view, and the aggregation logic that pulls its 15 inputs from the other lists.

---

## 6. Target data model — the 12 SharePoint lists this app should read/write

Per `Form_Specs/*.md`. Every list below is documented field-by-field in its own spec file — use those, not this table, when actually building a form; this is just the map.

| #   | List                             | Subsystem / Tab               | Child lists                                                        | Key status field                |
| --- | -------------------------------- | ----------------------------- | ------------------------------------------------------------------ | ------------------------------- |
| 1   | `LS_QP1201r01_Complaints`        | S3 · Ops → Complaints         | —                                                                  | `Status` (New→Closed)           |
| 2   | `LS_QP1301r01_NonconformingWork` | S3 · Ops → NCW                | —                                                                  | `Status` (Logged→Closed)        |
| 3   | `LS_QP1401r01_DocumentRegister`  | S2 · Docs → Register          | —                                                                  | `Status` (Draft→Obsolete)       |
| 4   | `LS_QP1402r01_ChangeRequests`    | S2 · Docs → DCR               | `…a_AffectedDocuments`, `…b_ImplementationAttendants`              | `Stage` (Draft→Closed)          |
| 5   | `LS_QP1501r01_ActionPlans`       | S3 · Ops → Risks & Opp.       | `…a_ImpactAssessment`, `…b_Deliverables`                           | `Status` (Initiated→Closed)     |
| 6   | `LS_QP1503r01_Improvement`       | S3 · Ops → Improvement        | —                                                                  | `Status` (Submitted→Closed)     |
| 7   | `LS_QP1601r01_CorrectiveActions` | S3 · Ops → Corrective Actions | `…a_Participants`, `…b_ActionItems`, `…c_EffectivenessControls`    | `Status` (Initiated→Closed)     |
| 8   | `LS_QP1701r01_AuditNotification` | S3 · Ops → Audits             | `…a_AuditAgenda`                                                   | `Status` (Draft→Completed)      |
| 9   | `LS_QP1702r01_AuditChecklist`    | S3 · Ops → Audits             | `…a_ChecklistItems` (+ `REF_ISO17025_Clauses` template, ~400 rows) | `Status` (Not Started→Reviewed) |
| 10  | `LS_QP1703r01_AuditReport`       | S3 · Ops → Audits             | `…a_Findings`                                                      | `Status` (Draft→Closed)         |
| 11  | `LS_QP1704r01_AuditProgram`      | S3 · Ops → Audits             | `…a_ScheduleLines`                                                 | `Status` (Draft→Completed)      |
| 12  | `LS_QP1801r01_ManagementReview`  | S1 · Dashboard                | `…a_ReviewInputs`, `…b_ReviewOutputs`                              | `Status` (Planned→Closed)       |

Plus two S2 support lists (not form-driven, just data): `LS_SOPProcessSteps` (209 rows, seeded from `SOP_Data/ProcessSteps_seed.csv`) and `LS_SOPRelationships` (53 edges, seeded from `SOP_Data/SOPRelationships_seed.csv`).

Every list also needs the **Record-Control block** (retention period, confidentiality class, audit trail/versioning, amendment rule, explicit `ApprovedBy`+`ApprovedDate` e-signature) — this is one reusable pattern applied uniformly, defined in `PlatformValidation_DataIntegrity_v01.md` Appendix A. Build it once, apply it to all 12.

---

## 7. Development approach

**Agreed sequencing:** convert to ASPX first, deploy to a **test/dev SharePoint site**, prove the plumbing works, then build out the remaining sections against the specs. This is a sound order — it validates the hard technical risk (SharePoint auth, list schema, digest tokens) early and cheaply, before sinking time into rebuilding every Ops form against the finalized field specs.

**Single file, matching existing production apps.** Like `TestResultsReporting.aspx` and `ReceivedSamples.aspx`, this becomes **one `.aspx` file**, not one file per subsystem — the four tabs/subsystems stay client-side view-switches within the same page, exactly as the prototype already does it. Reuse the same technical patterns already proven in those two production apps:

- `<%@ Page Language="C#" %>` directive.
- Site-URL resolution: prefer `_spPageContextInfo.webAbsoluteUrl`, fall back to parsing the page's own URL — never hardcode `location.origin` (this exact mistake broke `TestResultsReporting.aspx` in production on 2026-07-10 when opened from a non-standard context).
- `X-RequestDigest` via `/_api/contextinfo` for every write — the current `demoSave()`/`demoNew()` stubs have none of this and cannot be pointed at a real list without it.
- Explicit "Load" + `__next` pagination chase for list reads, rather than fetching everything on page load — the Audit Checklist alone seeds ~400 rows per audit from `REF_ISO17025_Clauses`, and SharePoint's 5,000-item list-view threshold is a real constraint once complaints/NCW/CA history accumulates.
- `SampleManagementHelp.aspx`/`SampleSubmissionHelp.aspx` are a working precedent for how Lab Compass (already functional in the prototype) should ultimately read — reuse that read-only-guidance pattern rather than inventing a new one.

**Suggested build order once the ASPX skeleton is live on the test site:**

1. Wire the Document Register + SOP Viewer + Relationships Network + Clause Map (S2, read-mostly, lowest risk, and the seed CSVs already exist for a one-time import).
2. Wire Complaints and DCR (S2/S3) — the two forms that already exist in the prototype; replace `demoSave()` with a real create/update against their lists.
3. Build the remaining Ops forms from scratch against their specs — NCW, CA, Risks, OFI (in that order, since NCW→CA is the primary escalation chain and each spec explicitly describes the "Create X" bridging action from the previous one).
4. Split Audits into its real four-list structure (Program → Notification → Checklist seeded from `REF_ISO17025_Clauses` → Report) — this is the single biggest gap between the prototype and the spec.
5. Build Management Review last — it depends on every other list existing first, since its 15 inputs are aggregated from them.
6. Apply the Record-Control block + e-signature (explicit approve action, record locking, MFA) across everything, and only then treat it as go-live-ready — the validation package marks this as a mandatory gate, not a polish pass.

---

## 8. What "done" looks like for this app

An assessor should be able to open a complaint record, follow its `NCWRef` to the nonconforming-work record it spawned, follow that record's `CARef` to the corrective action, see the extent-of-condition check and the `DCRRef` it raised, and see that DCR reflected in the Document Register — all through real, clickable lookups, not narrative text. And a Management Review record should show live counts pulled from all of the above, not hand-typed numbers. That end-to-end traceability is the actual acceptance criterion, more than any individual field.
