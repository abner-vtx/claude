# QMS Platform — Subsystem Architecture Proposal

**Project:** VxLabs – Catalyst LIMS / QMS Platform
**Inputs:** `QMS_Platform_v04_to_v05_Plan.md`, `QMS_Dashboard_v04.html` (six persona views), `QMS_Dahsboard_v05.html`, the 12 form specs + platform-validation package.
**Purpose:** Define how the QMS is divided into self-contained but connected subsystems, and map the v04 elements to migrate.
**Status:** Rev 02 — decisions locked (single SharePoint site; 4 subsystems as page groups; guidance subsystem = **Lab Compass**; Management Review in Dashboard & Governance).

---

## 0. Confirmed decisions (rev 02)

1. **Single SharePoint site.** The entire platform lives in — and is used from — **one SharePoint site**. The four "subsystems" are therefore **logical groups of pages + lists within that one site**, not separate sites. *(Earlier draft assumed separate sites; corrected here.)*
2. **4 subsystems:** S1 Dashboard & Governance · S2 Document Control & Compliance Map · S3 Quality Operations · S4 **Lab Compass**.
3. **Guidance subsystem name:** **Lab Compass** — *"quick instructions for everyday lab work."*
4. **Management Review** (`LS_QP1801r01`) lives in **S1 Dashboard & Governance**.

---

## 1. Two framing decisions from your plan

**1.1 "Dashboard" vs "System" (terminology).** Adopted: what we called the *QMS Dashboard* is the **QMS Platform**. The **Dashboard** is just one part of it — the *QMS-at-a-Glance* landing page plus the Compliance Statement. From here: **Platform** = the whole system; **Dashboard** = the at-a-glance home page.

**1.2 No persona-gated views.** Adopted. v04 walled the system behind six persona tabs (Top Management, Lab Manager, QA Manager, Lab Personnel, Customer Support, External Auditor). v05 is **one comprehensive system organized by function, not by role** — anyone can reach any part, subject to permissions. Personas become **optional entry points / landing shortcuts** ("I'm here to…") that deep-link into the right subsystem, and **list/page permissions** (not separate pages) decide who edits vs. views. The External Auditor "view" becomes a **read-only lens** over the real evidence, not a hand-built page.

---

## 2. What "subsystem" means here (single-site model)

Because everything is one SharePoint site, a **subsystem = a cohesive set of pages backed by a group of lists**, with its own navigation node, ownership, and permission scope. The benefit you're after — easier maintenance and change — comes from **modularity within the site**, not from physical separation:

- **All lists share one site → all lookups are native.** The referential integrity across the quality chain (complaint→NCW→CA→risk/OFI, audit finding→NCW/CA, CA→DCR/risk, MR→actions) is **free and enforced** — no cross-site flows, no reference-data workarounds. This is the big simplification of the single-site decision.
- **Boundaries are organizational, not technical.** We group by function so each area has clear ownership, a clean set of pages, and its own permission scope — a change to one subsystem's pages/lists doesn't disturb the others.
- **Permissions do the "persona" work.** Contribute/read is set per list and per page (e.g., customers see only service standards; external assessors get read-only evidence; QA owns event lists) — no duplicated role pages.

---

## 3. Proposed architecture — one site, four subsystems

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                  SINGLE SHAREPOINT SITE — "Vertex QMS Platform"               │
│         one navigation · one search · one security model · one look           │
├───────────────────┬───────────────────┬───────────────────┬──────────────────┤
│ S1 · DASHBOARD &   │ S2 · DOCUMENT      │ S3 · QUALITY       │ S4 · LAB COMPASS │
│    GOVERNANCE      │  CONTROL &         │  OPERATIONS         │  (quick guide)   │
│                    │  COMPLIANCE MAP    │  (the event core)   │                  │
│ • QMS at a Glance  │ • Doc Register 1401│ • Complaints  1201  │ • "What are you  │
│ • Compliance Stmt  │ • DCR         1402 │ • NCW         1301  │   doing today?"  │
│ • Management       │ • SOP viewer       │ • Corr. Action 1601 │ • Service        │
│   Review      1801 │ • Process steps *  │ • Risks/Opp   1501  │   standards      │
│ • roll-up metrics  │ • Relationships * │ • Improvement 1503  │ • Contacts       │
│                    │ • Clause-to-Clause │ • Audits 1701–1704  │                  │
│ (read/aggregation) │   Map              │ (transactional core)│ (read-only, all) │
└───────────────────┴───────────────────┴───────────────────┴──────────────────┘
        all backed by lists in the SAME site  →  native lookups throughout
                         (* = placeholder pending your schema)
```

---

## 4. Subsystem catalog

### S1 · Dashboard & Governance *(read/aggregation layer)*
**Purpose:** The real "dashboard" and the management layer above the data.
**Pages/lists:** QMS-at-a-Glance counters, section-coverage/distribution charts, **Compliance Statement**, and the **Management Review** record (`LS_QP1801r01`). Mostly reads — it aggregates metrics from the other subsystems' lists (same site, so simple roll-ups) and Management Review pulls its 8.9.2 inputs the same way.
**From v04:** Top Management → *QMS at a Glance* (item 1) and *Compliance Statement* (item 2).
**Audience:** everyone (overview); Top Management + QA own it.

### S2 · Document Control & Compliance Map
**Purpose:** Everything about controlled documents and their ISO mapping.
**Pages/lists:** Document Register (`LS_QP1401r01`), Document Change Request (`LS_QP1402r01`), a **document/SOP viewer** (view the full SOP), the **SOP process-steps** breakdown, the **SOP Relationships network**, and the **Clause-to-Clause Map** (SOP ↔ ISO 17025 clause).
**From v04:** Lab Manager view (SOP list, process steps, relationships network, + document viewer — item 3) and QA Manager *Clause-to-Clause Map* (item 4). **Excluded per your plan:** the QA quick-stat tiles (clauses covered, minor gaps, #forms/records, documentation rate).
**Audience:** all read; QA + Lab Manager manage.
**Placeholders:** the per-SOP **process-steps list schema** (you'll provide) and the **SOP Relationships network** data — stubbed for now.

### S3 · Quality Operations *(the transactional core)*
**Purpose:** The live, interlinked quality-event lifecycle.
**Pages/lists:** Complaints (1201), Nonconforming Work (1301), Corrective Actions (1601), Risks & Opportunities (1501), Improvement/OFI (1503), **and** Audits (Program/Notification/Checklist/Report, 1701–1704) with child lists.
**Why grouped:** these are the natively lookup-linked records — complaint→NCW→CA, CA→risk/DCR, audit finding→NCW/CA. Grouping their pages keeps the operator's mental model tight; the links are enforced by same-site lookups.
**Audience:** internal staff; Customer Support contributes to Complaints; QA governs; **External Auditor gets a read-only lens** here (evidence), replacing v04's separate auditor page.

### S4 · Lab Compass *(the NEW subsystem — item 5)*
**Purpose:** "Quick instructions for anyone in the lab" — the task-first help layer, combining v04's **Lab Personnel** ("What are you doing today?" activity search → SOP steps/forms/people) and **Customer Support** (service standards, complaint SLA, confidentiality, contacts) into one guidance area useful to *everyone*, not two roles.
**Pages/lists:** activity search + activity cards → step-by-step guidance (reads SOP/process-step data from S2), plus service-standard and contact reference cards.
**Audience:** all staff (read-only guidance); service-standard cards can be surfaced to customers.
**Why its own subsystem:** it's entirely read-only guidance derived from S2 — no data of its own — so it's the most cleanly modular area and the easiest to open to a broad (even customer-facing) audience without exposing event data.

---

## 5. How the subsystems connect (single site)

| Connection | Mechanism | Notes |
|---|---|---|
| One platform feel (nav, search, branding, security) | The **site** itself | One navigation, one search, one permission model. |
| Record links across all subsystems | **Native lookup columns** | Complaint→NCW→CA→Risk/OFI, audit finding→NCW/CA, CA→DCR/Risk, MR→actions, traceability `RelatedMethodSOP`→register — all native, all enforced, because everything is one site. |
| Dashboard & Management-Review roll-ups (S1 ← S2/S3) | **List views / rollups / Power BI / Graph** | Same-site aggregation of counts and 8.9.2 inputs; no cross-site plumbing. |
| Automated handoffs (auto-numbering, "Raise CA/DCR", escalations, notifications) | **Power Automate** | Same as specified in the form specs — now all within one site. |
| Guidance content (S4 ← S2) | **Same-site read** | Lab Compass renders SOP steps/forms sourced from the S2 lists; never writes. |

**Simplification vs. the earlier multi-site draft:** no cross-site lookups, no managed-metadata reference sets, no flow-based bridges just to join records. Everything joins natively; Power Automate is used only for genuine automation (numbering, routing, escalation), exactly as the form specs already describe.

---

## 6. v04 → v05 migration map

| v04 element (plan item) | Migrate? | Target subsystem | Notes |
|---|---|---|---|
| Top Management · **QMS at a Glance** (1) | Yes | **S1 Dashboard** | The real dashboard home page. |
| Top Management · **Compliance Statement** (2) | Yes | **S1 Dashboard** | Auto-generated from register + clause map. |
| Lab Manager · SOP list + **process steps** + **relationships network** + **document viewer** (3) | Yes | **S2 Document Control** | **Placeholders** for process-steps and relationships network until you provide the per-SOP process-step list schema; add a full-SOP document viewer. |
| QA Manager · **Clause-to-Clause Map** (4) | Yes | **S2 Document Control** | Keep the SOP↔ISO matrix. |
| QA Manager · quick-stat tiles (clauses covered, minor gaps, #forms/records, doc rate) | **No** (per plan) | — | Explicitly excluded. |
| Lab Personnel · "What are you doing today?" (5) | Yes | **S4 Lab Compass** | Core of the new subsystem. |
| Customer Support · service standards / SLA / contacts (5) | Yes | **S4 Lab Compass** | Merged in — guidance for everyone, not a role page. |
| External Auditor · clause tree / evidence / checklist | Reframe | **S3 (read-only lens)** + **S2 clause map** | Not a separate page — a read-only permission over real evidence + the clause map + the Audit Checklist (1702). |
| Persona bar (6 tabs) | Reframe | **Site navigation** | Optional "I'm here to…" launch shortcuts, not gated views. |

---

## 7. Naming — resolved

The Lab Guidance subsystem is named **Lab Compass** (tagline: *"quick instructions for everyday lab work"*) — role-neutral, memorable, and it reads as help rather than a compliance tool, suiting an all-staff (and partly customer-facing) audience.

---

## 8. Why this makes maintenance easier (single-site)

- **Modularity without fragmentation.** Each subsystem is a self-contained set of pages + lists with its own owner and permission scope, but they share one site — so you get change-isolation *and* native referential integrity, without multi-site plumbing.
- **Permissions replace duplicate role pages.** One set of function pages, with list/page-level permissions doing the persona work — far less to maintain than six parallel views.
- **Referential integrity is free.** The event chain's relationships are enforced by same-site lookups; nothing to hand-maintain.
- **Independent evolution.** Per the Platform Validation package, a change to Lab Compass or the clause map is scoped and re-verified on its own; live event data (S3) is untouched.
- **Room to grow.** New processes (equipment/EP, training/competence) drop into the right subsystem, or add a new page group, without disturbing the rest.

---

## 9. Next steps

With the decisions locked, the plan is to:
1. **Re-organize the form-spec index by subsystem** (S1–S4) so the build order and ownership are clear.
2. **Add S2 placeholders** — document viewer, per-SOP process-steps (pending your schema), SOP relationships network, and the Clause-to-Clause Map.
3. **Scaffold S4 "Lab Compass"** — activity-based quick-instructions + merged service standards/contacts, sourced read-only from S2.
4. Fold in the **v04 migration items** per §6, then proceed to the v05 build.

*Awaiting from you: the per-SOP **process-steps list schema** (and the SOP Relationships network data) to replace the S2 placeholders.*
