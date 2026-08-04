# List Specification: SOP Relationships (Network)

**Subsystem:** S2 – Document Control & Compliance Map
**List ID / Name:** `LS_SOPRelationships`
**Nodes:** `LS_QP1401r01_DocumentRegister` (the documents are the network nodes)
**Seed data:** `SOP_Data/SOPRelationships_seed.csv` (53 edges) · preview `SOP_Data/SOPRelationships_network.json`
**Purpose:** Data source for the **SOP Relationships Network** graph (migrated from v04). This list holds the **edges**; the **nodes** are the documents already in the register. The graph is rendered by **reading both lists** — no hardcoded nodes or links.

---

## 1. Data Schema

| Internal Name | Data Type | Required | Display Label | Options / Notes |
|---|---|---|---|---|
| `SourceSOP` | Lookup → `LS_QP1401r01_DocumentRegister` (`DocID`) | Yes | Source | Document that makes the reference. |
| `TargetSOP` | Lookup → `LS_QP1401r01_DocumentRegister` (`DocID`) | Yes | Target | Document being referenced. |
| `RelationshipType` | Choice | Yes | Type | `Governs` (Quality Manual → procedure), `Governed by`, `References` (default, cross-reference), `Feeds into`, `Uses form` — refine as needed. |
| `MentionCount` | Number | No | Weight | How many times the source cites the target (edge weight / thickness). |
| `Description` | Multiple Lines | No | Description | Optional human context for the link. |
| `Directional` | Yes/No | No | Directional | Default `Yes` (arrow Source→Target). |

> **Node styling comes from the register**, not this list: use `DocType`/`Tier` on `LS_QP1401r01` to color nodes (Manual = tier 1; QP/EP/LP = procedures; forms = leaves). Keeping edges here and node attributes on the register avoids duplication.

---

## 2. Coverage & method

- **53 edges** across the document set, extracted by scanning every SOP's text for citations of other controlled-document IDs (`QP-`, `EP-`, `LP-`, `QM`, `PM-`, `POL-`). Self-references removed; duplicates collapsed with a `MentionCount` weight.
- **Type seeding:** `QM → x` set to **Governs** (19 edges); the rest default to **References** (34 edges). Refine specific edges (e.g., "Feeds into", "Uses form") during SME review.
- **Not yet included:** edges from the two scanned docs (QP-08, LS-02) — no text to parse. Add after OCR / manual entry.
- **Forms as nodes (optional):** the network is currently document-to-document. If you want form/record leaves, add `SOP → Form` edges (`Uses form`) sourced from `LS_SOPProcessSteps.FormsReferenced`.

---

## 3. Usage in the page (no hardcoded data)

The relationships graph loads **nodes** from `LS_QP1401r01_DocumentRegister` and **edges** from `LS_SOPRelationships`, then renders with the skill's built-in `<canvas>` renderer (no external graph library, per the self-containment rule). Clicking a node can deep-link to that SOP's process steps (`LS_SOPProcessSteps`) and its register entry. The JSON file is a **preview/test convenience only** — production reads the lists.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Nodes from | `LS_QP1401r01_DocumentRegister` | `SourceSOP`/`TargetSOP` lookups; node color/tier from register. |
| Complements | `LS_SOPProcessSteps` | Node click → step list; optional `Uses form` edges from step forms. |
| Feeds | S2 Relationships Network graph + Clause-to-Clause context | Read-only rendering. |
| Seeded by | `SOP_Data/SOPRelationships_seed.csv` | Import to populate the list. |
