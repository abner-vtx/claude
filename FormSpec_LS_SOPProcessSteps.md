# List Specification: SOP Process Steps

**Subsystem:** S2 – Document Control & Compliance Map
**List ID / Name:** `LS_SOPProcessSteps`
**Nodes / parent:** `LS_QP1401r01_DocumentRegister` (each step belongs to one SOP)
**Seed data:** `SOP_Data/ProcessSteps_seed.csv` (201 rows, 30 procedures)
**Purpose:** Data source for the **per-SOP process-steps** breakdown on the Lab-Manager SOP viewer (migrated from v04). Each row is one step of one procedure — so the page renders the steps by **reading this list**, with **no hardcoded data**.

---

## 1. Data Schema

| Internal Name | Data Type | Required | Display Label | Options / Notes |
|---|---|---|---|---|
| `SOPRef` | Lookup → `LS_QP1401r01_DocumentRegister` (`DocID`) | Yes | SOP | The procedure this step belongs to. *(Seed column `SOPID`.)* |
| `StepNumber` | Single Line Text | Yes | Step # | The procedure sub-section number, e.g. `5.1`, `8.3`. Verbatim from the SOP. |
| `StepTitle` | Single Line Text | Yes | Step Title | The sub-section heading, e.g. "Initiating a Corrective Action Plan". |
| `StepOrder` | Number | Yes | Order | Sequence within the SOP (1..n) for sorting. |
| `StepSummary` | Multiple Lines | No | Summary | First substantive sentence of the step (extracted). Draft — for SME review/trim. |
| `FormsReferenced` | Multiple Lines | No | Forms | Form/record IDs used in the step (e.g. `FM QP16.01; FE QP16.01`). Can later be upgraded to a multi-lookup against the register. |
| `ResponsibleRole` | Choice | No | Responsible | `Laboratory Director`, `Laboratory Manager`, `Quality Assurance Manager`, `Laboratory Analyst`, `Customer Support`, `Personnel` (best-effort extracted; confirm). |
| `ClauseRef` | Single Line Text | No | ISO Clause | *(Optional enrichment — not yet populated.)* ISO 17025 clause the step supports. |
| `Notes` | Multiple Lines | No | Notes | SME notes / corrections. |

> **Extraction method (provenance):** Steps were parsed from each SOP's Table of Contents — the sub-sections of the **PROCEDURE** section (QP procedures = Section 5) or **INSTRUCTIONS** section (EP/LP procedures = Section 7–8). `StepSummary`, `FormsReferenced`, and `ResponsibleRole` were extracted from the body text under each heading. Treat summaries/roles as **draft for SME confirmation**; `StepNumber`/`StepTitle`/`StepOrder` are verbatim and reliable.

---

## 2. Coverage

- **31 procedures** with steps parsed (all QP incl. QP-08; all EP; all LP). **209 step rows.**
- **QP-08 Management of Samples** was a scanned PDF — **recovered by OCR** (Tesseract) and merged (8 steps: Transportation, Reception, Identification, Recording, Storage, Handling, Retention, Disposal). Because it came from OCR, give its summaries an extra look during SME review.
- **Excluded:** `LS-02 Approved Vendors` — a scanned vendor *list* (not a process SOP); disregarded by decision. Flagged `IsScanned = Yes` in the node register.
- **Quality Manual (QM)** is intentionally **not** in this list — it is a manual, not a procedure; it remains a tier-1 node in the register.

---

## 3. Usage in the page (no hardcoded data)

The SOP viewer (S2) queries `LS_SOPProcessSteps` filtered by the selected `SOPRef`, ordered by `StepOrder`, and renders each step (number, title, summary, forms, role). The **Lab Compass** subsystem (S4) reuses the same list to answer "what are the steps for this task?". Nothing is embedded in the `.aspx`; the list is the single source.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Belongs to | `LS_QP1401r01_DocumentRegister` | `SOPRef` lookup → the SOP node. |
| References | Register (forms) | `FormsReferenced` — form IDs that can resolve to register records. |
| Feeds | S2 SOP viewer + S4 Lab Compass | Read-only rendering of steps. |
| Seeded by | `SOP_Data/ProcessSteps_seed.csv` | Import to populate the list. |
