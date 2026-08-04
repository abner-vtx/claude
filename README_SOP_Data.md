# SOP_Data — seed data for the Document Control subsystem (S2)

Machine-extracted from the 33 controlled documents in `Lab_SOPs/`. These files **populate SharePoint lists**; the page reads from the lists, so nothing is hardcoded (per the iso17025-sharepoint-page skill).

## Files

| File | Loads into (list) | Rows | Notes |
|---|---|---|---|
| `nodes_SOP_Register.csv` | `LS_QP1401r01_DocumentRegister` (subset of columns) | 33 | Canonical node list: DocID, Title, Type, Revision, StepsSection, IsScanned. |
| `ProcessSteps_seed.csv` | `LS_SOPProcessSteps` | 201 | Per-SOP process steps (30 procedures). Schema: `FormSpec_LS_SOPProcessSteps.md`. |
| `SOPRelationships_seed.csv` | `LS_SOPRelationships` | 53 | Document-to-document reference edges. Schema: `FormSpec_LS_SOPRelationships.md`. |
| `SOPRelationships_network.json` | *(preview/test only)* | — | Nodes + edges for local graph preview; production reads the lists. |

## How it was built
- **pdftotext** on every SOP; parsed each document's **Table of Contents**.
- **Process steps** = sub-sections of the **PROCEDURE** section (QP = §5) or **INSTRUCTIONS** section (EP/LP = §7/§8). `StepNumber`/`StepTitle`/`StepOrder` are verbatim; `StepSummary`, `FormsReferenced`, `ResponsibleRole` are extracted from the body — **draft for SME review**.
- **Relationships** = every citation of another controlled-document ID found in each SOP's text; self-references removed; weighted by mention count; `QM→x` typed as `Governs`.

## Known gaps (need attention before final load)
1. **QP-08 (Management of Samples)** — was scanned; **recovered via OCR** (Tesseract) and merged (8 steps). OCR-sourced, so give it an extra SME look. **LS-02 (Approved Vendors)** is a scanned vendor *list*, not a process SOP — **disregarded by decision** (`IsScanned = Yes`, no steps).
2. **Summaries / roles / form links** are best-effort extractions — confirm during SME review (a subject-matter expert reads and corrects them); `StepSummary` may need trimming.
3. **Relationship types** default to `References` (or `Governs` for the manual) — refine to `Feeds into` / `Uses form` where appropriate.
4. Two titles were auto-corrected from filename artifacts (LS-02, QP-05); verify against the register.

## Future enhancements (backlog)
- **Forms as leaf nodes in the network** — generate `SOP → Form` edges (`Uses form`) from `LS_SOPProcessSteps.FormsReferenced`, so the relationships graph can also show which forms/records each SOP produces. *(Flagged for a future implementation; not built now.)*

## Where this plugs in
Replaces the two **placeholders** noted in `QMS_Platform_Architecture_v01.md` §S2: the *per-SOP process steps* and the *SOP Relationships network*. Consumed by the S2 SOP viewer/graph and reused by S4 **Lab Compass**.
