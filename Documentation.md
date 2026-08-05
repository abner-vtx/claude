# Quality Management System Platform v5.2 (SharePoint Online)

**Primary file:** `src/QMS_Platform.aspx`
**System:** Quality Management System Platform v5.2 — ISO/IEC 17025:2017
**Hosting:** SharePoint Online, intended for **SiteAssets** deployment (also works from Site Pages)
**Companion docs:** `QMS_Platform_AppGuide_v01.md` (roadmap, build order), `QMS_Platform_Architecture_v01.md` (subsystem design), `Form_Specs/*.md` (per-list field specs, 14 files), `Form_Specs/PlatformValidation_DataIntegrity_v01.md` (validation/e-signature requirements), `Form_Specs/README_FormSpecs_Index.md` (index + data-flow map), `SharePoint_List_Schema_v01.md` (28-list creation reference)

This document is the operational documentation for the page: (1) a change log of SharePoint Online conversion work, and (2) a concise summary of current feature behavior. For the target data model, gap-analysis decisions, and build roadmap, see the App Guide — this file tracks what the page _actually does today_, not what it's planned to do.

---

## Current build state

The page has a **hybrid SharePoint data layer**. On load it resolves the site URL, fetches a request digest, and attempts REST reads for each mapped list (titles from the Form Specs / `SharePoint_List_Schema_v01.md`). If a list is missing, empty, or unreachable, that key falls back to the embedded seed JSON (`<script id="lists" type="application/json">`). Renderers still call `SP.items(name)` and never bind to SharePoint field names directly — mappers convert SP rows into the UI shape. **Complaints** and **DCR** saves write to SharePoint when available (with session/seed fallback on failure); other Ops modals still use `demoSave()`. No Power Automate integration yet.

---

## What this page does

Four top-level tabs (`data-tab`), matching the architecture's four subsystems:

- **Dashboard** (S1): KPI cards (`renderDashboard()`) computed from the seed data (procedure count, forms/records, ISO clause coverage, process steps, open NCW/CA counts, pending DCRs), a static compliance-statement paragraph, a hardcoded Management Review summary card, and a recent-activity feed (`activity` list).
- **Document Control** (S2), 5 sub-tabs:
  - **Document Register** — full table renderer (`renderRegister()`) over the `register` list.
  - **SOP Viewer** — two-panel list/detail (`renderSopList()`/`showSop()`): selecting a procedure shows its process steps (`steps` list, filtered by `sop`), related documents (derived from `edges`), and a placeholder document-viewer box (no real PDF/file preview yet).
  - **Relationships Network** — hand-rolled `<canvas>` radial-layout graph (`layoutNetwork()`/`drawNetwork()`/`netClick()`), no external graph library. Nodes are documents from `register`, grouped by type (Quality Manual → center, Quality/Equipment/Laboratory Procedure → rings); edges come from the `edges` list. Click a node to highlight its connections.
  - **Clause-to-Clause Map** — matrix renderer (`renderClauseMatrix()`) over `clausemap`/`clausecols`.
  - **Change Requests (DCR)** — table (`renderDcr()`) plus the one real data-entry modal, `m-dcr` (`LS_QP1402r01` / QP-14), opened via **New Request**.
- **Quality Operations** (S3), 6 sub-tabs, all driven by one generic renderer (`renderOps()`) fed by a config object (`OPS_META`) naming each tab's data key, table columns, ISO clause, and button label:
  - **Complaints** — the other real modal, `m-cmp` (`LS_QP1201r01` / Clause 7.9), opened via **Log Complaint**.
  - **Nonconforming Work, Corrective Actions, Risks & Opportunities, Improvement, Audits** — table shells only; their "+ New" button calls the `demoNew()` stub (an alert), since no data-entry form exists yet for any of these five record types. Audits is still a single flat table — the spec's four-list structure (Notification/Checklist/Report/Program) is not represented.
- **Lab Compass** (S4): autocomplete search (`compassSearch`) over process-step titles, task cards (`activity_tasks` list) that open step-by-step guidance (`showGuidance()`), and static Service Standards / Confidentiality / Contacts cards.

**Not present in the UI at all:** a Management Review tab/form (`LS_QP1801r01`) — the Dashboard only shows a hardcoded summary card, not a real record.

---

## Deployment (SharePoint Online)

- **Recommended location:** upload `QMS_Platform.aspx` to the site's `SiteAssets` library, matching the pattern already used by `TestResultsReporting.aspx` and `ReceivedSamples.aspx`.
- **How to open:** navigate to the file from within SharePoint (same tenant/site) so auth cookies are present. Add a navigation link to the file in `SiteAssets` if you want it in the site nav.
- **Why SiteAssets is supported:** `resolveSiteUrl()` (lines 410–419) tries `_spPageContextInfo.webAbsoluteUrl` first, then falls back to stripping `/SiteAssets` or `/SitePages` from `window.location.href`, then falls back to `location.origin`. Unlike a hard guard on `_spPageContextInfo`, this never throws — it always resolves to _some_ URL, which is why there's currently no "SharePoint context not found" failure mode to document (see Data model notes).

---

## SharePoint lists used (REST)

Hybrid reads via `LIST_MAP` in `src/QMS_Platform.aspx`. Empty/missing lists fall back to seed. List titles must match the Form Specs naming (underscores). If a title differs on the site, change it in `LIST_MAP` only.

| Blob key                  | Target list                             | Subsystem / tab                           | Status                                                                |
| ------------------------- | --------------------------------------- | ----------------------------------------- | --------------------------------------------------------------------- |
| `register`                | `LS_QP1401r01_DocumentRegister`         | S2 Register, SOP Viewer, Network, Compass | Hybrid read + mapper                                                  |
| `steps`                   | `LS_SOPProcessSteps`                    | S2 SOP Viewer; feeds Compass search       | Hybrid read + mapper (`$expand=SOPRef`)                               |
| `edges`                   | `LS_SOPRelationships`                   | S2 Relationships Network                  | Hybrid read + mapper (`$expand=SourceSOP,TargetSOP`)                  |
| `clausemap`, `clausecols` | —                                       | S2 Clause-to-Clause Map                   | Seed only — no dedicated list yet                                     |
| `complaints`              | `LS_QP1201r01_Complaints`               | S3 Complaints                             | Hybrid read + **live create** (`saveComplaint`)                       |
| `ncw`                     | `LS_QP1301r01_NonconformingWork`        | S3 Nonconforming Work                     | Hybrid read; save still stub                                          |
| `ca`                      | `LS_QP1601r01_CorrectiveActions`        | S3 Corrective Actions                     | Hybrid read; save still stub                                          |
| `risks`                   | `LS_QP1501r01_ActionPlans`              | S3 Risks & Opportunities                  | Hybrid read; save still stub                                          |
| `ofi`                     | `LS_QP1503r01_Improvement`              | S3 Improvement                            | Hybrid read; save still stub                                          |
| `audits`                  | `LS_QP1701r01_AuditNotification`        | S3 Audits                                 | Hybrid read (Notification list only); UI still one flat table         |
| `dcr`                     | `LS_QP1402r01_ChangeRequests`           | S2 Change Requests                        | Hybrid read + **live create** (`saveDcr`)                             |
| `activity`                | —                                       | S1 Dashboard recent-activity feed         | Seed only — presentational                                            |
| `activity_tasks`          | —                                       | S4 Lab Compass task cards                 | Seed only — presentational                                            |
| _(not in blob)_           | `LS_QP1801r01_ManagementReview`         | S1 Dashboard                              | Target defined; no tab/form exists in the UI                          |

---

## Data model notes (important behaviors)

- **Hybrid data-access layer:** `SEED` is the embedded JSON blob; `CACHE` holds the active rows per key. `loadAllLists()` tries each `LIST_MAP` entry with `spGetAll` (follows `odata.nextLink`). Non-empty SP results are mapped into the UI shape and marked `DATA_SOURCE[key]='sp'`; otherwise the seed is used. `SP.items(name)` always returns from `CACHE`.
- **Writes (Complaints + DCR):** `saveComplaint()` / `saveDcr()` mint client-side IDs (`CMP{YY}{###}`, `DCR-{YY}{###}`), POST via digest-backed `spPost`, then refresh the table. On missing SP context or POST failure, the row is kept in-session via seed fallback and an info toast explains why.
- **Intake defaults on Complaint create:** the simple modal only collects Category / ReceivedThrough / Company / Description. Remaining schema-required evaluation fields are written as pending defaults (`IsValid=Yes`, rationale/NCW rationale `"Pending evaluation"`, etc.) so SharePoint Required columns do not block intake. Tighten once the full evaluation sections are wired.
- **Digest + REST helpers:** `getRequestDigest`, `spGet`, `spPost`, `spGetAll` follow the `ReceivedSamples.aspx` pattern (`odata=nometadata`, `credentials:'include'`).
- **Init gating:** prefers `_spBodyOnLoadFunctionNames` when present (SharePoint page lifecycle); otherwise `DOMContentLoaded`. No hard failure when opened outside SharePoint — seed mode continues.
- **No auth or permission logic beyond header user display.** `PTS_Users` lookup still supplies position for the header only.
- **ID numbering (partial):** implemented for Complaints and DCR creates; other record types still pending.

---

## Power Automate Flows

None implemented yet. The App Guide's target list (auto-numbering, "Raise CA/DCR" bridging actions, approval routing, escalation notifications) is unchanged from what's documented there — nothing in this file currently triggers or expects a flow.

---

## Change log (SharePoint Online conversion)

### Change 1 — ASPX Conversion & SharePoint Context Scaffolding

**Problem:** The source was a static HTML file (`prototypes/QMS_Platform_v5.1.html`) with no `.aspx` directive and no path to running inside SharePoint Online.

**Fix:**

- Added `<%@ Page Language="C#" %>` (line 1).
- Added `resolveSiteUrl()` (lines 410–419) — site-URL resolution with the `_spPageContextInfo` → `/SiteAssets` → `/SitePages` → `location.origin` fallback chain, per the pattern already proven in `TestResultsReporting.aspx`/`ReceivedSamples.aspx`.
- Added `getRequestDigest()` (lines 424–432) — fetches `/_api/contextinfo` and resolves the write digest. Scaffolded ahead of need so the first real write doesn't have to build this from scratch.
- Left the embedded JSON blob and `SP.items()` shim in place as the current data source, pending real list wiring.

**Not done in this change:** no list is actually read from or written to SharePoint; `demoSave()`/`demoNew()` are unchanged stubs.

### Change 2 — On-page version indicators removed

**Problem:** The header displayed the source prototype's version (`5.1`) as a page-version badge, and a separate indicator showed the ASPX scaffolding's own version (`0.1`). Both implied the running page carries a version identity, which isn't how this build is being tracked going forward.

**Fix:** Removed both on-page indicators. No JS variable, element, or footer currently displays a version string anywhere in the page.

**Known cleanup item:** the CSS rule `.app-header .ver{...}` (line 27) is now dead — no element uses `class="ver"` anymore. Harmless, but safe to delete in a future pass.

### Change 3 — Visual style refinement

**Problem:** The header, tables, and card sections used prototype-era spacing/border conventions — bare tables with no padding, a thin gray divider under section titles instead of a full accent line running edge-to-edge (rather than inset with the rest of the content), a bordered card outline instead of a shadow, and inconsistent title typography between the page-level section intros and the header's user/role text.

**Fix:**

- Header: `.who` split into `.name` (13px, 500 weight, 92% white) and `.role` (11px, 65% white) instead of one uniform 12px line; `.avatar` resized to 36×36px. Placeholder content left untouched — no current-user/permission logic wired in.
- Tables: the previously bare `<table>` elements (Document Register, DCR, and the shared `renderOps()` template covering all 6 Quality Operations tabs) now render inside `.card-bd`, giving them real padding instead of sitting flush against the card edge.
- Section title accent line: `.card-hd`'s border-bottom changed from `1px solid var(--border)` (gray) to `3px solid var(--gold)`; the card's horizontal padding moved from `.card-hd`/`.card-bd` up to `.card` itself, so the gold line now insets from the card's rounded corners instead of running edge-to-edge.
- `.card`: dropped its `1px solid var(--border)` outline in favor of a shadow (`0 2px 8px rgba(0,114,178,.08)`, with a hover-lift to `0 4px 16px rgba(0,114,178,.13)`).
- Page background (`--bg`): `#F5F5F5` → `#F9F9F9`.
- Section intro typography (`.page-intro h2`, e.g. "Quality Operations"): `1.25rem` / inherited 600 weight → `1.5rem` / 700 weight.
- Modal section titles (`.section-title` — "Requester" in the DCR modal, "General Information" in the Complaint modal): `display:inline-block` (shrink-to-fit) → `display:block`, so the underline spans the modal's full content width instead of just the word.

**Not done in this change:** no functional/logic change anywhere — CSS and markup only, purely visual.

### Change 4 — Hybrid SharePoint data layer + Complaints/DCR writes

**Problem:** Lists exist on the tenant but the page only read the embedded seed blob. There was no way to pick up real data when lists are populated, and Complaints/DCR could not persist.

**Fix:**

- Replaced the mock `SP.items()` shim with a hybrid layer: `LIST_MAP` list titles, REST helpers (`spGet`/`spPost`/`spGetAll` + digest), per-key mappers, and seed fallback when a list is empty/missing/unreachable.
- Init now follows the ReceivedSamples pattern (`_spBodyOnLoadFunctionNames` when available), then loads lists and re-renders.
- Wired `saveComplaint()` and `saveDcr()` with client-side ID generation and SharePoint POST; session/seed fallback if SP is unavailable or the write fails.
- Added `name` attributes on Complaint and DCR modal fields so saves can read the form.

**Not done in this change:** writes for NCW/CA/Risks/OFI/Audits; Management Review UI; full evaluation-section field capture on Complaint; Power Automate; permissions.

---

## Current state summary

- **SharePoint connectivity:** hybrid — live REST reads when lists have data; seed JSON otherwise. Digest-backed writes for Complaints and DCR.
- **Data source:** `LIST_MAP` → SharePoint, else embedded JSON (14 keys), always via `SP.items()` UI shape.
- **Working data-entry forms with persistence:** Complaints + DCR (SP when available, else session seed).
- **Forms still stub-saved:** NCW, CA, Risks, OFI, Audits.
- **Missing entirely from the UI:** Management Review (1 of 12).
- **Read-mostly:** Document Register, SOP Viewer, Relationships Network, Clause-to-Clause Map, Lab Compass — hybrid-ready.
- **No list-level permissions gating, no Power Automate.** Pagination chase exists for reads (`odata.nextLink`).
- **No on-page version display** (Change 2) — **v5.2** is tracked here, not in the UI.
