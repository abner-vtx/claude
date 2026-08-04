# Form Specification: Master List of Documents (Document Register)

**Master SOP:** QP-14 – Control of Management System Documents  
**Form ID:** LS_QP1401r01 *(digital successor to FE QP14.01 Master List of Documents; incorporates FM QP14.01 Document Distribution)*  
**Form Title:** Master List of Documents  
**SharePoint List:** `LS_QP1401r01_DocumentRegister`  
**ISO/IEC 17025:2017 Reference:** Clause 8.3 – Control of Management System Documents (Option A)  
**Document Status:** Draft  

**Purpose:** To maintain the single controlled register of all internal management-system documents — their identification, current revision, approval status, effective and next-revision dates, ownership, distribution, and hierarchical relationships. This list is the backbone of the **Control of Documents** tab (both the List view and the Relationship Map) and the authoritative source that every Document Change Request (`LS_QP1402r01`) updates on approval. It also carries the controlled external-document register.

---

## 1. Data Schema

*SharePoint List column definitions.*

| Internal Name | Data Type | Required | Display Label | Options / Default Value |
|---|---|---|---|---|
| `DocID` | Single Line Text | Yes | Document ID | Per QP-14 §5.5 identification structure (e.g., `QP-14`, `LP-01`, `EP-01`, `QRG-01`, `TM-2401`, `SP-2401`, `PM-05`, `FM QP16.01`, `FE QP14.01`, `LBK-2401`). Unique. |
| `Title` | Single Line Text | Yes | Title | — |
| `DocType` | Choice | Yes | Type of Document | `Policy`, `Quality Manual`, `Quality Management Procedure (QP)`, `Laboratory Procedure (LP)`, `Equipment Use Procedure (EP)`, `Quick Reference Guide (QRG)`, `Method of Analysis (TM/MOA)`, `Calculation Spreadsheet (SP)`, `Program (PM)`, `Form (FM)`, `Electronic Form (FE)`, `Logbook (LBK)` |
| `Tier` | Choice | Yes | Hierarchy Tier | `Tier 1 – Policies`, `Tier 2 – Manuals`, `Tier 3 – SOPs/Procedures`, `Tier 4 – Forms/Records` (drives Relationship Map coloring) |
| `Department` | Choice | Yes | Department | `QA`, `Chemistry`, `Microbiology`, `Management`, `All` |
| `Revision` | Single Line Text | Yes | Revision / Version | Revision start `01` per QP-14 §5.5. |
| `Status` | Choice | Yes | Status | `Draft`, `Under Review`, `Approved / Effective`, `Superseded`, `Obsolete` |
| `EffectiveDate` | Date | No | Effective Date | Set on approval. `-` while not yet effective. |
| `NextRevisionDate` | Date | No | Next Revision Date | Scheduled review date. |
| `TemplateUsed` | Choice | No | Template Used | `TMP-SOP`, `TMP-FM`, `TMP-TM`, `N/A` |
| `Owner` | Person | Yes | Document Owner | Responsible author/owner. |
| `ApprovedBy` | Person | No | Approved By | Approver captured on effectiveness. |
| `ParentDocID` | Lookup → `LS_QP1401r01_DocumentRegister` | No | Parent Document | Self-lookup establishing the hierarchy (e.g., a Form's parent SOP). Drives the Relationship Map tree. |
| `RelatedDocs` | Lookup (multi) → `LS_QP1401r01_DocumentRegister` | No | Related Documents | Cross-references (e.g., an SOP that references a Program). |
| `DistributionLocation` | Multiple Lines | No | Distribution / Storage Location | Controlled copy locations (replaces FM QP14.01 Document Distribution log). |
| `IsExternal` | Yes/No | No | External Document? | Default `No`. External controlled documents (standards, regulations) flagged here per QP-14 §7.x. |
| `ExternalSource` | Single Line Text | No | External Source / Issuer | Required when `IsExternal == Yes` (e.g., ISO, FDA). |
| `FileRef` | Attachment / Hyperlink | No | Controlled File | Link to the approved PDF/master file in the document library. |
| `LinkedDCR` | Lookup → `LS_QP1402r01_ChangeRequests` | No | Originating / Last DCR | The change request that created or last revised this record. Read-only. |

> **Data Integrity Rule:** `DocID`, `Revision`, `Status`, and `EffectiveDate` may only be changed by an approved `LS_QP1402r01` Document Change Request reaching its "Effective" stage — direct edits to controlled fields are blocked to preserve the audit trail. Superseding a revision automatically sets the prior record `Status = "Superseded"`.

---

## 2. Form Layout & Logic

### Section 01 – Identification

**Fields:** `DocID`, `Title`, `DocType`, `Tier`, `Department`, `TemplateUsed`  
**Logic:** `Tier` may be auto-suggested from `DocType` (Policies→Tier 1; Quality Manual→Tier 2; QP/LP/EP/QRG/TM→Tier 3; FM/FE/SP/LBK→Tier 4). `DocID` validated against QP-14 §5.5 naming patterns.

---

### Section 02 – Revision & Status

**Fields:** `Revision`, `Status`, `EffectiveDate`, `NextRevisionDate`, `Owner`, `ApprovedBy`  
**Logic:** Controlled fields (see Integrity Rule) are read-only in the register UI and updated only via the DCR workflow. `NextRevisionDate` feeds a review-due reminder.

---

### Section 03 – Relationships

**Fields:** `ParentDocID`, `RelatedDocs`  
**Logic:** Populates the **Relationship Map** tree view (parent → children). Guidance: *"Link each Form/Record to its parent SOP, and each SOP to its governing Manual/Policy."*

---

### Section 04 – Distribution & External Documents

**Fields:** `DistributionLocation`, `IsExternal`, `ExternalSource`, `FileRef`  
**Logic:** IF `IsExternal == Yes`, THEN show `ExternalSource` (mandatory) and the record is filtered into the External Documents register view.

---

## 3. Roles & Permissions

| Role | Permission Level |
|---|---|
| Quality Assurance Manager | Full Control (owner of the register) |
| Laboratory Manager | Contribute (edit non-controlled fields) + Approve |
| Laboratory Analyst | View |
| Laboratory Director | View + Approve (Policies/Manuals) |
| External Users – Assessor | View only |

**Approval Workflow:** New or revised documents enter the register only through an approved DCR (`LS_QP1402r01`). On the DCR's "Effective" stage, Power Automate creates/updates the register record, sets `Status`, `Revision`, and `EffectiveDate`, and supersedes the prior revision.

---

## 4. Integration Points

| Direction | Target / Source | Details |
|---|---|---|
| Receives from | `LS_QP1402r01_ChangeRequests` | On DCR approval/effectiveness, creates/updates/obsoletes register records. `LinkedDCR` stores the originating DCR. |
| Feeds into | Dashboard UI – Control of Documents (List view) | Primary data source for the document table (Doc ID, Title, Ver, Status, Effective Date). |
| Feeds into | Dashboard UI – Relationship Map | `Tier` + `ParentDocID` build the tiered org-tree visualization. |
| Provides lookups to | All QMS lists | Every other form that references a controlled document (SOP/Form IDs) can look up against this register. |
