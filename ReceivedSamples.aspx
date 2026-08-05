<%@ Page Language="C#" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sample Management System | QP08.01 Received Samples v2.1</title>
<style>
/* ═══════════════════════════════════════════════════════════════════════
   RESET & BASE
═══════════════════════════════════════════════════════════════════════ */
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;background:#F9F9F9;color:#333;line-height:1.6}

/* ═══════════════════════════════════════════════════════════════════════
   APP LAYOUT
═══════════════════════════════════════════════════════════════════════ */
.app{display:block;min-height:100vh;opacity:0;transition:opacity .15s ease}
.app.ready{opacity:1}

/* ═══════════════════════════════════════════════════════════════════════
   STICKY NAV WRAP
═══════════════════════════════════════════════════════════════════════ */
.app-nav-wrap{
  position:sticky;top:0;z-index:200;
  transform:translateY(0);
  transition:transform .3s ease;
}
.app-nav-wrap.nav-hidden{transform:translateY(-100%)}

/* ═══════════════════════════════════════════════════════════════════════
   TOP HEADER
═══════════════════════════════════════════════════════════════════════ */
.app-header{
  background:linear-gradient(135deg,#0072B2 0%,#56B4E9 100%);
  color:white;padding:20px 30px;
  box-shadow:0 2px 10px rgba(0,82,163,0.2);
}
.header-content{
  max-width:1400px;margin:0 auto;
  display:flex;justify-content:space-between;align-items:center;
}
.header-brand{display:flex;align-items:center;gap:15px}
.ph-logo{height:50px;width:auto;flex-shrink:0;}
.ph-logo-icon{display:none}
.header-brand h1{font-size:24px;font-weight:600;letter-spacing:.5px;color:white;margin:0;line-height:1.2}
.header-brand p{font-size:13px;color:rgba(255,255,255,.9);margin:0;line-height:1.3}

/* Mobile nav controls — hidden on wide screens */
.mobile-nav-controls{display:none;align-items:center;gap:10px;margin-left:auto}
/* Both page labels hidden on wide screens */
.cpl-left,.cpl-right{display:none}
.cpl-right{font-size:14px;font-weight:500;color:rgba(255,255,255,.9);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:180px}
.cpl-left{font-size:18px;font-weight:600;color:white;line-height:1.2;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;min-width:0}
.hamburger-btn{
  background:rgba(255,255,255,0.15);border:none;border-radius:6px;
  color:white;padding:8px 11px;font-size:18px;cursor:pointer;
  display:flex;align-items:center;justify-content:center;
  transition:background .2s;
}
.hamburger-btn:hover{background:rgba(255,255,255,0.28)}

/* Backdrop — fade in/out */
.nav-backdrop{
  position:fixed;inset:0;
  background:rgba(0,0,0,0.35);z-index:199;
  opacity:0;visibility:hidden;
  transition:opacity .25s ease,visibility .25s ease;
}
.nav-backdrop.show{opacity:1;visibility:visible}

/* ═══════════════════════════════════════════════════════════════════════
   TABS NAV
═══════════════════════════════════════════════════════════════════════ */
.tabs-container{
  background:white;border-bottom:2px solid #0072B2;
  box-shadow:0 2px 5px rgba(0,0,0,0.05);
}
.tabs-wrapper{
  width:100%;max-width:max-content;margin:0 auto;
  display:flex;overflow-x:auto;
}
.sb-item{
  flex:1;padding:16px 20px;border:none;background:none;cursor:pointer;
  font-size:15px;font-weight:400;line-height:1em;color:#666;
  border-bottom:3px solid transparent;
  transition:all .2s;white-space:nowrap;
  display:flex;align-items:center;justify-content:center;gap:8px;
  border-radius:5px;
  font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;
}
.sb-item:hover{color:#0072B2;background:#f0f8ff}
.sb-item.active{color:#0072B2;border-bottom-color:#E69F00;background:white}
.icon{display:inline-block;vertical-align:-0.2em;flex-shrink:0;width:16px;height:16px}
.icon-sm{width:12px;height:12px}
.icon-lg{width:20px;height:20px}
.icon-xl{width:24px;height:24px}

/* ═══════════════════════════════════════════════════════════════════════
   MAIN CONTENT
═══════════════════════════════════════════════════════════════════════ */
.main{background:#F9F9F9;min-height:calc(100vh - 130px);padding:0 30px 40px;}
.main-inner{max-width:1400px;margin:0 auto;}
.page{display:none}
.page.active{display:block;animation:fadeUp .3s ease}
@keyframes fadeUp{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}

/* ═══════════════════════════════════════════════════════════════════════
   PAGE HEADER — white with gold accent
═══════════════════════════════════════════════════════════════════════ */
.page-header{
  background:transparent;
  padding:30px 0 16px;
  margin:0 0 30px;
  border-bottom:1px solid #c0c0c0;
}
.page-header h1{font-size:1.5rem;font-weight:700;color:#2c3e50;line-height:1.2;margin:0 0 2px}
.page-header p{font-size:13px;color:#64748b;margin:0}

/* ═══════════════════════════════════════════════════════════════════════
   STATS GRID
═══════════════════════════════════════════════════════════════════════ */
.stats-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(190px,1fr));gap:18px;margin-bottom:24px}
.stat-card{
  background:#EBF2FB;padding:18px 20px;border-radius:4px;
  border-left:4px solid #0072B2;
  box-shadow:0 2px 8px rgba(0,114,178,0.08);
  transition:transform .2s,box-shadow .2s;
}
.stat-card:hover{transform:translateY(-2px);box-shadow:0 4px 12px rgba(0,114,178,0.15)}
.stat-card.green{background:#e8f5e9;border-left-color:#2e7d32}
.stat-card.orange{background:#fff3e0;border-left-color:#E69F00}
.stat-card.red{background:#ffebee;border-left-color:#c62828}
.stat-value{font-size:28px;font-weight:700;color:#0072B2;margin-bottom:4px}
.stat-card.green .stat-value{color:#2e7d32}
.stat-card.orange .stat-value{color:#a16207}
.stat-card.red .stat-value{color:#c62828}
.stat-label{font-size:12px;color:#666;text-transform:uppercase;font-weight:600;letter-spacing:.5px}

/* ═══════════════════════════════════════════════════════════════════════
   CARDS
═══════════════════════════════════════════════════════════════════════ */
.card{
  background:white;border-radius:8px;padding:22px 25px;
  box-shadow:0 2px 8px rgba(0,114,178,0.08);
  margin-bottom:22px;transition:box-shadow .2s;
}
.card:hover{box-shadow:0 4px 16px rgba(0,114,178,0.13)}
.card h2{
  font-size:1.0625rem;color:#0072B2;font-weight:600;
  margin-bottom:14px;padding-bottom:12px;border-bottom:3px solid #E69F00;
}
.card h3{font-size:14px;color:#333;font-weight:600;margin:18px 0 10px}

/* ═══════════════════════════════════════════════════════════════════════
   FORM ELEMENTS
═══════════════════════════════════════════════════════════════════════ */
.fg{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:18px;margin-bottom:16px}
.form-group{display:flex;flex-direction:column}
.form-group label{font-weight:500;color:#333;margin-bottom:6px;font-size:14px}
.form-group .req{color:#dc2626;font-weight:600;margin-left:2px}
.field-error{border:2px solid #c62828!important;background:#ffebee!important}
.field-error-label{color:#c62828!important}

input[type="text"],input[type="date"],input[type="month"],input[type="number"],select,textarea{
  padding:10px 12px;border:1px solid #ddd;border-radius:5px;
  font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;
  font-size:14px;transition:border-color .2s,box-shadow .2s;width:100%;
  background:white;color:#333;
}
input:focus,select:focus,textarea:focus{
  outline:none;border-color:#0072B2;box-shadow:0 0 0 3px rgba(0,114,178,0.12);
}
input[readonly]{background:#F9F9F9;color:#94a3b8;cursor:default}
input:disabled,select:disabled,textarea:disabled{background:#F9F9F9;color:#94a3b8;cursor:not-allowed;opacity:.75}
textarea{resize:vertical;min-height:75px}
input[type="checkbox"],input[type="radio"]{cursor:pointer;accent-color:#0072B2}

/* ═══════════════════════════════════════════════════════════════════════
   BATCH ENTRY STEP PANELS
═══════════════════════════════════════════════════════════════════════ */
.ns-panel{
  transition:opacity 0.3s ease;
}
.ns-panel.ns-hidden{
  display:none !important;
}
.ns-panel.ns-fading{
  opacity:0;
  pointer-events:none;
}
.ns-step.ns-done{cursor:pointer!important}
.ns-step.ns-done:hover .ns-circle{
  box-shadow:0 0 0 4px rgba(0,114,178,0.18);
}

/* ═══════════════════════════════════════════════════════════════════════
   BATCH ENTRY STEPPER
═══════════════════════════════════════════════════════════════════════ */
.ns-stepper{
  display:flex;align-items:flex-start;justify-content:center;
  padding:20px 16px 8px;margin-bottom:22px;position:relative;
}
.ns-step{
  display:flex;flex-direction:column;align-items:center;
  flex:1;position:relative;min-width:0;
}
/* connector line between steps */
.ns-step:not(:last-child)::after{
  content:'';position:absolute;top:16px;left:calc(50% + 18px);
  right:calc(-50% + 18px);height:2px;
  background:#dde3ec;z-index:0;
}
.ns-step:not(:last-child).ns-done::after,
.ns-step:not(:last-child).ns-active::after{
  background:#0072B2;
}
.ns-circle{
  width:34px;height:34px;border-radius:50%;
  display:flex;align-items:center;justify-content:center;
  font-size:14px;font-weight:700;z-index:1;position:relative;
  border:2px solid #dde3ec;background:white;color:#aaa;
  transition:background .25s,border-color .25s,color .25s;
  flex-shrink:0;
}
.ns-step.ns-active .ns-circle{
  background:#0072B2;border-color:#0072B2;color:white;
  box-shadow:0 0 0 4px rgba(0,114,178,0.14);
}
.ns-step.ns-done .ns-circle{
  background:#0072B2;border-color:#0072B2;color:white;
}
.ns-label{
  margin-top:8px;font-size:12px;font-weight:600;
  color:#aaa;text-align:center;line-height:1.3;
  white-space:nowrap;transition:color .25s;
}
.ns-step.ns-active .ns-label{color:#0072B2}
.ns-step.ns-done .ns-label{color:#0072B2}
@media(max-width:480px){
  .ns-stepper{padding:16px 6px 4px}
  .ns-label{display:none}
  .ns-circle{width:28px;height:28px;font-size:12px}
  .ns-step:not(:last-child)::after{top:13px;left:calc(50% + 15px);right:calc(-50% + 15px)}
}

/* ═══════════════════════════════════════════════════════════════════════
   BATCH HEADER
═══════════════════════════════════════════════════════════════════════ */
.batch-banner{
  background:#EBF2FB;border-left:4px solid #0072B2;
  border-radius:4px;padding:18px 22px;margin-bottom:22px;
}
.batch-banner h2{
  font-size:1.0625rem;color:#0072B2;font-weight:600;
  border-bottom:3px solid #E69F00;padding-bottom:10px;margin-bottom:14px;
}
.batch-banner label{font-size:13px;color:#374151;font-weight:500;display:block;margin-bottom:5px}
.batch-banner select,.batch-banner input{
  border:1px solid #C1D9F5;background:white;color:#333;
  padding:10px 12px;border-radius:5px;font-size:14px;width:100%;
  transition:border-color .2s,box-shadow .2s;
}
.batch-banner select:focus,.batch-banner input:focus{
  border-color:#0072B2;box-shadow:0 0 0 3px rgba(0,114,178,0.12);outline:none;
}
.batch-banner input[readonly]{background:#F9F9F9;color:#0072B2;font-weight:600;font-size:14px}

/* ═══════════════════════════════════════════════════════════════════════
   TEST CATEGORY CARDS
═══════════════════════════════════════════════════════════════════════ */
.test-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(185px,1fr));gap:12px;margin:14px 0}
.test-cat-card{
  background:#f8f9fa;border:2px solid #e2e8f0;border-radius:6px;
  padding:13px;cursor:pointer;transition:all .2s;position:relative;
}
.test-cat-card:hover{border-color:#0072B2;background:#EBF2FB}
.test-cat-card.selected{border-color:#0072B2;background:#EBF2FB}
.test-cat-card input[type="checkbox"]{
  position:absolute;top:10px;right:10px;
  width:18px;height:18px;cursor:pointer;accent-color:#0072B2;
}
.test-cat-name{font-weight:600;font-size:13px;color:#333;padding-right:28px;margin-bottom:4px}
.test-cat-desc{font-size:11px;color:#64748b}

/* ═══════════════════════════════════════════════════════════════════════
   TEST DETAIL PANEL
═══════════════════════════════════════════════════════════════════════ */
.test-panel{
  background:#f8f9fa;border-left:4px solid #0072B2;
  padding:14px;margin-top:10px;border-radius:4px;display:none;
}
.test-panel.open{display:block}
.test-panel h4{font-size:12px;font-weight:700;color:#0072B2;margin-bottom:10px;text-transform:uppercase;letter-spacing:.3px}
.test-row-wrap{display:flex;align-items:flex-end;gap:8px;margin-bottom:10px;flex-wrap:wrap}
.test-row-wrap .test-row{flex:1;margin-bottom:0}
.test-panel-clear-btn{display:none;flex-shrink:0;margin-bottom:1px}
.test-row{display:grid;gap:10px;margin-bottom:10px}
.test-row.cols-2{grid-template-columns:1fr 1fr}
.test-row.cols-3{grid-template-columns:1fr 1fr 1fr}
.test-fields-flex{display:flex;flex-wrap:wrap;gap:10px;flex:1;min-width:0}
.test-fields-flex .form-group{margin-bottom:0}
.test-fields-flex .form-group.name-field{flex:2 1 220px;min-width:200px}
.test-fields-flex .form-group.spec-field{flex:1 1 130px;min-width:110px}
.spec-mod-error{display:none;color:#c0392b;font-size:12px;margin:0 0 8px}
.test-item-list{margin-top:8px}
.test-item{
  background:white;padding:9px 12px;margin:4px 0;border-radius:4px;
  border-left:3px solid #0072B2;
  display:flex;justify-content:space-between;align-items:center;
  font-size:13px;color:#333;
}
.test-item span{flex:1}
.btn-remove-test{
  background:#e74c3c;color:white;border:none;
  padding:3px 8px;border-radius:3px;
  cursor:pointer;font-size:11px;font-weight:600;flex-shrink:0;transition:background .2s;
}
.btn-remove-test:hover{background:#c0392b}

/* ═══════════════════════════════════════════════════════════════════════
   BUTTONS
═══════════════════════════════════════════════════════════════════════ */
button{
  padding:11px 20px;border:none;border-radius:5px;
  cursor:pointer;font-size:14px;font-weight:600;
  font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;
  transition:all .2s;
}
.btn-primary{background:linear-gradient(135deg,#0072B2 0%,#56B4E9 100%);color:white}
.btn-primary:hover{background:linear-gradient(135deg,#004880 0%,#4590C1 100%);box-shadow:0 4px 12px rgba(0,114,178,0.3);transform:translateY(-2px)}
.btn-success{background:linear-gradient(135deg,#0072B2 0%,#56B4E9 100%);color:white}
.btn-success:hover{background:linear-gradient(135deg,#004880 0%,#4590C1 100%);box-shadow:0 4px 12px rgba(0,114,178,0.3);transform:translateY(-2px)}
.btn-secondary{background:#e0e0e0;color:#333}
.btn-secondary:hover{background:#d0d0d0}
.btn-export{background:linear-gradient(135deg,#E69F00 0%,#F0C832 100%);color:#1a1a1a}
.btn-export:hover{box-shadow:0 4px 12px rgba(230,159,0,0.35);transform:translateY(-2px)}
.btn-danger{background:#e74c3c;color:white;padding:6px 13px;font-size:12px}
.btn-danger:hover{background:#c0392b}
.btn-success:disabled,.btn-primary:disabled{opacity:0.45;cursor:not-allowed;transform:none!important;box-shadow:none!important}
.btn-sm{padding:8px 14px;font-size:13px}
.btn-group{display:flex;gap:10px;margin-top:22px;flex-wrap:wrap}
.btn-add-test{
  background:linear-gradient(135deg,#0072B2 0%,#56B4E9 100%);
  color:white;padding:8px 14px;font-size:13px;border:none;border-radius:5px;
  cursor:pointer;font-weight:600;margin-top:8px;transition:all .2s;
}
.btn-add-test:hover{background:linear-gradient(135deg,#004880 0%,#4590C1 100%);box-shadow:0 4px 12px rgba(0,114,178,0.3);transform:translateY(-2px)}

/* ═══════════════════════════════════════════════════════════════════════
   TABLES
═══════════════════════════════════════════════════════════════════════ */
.table-wrap{
  overflow-x:auto;margin-top:16px;
  border-radius:8px;background:white;
  box-shadow:0 2px 8px rgba(0,0,0,0.1);
}
table{width:100%;border-collapse:collapse;font-size:14px}
thead{background:linear-gradient(135deg,#0072B2 0%,#56B4E9 100%);color:white}
th{padding:14px;text-align:left;font-weight:600;font-size:13px;letter-spacing:.5px;white-space:nowrap}
td{padding:12px 14px;border-bottom:1px solid #eee;font-size:14px;vertical-align:middle}
tbody tr:hover{background-color:#f8f9fa}
tbody tr:last-child td{border-bottom:none}

/* ═══════════════════════════════════════════════════════════════════════
   BADGES
═══════════════════════════════════════════════════════════════════════ */
.badge{display:inline-block;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;white-space:nowrap}
.badge-Pending{background:#fff3cd;color:#664d03}
.badge-In-Progress{background:#cfe2ff;color:#084298}
.badge-Testing-Complete{background:#d1ecf1;color:#0c5460}
.badge-Approved-Released{background:#d4edda;color:#155724}
.badge-Cancelled{background:#f8d7da;color:#842029}
.tat-ok{background:#d4edda;color:#155724}
.tat-warn{background:#fff3cd;color:#664d03}
.tat-over{background:#f8d7da;color:#842029}
.tat-pill{display:inline-block;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;white-space:nowrap}
.sid-wrap{display:inline-flex;flex-wrap:wrap;align-items:center;gap:4px}
.edited-pill{display:inline-block;font-size:10px;font-weight:600;padding:1px 6px;border-radius:10px;background:#e9ecef;color:#6c757d;white-space:nowrap}

/* ═══════════════════════════════════════════════════════════════════════
   STATUS BULK SELECT
═══════════════════════════════════════════════════════════════════════ */
.status-chk{width:20px;height:20px;cursor:pointer;accent-color:#0072B2;flex-shrink:0;vertical-align:middle}
.ns-tat-fields{display:flex;flex-wrap:wrap;gap:16px}
.rush-filters{margin-bottom:16px}
.rush-row1{display:flex;flex-wrap:wrap;align-items:center;gap:10px}
.rush-search-input{flex:1;min-width:240px}
.rush-row1-filters{display:flex;gap:10px;flex:0 0 auto}
.rush-row1-filters select{width:200px;max-width:100%}
.rush-row2{display:flex;align-items:center;gap:10px;margin-top:10px}
.rush-row2 button{flex:0 0 auto;white-space:nowrap}
@media(max-width:663px){
  .rush-search-input{flex:1 1 100%;width:100%}
  .rush-row1-filters{flex:1 1 100%;width:100%}
  .rush-row1-filters select{flex:1;width:auto}
  .rush-row2{flex-wrap:wrap}
  .rush-row2 button{flex:1 1 0}
}
@media(max-width:480px){
  .rush-row1-filters{flex-direction:column}
  .rush-row1-filters select{width:100%}
  .rush-row2{flex-direction:column;align-items:stretch}
  .rush-row2 button{width:100%}
}
.ns-tat-fields .form-group{width:320px;max-width:100%}
@media(max-width:663px){.ns-tat-fields .form-group{width:100%}}
.rush-chk-label{display:flex;align-items:center;gap:7px;font-size:13px;font-weight:600;white-space:nowrap;cursor:pointer;user-select:none}
tr.status-row-selected td{background:#EBF2FB!important}
.status-prev-list{display:flex;flex-wrap:wrap;gap:8px;padding:0;margin-bottom:16px}
.status-id-capsule{
  display:inline-flex;align-items:center;gap:7px;
  border:1px solid #cdd8e3;
  border-radius:20px;padding:5px 5px 5px 12px;font-size:13px;
}
@media(max-width:480px){
  .status-id-capsule{width:100%;box-sizing:border-box;}
}

/* ═══════════════════════════════════════════════════════════════════════
   IN-HOUSE EDIT MODE
═══════════════════════════════════════════════════════════════════════ */
.ih-edit-mode-btn{padding:7px 14px;border:1px solid #0072B2;border-radius:6px;background:white;color:#0072B2;font-size:13px;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:6px;transition:background 0.2s,color 0.2s;white-space:nowrap}
.ih-edit-mode-btn.active{background:#0072B2;color:white}
.ih-edit-mode-btn:hover:not(.active){background:#f0f4fa}
.ih-edit-input{width:100%;border:1px solid #ddd;border-radius:5px;padding:10px 12px;font-size:14px;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;box-sizing:border-box;background:white;color:#333;transition:border-color .2s,box-shadow .2s}
.ih-edit-input:focus{outline:none;border-color:#0072B2;box-shadow:0 0 0 3px rgba(0,114,178,0.12)}
.ih-field-error{border-color:#c62828!important;box-shadow:0 0 0 3px rgba(198,40,40,0.12)!important;outline:none}
.ih-save-controls{display:flex;align-items:center;gap:14px;margin-top:20px;padding-top:14px;border-top:1px solid #e0e0e0}
.ih-save-status{font-size:13px;display:flex;align-items:center;gap:6px}
.ih-save-btn{padding:8px 20px;background:#0072B2;color:white;border:none;border-radius:6px;font-size:13px;font-weight:600;cursor:pointer;margin-left:auto;transition:background 0.2s,opacity 0.2s}
.ih-save-btn:hover:not(:disabled){background:#004880}
.ih-save-btn:disabled{opacity:0.45;cursor:not-allowed}
.ih-add-row-tr>td{border-top:1px dashed #ddd!important;padding:0!important}
.ih-add-row-btn{background:none;border:none;color:#0072B2;font-size:13px;font-weight:500;display:flex;align-items:center;justify-content:center;gap:6px;padding:10px 14px;width:100%;cursor:pointer;border-radius:4px;transition:background 0.08s,color 0.08s}
.ih-add-row-btn:hover{color:#004880;background:#c9ddf5}
.ih-status-capsule{display:inline-block;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;white-space:nowrap}
.ih-status-active{background:#e6f4ea;color:#2e7d32}
.ih-status-not-active{background:#fdecea;color:#c62828}
.ih-status-pending{background:#fff8e1;color:#856404}
.ih-status-default{background:#f0f0f0;color:#666}
.ih-accred-yes{background:#e8f1fb;color:#0072B2}
.ih-accred-no{background:#f0f0f0;color:#666}
.ih-del-btn{display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;padding:0;border:1.5px solid #4a7fb5;border-radius:5px;background:#f0f5fc;color:#4a7fb5;cursor:pointer;transition:background 0.15s,border-color 0.15s,color 0.15s}
.ih-del-btn:hover{background:#fdd;border-color:#c62828;color:#c62828}
.ih-undo-btn{display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;padding:0;border:1.5px solid #c62828;border-radius:5px;background:#fdecea;color:#c62828;cursor:pointer;transition:background 0.15s,border-color 0.15s,color 0.15s}
.ih-undo-btn:hover{background:#f0f5fc;border-color:#0072B2;color:#0072B2}
.ih-row-deleted-view>td{background:#f5f5f5!important;text-decoration:line-through;color:#999}
.ih-row-deleted-edit>td{background:#fdecea!important}
.ih-row-deleted-edit .ih-edit-input{text-decoration:line-through;color:#999}
.st-combobox-wrap{position:relative}
.st-dropdown{position:absolute;top:100%;left:0;right:0;background:white;border:1px solid #ddd;border-top:none;border-radius:0 0 5px 5px;box-shadow:0 4px 12px rgba(0,0,0,0.12);z-index:300;max-height:200px;overflow-y:auto;display:none}
.st-dropdown.open{display:block}
.st-dropdown.up{top:auto;bottom:100%;border-top:1px solid #ddd;border-bottom:none;border-radius:5px 5px 0 0}
.st-dropdown-item{padding:8px 12px;font-size:13px;cursor:pointer;color:#333}
.st-dropdown-item:hover{background:#f0f5fc;color:#0072B2}
.st-dropdown-other{padding:8px 12px;font-size:13px;cursor:pointer;color:#0072B2;border-top:1px solid #f0f0f0;font-style:italic}
.st-dropdown-other:hover{background:#f0f5fc}
.ih-cat-badge{display:inline-block;padding:2px 8px;border-radius:10px;font-size:11px;font-weight:600;background:#e8f1fb;color:#0072B2;white-space:nowrap}

/* ═══════════════════════════════════════════════════════════════════════
   SEARCH BAR
═══════════════════════════════════════════════════════════════════════ */
.search-bar{
  background:white;padding:14px 16px;border-radius:8px;
  margin-bottom:18px;box-shadow:0 2px 8px rgba(0,114,178,0.08);
  display:flex;gap:10px;flex-wrap:wrap;align-items:stretch;
}
.search-bar input{flex:1;min-width:240px;align-self:center}
.search-bar select{width:200px;flex:0 0 200px;padding:0 10px;border:1.5px solid #d0d7e2;border-radius:6px;font-size:13px;color:#333;background:#fff;cursor:pointer;align-self:stretch}
.search-bar button{align-self:stretch}
.ih-search-bar{flex-direction:column;gap:10px}
.ih-filter-row{display:flex;gap:10px;align-items:stretch}
.ih-filter-row input{flex:1;min-width:0;height:42px;box-sizing:border-box}
.ih-filter-row select{width:200px;flex:0 0 200px;height:42px;box-sizing:border-box}
.ih-action-row{display:flex;gap:10px;align-items:stretch}
.ih-action-row button{flex:0 0 auto}

/* ═══════════════════════════════════════════════════════════════════════
   FILTER PANEL
═══════════════════════════════════════════════════════════════════════ */
.filter-panel{
  background:white;border-radius:8px;padding:18px 25px;
  margin-bottom:18px;box-shadow:0 2px 8px rgba(0,114,178,0.08);
}
.filter-panel h3{
  font-size:1.0625rem;font-weight:600;color:#0072B2;
  margin-bottom:14px;padding-bottom:12px;border-bottom:3px solid #E69F00;
}
.filter-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(175px,1fr));gap:12px;margin-bottom:12px}
.filter-grid label{font-size:13px;font-weight:500;color:#333;margin-bottom:5px;display:block}
#page-master-list .filter-grid{display:flex;flex-wrap:wrap;align-items:flex-end}
#page-master-list .filter-grid>div{flex:1 1 140px;display:flex;flex-direction:column}
#page-master-list .filter-grid>div:first-child{flex:2 1 220px}
input[type="date"]:not(.has-value):not(:focus)::-webkit-datetime-edit{color:transparent}
.filter-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:4px;align-items:center}

/* ═══════════════════════════════════════════════════════════════════════
   INFO BOX & ALERTS
═══════════════════════════════════════════════════════════════════════ */
.info-box{
  background:#EBF2FB;border-left:4px solid #0072B2;border-radius:4px;
  padding:13px 16px;margin-bottom:18px;font-size:14px;color:#0052A3;
}
.alert{padding:12px 16px;border-radius:5px;margin-bottom:16px;font-size:14px;display:none}
.alert.show{display:block}
.alert.success{background:#e8f5e9;color:#2e7d32;border-left:4px solid #2e7d32}
.alert.error{background:#ffebee;color:#c62828;border-left:4px solid #c62828}

/* ═══════════════════════════════════════════════════════════════════════
   BULK IMPORT (Step 3)
═══════════════════════════════════════════════════════════════════════ */
.bi-banner{
  background:#EBF2FB;border-left:4px solid #0072B2;border-radius:0 8px 8px 0;
  padding:14px 18px;display:flex;align-items:center;gap:14px;margin-bottom:20px;
}
.bi-banner .icon{width:22px;height:22px;color:#0072B2;flex-shrink:0}
.bi-banner-body{flex:1;min-width:0;font-size:13.5px;color:#333;line-height:1.45}
.bi-banner-body strong{font-weight:600}
.bi-banner-btn{
  flex-shrink:0;background:linear-gradient(135deg,#0072B2 0%,#56B4E9 100%);color:white;border:none;
  border-radius:6px;padding:8px 16px;font-size:13px;font-weight:600;
  font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;cursor:pointer;white-space:nowrap;
  transition:all .2s;
}
.bi-banner-btn:hover{background:linear-gradient(135deg,#004880 0%,#4590C1 100%);box-shadow:0 4px 12px rgba(0,114,178,0.3);transform:translateY(-2px)}
.bi-back{
  display:inline-flex;align-items:center;gap:5px;font-size:13px;
  color:#0072B2;cursor:pointer;font-weight:500;margin-bottom:16px;
  text-decoration:none;padding:3px 0;border:none;background:none;
  font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;
}
.bi-back:hover{text-decoration:underline}
.bi-back .icon{width:14px;height:14px}
.bi-hidden{display:none!important}
.bi-upload-area{
  border:2px dashed #dde3ec;border-radius:8px;
  padding:36px 24px;text-align:center;cursor:pointer;
  transition:border-color .2s,background .2s;margin-top:14px;
}
.bi-upload-area:hover,.bi-upload-area.drag-over{border-color:#0072B2;background:#EBF2FB}
.bi-upload-area .icon{width:36px;height:36px;color:#7f8c8d;margin:0 auto 10px;display:block}
.bi-upload-text{font-size:14px;color:#7f8c8d;margin-bottom:4px}
.bi-upload-link{font-size:14px;font-weight:600;color:#0072B2;cursor:pointer}
.bi-upload-formats{font-size:12px;color:#7f8c8d;margin-top:6px}
.bi-stats{
  display:grid;grid-template-columns:repeat(auto-fit,minmax(110px,1fr));
  gap:10px;margin:16px 0;
}
.bi-stat{border-radius:6px;padding:12px 14px;text-align:center}
.bi-stat-num{font-size:22px;font-weight:700}
.bi-stat-lbl{font-size:11px;font-weight:600;color:#7f8c8d;text-transform:uppercase;letter-spacing:.04em}
.bi-stat.ok{background:#e8f5e9}.bi-stat.ok .bi-stat-num{color:#2e7d32}
.bi-stat.info{background:#EBF2FB}.bi-stat.info .bi-stat-num{color:#0072B2}
.bi-stat.warn{background:#fff8e7}.bi-stat.warn .bi-stat-num{color:#a16207}
.bi-stat.err{background:#ffebee}.bi-stat.err .bi-stat-num{color:#c62828}
.bi-group{border:1.5px solid #e2e8f0;border-radius:8px;overflow:hidden;margin-bottom:12px}
.bi-group-hdr{
  background:#EBF2FB;padding:12px 16px;
  display:flex;justify-content:space-between;align-items:center;gap:12px;
}
.bi-group-name{font-size:14px;font-weight:600;color:#333}
.bi-group-meta{font-size:12px;color:#7f8c8d;margin-top:2px}
.bi-status{
  font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.04em;
  padding:3px 10px;border-radius:10px;white-space:nowrap;
}
.bi-status.ready{background:#e8f5e9;color:#2e7d32}
.bi-status.warning{background:#fff8e7;color:#a16207}
.bi-status.error{background:#ffebee;color:#c62828}
.bi-test-row{
  padding:8px 16px;display:flex;justify-content:space-between;align-items:center;
  border-top:1px solid #e2e8f0;font-size:13px;gap:12px;
}
.bi-test-name{font-weight:500;color:#333;display:flex;align-items:center;gap:8px}
.bi-test-cat{
  font-size:10px;font-weight:600;background:#EBF2FB;color:#0072B2;
  padding:1px 7px;border-radius:3px;
}
.bi-test-spec{font-size:12.5px;color:#7f8c8d;text-align:right}
.bi-test-row.err .bi-test-spec{color:#c62828}
.bi-review-note{
  background:#fff8e7;border-left:3px solid #E69F00;
  border-radius:0 4px 4px 0;padding:8px 12px;margin:10px 16px;
  font-size:12.5px;color:#a16207;display:flex;align-items:center;gap:6px;
}
.bi-review-note .icon{width:14px;height:14px;flex-shrink:0}
.bi-review-note.err{background:#ffebee;border-left-color:#c62828;color:#c62828}
.bi-chk-row{
  display:flex;align-items:center;gap:8px;
  background:#EBF2FB;border-radius:6px;
  padding:10px 14px;margin-top:12px;cursor:pointer;
}
.bi-chk-row input[type="checkbox"]{width:17px;height:17px;accent-color:#0072B2;cursor:pointer;pointer-events:none}
.bi-chk-row label{font-size:13px;color:#333;cursor:pointer;pointer-events:none}
.bi-info-note{
  background:#fff8e7;border-left:4px solid #E69F00;
  border-radius:0 6px 6px 0;padding:12px 16px;margin-top:14px;
  font-size:13px;color:#333;line-height:1.5;
}
.bi-info-note strong{font-weight:600}
@media(max-width:600px){
  .bi-banner{flex-direction:column;align-items:flex-start}
  .bi-stats{grid-template-columns:1fr 1fr}
}

/* ═══════════════════════════════════════════════════════════════════════
   LOADING OVERLAY
═══════════════════════════════════════════════════════════════════════ */
#loadingOverlay{
  display:none;position:fixed;inset:0;
  background:rgba(255,255,255,.82);
  z-index:9999;justify-content:center;align-items:center;
  font-size:14px;font-weight:500;color:#555;flex-direction:column;gap:14px;
}
#loadingOverlay.show{display:flex}
.spinner{
  width:40px;height:40px;border:4px solid #e0e0e0;border-top-color:#0072B2;
  border-radius:50%;animation:spin .8s linear infinite;
}
@keyframes spin{to{transform:rotate(360deg)}}

/* ═══════════════════════════════════════════════════════════════════════
   MODAL
═══════════════════════════════════════════════════════════════════════ */
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:999;justify-content:center;align-items:flex-start;padding-top:40px}
.modal-overlay.open{display:flex}
.modal-box-outer{position:relative;width:90%;max-width:700px}
.modal-box{background:white;border-radius:8px;padding:0 28px 28px;max-height:88vh;overflow-y:auto;box-shadow:0 8px 32px rgba(0,0,0,.15)}
.modal-head{display:flex;justify-content:space-between;align-items:center;margin:0 -28px 18px;padding:18px 28px 12px;border-bottom:3px solid #E69F00;position:sticky;top:0;background:white;z-index:5}
.modal-head h2{font-size:1.0625rem;color:#0072B2;font-weight:600}
.modal-close-circle{position:absolute;top:0;right:-20px;transform:translateX(100%);width:40px;height:40px;padding:0;border-radius:50%;border:2px solid #fff;background:rgba(0,0,0,.55);color:#fff;font-size:22px;line-height:1;cursor:pointer;display:grid;place-items:center;transition:background .15s}
.modal-close-circle:hover{background:rgba(0,0,0,.8)}
.modal-section{margin-top:22px;padding-top:18px;border-top:1px solid #e0e0e0}
.modal-section h3{font-size:13px;font-weight:700;color:#0072B2;text-transform:uppercase;letter-spacing:.5px;margin:0 0 12px}
#m_changeLog{background:#f8f9fa;border-radius:6px;padding-block:10px}
.changelog-entry{display:flex;align-items:flex-start;gap:12px;padding:8px 20px;border-bottom:1px solid #E2E2E2}
.changelog-entry:last-child{border-bottom:none}
.changelog-author{flex-shrink:0;width:120px;font-size:13px;font-weight:600;color:#374151}
.changelog-reason{flex:1;font-size:13px;color:#374151}
.changelog-date{flex-shrink:0;font-size:12px;color:#6c757d;white-space:nowrap}
.modal-cat{margin-bottom:16px}
.modal-cat-title{font-size:12px;font-weight:700;color:#64748b;text-transform:uppercase;letter-spacing:.5px;margin-bottom:6px;padding:4px 8px;background:#f0f8ff;border-left:3px solid #0072B2;border-radius:0 4px 4px 0}
.modal-test-row{display:flex;justify-content:space-between;align-items:baseline;padding:5px 8px;border-bottom:1px solid #f5f5f5;font-size:13px;gap:10px}
.modal-test-row:last-child{border-bottom:none}
.modal-test-name{color:#2c3e50;font-weight:500}
.modal-test-spec{color:#64748b;font-size:12px;text-align:right}
.modal-test-result{color:#0072B2;font-size:12px;text-align:right;font-weight:600}
.modal-field{display:flex;align-items:baseline;gap:6px;flex-wrap:wrap;min-height:20px}
.modal-field-label{font-weight:500;color:#333;font-size:14px;white-space:nowrap}
.modal-field-value{font-size:14px;color:#2c3e50}
.modal-field-value.empty{color:#b0b8c1;font-style:italic}
.modal-checklist{display:flex;flex-direction:column;gap:0}
.modal-checklist .checklist-item{cursor:pointer;flex-wrap:wrap}
.modal-checklist .checklist-item label{font-weight:600;cursor:pointer}
.modal-checklist-desc{font-size:12px;color:#7f8c8d;margin-left:4px}
.modal-test-entry{border-left:4px solid #cbd5e1;background:#fff;padding:10px 12px;margin-bottom:12px;border-radius:4px}
.modal-test-entry .test-fields-flex{gap:16px;margin-top:10px}
.modal-test-row-actions{border-top:1px solid #e5e7eb;padding-top:10px}
.modal-new-test-section{margin-top:18px;padding-top:14px;border-top:2px dashed #d0d7e2}
.modal-new-test-section h5{font-size:12px;font-weight:700;color:#0072B2;text-transform:uppercase;letter-spacing:.5px;margin:0 0 10px}
.modal-test-row-actions{display:flex;align-items:center;gap:8px;margin-top:14px;width:100%}
.modal-test-row-actions .mt-result{flex:1}
.modal-test-row-actions .mt-status{flex:0 0 200px}
.modal-test-row-actions .mt-del{flex:0 0 auto}
@media(max-width:480px){
  .modal-test-row-actions{flex-direction:column;align-items:stretch}
  .modal-test-row-actions .mt-status{flex:1 1 auto}
}
#me_editReason{min-height:150px}
.m-acc-group{margin-top:22px}
.m-acc-item{border:1px solid #e2e8f0;border-radius:8px;overflow:hidden;margin-bottom:14px}
.m-acc-header{background:#f8f9fa;padding:14px 18px;cursor:pointer;display:flex;justify-content:space-between;align-items:center;transition:background .2s}
.m-acc-header:hover{background:#f1f5f9}
.m-acc-header h3{margin:0;font-weight:500;color:#333;font-size:14px}
.m-acc-toggle{color:#0072B2;font-size:1.1em;flex-shrink:0;transition:transform .3s ease}
.m-acc-item.active .m-acc-toggle{transform:rotate(180deg)}
.m-acc-content{display:none;padding:16px 18px;background:#fff;border-top:1px solid #e2e8f0}
.m-acc-item.active .m-acc-content{display:block}

/* ═══════════════════════════════════════════════════════════════════════
   CHECKLIST
═══════════════════════════════════════════════════════════════════════ */
.checklist-item{display:flex;align-items:center;padding:10px;margin:6px 0;background:#f8f9fa;border-radius:5px}
.checklist-item input[type="checkbox"]{margin-right:12px;width:17px;height:17px;cursor:pointer;accent-color:#0072B2;flex-shrink:0}
.checklist-item label{margin-bottom:0;cursor:pointer;font-size:14px;font-weight:400}

/* ═══════════════════════════════════════════════════════════════════════
   WIDGETS
═══════════════════════════════════════════════════════════════════════ */
.risk-widget{
  background:#ffebee;border-left:4px solid #c62828;
  border-radius:4px;padding:18px 22px;margin-bottom:22px;
  transition:background .3s,border-left-color .3s;
}
.risk-widget.safe{background:#e8f5e9;border-left-color:#2e7d32;}
.risk-widget h2{
  font-size:1.0625rem;color:#c62828;font-weight:600;
  margin-bottom:14px;padding-bottom:12px;
  border-bottom:3px solid rgba(198,40,40,.3);
  display:flex;align-items:center;gap:8px;
  transition:color .3s,border-bottom-color .3s;
}
.risk-widget.safe h2{color:#2e7d32;border-bottom-color:rgba(46,125,50,.3);}
.recent-widget{
  background:white;border-radius:8px;
  padding:22px 25px;box-shadow:0 2px 8px rgba(0,114,178,0.08);margin-bottom:22px;
}
.recent-widget h3{
  font-size:1.0625rem;font-weight:600;color:#0072B2;
  margin-bottom:14px;padding-bottom:12px;border-bottom:3px solid #E69F00;
  display:flex;align-items:center;gap:8px;
}
.recent-item{
  padding:10px 12px;border-bottom:1px solid #e2e8f0;
  font-size:13px;cursor:pointer;
  transition:background .15s,padding-left .15s;display:flex;align-items:center;gap:8px;
}
.recent-item:hover{background:#f0f8ff;padding-left:16px}
.recent-item:last-child{border-bottom:none}
.recent-item strong{color:#0072B2}
.empty-state{text-align:center;padding:40px 20px;color:#94a3b8;font-size:14px}

/* ═══════════════════════════════════════════════════════════════════════
   RESPONSIVE
═══════════════════════════════════════════════════════════════════════ */
/* ── 1150px: hamburger + h1 at full size + right-side page label ── */
@media(max-width:1150px){
  /* Header: slim single row */
  .header-content{flex-direction:row;align-items:center;gap:10px;padding:0}
  .app-header{padding:12px 16px}
  .header-brand{gap:10px;flex:1;min-width:0}
  /* Show icon logo, hide full logo */
  .ph-logo-full{display:none}
  .ph-logo-icon{display:block;height:38px}
  /* Show h1 at original size, hide subtitle */
  .header-text{display:block}
  .header-text p{display:none}
  /* cpl-right visible next to hamburger; cpl-left stays hidden */
  .cpl-right{display:block}
  .cpl-left{display:none}

  /* Hamburger visible */
  .mobile-nav-controls{display:flex}

  /* Navbar: animated dropdown */
  .tabs-wrapper{
    flex-direction:column;
    position:absolute;width:100%;max-width:100%;
    background:white;
    box-shadow:0 4px 16px rgba(0,0,0,0.18);
    z-index:201;
    opacity:0;visibility:hidden;
    transform:translateY(-6px);
    transition:opacity .25s ease,visibility .25s ease,transform .25s ease;
  }
  .tabs-wrapper.nav-open{opacity:1;visibility:visible;transform:translateY(0)}
  .sb-item{
    flex:none;justify-content:flex-start;border-radius:0;
    border-bottom:1px solid #f0f0f0;border-left:3px solid transparent;
    padding:14px 20px;font-size:15px;
  }
  .sb-item:last-child{border-bottom:none}
  .sb-item:hover{border-left-color:rgba(0,114,178,0.3);background:#f0f8ff}
  .sb-item.active{border-left-color:#E69F00;background:#f0f8ff;color:#0072B2}

  /* tabs-container is the positioning anchor for the dropdown */
  .tabs-container{position:relative}
}

/* ── 800px: IH filter row wraps — input full width, selects share next line ── */
@media(max-width:800px){
  .ih-filter-row{flex-wrap:wrap}
  .ih-filter-row input{flex:1 1 100%}
  .ih-filter-row select{flex:1 1 calc(50% - 5px);width:auto}
}

/* ── 560px: hide h1, cpl-left takes its place on the left ── */
@media(max-width:560px){
  .header-text{display:none}
  .cpl-left{display:block}
  .cpl-right{display:none}

  /* Main */
  .main{padding:0 14px 30px}

  /* Search bars: buttons wrap below, share width */
  .search-bar{flex-wrap:wrap}
  .search-bar input{width:100%;flex:1 1 100%}
  .search-bar select{width:100%;flex:1 1 100%}
  .search-bar button{flex:1}

  /* btn-group: buttons share width evenly */
  .btn-group{flex-wrap:wrap}
  .btn-group button{flex:1;min-width:120px}

  /* New Sample: remarks span reset, serving size stacks naturally */
  .fg [style*="grid-column:span 2"]{grid-column:span 1!important}

  /* Test panels: stack all inputs */
  .test-row.cols-3,.test-row.cols-2{grid-template-columns:1fr}
  .test-fields-flex .form-group.name-field,.test-fields-flex .form-group.spec-field{flex-basis:100%}
  .btn-add-test{width:100%}

  /* Recent item: stack content vertically */
  .recent-item{flex-direction:column;align-items:flex-start;gap:4px}
}

/* ── 480px: phones — stack buttons, tables → cards ── */
@media(max-width:480px){
  /* Search bar: buttons stack full width */
  .search-bar select{width:100%;flex:none}
  .search-bar button{flex:none;width:100%}
  /* IH: selects and action buttons stack full width */
  .ih-filter-row select{flex:1 1 100%;width:100%}
  .ih-action-row{flex-wrap:wrap}
  .ih-action-row button{flex:1 1 100%}
  /* Master list filter actions: stack full width on phones */
  .filter-actions button{flex:1 1 100%}
  /* Load More: full width on cards breakpoint */
  #masterLoadMoreWrap button{width:100%}
  /* Modal test rows: stack name above spec */
  .modal-test-row{flex-direction:column;align-items:flex-start;gap:2px}
  .modal-test-spec{text-align:left}

  /* btn-group: stack full width */
  .btn-group{flex-direction:column}
  .btn-group button{flex:none;width:100%}

  /* Tables → card layout */
  .table-wrap{box-shadow:none;background:transparent}
  .table-wrap table thead{display:none}
  .table-wrap table,.table-wrap table tbody,.table-wrap table tr{display:block}
  .table-wrap table tr{
    background:white;margin-bottom:12px;border-radius:8px;
    padding:14px 16px;border-left:4px solid #0072B2;
    box-shadow:0 2px 8px rgba(0,114,178,0.08);
  }
  .table-wrap table td{
    display:block;padding:5px 0;
    border-bottom:1px solid #f0f0f0;font-size:13px;
  }
  .table-wrap table td:last-child{border-bottom:none;padding-top:10px}
  .table-wrap table td[data-label]::before{
    content:attr(data-label);
    display:block;font-size:11px;font-weight:600;
    color:#0072B2;text-transform:uppercase;letter-spacing:.5px;
    margin-bottom:2px;
  }
  .table-wrap table td[data-label=""]{display:block;border-bottom:none;padding-top:10px}
  .table-wrap table td[data-label=""] button{width:100%}
  /* Lab order table: left-align all cells in card view */
  #loContent td{text-align:left!important}
  /* TAT & Rush tables: left-align all cells in card view */
  #tatCatsContainer td,#rushOrdersContainer td{text-align:left!important}
  /* IH accreditation cell: left-align in card view */
  #inhouseListContainer td[data-label="Accreditation Status (17025)"]{text-align:left!important}
  .rr-tc{text-align:left!important}
}
.print-only{display:none!important}
@media print{
  body>#loadingOverlay{display:none!important}
  body>.app{visibility:hidden!important}
  #loPrintArea{
    display:block!important;visibility:visible!important;
    position:absolute;top:0;left:0;width:100%;
    padding:10px;font-size:11px;font-family:Arial,sans-serif;
  }
  #loContent{visibility:visible!important}
  .no-print,#loButtons{display:none!important}
  .print-only{display:grid!important}
  *{-webkit-print-color-adjust:exact!important;print-color-adjust:exact!important}
  h2{font-size:14px!important;margin:0 0 6px 0!important}
  h3{font-size:11px!important;margin:8px 0 4px 0!important}
  table{font-size:10px!important}
  td,th{padding:3px 6px!important}
  hr{margin:6px 0!important}
  #loButtons,button,.btn-primary,.btn-secondary{display:none!important}
  /* Kill page background */
  html,body,#loPrintArea{background:white!important}
  /* Lab order table: white header + white rows for print */
  #loContent thead,#loContent th{background:white!important;color:#333!important}
  #loContent tbody tr,#loContent td{background:white!important}
  /* Remove table-wrap decoration for print */
  #loContent .table-wrap{box-shadow:none!important;border-radius:0!important;margin:12px 0!important}
  /* Smaller font for lab order table in print */
  #loContent table,#loContent td,#loContent th{font-size:9px!important;padding:2px 4px!important}
  /* Border bottom on rows for print only */
  #loContent td{border-bottom:1px solid #ccc!important}
  /* Header bottom border for print */
  #loContent th{border-bottom:2px solid #1A3A5C!important}
}

/* ═══════════════════════════════════════════════════════════════════════
   RECEIVED REQUESTS
═══════════════════════════════════════════════════════════════════════ */
.rr-tc{text-align:center}
.rr-prefill-banner{display:flex;align-items:center;gap:10px;background:#fff3e0;border-left:4px solid #E69F00;border-radius:4px;padding:13px 16px;margin-bottom:18px;font-size:14px;color:#7c5000;flex-wrap:wrap}
.rr-prefill-banner svg{color:#E69F00;flex-shrink:0}
.rr-prefill-banner strong{color:#4a3000}
.rr-prefill-banner-dismiss{margin-left:auto;background:#E69F00;border:1px solid #E69F00;border-radius:5px;padding:3px 10px;font-size:12px;color:white;cursor:pointer;white-space:nowrap}
.rr-prefill-banner-dismiss:hover{background:none;color:#7c5000}
.rr-prefill-queue-badge{background:#E69F00;color:white;font-weight:700;font-size:11px;padding:2px 8px;border-radius:10px;flex-shrink:0}
#page-received-requests .search-bar select{height:41px}
@media(max-width:640px){
  #page-received-requests .search-bar input[type="text"]{flex:1 1 100%;min-width:0}
  #page-received-requests .search-bar select{flex:1 1 auto}
}
@media(max-width:480px){
  #page-received-requests .search-bar select,
  #page-received-requests .search-bar button{flex:1 1 100%}
}
.rr-rush-icon{display:inline-flex;align-items:center;flex-shrink:0;vertical-align:middle}
.rr-batch-status{display:inline-block;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:700;flex-shrink:0}
.rr-s-pending{background:#fff3e0;color:#a16207}
.rr-s-in-review{background:#e3f2fd;color:#0072B2}
.rr-s-accepted{background:#e8f5e9;color:#2e7d32}
.rr-s-rejected{background:#ffebee;color:#c62828}
.rr-s-partial{background:#ede9fe;color:#6b21a8}
.rr-row-rejected{background:#fff5f5!important;opacity:0.65}
.rr-reject-toggle{background:none;border:1px solid #ef4444;border-radius:20px;cursor:pointer;font-size:11px;font-weight:600;color:#ef4444;transition:background .15s,color .15s;padding:4px 11px;line-height:1.4;white-space:nowrap;flex-shrink:0}
.rr-reject-toggle:hover{background:#fef2f2}
.rr-reject-toggle.active{background:#ef4444;color:white}
.rr-accepted-lock{color:#16a34a;font-size:14px;font-weight:700}
.rr-row-rejected+.rr-modal-detail-row td{background:#ffe4e4!important}
.rr-reject-box{display:none;margin-top:12px}
.rr-reject-box.show{display:block}
.rr-reject-box textarea{width:100%;font-size:13px;padding:8px 10px;border:1px solid #ddd;border-radius:5px;resize:vertical;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif}
.rr-reject-box-btns{display:flex;gap:8px;margin-top:8px}
.rr-modal-sample-row{cursor:pointer;transition:background .15s}
.rr-modal-sample-row:hover{background:#f8fbff}
.rr-modal-sample-row.rr-expanded td{border-bottom:none}
.rr-modal-detail-row td{padding:0!important;background:#fafafa}
.rr-modal-content{padding:0 4px}
#rrModalBox{padding-bottom:0}
.rr-modal-footer{margin-top:18px;padding:14px 0 16px;border-top:2px solid #f0f0f0;position:sticky;bottom:0;background:white;z-index:4}
.rr-modal-footer-inner{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px}
.rr-modal-footer-actions{display:flex;gap:8px;flex-wrap:wrap}
@media(max-width:1000px){
  #rrModal .modal-box-outer,#sampleModal .modal-box-outer{display:flex;flex-direction:column}
  #rrModal .modal-close-circle,#sampleModal .modal-close-circle{position:static;transform:none;align-self:center;margin-top:16px;flex-shrink:0;order:1}
}
@media(max-width:480px){
  .rr-modal-footer-inner{flex-direction:column;align-items:stretch}
  .rr-modal-footer-actions{flex-direction:column}
  .rr-modal-footer-actions button{width:100%}
}
.rr-detail-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:10px 24px;margin-bottom:16px;padding:16px 20px 0}
.rr-detail-field{font-size:13px}
.rr-detail-label{color:#64748b;font-size:11px;text-transform:uppercase;letter-spacing:.4px;margin-bottom:3px}
.rr-detail-val{color:#2c3e50;font-weight:600;line-height:1.5}
.rr-tests-section{margin-top:4px;padding:14px 20px 16px;border-top:1px solid #e8e8e8}
.rr-tests-section h4{font-size:13px;font-weight:700;color:#0072B2;margin:0 0 12px}
.rr-cat-block{margin-bottom:0;padding:10px 0;border-bottom:1px solid #e8e8e8}
.rr-cat-block:last-child{border-bottom:none;padding-bottom:0}
.rr-cat-title{font-size:11px;font-weight:700;text-transform:uppercase;color:#64748b;letter-spacing:.5px;margin-bottom:6px}
.rr-test-item{display:flex;align-items:baseline;gap:10px;padding:5px 0;font-size:13px}
.rr-test-name{flex:1;color:#2c3e50;font-weight:500}
.rr-test-spec{color:#64748b;font-size:12px;white-space:nowrap}
</style>
</head>
<body>

<div id="loadingOverlay"><div class="spinner"></div><span id="loadingMsg">Loading&#8230;</span></div>

<div class="app">

<!-- ═══════════════════════════ NAV WRAP (sticky) ════════════════════ -->
<div class="app-nav-wrap" id="appNavWrap">

<!-- ═══════════════════════════ TOP HEADER ═══════════════════════════ -->
<header class="app-header">
  <div class="header-content">
    <div class="header-brand">
      <img id="sb-logo" src="logo_vertex_secondary.svg" alt="VERTEX Logo" class="ph-logo ph-logo-full">
      <img id="sb-logo-icon" src="logo_vertex_icon_app_secondary.svg" alt="VERTEX Logo" class="ph-logo ph-logo-icon">
      <div class="header-text">
        <h1>Sample Management System</h1>
        <p>Received Samples &amp; Laboratory Workflow &#8212; QP08.01</p>
      </div>
      <!-- Shown at ≤560px: left-side label replacing h1 -->
      <span class="cpl-left">Dashboard</span>
    </div>
    <div class="mobile-nav-controls">
      <!-- Shown at 560px–900px: right-side label next to hamburger -->
      <span class="cpl-right">Dashboard</span>
      <button class="hamburger-btn" id="hamburgerBtn" onclick="toggleMobileNav()" aria-label="Toggle navigation">
        <svg class="icon" aria-hidden="true"><use href="#icon-menu-outline"></use></svg>
      </button>
    </div>
  </div>
</header>

<!-- ═══════════════════════════ TABS NAV ═══════════════════════════ -->
<div class="tabs-container">
  <div class="tabs-wrapper" id="tabsWrapper">
    <div class="sb-item active" data-page="dashboard"><svg class="icon" aria-hidden="true"><use href="#icon-gauge-outline"></use></svg> Dashboard</div>
    <div class="sb-item" id="tabInhouseTesting" data-page="inhouse-testing" style="display:none"><svg class="icon" aria-hidden="true"><use href="#icon-microscope-outline"></use></svg> In-House Testing</div>
    <div class="sb-item" data-page="tat-rush"><svg class="icon" aria-hidden="true"><use href="#icon-rush-outline"></use></svg> TAT &amp; Rush Orders</div>
    <div class="sb-item" data-page="received-requests"><svg class="icon" aria-hidden="true"><use href="#icon-folder-outline"></use></svg> Received Requests</div>
    <div class="sb-item" data-page="new-sample"><svg class="icon" aria-hidden="true"><use href="#icon-flask-outline"></use></svg> New Sample / Batch</div>
    <div class="sb-item" data-page="master-list"><svg class="icon" aria-hidden="true"><use href="#icon-list-outline"></use></svg> Master List of Samples</div>
    <div class="sb-item" data-page="update-status"><svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Update Sample Status</div>
    <div class="sb-item" data-page="lab-order"><svg class="icon" aria-hidden="true"><use href="#icon-vials-outline"></use></svg> Lab Orders &#8212; Vertex</div>
    <div class="sb-item" data-page="subcontract" style="display:none"><svg class="icon" aria-hidden="true"><use href="#icon-subcontracted-outline"></use></svg> Subcontracted Tests</div>
  </div>
</div>

</div><!-- /.app-nav-wrap -->
<div class="nav-backdrop" id="navBackdrop" onclick="closeMobileNav()"></div>

<!-- ═══════════════════════════ MAIN ═══════════════════════════════ -->
<main class="main">
<div class="main-inner">

<!-- ──────────────── DASHBOARD ──────────────── -->
<section id="page-dashboard" class="page active">
  <div class="page-header"><h1>Dashboard</h1><p>System overview, TAT alerts &amp; recent activity</p></div>
  <div class="search-bar">
    <input type="text" id="globalSearch" placeholder="Quick Find: Sample ID, Customer, Lot Number&#8230;">
    <button id="globalSearchBtn" class="btn-primary" onclick="runGlobalSearch()"><svg class="icon" aria-hidden="true"><use href="#icon-search-outline"></use></svg> Search</button>
    <button class="btn-secondary btn-sm" onclick="reloadAndRefresh()"><svg class="icon" aria-hidden="true"><use href="#icon-refresh-outline"></use></svg> Refresh</button>
  </div>
  <div id="globalSearchResults"></div>
  <div id="globalSearchLoadMoreWrap" style="display:none;text-align:center;margin-top:16px;margin-bottom:16px">
    <button class="btn-export" onclick="loadMoreGlobalSearch()"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Load More</button>
  </div>
  <div class="stats-grid">
    <div class="stat-card green"><div class="stat-value" id="statApproved">&#8212;</div><div class="stat-label">Approved / Released</div></div>
    <div class="stat-card orange"><div class="stat-value" id="statTesting">&#8212;</div><div class="stat-label">Testing In Progress</div></div>
    <div class="stat-card"><div class="stat-value" id="statPending">&#8212;</div><div class="stat-label">Pending Analysis</div></div>
    <div class="stat-card red"><div class="stat-value" id="statAtRisk">&#8212;</div><div class="stat-label"><svg class="icon" aria-hidden="true"><use href="#icon-warning-outline"></use></svg> TAT At Risk</div></div>
  </div>
  <div class="risk-widget">
    <h2><svg class="icon" aria-hidden="true"><use href="#icon-warning-outline"></use></svg> Samples At Risk (TAT Approaching / Exceeded)</h2>
    <div id="riskTable"><div class="empty-state">Loading&#8230;</div></div>
    <div id="riskLoadMoreWrap" style="display:none;text-align:center;margin-top:16px">
      <button class="btn-export" onclick="loadMoreRisk()"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Load More</button>
    </div>
  </div>
  <div class="recent-widget">
    <h3><svg class="icon" aria-hidden="true"><use href="#icon-list-outline"></use></svg> Recent Samples (Last 5)</h3>
    <div id="recentList"><div class="empty-state">Loading&#8230;</div></div>
  </div>
  <div class="card">
    <h2>All Samples Overview (Last 10)</h2>
    <div id="dashOverviewTable"><div class="empty-state">Loading&#8230;</div></div>
  </div>
</section>

<!-- ──────────────── IN-HOUSE TESTING ──────────────── -->
<section id="page-inhouse-testing" class="page">
  <div class="page-header"><h1>In-House Testing</h1><p>Tests Vertex Analytical Labs is certified to perform in-house</p></div>
  <div id="alertInhouse" class="alert"></div>
  <div class="search-bar ih-search-bar">
    <div class="ih-filter-row">
      <input type="text" id="inhouseSearch" placeholder="Search by test name or method&#8230;" oninput="renderInhouseTests()">
      <select id="inhouseAccrFilter" onchange="renderInhouseTests()">
        <option value="">&#8212; Select Accreditation &#8212;</option>
        <option value="true">Accredited</option>
        <option value="false">Not Accredited</option>
      </select>
      <select id="inhouseStatusFilter" onchange="renderInhouseTests()">
        <option value="">&#8212; Select Status &#8212;</option>
        <option value="Active">Active</option>
        <option value="Pending">Pending</option>
        <option value="Inactive">Inactive</option>
      </select>
    </div>
    <div class="ih-action-row">
      <button class="ih-edit-mode-btn" id="ihEditModeBtn" onclick="toggleInhouseEditMode()" style="display:none"><svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode</button>
      <button class="btn-secondary btn-sm" onclick="reloadAndInhouse()"><svg class="icon" aria-hidden="true"><use href="#icon-refresh-outline"></use></svg> Refresh from SP</button>
      <button class="btn-secondary btn-sm" onclick="ihClearFilters()">Clear Filters</button>
    </div>
  </div>
  <div id="inhouseListContainer"></div>
</section>

<!-- ──────────────── TAT & RUSH ORDERS ──────────────── -->
<section id="page-tat-rush" class="page">
  <div class="page-header"><h1>TAT and Rush Orders</h1><p>Turnaround time by test category and rush order tracking</p></div>
  <div id="alertTatRush" class="alert"></div>
  <div class="card">
    <h2><svg class="icon" aria-hidden="true"><use href="#icon-rush-outline"></use></svg> Rush Orders</h2>
    <div class="rush-filters">
      <div class="rush-row1">
        <input type="text" id="rushSearch" class="rush-search-input" placeholder="Search Sample ID or Customer&#8230;" onchange="renderRushOrders()" oninput="renderRushOrders()">
        <div class="rush-row1-filters">
          <select id="rushFilterType" onchange="renderRushOrders()">
            <option value="">&#8212; All Rush Types &#8212;</option>
            <option value="3-Day Rush">3-Day Rush</option>
            <option value="2-Day Rush">2-Day Rush</option>
            <option value="1-Day Rush">1-Day Rush</option>
          </select>
          <select id="rushFilterCat" onchange="renderRushOrders()">
            <option value="">&#8212; All Test Categories &#8212;</option>
          </select>
        </div>
      </div>
      <div class="rush-row2">
        <button id="rushDeepSearchBtn" class="btn-secondary btn-sm" style="display:none" onclick="runDeepSearch('rush','rushSearch','rushDeepSearchBtn',renderRushOrders)"><svg class="icon" aria-hidden="true"><use href="#icon-search-outline"></use></svg> Search All Records</button>
        <button class="btn-secondary btn-sm" onclick="clearRushFilters()">Clear Filters</button>
      </div>
    </div>
    <div id="rushOrdersContainer"></div>
    <div id="rushLoadMoreWrap" style="display:none;text-align:center;margin-top:16px">
      <button class="btn-export" onclick="loadMoreRush()"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Load More</button>
    </div>
  </div>
  <div class="card">
    <h2><svg class="icon" aria-hidden="true"><use href="#icon-rush-outline"></use></svg> Test Turnaround Time</h2>
    <div style="display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px">
      <button class="ih-edit-mode-btn" id="tatEditModeBtn" onclick="toggleTATEditMode()"><svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode</button>
      <button class="btn-secondary btn-sm" onclick="reloadAndTATCats()"><svg class="icon" aria-hidden="true"><use href="#icon-refresh-outline"></use></svg> Refresh from SP</button>
    </div>
    <div id="tatCatsContainer"></div>
  </div>
</section>

<!-- ──────────────── NEW SAMPLE ──────────────── -->
<section id="page-new-sample" class="page">
  <div class="page-header"><h1>New Sample / Batch Entry</h1><p>Register one or multiple samples from the same customer on the same day</p></div>
  <div id="nsPrefillBanner" style="display:none"></div>

  <div class="ns-stepper" id="nsStepper" aria-label="Entry steps">
    <div class="ns-step ns-active" id="nsStep1" onclick="nsStepClick(1)" style="cursor:default">
      <div class="ns-circle">1</div>
      <div class="ns-label">Batch Info</div>
    </div>
    <div class="ns-step" id="nsStep2" onclick="nsStepClick(2)" style="cursor:default">
      <div class="ns-circle">2</div>
      <div class="ns-label">Inspection</div>
    </div>
    <div class="ns-step" id="nsStep3" onclick="nsStepClick(3)" style="cursor:default">
      <div class="ns-circle">3</div>
      <div class="ns-label">Sample &amp; Tests</div>
    </div>
    <div class="ns-step" id="nsStep4" onclick="nsStepClick(4)" style="cursor:default">
      <div class="ns-circle">4</div>
      <div class="ns-label">Review &amp; Submit</div>
    </div>
  </div>

  <div class="info-box"><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Select Customer &amp; Date once &#8212; IDs auto-generate and increment for each sample added to the batch.</div>
  <div id="alertNewSample" class="alert"></div>

  <div class="batch-banner ns-panel" id="nsBatchBanner" data-step="1">
    <h2><svg class="icon" aria-hidden="true"><use href="#icon-folder-outline"></use></svg> Batch Information (Set Once per Session)</h2>
    <div class="fg" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr))">
      <div class="form-group">
        <label>Customer <span class="req">*</span></label>
        <select id="batchCustomer" onchange="initBatch()"><option value="">&#8212; Select Customer &#8212;</option></select>
      </div>
      <div class="form-group">
        <label>Date Received <span class="req">*</span></label>
        <input type="date" id="batchDate" onchange="initBatch()">
      </div>
      <div class="form-group">
        <label>Batch ID (Auto)</label>
        <input type="text" id="batchIDDisplay" readonly placeholder="Auto-generates">
      </div>
    </div>
    <div class="btn-group" id="nsBatchContinueGroup" style="display:none;margin-top:6px">
      <button class="btn-primary" onclick="nsShowStep(2)"><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Continue to Inspection</button>
    </div>
  </div>

  <div class="card ns-panel ns-hidden" id="nsInspectionCard" data-step="2">
    <h2>Batch Receipt Inspection</h2>
    <p style="font-size:13px;color:#7f8c8d;margin-bottom:14px">Document sample condition upon receipt &#8212; ISO 17025 Record</p>
    <div id="alertInspect" class="alert"></div>
    <div class="fg">
      <div class="form-group">
        <label>Batch ID</label>
        <input type="text" id="in_batchID" readonly placeholder="Auto-fills from Batch Info">
      </div>
      <div class="form-group">
        <label>Inspection Date <span class="req">*</span></label>
        <input type="date" id="in_date">
      </div>
      <div class="form-group">
        <label>Inspected By</label>
        <input type="text" id="in_by" disabled>
      </div>
    </div>
    <h3 style="margin:14px 0 10px">Sample Condition Checklist</h3>
    <div class="checklist-item"><input type="checkbox" id="in_labels" checked><label for="in_labels">Labels legible and complete</label></div>
    <div class="checklist-item"><input type="checkbox" id="in_containers" checked><label for="in_containers">Containers intact and properly sealed</label></div>
    <div class="checklist-item"><input type="checkbox" id="in_contam" checked><label for="in_contam">No visible contamination or leakage</label></div>
    <div class="checklist-item"><input type="checkbox" id="in_temp" checked><label for="in_temp">Temperature acceptable upon receipt</label></div>
    <div class="checklist-item"><input type="checkbox" id="in_qty" checked><label for="in_qty">Quantity matches documentation</label></div>
    <div class="checklist-item"><input type="checkbox" id="in_docs" checked><label for="in_docs">All documentation complete and accurate</label></div>
    <div class="form-group" style="margin-top:16px">
      <label>Temperature Upon Receipt</label>
      <input type="number" id="in_tempUponReceipt" step="0.1" placeholder="e.g. 20.0">
    </div>
    <div class="form-group">
      <label>Inspection Notes / Observations</label>
      <textarea id="in_notes" placeholder="Document any issues, anomalies, or observations&#8230;"></textarea>
    </div>
    <div class="form-group">
      <label>Documents Attached (list file names, semicolon-separated)</label>
      <input type="text" id="in_docs_attached" placeholder="e.g., COA_Batch01.pdf; SOP-QP08.01.pdf">
    </div>
    <div class="btn-group">
      <button class="btn-success" onclick="saveInspection()"><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Complete Inspection &amp; Save</button>
      <button class="btn-secondary" onclick="clearInspection()">Clear</button>
    </div>
  </div>

  <!-- Bulk Import: alert banner (default view on Step 3) -->
  <div class="bi-banner ns-panel ns-hidden" id="biBanner" data-step="3">
    <svg class="icon" aria-hidden="true"><use href="#icon-save-outline"></use></svg>
    <div class="bi-banner-body"><strong>Adding multiple samples?</strong> Import them from a file instead of adding each one individually.</div>
    <button class="bi-banner-btn" onclick="biShowImport()">Import from File</button>
  </div>

  <!-- Bulk Import: import panels (hidden by default, shown when user clicks banner) -->
  <div class="ns-panel ns-hidden bi-hidden" id="biImportPanel" data-step="3">
    <button class="bi-back" onclick="biShowSingleEntry()">&#8592; Back to single-entry form</button>

    <div class="card">
      <h2><svg class="icon" aria-hidden="true"><use href="#icon-save-outline"></use></svg> Step 1: Download Template</h2>
      <p style="font-size:13.5px;color:#7f8c8d;margin-bottom:14px">
        One row per test. Repeat the sample details on every row for that sample. Rows are grouped back into samples automatically when you upload.
      </p>
      <button class="btn-secondary" onclick="biDownloadTemplate()"><svg class="icon" aria-hidden="true"><use href="#icon-save-outline"></use></svg> Download CSV Template</button>
      <div class="bi-info-note">
        <strong>Note:</strong> Blank cells are OK &#8212; you don&#8217;t need to fill in every field. Anything left blank will be flagged for your confirmation when you upload, but won&#8217;t block your import.
      </div>
    </div>

    <div class="card">
      <h2><svg class="icon" aria-hidden="true"><use href="#icon-save-outline"></use></svg> Step 2: Upload File</h2>
      <div id="biUploadStatus" class="alert"></div>
      <div class="bi-upload-area" id="biUploadArea"
           ondragover="event.preventDefault();this.classList.add('drag-over')"
           ondragleave="this.classList.remove('drag-over')"
           ondrop="event.preventDefault();this.classList.remove('drag-over');biHandleDrop(event)"
           onclick="document.getElementById('biFileInput').click()">
        <svg class="icon" aria-hidden="true"><use href="#icon-save-outline"></use></svg>
        <div class="bi-upload-text">Drag and drop your completed file here, or</div>
        <div class="bi-upload-link">Click to Browse</div>
        <div class="bi-upload-formats">Supported format: .csv</div>
      </div>
      <input type="file" id="biFileInput" accept=".csv" style="display:none" onchange="biHandleFile(this.files[0])">
    </div>
  </div>

  <!-- Bulk Import: review preview (hidden, shown after upload) -->
  <div class="ns-panel ns-hidden bi-hidden" id="biPreviewPanel" data-step="3">
    <button class="bi-back" onclick="biShowSingleEntry()">&#8592; Back to single-entry form</button>

    <div class="card">
      <h2><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Review Import</h2>

      <div class="bi-stats">
        <div class="bi-stat ok"><div class="bi-stat-num" id="biStatSamples">0</div><div class="bi-stat-lbl">Samples</div></div>
        <div class="bi-stat info"><div class="bi-stat-num" id="biStatTests">0</div><div class="bi-stat-lbl">Tests</div></div>
        <div class="bi-stat warn"><div class="bi-stat-num" id="biStatWarnings">0</div><div class="bi-stat-lbl">Need Review</div></div>
        <div class="bi-stat err"><div class="bi-stat-num" id="biStatErrors">0</div><div class="bi-stat-lbl">Errors</div></div>
      </div>

      <p style="font-size:13px;color:#7f8c8d;margin-bottom:14px">
        Rows have been grouped into samples. Items in amber need your confirmation but won&#8217;t block import; items in red must be fixed in the file and re-uploaded.
      </p>

      <div id="biGroupedPreview"></div>

      <div class="bi-chk-row" onclick="this.querySelector('input').checked=!this.querySelector('input').checked;biUpdateImportBtn()">
        <input type="checkbox" id="biChkAccuracy">
        <label for="biChkAccuracy">I confirm the sample and test data above is correct.</label>
      </div>
      <div class="bi-chk-row" id="biChkWarnRow" style="display:none" onclick="this.querySelector('input').checked=!this.querySelector('input').checked;biUpdateImportBtn()">
        <input type="checkbox" id="biChkWarnings">
        <label for="biChkWarnings">I&#8217;ve reviewed the items flagged above and want to proceed anyway.</label>
      </div>

      <div class="btn-group">
        <button class="btn-secondary" onclick="biStartOver()">Start Over</button>
        <button class="btn-success" id="biImportBtn" disabled onclick="biPerformImport()" style="margin-left:auto"><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Import 0 Samples</button>
      </div>
    </div>
  </div>

  <div class="ns-panel ns-hidden" id="nsSampleCounter" data-step="3" style="display:flex;align-items:center;gap:14px;margin-bottom:20px"></div>

  <div class="card ns-panel ns-hidden" id="nsSampleInfoCard" data-step="3">
    <h2>Sample Information</h2>
    <div class="fg">
      <div class="form-group"><label>Sample ID (Auto)</label><input type="text" id="ns_sampleID" readonly placeholder="Auto-generates"></div>
      <div class="form-group"><label>Report ID (Auto)</label><input type="text" id="ns_reportID" readonly placeholder="Auto-generates"></div>
      <div class="form-group"><label>Sample Name <span class="req">*</span></label><input type="text" id="ns_sampleName" placeholder="e.g., Vitamin D3 1000 IU"></div>
      <div class="form-group"><label>Lot Number</label><input type="text" id="ns_lotNumber" placeholder="LOT-XXXX"></div>
    </div>
    <div class="fg">
      <div class="form-group">
        <label>Matrix <span class="req">*</span></label>
        <select id="ns_matrix">
          <option value="">&#8212; Select &#8212;</option>
          <option>Tablet</option><option>Capsule</option><option>Liquid</option>
          <option>Powder</option><option>Gummy</option><option>Beverage</option><option>Other</option>
        </select>
      </div>
      <div class="form-group">
        <label>Type</label>
        <select id="ns_type">
          <option>Finished Product</option><option>Raw Material</option><option>In-Process</option>
        </select>
      </div>
      <div class="form-group"><label>Quantity (Units) <span class="req">*</span></label><input type="number" id="ns_units" value="1" min="1"></div>
      <div class="form-group"><label>Received By</label><input type="text" id="ns_receivedBy" disabled></div>
    </div>
    <div class="fg">
      <div class="form-group">
        <label>Serving Size</label>
        <input type="text" id="ns_servingSize" placeholder="e.g., 355 mL / 2.4882 g / 60 mL / 2 Oz / 1 g">
      </div>
      <div class="form-group">
        <label>External Reference Number</label>
        <input type="text" id="ns_extRef">
      </div>
      <div class="form-group" style="grid-column:span 2">
        <label>Remarks / Special Instructions</label>
        <textarea id="ns_remarks" placeholder="Any handling notes&#8230;"></textarea>
      </div>
    </div>
  </div>

  <div class="card ns-panel ns-hidden" id="nsTATCard" data-step="3">
    <h2>Turnaround Time</h2>
    <label class="rush-chk-label" style="margin-bottom:16px">
      <input type="checkbox" id="ns_rushChk" class="status-chk" onchange="toggleRushOrder()"> Rush Order
    </label>
    <div class="ns-tat-fields">
      <div class="form-group">
        <label>Turnaround Time (TAT)</label>
        <input type="text" id="ns_tat" readonly placeholder="Add tests to calculate TAT">
      </div>
      <div class="form-group" id="ns_rushTypeGroup" style="display:none">
        <label>Rush Type <span class="req">*</span></label>
        <select id="ns_rushType">
          <option value="">&#8212; Select Rush Type &#8212;</option>
          <option value="3-Day Rush">3-Day Rush</option>
          <option value="2-Day Rush">2-Day Rush</option>
          <option value="1-Day Rush">1-Day Rush</option>
        </select>
      </div>
    </div>
  </div>

  <div class="card ns-panel ns-hidden" id="nsTestsCard" data-step="3">
    <h2>Required Tests</h2>
    <p style="font-size:13px;color:#7f8c8d;margin-bottom:4px">Select a category to expand it, then add individual tests. Multiple tests per category are supported.</p>
    <div class="test-grid" id="testCategoryGrid">
      <!-- Test category cards rendered dynamically by renderTestCategoryCards() -->
    </div>


    <div class="test-panel" id="panel-assay">
      <h4>Assay Testing</h4>
      <div class="test-row-wrap">
        <div class="test-fields-flex">
          <div class="form-group name-field"><label>Analyte <span class="req">*</span></label>
            <div class="st-combobox-wrap">
              <input type="text" id="assay_analyte" placeholder="Search or select analyte" autocomplete="off">
              <div class="st-dropdown" id="assay_analyte_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field"><label>Comparator</label>
            <div class="st-combobox-wrap">
              <input type="text" id="assay_mod" placeholder="e.g., NLT, NMT, Range" oninput="toggleUpperField('assay')" onblur="autoSplitSpecFields('assay')" autocomplete="off">
              <div class="st-dropdown" id="assay_mod_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field" id="assay_lowerGroup"><label>Lower / Value</label><input type="text" id="assay_lower" placeholder="e.g., 1000" onblur="autoSplitSpecFields('assay')"></div>
          <div class="form-group spec-field" id="assay_upperGroup" style="display:none"><label>Upper</label><input type="text" id="assay_upper" placeholder="e.g., 1200" onblur="autoSplitSpecFields('assay')"></div>
          <div class="form-group spec-field"><label>Units</label><input type="text" id="assay_units" placeholder="e.g., IU, mg, %" onblur="autoSplitSpecFields('assay')"></div>
        </div>
        <button class="ih-del-btn test-panel-clear-btn" onclick="clearTestPanel('assay')" title="Clear fields"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>
      </div>
      <div class="spec-mod-error" id="assay_modError"></div>
      <button class="btn-add-test" onclick="addTest('assay')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>
      <div class="test-item-list" id="list-assay"></div>
    </div>

    <div class="test-panel" id="panel-general">
      <h4>General Tests</h4>
      <div class="test-row-wrap">
        <div class="test-fields-flex">
          <div class="form-group name-field"><label>Test <span class="req">*</span></label>
            <div class="st-combobox-wrap">
              <input type="text" id="general_test" placeholder="Search or select test" autocomplete="off">
              <div class="st-dropdown" id="general_test_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field"><label>Comparator</label>
            <div class="st-combobox-wrap">
              <input type="text" id="general_mod" placeholder="e.g., NMT, NLT, Range" oninput="toggleUpperField('general')" onblur="autoSplitSpecFields('general')" autocomplete="off">
              <div class="st-dropdown" id="general_mod_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field" id="general_lowerGroup"><label>Lower / Value</label><input type="text" id="general_lower" placeholder="e.g., 5.0" onblur="autoSplitSpecFields('general')"></div>
          <div class="form-group spec-field" id="general_upperGroup" style="display:none"><label>Upper</label><input type="text" id="general_upper" placeholder="e.g., 6.0" onblur="autoSplitSpecFields('general')"></div>
          <div class="form-group spec-field"><label>Units</label><input type="text" id="general_units" placeholder="e.g., %" onblur="autoSplitSpecFields('general')"></div>
        </div>
        <button class="ih-del-btn test-panel-clear-btn" onclick="clearTestPanel('general')" title="Clear fields"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>
      </div>
      <div class="spec-mod-error" id="general_modError"></div>
      <button class="btn-add-test" onclick="addTest('general')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>
      <div class="test-item-list" id="list-general"></div>
    </div>

    <div class="test-panel" id="panel-metals">
      <h4>Heavy Metals</h4>
      <div class="test-row-wrap">
        <div class="test-fields-flex">
          <div class="form-group name-field"><label>Metal <span class="req">*</span></label>
            <div class="st-combobox-wrap">
              <input type="text" id="metals_test" placeholder="Search or select metal" autocomplete="off">
              <div class="st-dropdown" id="metals_test_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field"><label>Comparator</label>
            <div class="st-combobox-wrap">
              <input type="text" id="metals_mod" placeholder="e.g., NMT, NLT, Range" oninput="toggleUpperField('metals')" onblur="autoSplitSpecFields('metals')" autocomplete="off">
              <div class="st-dropdown" id="metals_mod_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field" id="metals_lowerGroup"><label>Lower / Value</label><input type="text" id="metals_lower" placeholder="e.g., 2.0" onblur="autoSplitSpecFields('metals')"></div>
          <div class="form-group spec-field" id="metals_upperGroup" style="display:none"><label>Upper</label><input type="text" id="metals_upper" placeholder="e.g., 3.0" onblur="autoSplitSpecFields('metals')"></div>
          <div class="form-group spec-field"><label>Units</label><input type="text" id="metals_units" placeholder="e.g., ppm" onblur="autoSplitSpecFields('metals')"></div>
        </div>
        <button class="ih-del-btn test-panel-clear-btn" onclick="clearTestPanel('metals')" title="Clear fields"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>
      </div>
      <div class="spec-mod-error" id="metals_modError"></div>
      <button class="btn-add-test" onclick="addTest('metals')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>
      <div class="test-item-list" id="list-metals"></div>
    </div>

    <div class="test-panel" id="panel-id">
      <h4>Identity Testing</h4>
      <div class="test-row-wrap">
        <div class="test-fields-flex">
          <div class="form-group name-field"><label>Ingredient <span class="req">*</span></label>
            <div class="st-combobox-wrap">
              <input type="text" id="id_ingredient" placeholder="e.g., Beta-Alanine" autocomplete="off">
              <div class="st-dropdown" id="id_ingredient_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field"><label>Comparator</label>
            <div class="st-combobox-wrap">
              <input type="text" id="id_mod" placeholder="e.g., Conforms to Reference Standard" onblur="normalizeModifierField('id_mod')" autocomplete="off">
              <div class="st-dropdown" id="id_mod_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field"><label>Method</label><input type="text" id="id_method" placeholder="e.g., TLC, FTIR"></div>
        </div>
        <button class="ih-del-btn test-panel-clear-btn" onclick="clearTestPanel('id')" title="Clear fields"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>
      </div>
      <div class="spec-mod-error" id="id_modError"></div>
      <button class="btn-add-test" onclick="addTest('id')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>
      <div class="test-item-list" id="list-id"></div>
    </div>

    <div class="test-panel" id="panel-micro">
      <h4>Microbiology Testing</h4>
      <div class="test-row-wrap">
        <div class="test-fields-flex">
          <div class="form-group name-field"><label>Microorganism <span class="req">*</span></label>
            <div class="st-combobox-wrap">
              <input type="text" id="micro_test" placeholder="Search or select microorganism" autocomplete="off">
              <div class="st-dropdown" id="micro_test_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field"><label>Comparator</label>
            <div class="st-combobox-wrap">
              <input type="text" id="micro_mod" placeholder="e.g., NMT, Negative" oninput="toggleUpperField('micro')" onblur="autoSplitSpecFields('micro')" autocomplete="off">
              <div class="st-dropdown" id="micro_mod_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field" id="micro_lowerGroup"><label>Lower / Value</label><input type="text" id="micro_lower" placeholder="e.g., 1000" onblur="autoSplitSpecFields('micro')"></div>
          <div class="form-group spec-field" id="micro_upperGroup" style="display:none"><label>Upper</label><input type="text" id="micro_upper" placeholder="e.g., 2000" onblur="autoSplitSpecFields('micro')"></div>
          <div class="form-group spec-field"><label>Units</label><input type="text" id="micro_units" placeholder="e.g., CFU/g" onblur="autoSplitSpecFields('micro')"></div>
        </div>
        <button class="ih-del-btn test-panel-clear-btn" onclick="clearTestPanel('micro')" title="Clear fields"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>
      </div>
      <div class="spec-mod-error" id="micro_modError"></div>
      <button class="btn-add-test" onclick="addTest('micro')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>
      <div class="test-item-list" id="list-micro"></div>
    </div>

    <div class="test-panel" id="panel-Mnr">
      <h4>Minerals Testing</h4>
      <div class="test-row-wrap">
        <div class="test-fields-flex">
          <div class="form-group name-field"><label>Mineral / Analyte <span class="req">*</span></label>
            <div class="st-combobox-wrap">
              <input type="text" id="Mnr_name" placeholder="e.g., Zinc, Magnesium, Iron" autocomplete="off">
              <div class="st-dropdown" id="Mnr_name_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field"><label>Comparator</label>
            <div class="st-combobox-wrap">
              <input type="text" id="Mnr_mod" placeholder="e.g., NLT, NMT" oninput="toggleUpperField('Mnr')" onblur="autoSplitSpecFields('Mnr')" autocomplete="off">
              <div class="st-dropdown" id="Mnr_mod_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field" id="Mnr_lowerGroup"><label>Lower / Value</label><input type="text" id="Mnr_lower" placeholder="e.g., 15" onblur="autoSplitSpecFields('Mnr')"></div>
          <div class="form-group spec-field" id="Mnr_upperGroup" style="display:none"><label>Upper</label><input type="text" id="Mnr_upper" placeholder="e.g., 20" onblur="autoSplitSpecFields('Mnr')"></div>
          <div class="form-group spec-field"><label>Units</label><input type="text" id="Mnr_units" placeholder="e.g., mg" onblur="autoSplitSpecFields('Mnr')"></div>
        </div>
        <button class="ih-del-btn test-panel-clear-btn" onclick="clearTestPanel('Mnr')" title="Clear fields"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>
      </div>
      <div class="spec-mod-error" id="Mnr_modError"></div>
      <button class="btn-add-test" onclick="addTest('Mnr')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>
      <div class="test-item-list" id="list-Mnr"></div>
    </div>

    <div class="test-panel" id="panel-pest">
      <h4>Pesticides</h4>
      <div class="test-row-wrap">
        <div class="test-fields-flex">
          <div class="form-group name-field"><label>Pesticide / Scope <span class="req">*</span></label>
            <div class="st-combobox-wrap">
              <input type="text" id="pest_name" placeholder="e.g., Multi-residue screen" autocomplete="off">
              <div class="st-dropdown" id="pest_name_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field"><label>Comparator</label>
            <div class="st-combobox-wrap">
              <input type="text" id="pest_mod" placeholder="e.g., Negative, NMT" oninput="toggleUpperField('pest')" onblur="autoSplitSpecFields('pest')" autocomplete="off">
              <div class="st-dropdown" id="pest_mod_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field" id="pest_lowerGroup"><label>Lower / Value</label><input type="text" id="pest_lower" placeholder="e.g., 0.01" onblur="autoSplitSpecFields('pest')"></div>
          <div class="form-group spec-field" id="pest_upperGroup" style="display:none"><label>Upper</label><input type="text" id="pest_upper" placeholder="e.g., 0.05" onblur="autoSplitSpecFields('pest')"></div>
          <div class="form-group spec-field"><label>Units</label><input type="text" id="pest_units" placeholder="e.g., ppm" onblur="autoSplitSpecFields('pest')"></div>
        </div>
        <button class="ih-del-btn test-panel-clear-btn" onclick="clearTestPanel('pest')" title="Clear fields"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>
      </div>
      <div class="spec-mod-error" id="pest_modError"></div>
      <button class="btn-add-test" onclick="addTest('pest')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>
      <div class="test-item-list" id="list-pest"></div>
    </div>

    <div class="test-panel" id="panel-solv">
      <h4>Residual Solvents</h4>
      <div class="test-row-wrap">
        <div class="test-fields-flex">
          <div class="form-group name-field"><label>Solvent <span class="req">*</span></label>
            <div class="st-combobox-wrap">
              <input type="text" id="solv_name" placeholder="e.g., Ethanol, Acetone" autocomplete="off">
              <div class="st-dropdown" id="solv_name_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field"><label>Comparator</label>
            <div class="st-combobox-wrap">
              <input type="text" id="solv_mod" placeholder="e.g., NMT" oninput="toggleUpperField('solv')" onblur="autoSplitSpecFields('solv')" autocomplete="off">
              <div class="st-dropdown" id="solv_mod_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field" id="solv_lowerGroup"><label>Lower / Value</label><input type="text" id="solv_lower" placeholder="e.g., 5000" onblur="autoSplitSpecFields('solv')"></div>
          <div class="form-group spec-field" id="solv_upperGroup" style="display:none"><label>Upper</label><input type="text" id="solv_upper" placeholder="e.g., 6000" onblur="autoSplitSpecFields('solv')"></div>
          <div class="form-group spec-field"><label>Units</label><input type="text" id="solv_units" placeholder="e.g., ppm" onblur="autoSplitSpecFields('solv')"></div>
        </div>
        <button class="ih-del-btn test-panel-clear-btn" onclick="clearTestPanel('solv')" title="Clear fields"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>
      </div>
      <div class="spec-mod-error" id="solv_modError"></div>
      <button class="btn-add-test" onclick="addTest('solv')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>
      <div class="test-item-list" id="list-solv"></div>
    </div>

    <div class="test-panel" id="panel-spec">
      <h4>Specialty Testing</h4>
      <div class="test-row-wrap">
        <div class="test-fields-flex">
          <div class="form-group name-field"><label>Test Name <span class="req">*</span></label>
            <div class="st-combobox-wrap">
              <input type="text" id="spec_name" placeholder="e.g., Allergen Screen" autocomplete="off">
              <div class="st-dropdown" id="spec_name_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field"><label>Comparator</label>
            <div class="st-combobox-wrap">
              <input type="text" id="spec_mod" placeholder="e.g., Negative, Report" oninput="toggleUpperField('spec')" onblur="autoSplitSpecFields('spec')" autocomplete="off">
              <div class="st-dropdown" id="spec_mod_dd"></div>
            </div>
          </div>
          <div class="form-group spec-field" id="spec_lowerGroup"><label>Lower / Value</label><input type="text" id="spec_lower" placeholder="e.g., 100" onblur="autoSplitSpecFields('spec')"></div>
          <div class="form-group spec-field" id="spec_upperGroup" style="display:none"><label>Upper</label><input type="text" id="spec_upper" placeholder="e.g., 120" onblur="autoSplitSpecFields('spec')"></div>
          <div class="form-group spec-field"><label>Units</label><input type="text" id="spec_units" placeholder="e.g., %" onblur="autoSplitSpecFields('spec')"></div>
        </div>
        <button class="ih-del-btn test-panel-clear-btn" onclick="clearTestPanel('spec')" title="Clear fields"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>
      </div>
      <div class="spec-mod-error" id="spec_modError"></div>
      <button class="btn-add-test" onclick="addTest('spec')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>
      <div class="test-item-list" id="list-spec"></div>
    </div>

    <div class="test-panel" id="panel-stability">
      <h4>Stability</h4>
      <div class="test-row-wrap">
        <div class="test-fields-flex">
          <div class="form-group name-field"><label>Test <span class="req">*</span></label>
            <div class="st-combobox-wrap">
              <input type="text" id="stability_name" placeholder="e.g., Stress Testing, Accelerated, Real Time" autocomplete="off">
              <div class="st-dropdown" id="stability_name_dd"></div>
            </div>
          </div>
        </div>
        <button class="ih-del-btn test-panel-clear-btn" onclick="clearTestPanel('stability')" title="Clear fields"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>
      </div>
      <button class="btn-add-test" onclick="addTest('stability')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>
      <div class="test-item-list" id="list-stability"></div>
    </div>
  </div><!-- /card Required Tests -->

  <div class="btn-group ns-panel ns-hidden" id="nsAddSampleGroup" data-step="3">
    <button class="btn-success" onclick="addSampleToBatch()"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Sample to Batch</button>
    <button class="btn-secondary" onclick="clearSampleForm()">Clear Form</button>
  </div>

  <div class="card ns-panel ns-hidden" id="nsBatchSummaryCard" data-step="4" style="margin-top:24px">
    <h2>Samples in Current Batch</h2>
    <div id="batchSummary"><div class="empty-state">Add samples above to see them listed here.</div></div>
    <div class="btn-group" id="finalizeGroup" style="display:none">
      <button class="btn-primary" onclick="finalizeBatch()"><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Finalize &amp; Save Batch to SharePoint</button>
      <button class="btn-secondary" onclick="nsShowStep(3)"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Another Sample</button>
    </div>
  </div>

  <div class="card ns-panel ns-hidden" id="nsPrevInspectCard" data-step="4">
    <h2>Previous Inspections <button class="btn-secondary btn-sm" style="margin-left:10px;margin-top:0" onclick="loadInspections(renderInspectionHistory)"><svg class="icon" aria-hidden="true"><use href="#icon-refresh-outline"></use></svg> Refresh</button></h2>
    <div id="inspectionHistory"><div class="empty-state">Loading&#8230;</div></div>
  </div>
</section>

<!-- ──────────────── MASTER LIST ──────────────── -->
<section id="page-master-list" class="page">
  <div class="page-header"><h1>Master List of Samples</h1><p>View, search, filter, and export all received samples</p></div>
  <div class="filter-panel">
    <h3><svg class="icon" aria-hidden="true"><use href="#icon-search-outline"></use></svg> Search &amp; Filter</h3>
    <div class="filter-grid">
      <div>
        <label>Search</label>
        <input type="text" id="masterSearch" placeholder="Sample ID, Customer, Lot Number, Status&#8230;" onkeydown="if(event.key==='Enter')runMasterSearch()">
      </div>
      <div>
        <label>Date</label>
        <input type="date" id="fDate" oninput="this.classList.toggle('has-value',!!this.value)" onclick="this.showPicker()">
      </div>
      <div>
        <label>Client</label>
        <select id="fClient"><option value="">All Clients</option></select>
      </div>
      <div>
        <label>Status</label>
        <select id="fStatus">
          <option value="">All Statuses</option>
          <option>Pending</option><option>In Progress</option>
          <option>Testing Complete</option><option>Approved/Released</option>
          <option>Cancelled</option>
        </select>
      </div>
      <div style="flex:0 0 auto">
        <label aria-hidden="true">&nbsp;</label>
        <button class="btn-secondary" onclick="clearFilters()">Clear Filters</button>
      </div>
    </div>
    <div class="filter-actions">
      <button id="masterSearchBtn" class="btn-primary" onclick="runMasterSearch()"><svg class="icon" aria-hidden="true"><use href="#icon-search-outline"></use></svg> Search</button>
      <button class="btn-export" onclick="exportCSV()"><svg class="icon" aria-hidden="true"><use href="#icon-csv-outline"></use></svg> Export to CSV</button>
      <button class="btn-secondary" onclick="reloadAndMasterList()"><svg class="icon" aria-hidden="true"><use href="#icon-refresh-outline"></use></svg> Refresh from SP</button>
    </div>
  </div>
  <div class="card">
    <h2>Sample Records</h2>
    <div id="masterListContainer"><div class="empty-state">Loading from SharePoint&#8230;</div></div>
    <div id="masterLoadMoreWrap" style="display:none;text-align:center;margin-top:16px">
      <button class="btn-export" onclick="loadMoreMasterList()"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Load More</button>
    </div>
  </div>
</section>

<!-- ──────────────── UPDATE STATUS ──────────────── -->
<section id="page-update-status" class="page">
  <div class="page-header"><h1>Update Sample Status</h1><p>Progress samples: Pending &#8594; In Progress &#8594; Testing Complete &#8594; Approved/Released</p></div>
  <div id="alertStatus" class="alert"></div>
  <div class="info-box"><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Select one or more samples using the checkboxes &#8212; the Edit Status section will appear once a selection is made.</div>
  <div class="search-bar">
    <input type="text" id="statusSearch" placeholder="Find by Sample ID, Customer or Name&#8230;" oninput="renderStatusList()">
    <button id="statusDeepSearchBtn" class="btn-secondary btn-sm" style="display:none" onclick="runDeepSearch('status','statusSearch','statusDeepSearchBtn',renderStatusList)"><svg class="icon" aria-hidden="true"><use href="#icon-search-outline"></use></svg> Search All Records</button>
    <button class="btn-secondary btn-sm" onclick="reloadAndStatusList()"><svg class="icon" aria-hidden="true"><use href="#icon-refresh-outline"></use></svg> Refresh from SP</button>
  </div>
  <div id="statusListContainer"></div>
  <div id="statusLoadMoreWrap" style="display:none;text-align:center;margin-top:16px;margin-bottom:16px">
    <button class="btn-export" onclick="loadMoreStatusList()"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Load More</button>
  </div>
  <div class="card" id="statusEditCard" style="display:none">
    <h2>Edit Status</h2>
    <div class="form-group">
      <label>Previous Status</label>
      <div id="statusPrevList" class="status-prev-list"></div>
    </div>
    <div class="fg">
      <div class="form-group">
        <label>New Status <span class="req">*</span></label>
        <select id="newStatusSel">
          <option value="">&#8212; Select &#8212;</option>
          <option value="Pending">Pending</option>
          <option value="In Progress">In Progress</option>
          <option value="Testing Complete">Testing Complete</option>
          <option value="Approved/Released">Approved/Released</option>
          <option value="Cancelled">Cancelled</option>
        </select>
      </div>
    </div>
    <div class="form-group">
      <label>Notes / Comments</label>
      <textarea id="statusNotes" placeholder="Document reason for status change&#8230;"></textarea>
    </div>
    <div class="btn-group">
      <button class="btn-success" onclick="saveStatus()"><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Update Status in SharePoint</button>
      <button class="btn-secondary" onclick="cancelStatusEdit()">Cancel</button>
    </div>
  </div>
</section>

<!-- ──────────────── LAB ORDER ──────────────── -->
<section id="page-lab-order" class="page">
  <div class="page-header">
    <h1>Lab Orders &#8212; Vertex</h1>
    <p>Select a batch to generate the full Lab Order document</p>
  </div>

  <div class="search-bar">
    <input type="text" id="loSearch" placeholder="Search by Batch ID or Customer&#8230;" oninput="renderLabOrderList()">
    <button id="loDeepSearchBtn" class="btn-secondary btn-sm" style="display:none" onclick="runDeepSearch('lab','loSearch','loDeepSearchBtn',renderLabOrderList)"><svg class="icon" aria-hidden="true"><use href="#icon-search-outline"></use></svg> Search All Records</button>
    <button class="btn-secondary btn-sm" onclick="document.getElementById('loSearch').value='';renderLabOrderList()">
      Clear
    </button>
  </div>

  <div id="loSampleList"></div>
  <div id="loLoadMoreWrap" style="display:none;text-align:center;margin-top:16px">
    <button class="btn-export" onclick="loadMoreLabOrderBatches()"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Load More</button>
  </div>

  <div id="loPrintArea" style="display:none">
    <div class="btn-group" style="margin-bottom:16px">
      <button class="btn-primary" onclick="window.print()">
        <svg class="icon" aria-hidden="true"><use href="#icon-print-outline"></use></svg> Print / Save PDF
      </button>
      <button class="btn-secondary" onclick="document.getElementById('loPrintArea').style.display='none'">
        Close
      </button>
    </div>
    <div id="loContent"></div>
  </div>
</section>

<!-- ──────────────── SUBCONTRACTED TESTS ──────────────── -->
<section id="page-subcontract" class="page" style="display:none">
  <div class="page-header">
    <h1>Subcontracted Tests</h1>
    <p>Log and track samples sent to external approved laboratories</p>
  </div>
  <div id="alertSubcontract" class="alert"></div>

  <!-- ── Log New Entry ── -->
  <div class="card">
    <h2>Log Subcontracted Test</h2>
    <div class="fg">
      <div class="form-group">
        <label>Sample ID <span class="req">*</span></label>
        <select id="sub_sampleID">
          <option value="">&#8212; Select Sample &#8212;</option>
        </select>
      </div>
      <div class="form-group">
        <label>Shipped To <span class="req">*</span></label>
        <select id="sub_lab">
          <option value="">&#8212; Select Approved Lab &#8212;</option>
        </select>
      </div>
      <div class="form-group">
        <label>Date Shipped <span class="req">*</span></label>
        <input type="date" id="sub_dateShipped">
      </div>
      <div class="form-group">
        <label>Results Received On</label>
        <input type="date" id="sub_dateReceived">
      </div>
      <div class="form-group">
        <label>CoA ID</label>
        <input type="text" id="sub_coaID" placeholder="Enter CoA reference once received">
      </div>
    </div>
    <div class="form-group" style="margin-top:10px">
      <label>Tests Requested <span class="req">*</span></label>
      <textarea id="sub_testsRequested" rows="3" placeholder="Describe tests requested (e.g., Heavy metals panel: As, Cd, Hg, Pb; Pesticide residues per USP &lt;561&gt;)&#8230;" style="width:100%;padding:9px;border:1px solid #ddd;border-radius:6px;font-size:13px;resize:vertical"></textarea>
    </div>
    <div class="form-group" style="margin-top:10px">
      <label>Flags / Notes</label>
      <textarea id="sub_flags" rows="2" placeholder="Any flags, discrepancies, hold issues, or relevant notes&#8230;" style="width:100%;padding:9px;border:1px solid #ddd;border-radius:6px;font-size:13px;resize:vertical"></textarea>
    </div>
    <div class="btn-group" style="margin-top:14px">
      <button class="btn-success" onclick="saveSubcontractEntry()"><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Save to SharePoint</button>
      <button class="btn-secondary" onclick="clearSubcontractForm()">Clear</button>
    </div>
  </div>

  <!-- ── History ── -->
  <div class="card" style="margin-top:20px">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
      <h2 style="margin:0">Subcontracted Tests Log</h2>
      <button class="btn-secondary btn-sm" onclick="loadSubcontractEntries(renderSubcontractLog)"><svg class="icon" aria-hidden="true"><use href="#icon-refresh-outline"></use></svg> Refresh from SP</button>
    </div>
    <div class="search-bar" style="margin-bottom:14px">
      <input type="text" id="sub_search" placeholder="Search by Sample ID, Lab, CoA ID&#8230;" oninput="renderSubcontractLog()">
    </div>
    <div id="subcontractLogContainer">
      <div class="empty-state">Loading&#8230;</div>
    </div>
  </div>
</section>

<!-- ──────────────── RECEIVED REQUESTS ──────────────── -->
<section id="page-received-requests" class="page">
  <div class="page-header">
    <h1>Received Requests</h1>
    <p>Review and process customer sample submission requests from the SSF portal</p>
  </div>
  <div id="alertReceivedRequests" class="alert"></div>

  <div class="search-bar">
    <input type="text" id="rrSearch" placeholder="Search by customer, confirmation #, sample name&#8230;" oninput="renderRequestGroups()">
    <select id="rrStatusFilter" onchange="renderRequestGroups()">
      <option value="">All Statuses</option>
      <option value="Pending" selected>Pending</option>
      <option value="In Review">In Review</option>
      <option value="Accepted">Accepted</option>
      <option value="Rejected">Rejected</option>
      <option value="Partial">Partial</option>
    </select>
    <button class="btn-secondary" onclick="loadReceivedRequests(renderRequestGroups)"><svg class="icon" aria-hidden="true"><use href="#icon-refresh-outline"></use></svg> Refresh</button>
    <button class="btn-secondary" id="rrLoadAllBtn" onclick="rrLoadAllRequests()"><svg class="icon" aria-hidden="true"><use href="#icon-folder-outline"></use></svg> Load All</button>
  </div>

  <div id="rrListContainer"><div class="empty-state">Loading&#8230;</div></div>
</section>

</div><!-- /.main-inner -->
</main>
</div><!-- /.app -->

<!-- ═══ RECEIVED REQUESTS MODAL ═══ -->
<div class="modal-overlay" id="rrModal">
  <div class="modal-box-outer" style="max-width:820px">
    <button class="modal-close-circle" onclick="rrCloseModal()" title="Close">&#215;</button>
    <div class="modal-box" id="rrModalBox">
      <div class="modal-head">
        <div>
          <h2 id="rrModalTitle"></h2>
          <div id="rrModalMeta" style="font-size:12px;color:#64748b;margin-top:3px"></div>
        </div>
      </div>
      <div id="rrModalContent" class="rr-modal-content"></div>
      <div class="rr-modal-footer" id="rrModalFooter"></div>
    </div>
  </div>
</div>

<!-- ═══ SAMPLE DETAIL MODAL ═══ -->
<div class="modal-overlay" id="sampleModal">
  <div class="modal-box-outer">
    <button class="modal-close-circle" onclick="requestCloseModal()" title="Close">&#215;</button>
    <div class="modal-box" id="modalBox">
    <div class="modal-head">
      <h2>Sample Details</h2>
      <button class="ih-edit-mode-btn" id="modalEditBtn" onclick="modalEditModeToggleClick()"><svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode</button>
    </div>
    <div id="alertModal" class="alert"></div>

    <div id="m_readView">
      <div class="fg" id="m_readFields"></div>
      <div class="modal-section">
        <h3>Batch Info</h3>
        <div id="m_batchInfoRead"></div>
      </div>
      <div class="modal-section" id="m_testsSectionRead">
        <h3>Tests Requested</h3>
        <div id="m_testsList"></div>
      </div>
      <div class="modal-section" id="m_changeLogSection" style="display:none">
        <h3>Change Log</h3>
        <div id="m_changeLog"></div>
      </div>
      <div class="btn-group">
        <button class="btn-primary" onclick="goToStatusEdit()">Edit Status</button>
        <button class="btn-secondary" onclick="requestCloseModal()">Close</button>
      </div>
    </div>

    <div id="m_editView" style="display:none">
      <div class="fg" id="m_editFields"></div>
      <div class="m-acc-group">
        <div class="m-acc-item" id="m_batchAccEdit">
          <div class="m-acc-header" onclick="modalToggleAcc(this)"><h3>Batch Info</h3><span class="m-acc-toggle">&#9662;</span></div>
          <div class="m-acc-content" id="m_batchInfoEdit"></div>
        </div>
        <div class="m-acc-item" id="m_testsAccEdit">
          <div class="m-acc-header" onclick="modalToggleAcc(this)"><h3>Tests Requested</h3><span class="m-acc-toggle">&#9662;</span></div>
          <div class="m-acc-content">
            <p style="font-size:13px;color:#7f8c8d;margin-bottom:8px">Check a category to add a test, or edit/remove an existing one below.</p>
            <div class="modal-checklist" id="m_catGrid"></div>
            <div id="m_catPanels"></div>
          </div>
        </div>
      </div>
      <div class="modal-section">
        <div class="form-group">
          <label>Reason for Changes <span class="req">*</span></label>
          <p style="font-size:12px;color:#7f8c8d;margin:0 0 6px">Logging this change as: <strong id="me_editorName"></strong></p>
          <textarea id="me_editReason" placeholder="Briefly explain why these changes were made (e.g. corrected a typo, recorded a retest, customer request)..."></textarea>
        </div>
      </div>
      <div class="btn-group">
        <button class="btn-success" onclick="saveModalEdits()"><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Save Changes</button>
        <button class="btn-secondary" onclick="requestExitModalEdit()">Cancel</button>
      </div>
    </div>
    </div>
  </div>
</div>

<script>
/* ════════════════════════════════════════════════════════════
   SHAREPOINT CONFIG
════════════════════════════════════════════════════════════ */
var SP_URL    = '';
var SP_DIGEST = '';
var PATH_SAMPLES        = "/_api/web/lists/getbytitle('LS-QP08.01_ReceivedSamples')/items";
var PATH_INSPECT        = "/_api/web/lists/getbytitle('LS-QP08.01_BatchInspection')/items";
var PATH_TEST_RESULTS   = "/_api/web/lists/getbytitle('LS-QP08.01_TestResults')/items";
var PATH_VERTEX_TESTS   = "/_api/web/lists/getbytitle('VertexTests')/items";
var PATH_SAMPLE_TESTS   = "/_api/web/lists/getbytitle('SampleTests')/items";
var IH_LAB_NAME         = 'Vertex';
// Hides the Result UI in the Sample Detail modal and the Lab Order
// document. The underlying TestResults data/fetches are left completely
// untouched (still read, still re-saved as-is on edit) -- only rendering
// the result is gated, so flipping this back to true needs nothing else.
var SHOW_TEST_RESULTS   = false;
var PATH_CUSTOMERS      = "/_api/web/lists/getbytitle('Customers')/items";
var PATH_EXTERNAL_LABS  = "/_api/web/lists/getbytitle('VertexTests')/items";
var PATH_TEST_CATS      = "/_api/web/lists/getbytitle('TestCategories')/items";
var PATH_APPROVED_LABS  = "/_api/web/lists/getbytitle('ApprovedLabs')/items";
var PATH_SUBCONTRACT    = "/_api/web/lists/getbytitle('LS-QP08.01_SubcontractedTests')/items";
var PATH_EDIT_LOG       = "/_api/web/lists/getbytitle('LS-QP08.01_SampleEditLog')/items";
var PATH_REQUESTS       = "/_api/web/lists/getbytitle('LS-QP08.01_ReceivedRequests')/items";

var allSamples          = [];
var allSampleTests      = [];   // { _spID, title, category } from SampleTests list
var allInspections      = [];
var externalLabTests    = [];
var testCategories      = [];
var catTATDays          = {};   // { code: days } built from TestCategories.TATByDays
var allSubcontractEntries = [];
var allRequests           = [];

/* ════════════════════════════════════════════════════════════
   SP REST HELPERS
════════════════════════════════════════════════════════════ */
function spGet(path){
  return fetch(SP_URL+path,{
    credentials:'include',
    headers:{'Accept':'application/json;odata=nometadata'}
  }).then(function(r){
    if(!r.ok) throw new Error('GET '+r.status);
    return r.json();
  });
}
function spPost(path,body){
  return getRequestDigest().then(function(digest){
    return fetch(SP_URL+path,{
      method:'POST',
      credentials:'include',
      headers:{
        'Accept':'application/json;odata=nometadata',
        'Content-Type':'application/json;odata=nometadata',
        'X-RequestDigest':digest
      },
      body:JSON.stringify(body)
    }).then(function(r){
      if(r.status===204) return null;
      return r.json().then(function(d){
        if(d&&d.error) throw new Error(d.error.message||'POST error');
        if(!r.ok) throw new Error('POST '+r.status);
        return d;
      });
    });
  });
}
function spPatch(path,id,body){
  return getRequestDigest().then(function(digest){
    return fetch(SP_URL+path+'('+id+')',{
      method:'POST',
      credentials:'include',
      headers:{
        'Accept':'application/json;odata=nometadata',
        'Content-Type':'application/json;odata=nometadata',
        'X-RequestDigest':digest,
        'X-HTTP-Method':'MERGE',
        'If-Match':'*'
      },
      body:JSON.stringify(body)
    }).then(function(r){
      if(!r.ok&&r.status!==204) throw new Error('PATCH '+r.status);
    });
  });
}
function spDelete(path,id){
  return getRequestDigest().then(function(digest){
    return fetch(SP_URL+path+'('+id+')',{
      method:'POST',
      credentials:'include',
      headers:{
        'Accept':'application/json;odata=nometadata',
        'Content-Type':'application/json;odata=nometadata',
        'X-RequestDigest':digest,
        'X-HTTP-Method':'DELETE',
        'IF-MATCH':'*'
      }
    }).then(function(r){ if(!r.ok&&r.status!==204) throw new Error('DELETE '+r.status); });
  });
}

/* ════════════════════════════════════════════════════════════
   LOADING OVERLAY
════════════════════════════════════════════════════════════ */
function showLoading(msg){
  document.getElementById('loadingMsg').textContent=msg||'Loading...';
  document.getElementById('loadingOverlay').classList.add('show');
}
function hideLoading(){ document.getElementById('loadingOverlay').classList.remove('show'); }

/* ════════════════════════════════════════════════════════════
   INIT  —  register with SP when available, fallback to window.load
════════════════════════════════════════════════════════════ */
(function(){
  function safeInit(){
    if(window._appInitialized) return;
    window._appInitialized = true;
    initApp();
  }
  if(typeof _spBodyOnLoadFunctionNames !== 'undefined'){
    _spBodyOnLoadFunctionNames.push('safeInit');
  } else {
    window.addEventListener('load', function(){ setTimeout(safeInit, 300); });
  }
  // Also expose safeInit globally so SP can call it if it loads later
  window.safeInit = safeInit;
})();

let siteUrl = '';

function getSharePointContext() {
  return new Promise((resolve, reject) => {
    if (typeof _spPageContextInfo !== 'undefined' && _spPageContextInfo.webAbsoluteUrl) {
      siteUrl = _spPageContextInfo.webAbsoluteUrl;
      setLogoSrc(siteUrl);
      loadIconSprite(siteUrl);
      biInitTemplateUrl();
      resolve();
    } else {
      // Fallback: derive site URL from current page URL
      // Strips everything from /SiteAssets onward
      const href = window.location.href;
      const idx = href.indexOf('/SiteAssets');
      if (idx !== -1) {
        siteUrl = href.substring(0, idx);
        setLogoSrc(siteUrl);
        loadIconSprite(siteUrl);
        biInitTemplateUrl();
        resolve();
      } else {
        setLogoSrc('');
        reject(new Error('SharePoint Context Not Found - open this page from within SharePoint.'));
      }
    }
  });
}

function setLogoSrc(base) {
  if (!base) return; // local fallbacks already set via src attributes
  var logo = document.getElementById('sb-logo');
  var logoIcon = document.getElementById('sb-logo-icon');
  if (logo) logo.src = base + '/SiteAssets/logo_vertex_secondary.svg';
  if (logoIcon) logoIcon.src = base + '/SiteAssets/logo_vertex_icon_app_secondary.svg';
}

function loadIconSprite(base) {
  if (!base) return;
  fetch(base + '/SiteAssets/brand-icons.svg')
    .then(function(r) { if (!r.ok) throw new Error('HTTP ' + r.status); return r.text(); })
    .then(function(svgText) {
      var c = document.createElement('div');
      c.setAttribute('aria-hidden', 'true');
      c.style.display = 'none';
      c.id = 'brand-icon-sprite';
      c.innerHTML = svgText;
      document.body.insertBefore(c, document.body.firstChild);
    })
    .catch(function(err) { console.warn('[Icons] Sprite failed to load:', err.message); });
}

// Get request digest dynamically (works from SiteAssets and Site Pages)
function getRequestDigest() {
  return fetch(SP_URL + '/_api/contextinfo', {
    method: 'POST',
    credentials: 'include',
    headers: { 'Accept': 'application/json;odata=nometadata' }
  })
  .then(function(r) { return r.json(); })
  .then(function(d) { return d.FormDigestValue; });
}

function initApp(){
  getSharePointContext().then(function(){
    SP_URL = siteUrl;
    return getRequestDigest().then(function(digest) {
      SP_DIGEST = digest;

      var t = todayStr();
      document.getElementById('batchDate').value = t;
      document.getElementById('in_date').value = t;

      loadCurrentUser();
      loadCustomers(function() {
        loadSamples(function() {
          refreshDashboard();
          loadInspections(renderInspectionHistory);
        });
      });
      loadExternalLabTests(function() {});  // Load external lab tests in background
      loadTestCategories(function() {});    // Load test categories in background
      loadSampleTests(function() {});       // Load master test catalog for comboboxes
      loadApprovedLabs(function() {});      // Load approved labs for subcontracting dropdown
      loadInhouseTests(function() {});      // Load in-house tests for Lab Orders filtering
      loadEditLog(function(){               // Load edited sample IDs for "Edited" pill indicator
        var pg=(document.querySelector('.sb-item.active')||{}).dataset&&document.querySelector('.sb-item.active').dataset.page;
        if(pg==='master-list')  renderMasterList();
        else if(pg==='update-status') renderStatusList();
        else if(pg==='tat-rush')      renderRushOrders();
      });
      document.querySelector('.app').classList.add('ready');
    }).catch(function(e) {
      console.error('Could not get SP digest:', e);
    });
  }).catch(function(err){
    document.getElementById('page-dashboard').innerHTML=
      '<div class="card"><h2><svg class="icon" aria-hidden="true"><use href="#icon-warning-outline"></use></svg> SharePoint Context Not Found</h2>'
      +'<p style="font-size:14px;line-height:1.8">'+err.message+'<br>'
      +'Go to <strong>Site Pages → ReceivedSamples.aspx</strong> and click it there, '
      +'or add it to your site navigation.</p></div>';
  });
}

/* ════════════════════════════════════════════════════════════
   CURRENT USER
════════════════════════════════════════════════════════════ */
var currentUserName='';
var currentUserIsOwner=false;

function loadCurrentUser(){
  spGet('/_api/web/currentuser?$select=Title')
  .then(function(d){
    currentUserName=d.Title||'';
    var inBy=document.getElementById('in_by');
    var recvBy=document.getElementById('ns_receivedBy');
    if(inBy) inBy.value=currentUserName;
    if(recvBy) recvBy.value=currentUserName;
  })
  .catch(function(e){ console.warn('loadCurrentUser:',e); });
  spGet('/_api/web/associatedownergroup/containsCurrentUser')
  .then(function(d){
    currentUserIsOwner=d.value===true;
    renderTabVisibility();
  })
  .catch(function(e){ console.warn('loadCurrentUserIsOwner:',e); });
}

function renderTabVisibility(){
  var tab=document.getElementById('tabInhouseTesting');
  if(tab) tab.style.display=currentUserIsOwner?'':'none';
  var editBtn=document.getElementById('ihEditModeBtn');
  if(editBtn) editBtn.style.display=currentUserIsOwner?'':'none';
  var tatEditBtn=document.getElementById('tatEditModeBtn');
  if(tatEditBtn) tatEditBtn.style.display='';
}

function checkCurrentUserIsOwner(){
  return spGet('/_api/web/associatedownergroup/containsCurrentUser')
    .then(function(d){ currentUserIsOwner=d.value===true; return currentUserIsOwner; })
    .catch(function(){ return false; });
}

/* ════════════════════════════════════════════════════════════
   CUSTOMERS
════════════════════════════════════════════════════════════ */
var allCustomerNames=[];
function loadCustomers(cb){
  spGet(PATH_CUSTOMERS+'?$select=Title&$orderby=Title&$top=500')
  .then(function(d){
    var customers=(d.value||[]).map(function(c){ return c.Title; });
    allCustomerNames=customers;
    var sb=document.getElementById('batchCustomer');
    var fc=document.getElementById('fClient');
    customers.forEach(function(n){
      var o=document.createElement('option'); o.textContent=n; sb.appendChild(o);
      var o2=document.createElement('option'); o2.textContent=n; fc.appendChild(o2);
    });
    if(cb) cb();
  })
  .catch(function(e){ console.warn('loadCustomers:',e); if(cb) cb(); });
}

/* ════════════════════════════════════════════════════════════
   SAMPLES  —  load / map / serialize
════════════════════════════════════════════════════════════ */
var SAMPLE_FIELDS='ID,Title,ReportID,BatchID,Customer,SampleName,ServingSize,LotNumber,ExtRef,Matrix,SampleType,Units,'
  +'ReceivedBy,Turnaround,DateReceived,TAT_Deadline,Status,StatusNotes,TestsJSON,TestCategories,Remarks,IsRush,RushType,TempUponReceipt,TestDate,SSFConfirmationNumber';

function loadSamples(cb){
  showLoading('Loading samples from SharePoint...');
  spGet(PATH_SAMPLES+'?$select='+SAMPLE_FIELDS+'&$orderby=Created+desc&$top=500')
  .then(function(d){
    allSamples=(d.value||[]).map(spItemToSample);
    samplesAtCap=allSamples.length>=500;
    updateDeepSearchButtonsVisibility();
    hideLoading();
    if(cb) cb();
  })
  .catch(function(e){
    hideLoading();
    console.error('loadSamples:',e);
    if(cb) cb();
  });
}

// SharePoint's REST API always returns DateTime columns as a full ISO
// timestamp (e.g. "2026-06-26T07:00:00Z"), even when the column is
// configured as "Date Only" in SharePoint's own list settings -- that
// setting only affects SharePoint's own browser list view, not the REST
// payload. Trim to the date-only portion here so every date field is
// consistently "YYYY-MM-DD" everywhere it's read in the app (modal,
// <input type="date">, CSV export, etc.).
function dateOnly(v){ return v?String(v).slice(0,10):''; }
function spItemToSample(item){
  var empty={id:[],assay:[],micro:[],metals:[],general:[],pest:[],solv:[],spec:[],Mnr:[],stability:[]};
  var tests=empty;
  try{
    var parsed=JSON.parse(item.TestsJSON||'{}');
    Object.keys(empty).forEach(function(k){ if(Array.isArray(parsed[k])) tests[k]=parsed[k]; });
  }catch(e){}
  return{
    _spID:item.ID,
    sampleID:item.Title||'',
    reportID:item.ReportID||'',
    batchID:item.BatchID||'',
    customer:item.Customer||'',
    sampleName:item.SampleName||'',
    lotNumber:item.LotNumber||'',
    extRef:item.ExtRef||'',
    tempUponReceipt:item.TempUponReceipt||'',
    ssfConfirmationNumber:item.SSFConfirmationNumber||'',
    servingSize:item.ServingSize||'',
    matrix:item.Matrix||'',
    type:item.SampleType||'Finished Product',
    units:item.Units||0,
    receivedBy:item.ReceivedBy||'',
    tat:item.Turnaround||'',
    dateReceived:dateOnly(item.DateReceived),
    tatDeadline:dateOnly(item.TAT_Deadline),
    status:item.Status||'Pending',
    statusNotes:item.StatusNotes||'',
    testDate:dateOnly(item.TestDate),
    remarks:item.Remarks||'',
    isRush:item.IsRush===true,
    rushType:item.RushType||'',
    testCategoryCodes:item.TestCategories||'',
    tests:tests
  };
}

/* ════════════════════════════════════════════════════════════
   SERVER-SIDE "SEARCH ALL RECORDS" (beyond the capped local 500)
════════════════════════════════════════════════════════════ */
var samplesAtCap=false;   // true once loadSamples() returns a full 500 -- signals there may be more
var DEEP_SEARCH_BTN_IDS=['rushDeepSearchBtn','statusDeepSearchBtn','loDeepSearchBtn'];

function updateDeepSearchButtonsVisibility(){
  DEEP_SEARCH_BTN_IDS.forEach(function(id){
    var b=document.getElementById(id);
    if(b) b.style.display=samplesAtCap?'':'none';
  });
}

function odataEscapeLiteral(s){ return String(s).replace(/'/g,"''"); }

function mergeSamplesUnique(a,b){
  var seen={}; var out=[];
  a.concat(b).forEach(function(s){ if(!seen[s.sampleID]){ seen[s.sampleID]=true; out.push(s); } });
  return out;
}

// Live SharePoint search beyond the local 500-record cache. Runs two simple
// single-column filters (each safely indexed -- Title and Customer) rather
// than one compound OR filter, since SharePoint's List View Threshold can
// reject multi-column OR filters once a list passes 5,000 items.
function searchSamplesServerSide(query,cb){
  var esc=odataEscapeLiteral(query.trim());
  if(!esc){ cb([]); return; }
  Promise.all([
    spGet(PATH_SAMPLES+"?$select="+SAMPLE_FIELDS+"&$filter=substringof('"+esc+"',Title)&$top=200"),
    spGet(PATH_SAMPLES+"?$select="+SAMPLE_FIELDS+"&$filter=substringof('"+esc+"',Customer)&$top=200"),
    spGet(PATH_SAMPLES+"?$select="+SAMPLE_FIELDS+"&$filter=substringof('"+esc+"',BatchID)&$top=200")
  ]).then(function(results){
    var seen={}; var merged=[];
    results.forEach(function(d){
      (d.value||[]).forEach(function(item){
        if(seen[item.ID]) return;
        seen[item.ID]=true;
        merged.push(spItemToSample(item));
      });
    });
    cb(merged);
  }).catch(function(e){
    console.error('searchSamplesServerSide:',e);
    cb(null);
  });
}

// Per-view "last deep search" state. A view's pool only includes the server
// results while its search box still holds the exact query that was
// searched -- typing anything different naturally falls back to local-only
// without needing separate clear-on-input wiring.
var deepSearchState={ master:{query:'',results:[]}, rush:{query:'',results:[]},
                       status:{query:'',results:[]}, lab:{query:'',results:[]} };
// Accumulates every sample ever returned by any server-side search, across
// all views, so openModal() can still find a sample that only exists in
// search results and isn't part of the locally-cached 500.
var deepSearchSeenSamples=[];

function poolFor(viewKey,currentQueryLower,baseArray){
  var st=deepSearchState[viewKey];
  if(st&&st.results.length&&st.query===currentQueryLower) return mergeSamplesUnique(baseArray,st.results);
  return baseArray;
}

function runDeepSearch(viewKey,inputId,btnId,renderFn){
  var raw=(document.getElementById(inputId).value||'').trim();
  if(!raw) return;
  var btn=document.getElementById(btnId);
  var orig=btn.innerHTML;
  btn.disabled=true; btn.innerHTML='Searching&#8230;';
  searchSamplesServerSide(raw,function(results){
    btn.disabled=false; btn.innerHTML=orig;
    if(results===null){ showAlertGeneric('Search failed. Please try again.'); return; }
    deepSearchState[viewKey]={query:raw.toLowerCase(),results:results};
    deepSearchSeenSamples=mergeSamplesUnique(deepSearchSeenSamples,results);
    renderFn();
  });
}

function showAlertGeneric(msg){
  if(window.alert) alert(msg);
}

function sampleToSpItem(s){
  var cats=Object.entries(s.tests||{})
    .filter(function(e){ return e[1]&&e[1].length>0; })
    .map(function(e){ return e[0]; }).join(',');
  return{
    Title:s.sampleID,
    ReportID:s.reportID,
    BatchID:s.batchID,
    Customer:s.customer,
    SampleName:s.sampleName,
    LotNumber:s.lotNumber||'',
    ExtRef:s.extRef||'',
    TempUponReceipt:s.tempUponReceipt||'',
    ServingSize:s.servingSize||'',
    Matrix:s.matrix,
    SampleType:s.type,
    Units:s.units,
    ReceivedBy:s.receivedBy,
    Turnaround:s.tat,
    DateReceived:s.dateReceived,
    TAT_Deadline:s.tatDeadline,
    Status:s.status,
    StatusNotes:s.statusNotes||'',
    TestsJSON:JSON.stringify(s.tests||{}),
    TestCategories:cats,
    Remarks:s.remarks||'',
    IsRush:s.isRush||false,
    RushType:s.rushType||'',
    SSFConfirmationNumber:s.ssfConfirmationNumber||''
  };
}

/* ════════════════════════════════════════════════════════════
   INSPECTIONS
════════════════════════════════════════════════════════════ */
function loadInspections(cb){
  var flds='ID,Title,BatchID,InspectionDate,InspectedBy,LabelsLegible,ContainersIntact,'
    +'NoContamination,Temperature,QuantityMatches,DocumentationComplete,TempUponReceipt,InspectionNotes,DocumentsAttached';
  spGet(PATH_INSPECT+'?$select='+flds+'&$orderby=Created+desc&$top=200')
  .then(function(d){ allInspections=d.value||[]; if(cb) cb(); })
  .catch(function(e){ console.error('loadInspections:',e); if(cb) cb(); });
}

function loadExternalLabTests(cb){
  spGet(PATH_EXTERNAL_LABS+'?$select=Title,LabName&$orderby=LabName,Title&$top=500')
  .then(function(d){ externalLabTests=d.value||[]; if(cb) cb(); })
  .catch(function(e){ console.warn('loadExternalLabTests:',e); if(cb) cb(); });
}

function loadTestCategories(cb){
  spGet(PATH_TEST_CATS+'?$select=ID,Title,Code,Description,TATByDays&$orderby=Title&$top=100')
  .then(function(d){
    testCategories=d.value||[];
    buildCatTATMap();
    renderTestCategoryCards();
    if(cb) cb();
  })
  .catch(function(e){ console.warn('loadTestCategories:',e); if(cb) cb(); });
}

var editedSampleIds=new Set();

function loadEditLog(cb){
  spGet(PATH_EDIT_LOG+'?$select=Title&$top=5000')
  .then(function(d){
    (d.value||[]).forEach(function(item){ if(item.Title) editedSampleIds.add(item.Title); });
    if(cb) cb();
  })
  .catch(function(e){ console.warn('loadEditLog:',e); if(cb) cb(); });
}

function editedPill(sid){
  return editedSampleIds.has(sid)?'<span class="edited-pill">Edited</span>':'';
}

function loadSampleTests(cb){
  spGet(PATH_SAMPLE_TESTS+'?$select=ID,Title,Category&$orderby=Title+asc&$top=500')
  .then(function(d){
    allSampleTests=(d.value||[]).map(function(item){
      return { _spID:item.ID, title:item.Title||'', category:item.Category||'' };
    });
    normalizeSampleTestCategories();
    initAllComboboxes();
    initAllModifierComboboxes();
    initStabilityCombobox();
    initPanelDirtyWatchers();
    if(cb) cb();
  })
  .catch(function(e){ console.warn('loadSampleTests:',e); if(cb) cb(); });
}

function buildCatTATMap(){
  catTATDays={};
  testCategories.forEach(function(tc){
    if(tc.Code && tc.TATByDays) catTATDays[tc.Code]=parseInt(tc.TATByDays)||0;
  });
}

/* Returns the maximum TAT days across all categories that have at least one test.
   Returns 0 when no tests have been added yet. */
function computeTAT(tests){
  var max=0;
  Object.keys(tests).forEach(function(cat){
    if(tests[cat]&&tests[cat].length>0){
      var days=catTATDays[cat]||0;
      if(days>max) max=days;
    }
  });
  return max;
}

/* Updates the read-only TAT field in the New Sample form in real time. */
function updateTATDisplay(){
  var field=document.getElementById('ns_tat');
  if(!field) return;
  var days=computeTAT(currentTestLists);
  field.value=days>0?(days+' days'):'';
}

function toggleRushOrder(){
  var chk=document.getElementById('ns_rushChk');
  var grp=document.getElementById('ns_rushTypeGroup');
  if(!chk||!grp) return;
  grp.style.display=chk.checked?'block':'none';
  if(!chk.checked) document.getElementById('ns_rushType').value='';
}

/* ════════════════════════════════════════════════════════════
   ID GENERATION  (localStorage counters — single-user lab)
════════════════════════════════════════════════════════════ */
function nextSeq(yy,mm){
  var k='lis_seq_'+yy+mm;
  var n=(parseInt(localStorage.getItem(k)||'0'))+1;
  localStorage.setItem(k,n);
  return String(n).padStart(3,'0');
}
function parseDateParts(s){
  var p=(s||todayStr()).split('-');
  return{y:parseInt(p[0]),m:parseInt(p[1]),d:parseInt(p[2])};
}
function formatDate(y,m,d){
  return y+'-'+String(m).padStart(2,'0')+'-'+String(d).padStart(2,'0');
}
function genSampleID(dateStr){
  var p=parseDateParts(dateStr);
  var yy=String(p.y).slice(-2), mm=String(p.m).padStart(2,'0');
  return 'S'+yy+mm+'X'+nextSeq(yy,mm);
}
// SharePoint-backed version of genSampleID — same collision fix already
// applied to Batch IDs (see initBatch()). A fresh browser profile with an
// empty localStorage counter would otherwise mint a Sample ID that already
// belongs to an existing record (especially right after a historical data
// migration, where every counter slot up to the migrated max is already
// taken). Queries for the highest existing Sample ID this month and uses
// max+1; falls back to the old localStorage counter only if the query fails.
var reservedSampleSeq={};  // prefix ('S2606X') -> last number handed out this
                            // session. Samples added to an in-progress batch
                            // aren't on SharePoint yet, so re-querying its max
                            // for every add would hand out the same ID twice
                            // (the bug that caused duplicate Sample IDs within
                            // one batch). Once seeded from SharePoint, this
                            // counter is incremented locally instead.
function genSampleIDAsync(dateStr){
  var p=parseDateParts(dateStr);
  var yy=String(p.y).slice(-2), mm=String(p.m).padStart(2,'0');
  var prefix='S'+yy+mm+'X';
  if(reservedSampleSeq[prefix]!==undefined){
    reservedSampleSeq[prefix]+=1;
    return Promise.resolve(prefix+String(reservedSampleSeq[prefix]).padStart(3,'0'));
  }
  return spGet(PATH_SAMPLES+"?$select=Title&$filter=startswith(Title,'"+prefix+"')&$orderby=Title desc&$top=1")
    .then(function(d){
      var items=d.value||[];
      var max=items.reduce(function(m,i){
        var n=parseInt((i.Title||'').slice(prefix.length))||0;
        return Math.max(m,n);
      },0);
      reservedSampleSeq[prefix]=max+1;
      return prefix+String(reservedSampleSeq[prefix]).padStart(3,'0');
    })
    .catch(function(){
      return genSampleID(dateStr);
    });
}
function genReportID(sid){ return sid.replace(/^S/,'AR'); }
function genBatchID(dateStr,customer){
  var p=parseDateParts(dateStr);
  var yy=String(p.y).slice(-2), mm=String(p.m).padStart(2,'0'), dd=String(p.d).padStart(2,'0');
  var bk='lis_bch_'+yy+mm+dd;
  var n=(parseInt(localStorage.getItem(bk)||'0'))+1;
  localStorage.setItem(bk,n);
  return 'SBCH'+yy+mm+dd+String(n).padStart(2,'0');
}
function tatDeadline(dateStr,tat){
  var p=parseDateParts(dateStr);
  // Support legacy dropdown values ("Standard", "3-Day Rush", "2-Day Rush", "1-Day Rush")
  // and new computed format ("N days")
  var days=tat==='3-Day Rush'?3:tat==='2-Day Rush'?2:tat==='1-Day Rush'?1:(parseInt(tat)||7);
  var d=new Date(p.y,p.m-1,p.d+days);
  return formatDate(d.getFullYear(),d.getMonth()+1,d.getDate());
}

/* ════════════════════════════════════════════════════════════
   SMART STICKY NAV
════════════════════════════════════════════════════════════ */
(function(){
  var navWrap=document.getElementById('appNavWrap');
  var lastY=0, ticking=false;
  window.addEventListener('scroll',function(){
    if(!ticking){
      requestAnimationFrame(function(){
        var y=window.scrollY;
        if(y>lastY&&y>80) navWrap.classList.add('nav-hidden');
        else navWrap.classList.remove('nav-hidden');
        lastY=y; ticking=false;
      });
      ticking=true;
    }
  });
})();

/* ════════════════════════════════════════════════════════════
   MOBILE NAV TOGGLE
════════════════════════════════════════════════════════════ */
function toggleMobileNav(){
  var tw=document.getElementById('tabsWrapper');
  var btn=document.getElementById('hamburgerBtn');
  var bd=document.getElementById('navBackdrop');
  var open=tw.classList.toggle('nav-open');
  btn.innerHTML=open?'<svg class="icon" aria-hidden="true"><use href="#icon-x-outline"></use></svg>':'<svg class="icon" aria-hidden="true"><use href="#icon-menu-outline"></use></svg>';
  bd.classList.toggle('show',open);
}
function closeMobileNav(){
  document.getElementById('tabsWrapper').classList.remove('nav-open');
  document.getElementById('hamburgerBtn').innerHTML='<svg class="icon" aria-hidden="true"><use href="#icon-menu-outline"></use></svg>';
  document.getElementById('navBackdrop').classList.remove('show');
}

/* ════════════════════════════════════════════════════════════
   TAB NAVIGATION
════════════════════════════════════════════════════════════ */
document.querySelectorAll('.sb-item').forEach(function(el){
  el.addEventListener('click',function(){
    document.querySelectorAll('.sb-item').forEach(function(i){ i.classList.remove('active'); });
    el.classList.add('active');
    var pg=el.getAttribute('data-page');
    document.querySelectorAll('.page').forEach(function(p){ p.classList.remove('active'); });
    document.getElementById('page-'+pg).classList.add('active');
    // Update both mobile page labels
    var txt=el.textContent.trim();
    document.querySelectorAll('.cpl-left,.cpl-right').forEach(function(l){ l.textContent=txt; });
    closeMobileNav();
    window.scrollTo({top:0,behavior:'smooth'});
    if(pg==='dashboard')        loadSamples(refreshDashboard);
    if(pg==='inhouse-testing')  loadInhouseTests(renderInhouseTests);
    if(pg==='tat-rush')         loadSamples(function(){ renderRushOrders(); loadTestCategories(renderTATCats); });
    if(pg==='master-list')      loadSamples(renderMasterList);
    if(pg==='update-status')    loadSamples(renderStatusList);
    if(pg==='lab-order')        renderLabOrderList();
    if(pg==='received-requests') loadReceivedRequests(renderRequestGroups);
    if(pg==='new-sample') nsCheckPrefill();
    if(pg==='subcontract'){
      populateSubcontractSampleDropdown();
      loadSubcontractEntries(renderSubcontractLog);
    }
  });
});

/* ════════════════════════════════════════════════════════════
   BATCH STATE
════════════════════════════════════════════════════════════ */
var batchID='', batchSamples=[], batchTempUponReceipt='';
var rrPrefillData=null, rrPrefillQueueIdx=0;
var currentTestLists={id:[],assay:[],micro:[],metals:[],general:[],pest:[],solv:[],spec:[],Mnr:[],stability:[]};

/* Helper: get loaded category codes, fallback to defaults */
function getCategoryCodes(){
  if(testCategories.length > 0){
    return testCategories.map(function(tc){ return tc.Code; });
  }
  return ['id','assay','micro','metals','general','pest','solv','spec','Mnr','stability'];
}
var editingSampleID=null, editingSPID=null;
var selectedStatusIDs=[];

function nsSetStep(n){
  for(var i=1;i<=4;i++){
    var el=document.getElementById('nsStep'+i);
    if(!el) continue;
    el.classList.remove('ns-active','ns-done');
    if(i<n) el.classList.add('ns-done');
    else if(i===n) el.classList.add('ns-active');
  }
}

function nsShowStep(n, extraDelay){
  nsSetStep(n);
  if(n===3) nsUpdateSampleCounter();
  extraDelay = extraDelay || 0;
  var all=document.querySelectorAll('#page-new-sample .ns-panel');
  var toHide=[], toShow=[];
  all.forEach(function(p){
    var pStep=parseInt(p.getAttribute('data-step'));
    if(pStep===n) toShow.push(p);
    else if(!p.classList.contains('ns-hidden')) toHide.push(p);
  });
  function showPanels(){
    toShow.forEach(function(p){
      p.classList.remove('ns-hidden');
      p.style.opacity='0';
    });
    requestAnimationFrame(function(){
      requestAnimationFrame(function(){
        toShow.forEach(function(p){ p.style.opacity=''; });
      });
    });
  }
  // Scroll to stepper first, then fade after scroll settles + any extra delay
  nsScrollToStepper();
  if(toHide.length===0){
    setTimeout(showPanels, 350+extraDelay);
    return;
  }
  setTimeout(function(){
    toHide.forEach(function(p){ p.classList.add('ns-fading'); });
    setTimeout(function(){
      toHide.forEach(function(p){
        p.classList.add('ns-hidden');
        p.classList.remove('ns-fading');
      });
      showPanels();
    },500);
  }, 350+extraDelay);
}

// Scrolls a page-level alert banner into view -- used for pages where the
// alert sits at the top while the action that triggers it (a validation
// error, a save) can happen while scrolled deep into a long form/list below.
function scrollAlertIntoView(id){
  var el=document.getElementById(id);
  if(!el) return;
  var nav=document.getElementById('appNavWrap');
  var navH=nav?nav.offsetHeight:0;
  var top=el.getBoundingClientRect().top+window.pageYOffset-navH-16;
  window.scrollTo({top:top,behavior:'smooth'});
}
function nsScrollToStepper(){
  var st=document.getElementById('nsStepper');
  if(!st) return;
  var nav=document.getElementById('appNavWrap');
  var navH=nav?nav.offsetHeight:0;
  var top=st.getBoundingClientRect().top+window.pageYOffset-navH-16;
  window.scrollTo({top:top,behavior:'smooth'});
}

function nsStepClick(n){
  var el=document.getElementById('nsStep'+n);
  if(el&&el.classList.contains('ns-done')) nsShowStep(n);
}

function initBatch(){
  var cust=document.getElementById('batchCustomer').value;
  var date=document.getElementById('batchDate').value;
  if(!cust||!date) return;
  var p=parseDateParts(date);
  var yy=String(p.y).slice(-2), mm=String(p.m).padStart(2,'0'), dd=String(p.d).padStart(2,'0');
  var prefix='SBCH'+yy+mm+dd;
  var contBtn=document.getElementById('nsBatchContinueGroup');
  document.getElementById('batchIDDisplay').value='Loading...';
  if(contBtn) contBtn.style.display='none';
  // If prefilling from an SSF request, reuse the batch ID of any already-registered samples for that request.
  var confNum=rrPrefillData&&rrPrefillData.confNum;
  if(confNum){
    var esc=confNum.replace(/'/g,"''");
    spGet(PATH_SAMPLES+"?$select=BatchID&$filter=SSFConfirmationNumber eq '"+esc+"'&$top=1")
    .then(function(d){
      if(d.value&&d.value.length&&d.value[0].BatchID){
        batchID=d.value[0].BatchID;
        _applyBatchID(batchID,contBtn,date);
      } else {
        _initBatchGenerateNew(prefix,contBtn,date,cust);
      }
    })
    .catch(function(){ _initBatchGenerateNew(prefix,contBtn,date,cust); });
  } else {
    _initBatchGenerateNew(prefix,contBtn,date,cust);
  }
}
function _initBatchGenerateNew(prefix,contBtn,date,cust){
  spGet(PATH_SAMPLES+"?$select=BatchID&$filter=startswith(BatchID,'"+prefix+"')")
  .then(function(d){
    var items=d.value||[];
    var max=items.reduce(function(m,i){
      var n=parseInt((i.BatchID||'').replace(prefix,''))||0;
      return Math.max(m,n);
    },0);
    batchID=prefix+String(max+1).padStart(2,'0');
    _applyBatchID(batchID,contBtn,date);
  })
  .catch(function(){
    // Fallback to localStorage counter if SP is unreachable
    batchID=genBatchID(date,cust);
    _applyBatchID(batchID,contBtn,date);
  });
}
function _applyBatchID(id,contBtn,date){
  document.getElementById('batchIDDisplay').value=id;
  var inBID=document.getElementById('in_batchID');
  var inDate=document.getElementById('in_date');
  if(inBID) inBID.value=id;
  if(inDate&&!inDate.value) inDate.value=todayStr();
  if(contBtn) contBtn.style.display='';
  updateSampleIDPreview();
}
function updateSampleIDPreview(){
  var date=document.getElementById('batchDate').value;
  if(!date) return;
  var p=parseDateParts(date);
  var yy=String(p.y).slice(-2), mm=String(p.m).padStart(2,'0');
  var n=String(batchSamples.length+1).padStart(3,'0');
  document.getElementById('ns_sampleID').value='S'+yy+mm+'X'+n+' (preview)';
  document.getElementById('ns_reportID').value='AR'+yy+mm+'X'+n+' (preview)';
}

/* ════════════════════════════════════════════════════════════
   TEST CATEGORIES
════════════════════════════════════════════════════════════ */
function renderTestCategoryCards(){
  var grid=document.getElementById('testCategoryGrid');
  if(!grid) return; // Not on new-sample page
  grid.innerHTML='';
  var loadedCodes={};
  testCategories.forEach(function(tc){
    loadedCodes[tc.Code]=true;
    var card='<div class="test-cat-card" id="cat-'+tc.Code+'" onclick="toggleCat(\''+tc.Code+'\',this)">'
      +'<input type="checkbox" id="chk-'+tc.Code+'" onclick="event.stopPropagation();syncCat(\''+tc.Code+'\',this)">'
      +'<div class="test-cat-name">'+escHtml(tc.Title)+'</div>'
      +'<div class="test-cat-desc">'+escHtml(tc.Description)+'</div>'
      +'</div>';
    grid.innerHTML+=card;
  });
  // Hide test panels for categories not loaded
  ['id','assay','micro','metals','general','pest','solv','spec','Mnr','stability'].forEach(function(cat){
    var panel=document.getElementById('panel-'+cat);
    if(!panel) return;
    if(!loadedCodes[cat]){
      panel.style.display='none';
    } else {
      panel.style.display='';
      panel.classList.remove('open');
    }
  });
}
function toggleCat(cat,cardEl){
  var chk=document.getElementById('chk-'+cat);
  chk.checked=!chk.checked;
  cardEl.classList.toggle('selected',chk.checked);
  var panel=document.getElementById('panel-'+cat);
  if(panel) panel.classList.toggle('open',chk.checked);
}
function syncCat(cat,chk){
  var cardEl=chk.closest('.test-cat-card');
  cardEl.classList.toggle('selected',chk.checked);
  var panel=document.getElementById('panel-'+cat);
  if(panel) panel.classList.toggle('open',chk.checked);
}
var PANEL_FIELDS={
  assay: {combos:[['assay_analyte','assay_analyte_dd']],plain:['assay_mod','assay_lower','assay_upper','assay_units']},
  general:{combos:[['general_test','general_test_dd']],plain:['general_mod','general_lower','general_upper','general_units']},
  metals: {combos:[['metals_test','metals_test_dd']],plain:['metals_mod','metals_lower','metals_upper','metals_units']},
  id:     {combos:[['id_ingredient','id_ingredient_dd']],plain:['id_mod','id_method']},
  micro:  {combos:[['micro_test','micro_test_dd']],plain:['micro_mod','micro_lower','micro_upper','micro_units']},
  Mnr:    {combos:[['Mnr_name','Mnr_name_dd']],plain:['Mnr_mod','Mnr_lower','Mnr_upper','Mnr_units']},
  pest:   {combos:[['pest_name','pest_name_dd']],plain:['pest_mod','pest_lower','pest_upper','pest_units']},
  solv:   {combos:[['solv_name','solv_name_dd']],plain:['solv_mod','solv_lower','solv_upper','solv_units']},
  spec:   {combos:[['spec_name','spec_name_dd']],plain:['spec_mod','spec_lower','spec_upper','spec_units']},
  stability: {combos:[['stability_name','stability_name_dd']],plain:[]}
};
function checkPanelDirty(cat){
  var cfg=PANEL_FIELDS[cat];
  if(!cfg) return;
  var dirty=false;
  cfg.combos.forEach(function(pair){
    var el=document.getElementById(pair[0]);
    if(el&&el.value.trim()) dirty=true;
  });
  cfg.plain.forEach(function(id){
    var el=document.getElementById(id);
    if(el&&el.value.trim()) dirty=true;
  });
  var btn=document.querySelector('#panel-'+cat+' .test-panel-clear-btn');
  if(btn) btn.style.display=dirty?'inline-flex':'none';
}
function clearTestPanel(cat){
  var cfg=PANEL_FIELDS[cat];
  if(!cfg) return;
  cfg.combos.forEach(function(pair){
    resetCombobox(document.getElementById(pair[0]),document.getElementById(pair[1]));
  });
  cfg.plain.forEach(function(id){
    var el=document.getElementById(id);
    if(el) el.value='';
  });
  resetModifierField(cat);
  toggleUpperField(cat);
  checkPanelDirty(cat);
}
function initPanelDirtyWatchers(){
  Object.keys(PANEL_FIELDS).forEach(function(cat){
    var panel=document.getElementById('panel-'+cat);
    if(!panel) return;
    checkPanelDirty(cat);
    panel.addEventListener('input',function(){ checkPanelDirty(cat); });
  });
}
// Builds the "modifier lower upper units" fragment from a category's 4 split
// spec fields, re-running autoSplitSpecFields first so values typed into the
// wrong field (or all jammed into one) land in the right place before the
// label string gets assembled. Returns '' if nothing was filled in at all —
// every spec field is optional, by design (mirrors the source spreadsheet,
// where techs could leave a spec blank for their own reasons). Returns
// `false` (not a string) if the Modifier field holds a value that isn't a
// recognized option and isn't in "Other" free-type mode — callers must
// check for this and abort before adding the test.
function buildSpecFragment(cat){
  autoSplitSpecFields(cat);
  if(!validateModifierField(cat)) return false;
  var mod=(document.getElementById(cat+'_mod').value||'').trim();
  var low=(document.getElementById(cat+'_lower').value||'').trim();
  var up =(document.getElementById(cat+'_upper').value||'').trim();
  var unt=(document.getElementById(cat+'_units').value||'').trim();
  return [mod,low,up,unt].filter(function(v){ return v; }).join(' ');
}
function clearSpecFields(cat){
  ['_mod','_lower','_upper','_units'].forEach(function(suf){
    var el=document.getElementById(cat+suf);
    if(el) el.value='';
  });
  resetModifierField(cat);
  toggleUpperField(cat);
}
function addTest(cat){
  var label='';
  if(cat==='id'){
    var ing=document.getElementById('id_ingredient').value.trim();
    if(!ing){ alert('Enter Ingredient name'); return; }
    if(!validateModifierField('id')) return;
    var idmod=normalizeModifier(document.getElementById('id_mod').value.trim());
    var mth=document.getElementById('id_method').value.trim();
    // Modifier blank => same format as before ("Name — Method"), so existing
    // entries and historical parsing stay unaffected. Modifier filled => the
    // method (if any) is appended in parentheses to keep both pieces of
    // information without inventing a new delimiter scheme.
    var idspec=idmod?(idmod+(mth?' ('+mth+')':'')):mth;
    label=ing+(idspec?' '+String.fromCharCode(8212)+' '+idspec:'');
    document.getElementById('id_ingredient').value='';
    resetModifierField('id');
    document.getElementById('id_method').value='';
    checkPanelDirty('id');
  } else if(cat==='assay'){
    var ana=document.getElementById('assay_analyte').value;
    if(!ana){ alert('Enter Analyte name'); return; }
    var aspec=buildSpecFragment('assay');
    if(aspec===false) return;
    label=ana+(aspec?' '+String.fromCharCode(8212)+' '+aspec:'');
    resetCombobox(document.getElementById('assay_analyte'),document.getElementById('assay_analyte_dd'));
    clearSpecFields('assay');
    checkPanelDirty('assay');
  } else if(cat==='micro'){
    var tst=document.getElementById('micro_test').value;
    if(!tst){ alert('Enter Microorganism name'); return; }
    var mispec=buildSpecFragment('micro');
    if(mispec===false) return;
    label=tst+(mispec?' '+String.fromCharCode(8212)+' '+mispec:'');
    resetCombobox(document.getElementById('micro_test'),document.getElementById('micro_test_dd'));
    clearSpecFields('micro');
    checkPanelDirty('micro');
  } else if(cat==='metals'){
    var mtl=document.getElementById('metals_test').value;
    if(!mtl){ alert('Enter Metal name'); return; }
    var mtspec=buildSpecFragment('metals');
    if(mtspec===false) return;
    label=mtl+(mtspec?' '+String.fromCharCode(8212)+' '+mtspec:'');
    resetCombobox(document.getElementById('metals_test'),document.getElementById('metals_test_dd'));
    clearSpecFields('metals');
    checkPanelDirty('metals');
  } else if(cat==='general'){
    var gt=document.getElementById('general_test').value;
    if(!gt){ alert('Enter Test name'); return; }
    var gspec=buildSpecFragment('general');
    if(gspec===false) return;
    label=gt+(gspec?' '+String.fromCharCode(8212)+' '+gspec:'');
    resetCombobox(document.getElementById('general_test'),document.getElementById('general_test_dd'));
    clearSpecFields('general');
    checkPanelDirty('general');
  } else if(cat==='pest'){
    var pn=document.getElementById('pest_name').value.trim();
    if(!pn){ alert('Enter Pesticide / Scope name'); return; }
    var pspec=buildSpecFragment('pest');
    if(pspec===false) return;
    label=pn+(pspec?' '+String.fromCharCode(8212)+' '+pspec:'');
    document.getElementById('pest_name').value='';
    clearSpecFields('pest');
    checkPanelDirty('pest');
  } else if(cat==='solv'){
    var sn=document.getElementById('solv_name').value.trim();
    if(!sn){ alert('Enter Solvent name'); return; }
    var sspec=buildSpecFragment('solv');
    if(sspec===false) return;
    label=sn+(sspec?' '+String.fromCharCode(8212)+' '+sspec:'');
    document.getElementById('solv_name').value='';
    clearSpecFields('solv');
    checkPanelDirty('solv');
  } else if(cat==='spec'){
    var spn=document.getElementById('spec_name').value.trim();
    if(!spn){ alert('Enter Test Name'); return; }
    var spspec=buildSpecFragment('spec');
    if(spspec===false) return;
    label=spn+(spspec?' '+String.fromCharCode(8212)+' '+spspec:'');
    document.getElementById('spec_name').value='';
    clearSpecFields('spec');
    checkPanelDirty('spec');
  } else if(cat==='Mnr'){
    var mn=document.getElementById('Mnr_name').value.trim();
    if(!mn){ alert('Enter Mineral / Analyte name'); return; }
    var mnspec=buildSpecFragment('Mnr');
    if(mnspec===false) return;
    label=mn+(mnspec?' '+String.fromCharCode(8212)+' '+mnspec:'');
    document.getElementById('Mnr_name').value='';
    clearSpecFields('Mnr');
    checkPanelDirty('Mnr');
  } else if(cat==='stability'){
    var stn=document.getElementById('stability_name').value.trim();
    if(!stn){ alert('Select or enter a Test'); return; }
    label=stn;
    resetCombobox(document.getElementById('stability_name'),document.getElementById('stability_name_dd'));
    checkPanelDirty('stability');
  }
  currentTestLists[cat].push(label);
  renderTestList(cat);
  updateTATDisplay();
}
function renderTestList(cat){
  var ul=document.getElementById('list-'+cat);
  if(!ul) return;
  ul.innerHTML='';
  currentTestLists[cat].forEach(function(item,idx){
    var div=document.createElement('div');
    div.className='test-item';
    div.innerHTML='<span>'+escHtml(item).replace(/—/g,'&#8212;')+'</span>'
      +'<button class="btn-remove-test" onclick="removeTest(\''+cat+'\','+idx+')">Remove</button>';
    ul.appendChild(div);
  });
}
function removeTest(cat,idx){ currentTestLists[cat].splice(idx,1); renderTestList(cat); updateTATDisplay(); }

/* ════════════════════════════════════════════════════════════
   ADD SAMPLE TO BATCH
════════════════════════════════════════════════════════════ */
function addSampleToBatch(){
  var cust=document.getElementById('batchCustomer').value;
  var date=document.getElementById('batchDate').value;
  if(!cust||!date){ showAlert('alertNewSample','Set Customer and Date first','error'); scrollAlertIntoView('alertNewSample'); return; }
  clearFieldErrors();
  var name=document.getElementById('ns_sampleName').value.trim();
  var matrix=document.getElementById('ns_matrix').value;
  var units=document.getElementById('ns_units').value;
  var recv=document.getElementById('ns_receivedBy').value.trim();
  clearFieldErrors();
  var hasErrors = false;
  if(!name)  { markFieldError('ns_sampleName');  hasErrors=true; }
  if(!matrix){ markFieldError('ns_matrix');       hasErrors=true; }
  if(!units) { markFieldError('ns_units');         hasErrors=true; }
  if(!recv)  { /* ns_receivedBy is auto-filled from current user — skip manual validation */ }
  if(hasErrors){
    showAlert('alertNewSample','Please fill all required fields marked with *','error');
    scrollAlertIntoView('alertNewSample');
    return;
  }
  var total=Object.values(currentTestLists).reduce(function(s,a){ return s+a.length; },0);
  if(total===0){ showAlert('alertNewSample','Add at least one test in any category','error'); scrollAlertIntoView('alertNewSample'); return; }

  var isRush=document.getElementById('ns_rushChk').checked;
  var rushType=isRush?document.getElementById('ns_rushType').value.trim():'';
  if(isRush&&!rushType){
    markFieldError('ns_rushType');
    showAlert('alertNewSample','Please select a Rush Type for the rush order','error');
    scrollAlertIntoView('alertNewSample');
    return;
  }
  var tatDays=computeTAT(currentTestLists);
  var tat=tatDays>0?(tatDays+' days'):'';
  showLoading('Generating Sample ID...');
  genSampleIDAsync(date).then(function(sid){
    hideLoading();
    var sample={
      sampleID:sid, reportID:genReportID(sid), batchID:batchID,
      customer:cust, sampleName:name, lotNumber:document.getElementById('ns_lotNumber').value.trim(),
      extRef:document.getElementById('ns_extRef').value.trim(),
      tempUponReceipt:batchTempUponReceipt,
      servingSize:document.getElementById('ns_servingSize').value.trim(),
      matrix:matrix, type:document.getElementById('ns_type').value,
      units:parseInt(units), receivedBy:recv, tat:tat,
      dateReceived:date, tatDeadline:tatDeadline(date,tat),
      status:'Pending', statusNotes:'',
      isRush:isRush, rushType:rushType,
      remarks:document.getElementById('ns_remarks').value.trim(),
      tests:JSON.parse(JSON.stringify(currentTestLists))
    };

    if(rrPrefillData) sample.ssfConfirmationNumber=rrPrefillData.confNum;
    batchSamples.push(sample);
    var count=batchSamples.length;
    rrPrefillQueueIdx++;
    clearSampleForm();
    renderBatchSummary();
    nsScrollToStepper();
    var moreInQueue=rrPrefillData&&rrPrefillQueueIdx<rrPrefillData.samples.length;
    setTimeout(function(){
      if(moreInQueue){
        showAlert('alertNewSample','Sample '+sid+' added. Loading next sample ('+(rrPrefillQueueIdx+1)+' of '+rrPrefillData.samples.length+')\u2026','success');
        setTimeout(function(){ nsLoadPrefillSample(rrPrefillQueueIdx); nsShowStep(3); },1200);
      } else {
        if(rrPrefillData) nsClearPrefillQueue();
        showAlert('alertNewSample','Sample '+sid+' added to batch ('+count+' total)','success');
        setTimeout(function(){ nsShowStep(4); },1500);
      }
    },500);
  });
}

function renderBatchSummary(){
  var el=document.getElementById('batchSummary');
  var fg=document.getElementById('finalizeGroup');
  if(batchSamples.length===0){
    el.innerHTML='<div class="empty-state">Add samples above to see them listed here.</div>';
    fg.style.display='none'; return;
  }
  var rows=batchSamples.map(function(s,i){
    var cats=Object.entries(s.tests).filter(function(e){ return e[1].length>0; })
      .map(function(e){ return e[0].toUpperCase()+'('+e[1].length+')'; }).join(', ');
    return '<tr>'
      +'<td data-label="#">'+(i+1)+'</td>'
      +'<td data-label="Sample ID"><strong>'+s.sampleID+'</strong></td>'
      +'<td data-label="Sample Name">'+escHtml(s.sampleName)+'</td>'
      +'<td data-label="Matrix">'+s.matrix+'</td>'
      +'<td data-label="TAT">'+s.tat+'</td>'
      +'<td data-label="Tests"><small>'+cats+'</small></td>'
      +'<td data-label=""><button class="btn-danger btn-sm" onclick="removeBatchSample('+i+')">Delete</button></td></tr>';
  }).join('');
  el.innerHTML='<div class="table-wrap"><table><thead><tr><th>#</th><th>Sample ID</th>'
    +'<th>Sample Name</th><th>Matrix</th><th>TAT</th><th>Tests</th><th></th></tr></thead>'
    +'<tbody>'+rows+'</tbody></table></div>';
  fg.style.display='flex';
}
function removeBatchSample(i){
  batchSamples.splice(i,1);
  renderBatchSummary();
}

/* ── TEST RESULTS helpers ── */

// TestsJSON entries are either a plain label string (every sample created
// before the editable-tests feature) or an object {label, id} carrying the
// matching LS-QP08.01_TestResults row's SharePoint ID (every sample created
// or edited after it, plus anything the backfill script has touched). These
// two helpers let every consumer treat both shapes uniformly without caring
// which one a given sample has.
function testEntryLabel(entry){ return typeof entry==='string'?entry:(entry&&entry.label)||''; }
function testEntryId(entry){ return (entry&&typeof entry==='object')?(entry.id||null):null; }
function makeTestEntry(label,id){ return id?{label:label,id:id}:label; }

// Which input-field "shape" each test category panel needs. Any category
// code not listed here (e.g. a brand-new one added to the TestCategories
// SharePoint list before the app is updated to know about it) falls back to
// 'standard' -- the most common shape, covering the large majority of
// plausible new categories without requiring a code change first.
var CAT_FIELD_SHAPE = {
  assay:'standard', general:'standard', metals:'standard', micro:'standard',
  pest:'standard', solv:'standard', spec:'standard', Mnr:'standard',
  id:'single', stability:'typed'
};
function fieldShapeFor(cat){ return CAT_FIELD_SHAPE[cat]||'standard'; }

// Traduce el code interno del TestsJSON al valor de TestCategory
// que usa la lista LS-QP08.01_TestResults y los scripts de COA.
var CAT_CODE_TO_LABEL = {
  'assay'   : 'Assay',
  'id'      : 'Identity',
  'micro'   : 'Microbiology',
  'metals'  : 'Heavy_Metals',
  'Mnr'     : 'Minerals',
  'general' : 'General_Tests',
  'pest'    : 'Pesticides',
  'solv'    : 'Residual_Solvents',
  'spec'    : 'Special_Tests',
  'stability' : 'Stability'
};

// Parsea el label de una prueba al formato que espera LS-QP08.01_TestResults.
// Los labels se escriben en addTest() con formato: "TestName — SpecModifier Valor Units"
// El separador es un em dash (U+2014).
// Maps symbol forms to the canonical text form used for storage.
var MODIFIER_CANON = {'\u2264':'NMT','\u2265':'NLT'};
// Maps canonical text forms to their symbol, for read/print display.
var MODIFIER_SYMBOL = {'NMT':'\u2264','NLT':'\u2265'};
function normalizeModifier(mod){
  mod=(mod||'').trim();
  return MODIFIER_CANON[mod]||mod;
}

// Parses a raw "modifier value(s) units" fragment (the part after the em dash
// in a test label, or the concatenation of the 4 split spec fields).
// Returns matched:true only when a recognized modifier pattern was found \u2014
// callers that need to know whether it's safe to redistribute values into
// separate fields should check this flag rather than assuming a result.
function parseSpecRaw(specRaw){
  specRaw=(specRaw||'').trim();
  var specModifier='', specValueLower='', specValueUpper='', units='', matched=false;
  if(!specRaw) return {specModifier,specValueLower,specValueUpper,units,matched};

  // Note: Nominal is NOT in this list — despite reading like a qualitative
  // term, legacy data shows it almost always carries a Lower value (it's a
  // target value with implied tolerance), so it's handled by the numeric
  // regex below alongside NMT/NLT/Range, not treated as units-only.
  var keywords = ['Negative','Report','Absence','Presence',
                  'Conforms to Reference Standard','Conforms to Reference Spectrum'];
  for (var k = 0; k < keywords.length; k++) {
    if (specRaw.indexOf(keywords[k]) === 0) {
      specModifier = keywords[k];
      units = specRaw.slice(keywords[k].length).trim();
      matched = true;
      break;
    }
  }
  if (!matched) {
    var mSimple = specRaw.match(/^([\d.]+)\s+(.+)$/);
    if (mSimple) {
      specModifier   = 'NLT';
      specValueLower = mSimple[1];
      specValueUpper = '';
      units          = mSimple[2].trim();
      matched        = true;
    }
  }
  if (!matched) {
    var m = specRaw.match(/^([\u2265\u2264><]|NMT|NLT|Range|Nominal|=)\s*([\d.]+)(?:\s+([\d.]+))?\s*(.*)$/);
    if (m) {
      specModifier   = m[1];
      specValueLower = m[2] || '';
      specValueUpper = m[3] || '';
      units          = (m[4] || '').trim();
      matched        = true;
    } else {
      specModifier = specRaw;
    }
  }
  return { specModifier, specValueLower, specValueUpper, units, matched };
}

function parseTestLabel(label) {
  var parts       = label.split(/\s*(?:\u2014|\u00E2\u20AC[\u201C\u201D"])\s*/);
  var test        = (parts[0] || '').trim();
  var specRaw     = (parts[1] || '').trim();
  var specDisplay = specRaw;
  var p = parseSpecRaw(specRaw);
  return { test, specModifier:p.specModifier, specValueLower:p.specValueLower, specValueUpper:p.specValueUpper, units:p.units, specDisplay };
}

// Modifiers that, per the legacy data, never carry a numeric Lower/Upper
// value \u2014 only an optional trailing Units annotation (e.g. "Negative CFU/g").
// Nominal is deliberately excluded \u2014 despite the name, it almost always has
// a Lower value (a target value with implied tolerance), so it behaves like
// NMT/NLT, not like these.
var QUALITATIVE_MODIFIERS=['Negative','Report','Absence','Presence',
  'Conforms to Reference Standard','Conforms to Reference Spectrum'];

// Shows/hides the Lower and Upper fields for a category's spec row based on
// the current Modifier value \u2014 Upper only makes sense for a Range spec;
// Lower (and Upper) don't apply at all for purely qualitative modifiers.
// Modifiers for which Upper should be available — Range always needs it;
// Nominal occasionally carries a tolerance upper bound too (a small minority
// of legacy rows, but real), so it's offered just in case rather than hidden.
var UPPER_CAPABLE_MODIFIERS=['Range','Nominal'];
function toggleUpperField(cat){
  var modEl=document.getElementById(cat+'_mod');
  if(!modEl) return;
  var modVal=(modEl.value||'').trim();
  var upGroup=document.getElementById(cat+'_upperGroup');
  var lowGroup=document.getElementById(cat+'_lowerGroup');
  var showUpper=UPPER_CAPABLE_MODIFIERS.some(function(m){ return m.toLowerCase()===modVal.toLowerCase(); });
  var isQualitative=QUALITATIVE_MODIFIERS.some(function(q){ return q.toLowerCase()===modVal.toLowerCase(); });
  if(upGroup){
    upGroup.style.display=showUpper?'':'none';
    if(!showUpper){ var upEl=document.getElementById(cat+'_upper'); if(upEl) upEl.value=''; }
  }
  if(lowGroup){
    lowGroup.style.display=isQualitative?'none':'';
    if(isQualitative){ var lowEl=document.getElementById(cat+'_lower'); if(lowEl) lowEl.value=''; }
  }
}
// Normalizes a single standalone modifier field (used by Identity, which has
// no Lower/Upper/Units to auto-split against \u2014 just a direct symbol\u2192canonical
// normalization on blur).
function normalizeModifierField(id){
  var el=document.getElementById(id);
  if(!el) return;
  el.value=normalizeModifier(el.value);
}

// Re-parses the combined contents of a category's 4 spec fields and
// redistributes them into Modifier/Lower/Upper/Units. Handles the whole
// spec being typed into one field, or split unevenly across 2-3 fields.
// Leaves all fields untouched if the combined text doesn't match a known
// modifier pattern \u2014 never guesses on scrambled/unrecognized input.
function autoSplitSpecFields(cat){
  var modEl=document.getElementById(cat+'_mod');
  var lowEl=document.getElementById(cat+'_lower');
  var upEl=document.getElementById(cat+'_upper');
  var untEl=document.getElementById(cat+'_units');
  if(!modEl||!lowEl||!upEl||!untEl) return;
  var combined=[modEl.value,lowEl.value,upEl.value,untEl.value]
    .map(function(v){ return (v||'').trim(); })
    .filter(function(v){ return v; })
    .join(' ')
    .replace(/(\d),(?=\d{3})/g,'$1');
  if(!combined) return;
  var p=parseSpecRaw(combined);
  if(!p.matched) return;
  modEl.value=normalizeModifier(p.specModifier)||'';
  lowEl.value=p.specValueLower||'';
  upEl.value=p.specValueUpper||'';
  untEl.value=p.units||'';
  toggleUpperField(cat);
}

// Construye el array de items para LS-QP08.01_TestResults desde un sample en memoria.
// Una fila por prueba individual dentro del TestsJSON. Each item also
// carries (non-SharePoint) _cat/_idx back-references so the caller can
// match each POST's returned ID back to its originating TestsJSON entry,
// to enrich TestsJSON with real test-result IDs once they exist.
function buildTestResultItems(sample) {
  var items = [];
  var tests = sample.tests || {};
  Object.keys(tests).forEach(function(code) {
    var testList = tests[code];
    if (!testList || testList.length === 0) return;
    var category = CAT_CODE_TO_LABEL[code] || code;
    testList.forEach(function(label,idx) {
      var p = parseTestLabel(label);
      items.push({
        Title         : sample.sampleID,
        DateReceived  : sample.dateReceived,
        Customer      : sample.customer,
        LotNumber     : sample.lotNumber || '',
        TestCategory  : category,
        Test          : p.test,
        Status        : 'Pending',
        SpecModifier  : p.specModifier,
        SpecValueLower: p.specValueLower,
        SpecValueUpper: p.specValueUpper,
        Units         : p.units,
        TestResults   : '',
        TestMethod    : '',
        SpecDisplay   : p.specDisplay,
        ResultsDisplay: '',
        _cat: code, _idx: idx
      });
    });
  });
  return items;
}

// Guarda el array de test-result items secuencialmente, capturando el ID
// real devuelto por cada POST (stashed onto the item itself) so the caller
// can enrich the sample's TestsJSON afterward. Si un item falla, lo loguea
// y continúa — el sample ya está commiteado.
function saveTestResultsRecursive(items, index, onDone) {
  if (index >= items.length) { onDone(); return; }
  var body={}; Object.keys(items[index]).forEach(function(k){ if(k!=='_cat'&&k!=='_idx') body[k]=items[index][k]; });
  spPost(PATH_TEST_RESULTS, body)
    .then(function(d) {
      if(d&&d.ID) items[index]._newId=d.ID;
      saveTestResultsRecursive(items, index + 1, onDone);
    })
    .catch(function(e) {
      console.error('saveTestResultsRecursive item ' + index + ':', e);
      saveTestResultsRecursive(items, index + 1, onDone);
    });
}

/* ════════════════════════════════════════════════════════════
   FINALIZE BATCH — sequential save to SharePoint
════════════════════════════════════════════════════════════ */
var batchSaveInProgress=false;
function _setFinalizeBtn(disabled){
  var btn=document.querySelector('#finalizeGroup .btn-primary');
  if(btn) btn.disabled=disabled;
}
function finalizeBatch(){
  if(batchSaveInProgress) return;
  if(batchSamples.length===0){ alert('No samples in batch.'); return; }
  batchSaveInProgress=true;
  _setFinalizeBtn(true);
  showLoading('Saving to SharePoint... (0/'+batchSamples.length+')');
  saveSamplesRecursive(batchSamples.slice(),0);
}
function saveSamplesRecursive(items,index){
  if(index>=items.length){
    batchSaveInProgress=false;
    _setFinalizeBtn(false);
    hideLoading();
    showAlert('alertNewSample','Batch '+batchID+' saved - '+items.length+' sample(s) registered in SharePoint','success');
    clearBatch();
    refreshDashboard();
    return;
  }
  document.getElementById('loadingMsg').textContent='Saving sample '+(index+1)+' of '+items.length+'...';
  // Post the TestResults rows FIRST (they only need the Sample ID text,
  // not the Sample's own SharePoint item, since Title is the Sample ID
  // string, not a lookup) so we know every test's real TestResults ID
  // *before* writing the Sample item -- TestsJSON goes out already
  // linked to those IDs in a single POST, instead of needing a second
  // PATCH afterward that could fail and leave the sample's tests
  // permanently unlinked (un-editable later) if anything went wrong.
  var testItems = buildTestResultItems(items[index]);
  saveTestResultsRecursive(testItems, 0, function(){
    var enriched={};
    Object.keys(items[index].tests||{}).forEach(function(cat){
      var labels=items[index].tests[cat]||[];
      enriched[cat]=labels.map(function(label,idx){
        var match=testItems.find(function(ti){ return ti._cat===cat&&ti._idx===idx; });
        return makeTestEntry(label, match?match._newId:null);
      });
    });
    items[index].tests=enriched;
    spPost(PATH_SAMPLES, sampleToSpItem(items[index]))
    .then(function(d){
      if(d&&d.ID) items[index]._spID=d.ID;
      // Remove this sample from the live batch the moment it's actually
      // confirmed saved -- so if a later sample in the batch fails, retrying
      // (finalizeBatch again) only resends what's left, instead of
      // re-posting already-saved samples as duplicates. Also reflect it in
      // allSamples right away instead of waiting for the whole batch to
      // finish, so a partial save still shows up in the UI immediately.
      var bsIdx=batchSamples.indexOf(items[index]);
      if(bsIdx>-1) batchSamples.splice(bsIdx,1);
      allSamples.unshift(items[index]);
      renderBatchSummary();
      saveSamplesRecursive(items, index+1);
    })
    .catch(function(e){
      batchSaveInProgress=false;
      _setFinalizeBtn(false);
      hideLoading();
      console.error('saveSamplesRecursive:',e);
      showBatchSaveError('Sample '+items[index].sampleID+' failed to save: '+e.message
        +'. '+(items.length-index-1>0?(items.length-index-1)+' more sample(s) in this batch were not yet attempted. ':'')
        +(index>0?(index)+' sample(s) earlier in this batch saved successfully and will not be re-sent.':''));
    });
  });
}
function showBatchSaveError(msg){
  var el=document.getElementById('alertNewSample');
  if(!el) return;
  clearTimeout(el._t);
  el.className='alert show error';
  el.innerHTML='<span>'+escHtml(msg)+'</span> '
    +'<button type="button" class="btn-secondary btn-sm" style="margin-left:10px" onclick="tryAgainBatch()">Try Again</button>';
  scrollAlertIntoView('alertNewSample');
}
// Before retrying, ask SP which samples in this batch already landed so we
// never re-post one whose request timed out on our end but succeeded on SP's.
function tryAgainBatch(){
  showLoading('Checking what was already saved…');
  spGet(PATH_SAMPLES+'?$select=Title&$filter=BatchID eq \''+odataEscapeLiteral(batchID)+'\'&$top=500')
  .then(function(d){
    var saved=new Set((d.value||[]).map(function(x){ return x.Title; }));
    batchSamples=batchSamples.filter(function(s){ return !saved.has(s.sampleID); });
    hideLoading();
    if(!batchSamples.length){
      showAlert('alertNewSample','All samples in this batch were already saved successfully.','success');
      clearBatch(); refreshDashboard();
    } else {
      finalizeBatch();
    }
  })
  .catch(function(){ hideLoading(); finalizeBatch(); });
}
function clearBatch(){
  nsClearPrefill();
  batchSamples=[]; batchID=''; batchTempUponReceipt='';
  document.getElementById('batchCustomer').value='';
  document.getElementById('batchDate').value=todayStr();
  document.getElementById('batchIDDisplay').value='';
  batchID='';
  var contBtn=document.getElementById('nsBatchContinueGroup');
  if(contBtn) contBtn.style.display='none';
  nsShowStep(1);
  clearSampleForm(); renderBatchSummary();
}
function clearSampleForm(){
  ['ns_sampleName','ns_extRef','ns_servingSize','ns_lotNumber','ns_remarks'].forEach(function(id){ document.getElementById(id).value=''; });
  document.getElementById('ns_matrix').value='';
  document.getElementById('ns_type').value='Finished Product';
  document.getElementById('ns_units').value='1';
  document.getElementById('ns_receivedBy').value=currentUserName;
  document.getElementById('ns_tat').value='';
  document.getElementById('ns_rushChk').checked=false;
  document.getElementById('ns_rushType').value='';
  document.getElementById('ns_rushTypeGroup').style.display='none';
  getCategoryCodes().forEach(function(cat){
    currentTestLists[cat]=[];
    renderTestList(cat);
    var chkEl=document.getElementById('chk-'+cat);
    var catEl=document.getElementById('cat-'+cat);
    var panelEl=document.getElementById('panel-'+cat);
    if(chkEl) chkEl.checked=false;
    if(catEl) catEl.classList.remove('selected');
    if(panelEl) panelEl.classList.remove('open');
  });
  updateSampleIDPreview();
}

/* ════════════════════════════════════════════════════════════
   BULK IMPORT (Step 3)
═══════════════════════════════════════════════════════════════
   CSV-based import for adding multiple samples at once.
   One row per test; rows grouped into samples by
   Lot Number -> Reference Number -> Sample Name.
════════════════════════════════════════════════════════════ */
var BI_TEMPLATE_URL='';
var biParsedSamples=[];

function biInitTemplateUrl(){
  if(siteUrl) BI_TEMPLATE_URL=siteUrl+'/SiteAssets/SMS_Bulk_Import_Template.csv';
}

function biDownloadTemplate(){
  if(!BI_TEMPLATE_URL){ biInitTemplateUrl(); }
  if(!BI_TEMPLATE_URL){ alert('SharePoint site URL not available yet. Please try again.'); return; }
  var a=document.createElement('a');
  a.href=BI_TEMPLATE_URL;
  a.download='SMS_Bulk_Import_Template.csv';
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
}

function biShowImport(){
  document.getElementById('biBanner').classList.add('bi-hidden');
  document.getElementById('nsSampleCounter').classList.add('bi-hidden');
  document.getElementById('nsSampleInfoCard').classList.add('bi-hidden');
  document.getElementById('nsTATCard').classList.add('bi-hidden');
  document.getElementById('nsTestsCard').classList.add('bi-hidden');
  document.getElementById('nsAddSampleGroup').classList.add('bi-hidden');
  document.getElementById('biImportPanel').classList.remove('bi-hidden');
  document.getElementById('biPreviewPanel').classList.add('bi-hidden');
  biResetUpload();
}

function biShowSingleEntry(){
  document.getElementById('biImportPanel').classList.add('bi-hidden');
  document.getElementById('biPreviewPanel').classList.add('bi-hidden');
  document.getElementById('biBanner').classList.remove('bi-hidden');
  document.getElementById('nsSampleCounter').classList.remove('bi-hidden');
  document.getElementById('nsSampleInfoCard').classList.remove('bi-hidden');
  document.getElementById('nsTATCard').classList.remove('bi-hidden');
  document.getElementById('nsTestsCard').classList.remove('bi-hidden');
  document.getElementById('nsAddSampleGroup').classList.remove('bi-hidden');
  biParsedSamples=[];
}

function biStartOver(){
  document.getElementById('biPreviewPanel').classList.add('bi-hidden');
  document.getElementById('biImportPanel').classList.remove('bi-hidden');
  biResetUpload();
  biParsedSamples=[];
}

function biResetUpload(){
  var inp=document.getElementById('biFileInput');
  if(inp) inp.value='';
  var status=document.getElementById('biUploadStatus');
  if(status){ status.className='alert'; status.textContent=''; }
}

function biShowUploadStatus(msg,type){
  var el=document.getElementById('biUploadStatus');
  if(!el) return;
  el.textContent=msg;
  el.className='alert show '+type;
}

function biHandleDrop(e){
  var files=e.dataTransfer&&e.dataTransfer.files;
  if(files&&files.length>0) biHandleFile(files[0]);
}

function biHandleFile(file){
  if(!file) return;
  var ext=(file.name||'').split('.').pop().toLowerCase();
  if(ext!=='csv'){
    biShowUploadStatus('Please upload a .csv file. Got: .'+ext,'error');
    return;
  }
  biShowUploadStatus('Reading file...','success');
  var reader=new FileReader();
  reader.onload=function(e){
    try{
      var text=e.target.result;
      var rows=biParseCSV(text);
      if(!rows.length){
        biShowUploadStatus('No data rows found. Make sure the file has a header row and at least one data row.','error');
        return;
      }
      biProcessRows(rows);
    }catch(err){
      biShowUploadStatus('Could not read this file: '+err.message,'error');
    }
  };
  reader.readAsText(file);
}

function biParseCSV(text){
  var lines=[];
  var current='';
  var inQuotes=false;
  for(var i=0;i<text.length;i++){
    var ch=text[i];
    if(inQuotes){
      if(ch==='"'){
        if(i+1<text.length&&text[i+1]==='"'){
          current+='"'; i++;
        }else{
          inQuotes=false;
        }
      }else{
        current+=ch;
      }
    }else{
      if(ch==='"'){
        inQuotes=true;
      }else if(ch==='\r'){
        continue;
      }else if(ch==='\n'){
        lines.push(current);
        current='';
      }else{
        current+=ch;
      }
    }
  }
  if(current) lines.push(current);

  if(lines.length<2) return [];

  var out=[];
  for(var li=1;li<lines.length;li++){
    var fields=biSplitRow(lines[li]);
    var name=(fields[0]||'').trim();
    var testName=(fields[7]||'').trim();
    var type=(fields[1]||'').trim();
    var lot=(fields[2]||'').trim();
    var refNo=(fields[3]||'').trim();
    var matrix=(fields[4]||'').trim();
    var amount=(fields[5]||'').trim();
    var serving=(fields[6]||'').trim();
    var comparator=(fields[8]||'').trim();
    var lower=(fields[9]||'').trim();
    var upper=(fields[10]||'').trim();
    var units=(fields[11]||'').trim();
    var rush=(fields[12]||'').trim();
    var rushType=(fields[13]||'').trim();
    var comments=(fields[14]||'').trim();
    var hasAny=[name,testName,type,lot,refNo,matrix,amount,serving,comparator,lower,upper,units,rush,rushType,comments]
      .some(function(v){ return v; });
    if(!hasAny) continue;
    out.push({
      name:name,lot:lot,refNo:refNo,type:type,matrix:matrix,
      amount:amount,serving:serving,testName:testName,
      comparator:comparator,lower:lower,upper:upper,units:units,
      rush:rush,rushType:rushType,comments:comments
    });
  }
  return out;
}

function biSplitRow(line){
  var fields=[];
  var current='';
  var inQuotes=false;
  for(var i=0;i<line.length;i++){
    var ch=line[i];
    if(inQuotes){
      if(ch==='"'){
        if(i+1<line.length&&line[i+1]==='"'){
          current+='"'; i++;
        }else{
          inQuotes=false;
        }
      }else{
        current+=ch;
      }
    }else{
      if(ch==='"'){
        inQuotes=true;
      }else if(ch===','){
        fields.push(current);
        current='';
      }else{
        current+=ch;
      }
    }
  }
  fields.push(current);
  return fields;
}

function biGroupingKey(row){
  if(row.lot&&row.lot.toUpperCase()!=='NA') return{key:'lot:'+row.lot,fallback:false};
  if(row.refNo&&row.refNo.toUpperCase()!=='NA') return{key:'ref:'+row.refNo,fallback:false};
  return{key:'name:'+(row.name||'').toLowerCase(),fallback:true};
}

function biResolveCategory(testName){
  if(!testName) return null;
  var lc=testName.trim().toLowerCase();
  var match=allSampleTests.find(function(t){ return t.title.toLowerCase()===lc; });
  if(!match) return null;
  var catLookup={};
  Object.keys(CAT_CODE_TO_ST).forEach(function(code){
    catLookup[CAT_CODE_TO_ST[code].toLowerCase()]=code;
  });
  return catLookup[(match.category||'').toLowerCase()]||null;
}

function biProcessRows(rows){
  var groups={};
  var order=[];
  rows.forEach(function(r){
    var g=biGroupingKey(r);
    if(!groups[g.key]){ groups[g.key]={rows:[],fallback:g.fallback}; order.push(g.key); }
    groups[g.key].rows.push(r);
  });

  biParsedSamples=order.map(function(key){
    var g=groups[key];
    var first=g.rows[0];
    var errors=[];
    var warnings=[];

    if(!first.name) errors.push('Sample Name is required');
    var nameConsistent=g.rows.every(function(r){ return r.name===first.name; });
    if(!nameConsistent) errors.push('Sample Name differs across rows grouped under this sample');

    if(!first.matrix) warnings.push('Matrix is blank');
    if(!first.refNo) warnings.push('Reference Number is blank');
    if(/^yes$/i.test(first.rush)&&!first.rushType) warnings.push('Rush Type is blank even though Rush = Yes');
    if(g.fallback) warnings.push('No Lot Number or Reference Number found '+String.fromCharCode(8212)+' rows were grouped by Sample Name only');

    var tests=g.rows.map(function(r){
      var testErr=!r.testName?'Test Name is required':null;
      var category=testErr?null:biResolveCategory(r.testName);
      return{
        testName:r.testName,
        category:category,
        specModifier:r.comparator?normalizeModifier(r.comparator):'',
        specValueLower:r.lower,
        specValueUpper:r.upper,
        units:r.units,
        specDisplay:[r.comparator,r.lower,r.upper?'- '+r.upper:'',r.units].filter(Boolean).join(' '),
        error:testErr
      };
    });

    if(tests.length===0) errors.push('At least one test is required');
    var hasTestErrors=tests.some(function(t){ return t.error; });
    var hasErrors=errors.length>0||hasTestErrors;
    var hasWarnings=warnings.length>0;

    return{
      sampleName:first.name,
      sampleType:first.type||'Finished Product',
      lotNumber:first.lot,
      refNumber:first.refNo,
      matrix:first.matrix,
      amount:first.amount,
      servingSize:first.serving,
      comments:first.comments,
      isRush:/^yes$/i.test(first.rush),
      rushType:first.rushType,
      tests:tests,
      errors:errors,
      warnings:warnings,
      hasErrors:hasErrors,
      hasWarnings:hasWarnings
    };
  });

  biRenderPreview();
}

function biRenderPreview(){
  var samples=biParsedSamples;
  var totalTests=samples.reduce(function(n,s){ return n+s.tests.length; },0);
  var errorSamples=samples.filter(function(s){ return s.hasErrors; });
  var warningSamples=samples.filter(function(s){ return s.hasWarnings&&!s.hasErrors; });

  document.getElementById('biStatSamples').textContent=samples.length;
  document.getElementById('biStatTests').textContent=totalTests;
  document.getElementById('biStatWarnings').textContent=warningSamples.length;
  document.getElementById('biStatErrors').textContent=errorSamples.length;

  var catNames={};
  Object.keys(CAT_CODE_TO_ST).forEach(function(code){
    catNames[code]=CAT_CODE_TO_ST[code];
  });

  var html=samples.map(function(s){
    var testRowsHtml=s.tests.map(function(t){
      var catHtml=(t.error||!t.category)?'':'<span class="bi-test-cat">'+escHtml(catNames[t.category]||t.category)+'</span>';
      return '<div class="bi-test-row'+(t.error?' err':'')+'">'
        +'<span class="bi-test-name">'+escHtml(t.testName||'(empty)')+catHtml+'</span>'
        +'<span class="bi-test-spec">'+(t.error?escHtml(t.error):escHtml(t.specDisplay||String.fromCharCode(8212)))+'</span>'
        +'</div>';
    }).join('');

    var idBits=[];
    if(s.lotNumber) idBits.push('Lot: '+escHtml(s.lotNumber));
    if(s.refNumber) idBits.push('Ref: '+escHtml(s.refNumber));
    var idLine=idBits.length?idBits.join(' | '):'No Lot or Reference Number';

    var statusClass=s.hasErrors?'error':(s.hasWarnings?'warning':'ready');
    var statusLabel=s.hasErrors?'Needs Fixes':(s.hasWarnings?'Review':'Ready');

    var reviewItems='';
    s.errors.forEach(function(e){
      reviewItems+='<div class="bi-review-note err"><svg class="icon" aria-hidden="true"><use href="#icon-warning-outline"></use></svg>'+escHtml(e)+'</div>';
    });
    s.warnings.forEach(function(w){
      reviewItems+='<div class="bi-review-note"><svg class="icon" aria-hidden="true"><use href="#icon-warning-outline"></use></svg>'+escHtml(w)+'</div>';
    });

    return '<div class="bi-group">'
      +'<div class="bi-group-hdr"><div>'
      +'<div class="bi-group-name">'+escHtml(s.sampleName||'(unnamed)')+'</div>'
      +'<div class="bi-group-meta">'+idLine+' | '+s.tests.length+' test(s)</div>'
      +'</div><span class="bi-status '+statusClass+'">'+statusLabel+'</span></div>'
      +reviewItems
      +testRowsHtml
      +'</div>';
  }).join('');

  document.getElementById('biGroupedPreview').innerHTML=html;

  var hasAnyWarnings=samples.some(function(s){ return s.hasWarnings; });
  document.getElementById('biChkWarnRow').style.display=hasAnyWarnings?'flex':'none';
  document.getElementById('biChkAccuracy').checked=false;
  document.getElementById('biChkWarnings').checked=false;

  document.getElementById('biImportPanel').classList.add('bi-hidden');
  document.getElementById('biPreviewPanel').classList.remove('bi-hidden');
  biUpdateImportBtn();
}

function biUpdateImportBtn(){
  var btn=document.getElementById('biImportBtn');
  if(!btn) return;
  var importable=biParsedSamples.filter(function(s){ return !s.hasErrors; });
  var acc=document.getElementById('biChkAccuracy').checked;
  var hasWarnings=biParsedSamples.some(function(s){ return s.hasWarnings; });
  var warnOk=hasWarnings?document.getElementById('biChkWarnings').checked:true;
  btn.disabled=!(acc&&warnOk&&importable.length>0);
  btn.innerHTML='<svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Import '+importable.length+' Sample'+(importable.length!==1?'s':'');
}

function biPerformImport(){
  var cust=document.getElementById('batchCustomer').value;
  var date=document.getElementById('batchDate').value;
  if(!cust||!date){
    showAlert('alertNewSample','Set Customer and Date in Step 1 first','error');
    scrollAlertIntoView('alertNewSample');
    return;
  }
  var importable=biParsedSamples.filter(function(s){ return !s.hasErrors; });
  if(importable.length===0) return;

  showLoading('Generating Sample IDs for '+importable.length+' sample'+(importable.length!==1?'s':'')+'...');
  var recv=currentUserName;

  biGenerateIdsRecursive(importable,date,0,function(){
    importable.forEach(function(s){
      var testLists={};
      getCategoryCodes().forEach(function(cat){ testLists[cat]=[]; });
      s.tests.forEach(function(t){
        var cat=t.category||'general';
        if(!testLists[cat]) testLists[cat]=[];
        var specParts=[t.specModifier,t.specValueLower,t.specValueUpper,t.units].filter(Boolean);
        var label=t.testName+(specParts.length?' '+String.fromCharCode(8212)+' '+specParts.join(' '):'');
        testLists[cat].push(label);
      });
      var tatDays=computeTAT(testLists);
      var tat=tatDays>0?(tatDays+' days'):'';

      var sample={
        sampleID:s._generatedID,
        reportID:genReportID(s._generatedID),
        batchID:batchID,
        customer:cust,
        sampleName:s.sampleName,
        lotNumber:s.lotNumber||'',
        extRef:s.refNumber||'',
        tempUponReceipt:batchTempUponReceipt,
        servingSize:s.servingSize||'',
        matrix:s.matrix||'',
        type:s.sampleType||'Finished Product',
        units:1,
        receivedBy:recv,
        tat:tat,
        dateReceived:date,
        tatDeadline:tatDeadline(date,tat),
        status:'Pending',
        statusNotes:'',
        isRush:s.isRush||false,
        rushType:s.rushType||'',
        remarks:s.comments||'',
        tests:testLists
      };
      batchSamples.push(sample);
    });

    hideLoading();
    biParsedSamples=[];
    renderBatchSummary();
    biShowSingleEntry();
    nsShowStep(4);
    showAlert('alertNewSample','Imported '+importable.length+' sample'+(importable.length!==1?'s':'')+' into batch ('+batchSamples.length+' total)','success');
  });
}

function biGenerateIdsRecursive(samples,date,index,done){
  if(index>=samples.length){ done(); return; }
  genSampleIDAsync(date).then(function(sid){
    samples[index]._generatedID=sid;
    biGenerateIdsRecursive(samples,date,index+1,done);
  });
}

/* ════════════════════════════════════════════════════════════
   DASHBOARD
════════════════════════════════════════════════════════════ */
// Lightweight paginated read of every ReceivedSamples row (just the fields
// the KPI cards/at-risk widget need), following odata.nextLink past the
// 5,000-item page size -- used so Dashboard KPIs reflect the whole system,
// not just the capped local 500-record cache (`allSamples`).
function getAllSamplesForKPI(cb){
  var fields='Title,Customer,Status,TAT_Deadline';
  var items=[];
  function step(url){
    fetch(url,{credentials:'include',headers:{'Accept':'application/json;odata=nometadata'}})
      .then(function(r){ if(!r.ok) throw new Error('GET '+r.status); return r.json(); })
      .then(function(d){
        items=items.concat(d.value||[]);
        var next=d['odata.nextLink'];
        if(next){
          if(!/^https?:\/\//i.test(next)){
            var host=SP_URL.split('/sites/')[0];
            next=host+'/'+next.replace(/^\//,'');
          }
          step(next);
        } else {
          cb(items.map(function(item){
            return{ sampleID:item.Title||'', customer:item.Customer||'',
                    status:item.Status||'Pending', tatDeadline:dateOnly(item.TAT_Deadline) };
          }));
        }
      })
      .catch(function(e){
        console.error('getAllSamplesForKPI:',e);
        cb(null);
      });
  }
  step(SP_URL+PATH_SAMPLES+'?$select='+fields+'&$top=5000');
}

function renderDashboardKPIs(s){
  var elApproved=document.getElementById('statApproved');
  if(elApproved) elApproved.textContent=s.filter(function(x){ return x.status==='Approved/Released'; }).length;
  var elTesting=document.getElementById('statTesting');
  if(elTesting) elTesting.textContent=s.filter(function(x){ return x.status==='In Progress'||x.status==='Testing Complete'; }).length;
  var elPending=document.getElementById('statPending');
  if(elPending) elPending.textContent=s.filter(function(x){ return x.status==='Pending'; }).length;

  var today=new Date(); today.setHours(0,0,0,0);
  var atRisk=s.filter(function(x){
    if(x.status==='Approved/Released'||!x.tatDeadline) return false;
    var p=parseDateParts(x.tatDeadline);
    return Math.ceil((new Date(p.y,p.m-1,p.d)-today)/(864e5))<=2;
  });
  var elAtRisk=document.getElementById('statAtRisk');
  if(elAtRisk) elAtRisk.textContent=atRisk.length;

  atRiskAll=atRisk;
  atRiskShown=0;
  var riskEl=document.getElementById('riskTable');
  var riskWidget=riskEl.closest('.risk-widget');
  if(!atRisk.length){
    if(riskWidget) riskWidget.classList.add('safe');
    riskEl.innerHTML='<div class="empty-state" style="color:#2e7d32"><svg class="icon" aria-hidden="true"><use href="#icon-check-outline"></use></svg> No samples at risk.</div>';
    updateRiskLoadMore(); return;
  }
  if(riskWidget) riskWidget.classList.remove('safe');
  atRiskShown=Math.min(RISK_PAGE,atRisk.length);
  riskEl.innerHTML='<div class="table-wrap"><table><thead><tr>'
    +'<th>Sample ID</th><th>Customer</th><th>Deadline</th><th>TAT Status</th><th>Status</th><th></th>'
    +'</tr></thead><tbody>'+riskRows(atRisk.slice(0,atRiskShown))+'</tbody></table></div>';
  updateRiskLoadMore();
}

function riskRows(list){
  return list.map(function(x){
    var ti=tatDisplay(x);
    return '<tr>'
      +'<td data-label="Sample ID"><strong>'+x.sampleID+'</strong></td>'
      +'<td data-label="Customer">'+escHtml(x.customer)+'</td>'
      +'<td data-label="Deadline">'+x.tatDeadline+'</td>'
      +'<td data-label="TAT Status"><span class="tat-pill '+ti.cls+'">'+ti.txt+'</span></td>'
      +'<td data-label="Status"><span class="badge badge-'+badgeCls(x.status)+'">'+x.status+'</span></td>'
      +'<td data-label=""><button class="btn-primary btn-sm" onclick="openModal(\''+x.sampleID+'\')">View</button></td></tr>';
  }).join('');
}

function updateRiskLoadMore(){
  document.getElementById('riskLoadMoreWrap').style.display=
    atRiskShown<atRiskAll.length?'':'none';
}

function loadMoreRisk(){
  var next=atRiskAll.slice(atRiskShown,atRiskShown+RISK_PAGE);
  var tbody=document.querySelector('#riskTable tbody');
  if(tbody) tbody.insertAdjacentHTML('beforeend',riskRows(next));
  atRiskShown+=next.length;
  updateRiskLoadMore();
}

function refreshDashboard(){
  var s=allSamples;

  // KPI cards and the At Risk widget reflect EVERY sample in the system,
  // not just the capped local 500 -- fetched separately, asynchronously.
  ['statApproved','statTesting','statPending','statAtRisk'].forEach(function(id){
    var el=document.getElementById(id);
    if(el) el.textContent=String.fromCharCode(8230);
  });
  getAllSamplesForKPI(function(allForKPI){
    renderDashboardKPIs(allForKPI||s);
  });

  var recentEl=document.getElementById('recentList');
  var rec=s.slice(0,5);
  recentEl.innerHTML=rec.length?rec.map(function(x){
    return '<div class="recent-item" onclick="openModal(\''+x.sampleID+'\')"><strong>'+x.sampleID+'</strong> &#8212; '
      +escHtml(x.customer)+' | '+escHtml(x.sampleName)
      +' <span class="badge badge-'+badgeCls(x.status)+'">'+x.status+'</span></div>';
  }).join(''):'<div class="empty-state">No samples yet.</div>';

  var ovEl=document.getElementById('dashOverviewTable');
  ovEl.innerHTML=s.length?'<div class="table-wrap"><table><thead><tr>'
    +'<th>Sample ID</th><th>Customer</th><th>Sample</th><th>Date Received</th><th>TAT</th><th>Status</th><th></th>'
    +'</tr></thead><tbody>'+s.slice(0,10).map(function(x){
      var ti=tatDisplay(x);
      return '<tr>'
        +'<td data-label="Sample ID"><strong>'+x.sampleID+'</strong></td>'
        +'<td data-label="Customer">'+escHtml(x.customer)+'</td>'
        +'<td data-label="Sample">'+escHtml(x.sampleName)+'</td>'
        +'<td data-label="Date Received">'+x.dateReceived+'</td>'
        +'<td data-label="TAT Status"><span class="tat-pill '+ti.cls+'">'+ti.txt+'</span></td>'
        +'<td data-label="Status"><span class="badge badge-'+badgeCls(x.status)+'">'+x.status+'</span></td>'
        +'<td data-label=""><button class="btn-primary btn-sm" onclick="openModal(\''+x.sampleID+'\')">View</button></td></tr>';
    }).join('')+'</tbody></table></div>'
    :'<div class="empty-state">No samples yet. Register the first one in New Sample / Batch.</div>';
}
function reloadAndRefresh(){ loadSamples(refreshDashboard); }

/* ════════════════════════════════════════════════════════════
   MASTER LIST
════════════════════════════════════════════════════════════ */
var atRiskAll=[];
var atRiskShown=0;
var RISK_PAGE=10;
var masterSearchResults=null; // null=local cache, array=server search results
var masterListFiltered=[];
var masterListShown=0;
var MASTER_PAGE=10;

function masterListRows(samples){
  return samples.map(function(s){
    var ti=tatDisplay(s);
    return '<tr>'
      +'<td data-label="Sample ID"><span class="sid-wrap"><strong>'+s.sampleID+'</strong>'+editedPill(s.sampleID)+'</span></td>'
      +'<td data-label="Date">'+s.dateReceived+'</td>'
      +'<td data-label="Batch ID">'+s.batchID+'</td>'
      +'<td data-label="Customer">'+escHtml(s.customer)+'</td>'
      +'<td data-label="Sample Name">'+escHtml(s.sampleName)+'</td>'
      +'<td data-label="Lot #">'+(s.lotNumber||' - ')+'</td>'
      +'<td data-label="Matrix">'+s.matrix+'</td>'
      +'<td data-label="Status"><span class="badge badge-'+badgeCls(s.status)+'">'+s.status+'</span></td>'
      +'<td data-label="TAT Status"><span class="tat-pill '+ti.cls+'">'+ti.txt+'</span></td>'
      +'<td data-label="TAT">'+s.tat+'</td>'
      +'<td data-label=""><button class="btn-primary btn-sm" onclick="openModal(\''+s.sampleID+'\')">View</button></td></tr>';
  }).join('');
}

function updateMasterLoadMore(){
  document.getElementById('masterLoadMoreWrap').style.display=
    masterListShown<masterListFiltered.length?'':'none';
}

function renderMasterList(){
  var q=(document.getElementById('masterSearch').value||'').toLowerCase();
  var pool=masterSearchResults!==null?masterSearchResults:poolFor('master',q,allSamples);
  masterListFiltered=pool.filter(function(s){
    if(q&&!(s.sampleID.toLowerCase().includes(q)||s.customer.toLowerCase().includes(q)||
            (s.lotNumber||'').toLowerCase().includes(q)||s.status.toLowerCase().includes(q)||
            s.sampleName.toLowerCase().includes(q))) return false;
    if(masterSearchResults===null){
      var fDate=document.getElementById('fDate').value;
      var fC=document.getElementById('fClient').value;
      var fS=document.getElementById('fStatus').value;
      if(fDate&&!s.dateReceived.includes(fDate.substring(4))) return false;
      if(fC&&s.customer!==fC) return false;
      if(fS&&s.status!==fS) return false;
    }
    return true;
  });
  masterListShown=0;
  var el=document.getElementById('masterListContainer');
  if(!masterListFiltered.length){
    el.innerHTML='<div class="empty-state">No samples match the selected filters.</div>';
    updateMasterLoadMore(); return;
  }
  masterListShown=Math.min(MASTER_PAGE,masterListFiltered.length);
  el.innerHTML='<div class="table-wrap"><table><thead><tr>'
    +'<th>Sample ID</th><th>Date</th><th>Batch ID</th><th>Customer</th><th>Sample Name</th>'
    +'<th>Lot #</th><th>Matrix</th><th>Status</th><th>TAT Status</th><th>TAT</th><th></th>'
    +'</tr></thead><tbody>'
    +masterListRows(masterListFiltered.slice(0,masterListShown))
    +'</tbody></table></div>';
  updateMasterLoadMore();
}

function loadMoreMasterList(){
  var next=masterListFiltered.slice(masterListShown,masterListShown+MASTER_PAGE);
  var tbody=document.querySelector('#masterListContainer tbody');
  if(tbody) tbody.insertAdjacentHTML('beforeend',masterListRows(next));
  masterListShown+=next.length;
  updateMasterLoadMore();
}

function clearFilters(){
  ['fDate','fClient','fStatus'].forEach(function(id){ document.getElementById(id).value=''; });
  document.getElementById('fDate').classList.remove('has-value');
  document.getElementById('masterSearch').value='';
  masterSearchResults=null;
  renderMasterList();
}
function runMasterSearch(){
  var q=(document.getElementById('masterSearch').value||'').trim();
  var fDate=document.getElementById('fDate').value;
  var fC=document.getElementById('fClient').value;
  var fS=document.getElementById('fStatus').value;
  if(!q&&!fDate&&!fC&&!fS){
    masterSearchResults=null;
    renderMasterList();
    return;
  }
  var btn=document.getElementById('masterSearchBtn');
  var orig=btn.innerHTML;
  btn.disabled=true; btn.innerHTML='Searching&#8230;';
  function done(results){
    btn.disabled=false; btn.innerHTML=orig;
    if(results===null){showAlertGeneric('Search failed. Please try again.'); return;}
    masterSearchResults=results;
    deepSearchSeenSamples=mergeSamplesUnique(deepSearchSeenSamples,results);
    renderMasterList();
  }
  // Build $filter from structured fields
  // fDate is 'YYYY-MM-DD'; filter by month+day only (substring(4) = '-MM-DD') to ignore year
  var spFilters=[];
  if(fDate) spFilters.push("substringof('"+odataEscapeLiteral(fDate.substring(4))+"',DateReceived)");
  if(fC) spFilters.push("Customer eq '"+odataEscapeLiteral(fC)+"'");
  if(fS) spFilters.push("Status eq '"+odataEscapeLiteral(fS)+"'");
  var filterStr=spFilters.join(' and ');
  if(filterStr){
    spGet(PATH_SAMPLES+'?$select='+SAMPLE_FIELDS+'&$filter='+encodeURIComponent(filterStr)+'&$top=500')
    .then(function(d){done((d.value||[]).map(spItemToSample));})
    .catch(function(){done(null);});
  } else {
    // Text-only: search Title + Customer (indexed) and LotNumber in parallel
    var esc=odataEscapeLiteral(q);
    Promise.all([
      new Promise(function(res){ searchSamplesServerSide(q,res); }),
      spGet(PATH_SAMPLES+'?$select='+SAMPLE_FIELDS+'&$filter=substringof(\''+esc+'\',LotNumber)&$top=200')
        .then(function(d){ return (d.value||[]).map(spItemToSample); })
        .catch(function(){ return []; })
    ]).then(function(arrays){
      done(mergeSamplesUnique(arrays[0]||[],arrays[1]));
    }).catch(function(){ done(null); });
  }
}

function reloadAndMasterList(){ loadSamples(renderMasterList); }

function exportCSV(){
  if(!allSamples.length){ alert('No samples to export.'); return; }
  var hdr='Sample ID,Report ID,Date Received,Batch ID,Customer,Sample Name,Lot Number,Ext. Ref.,Matrix,Type,Temp. Upon Receipt,Units,Received By,TAT,TAT Deadline,Status,Test Categories,Remarks\n';
  var rows=allSamples.map(function(s){
    var cats=Object.entries(s.tests||{}).filter(function(e){ return e[1]&&e[1].length; }).map(function(e){ return e[0]; }).join('|');
    return[s.sampleID,s.reportID,s.dateReceived,s.batchID,'"'+s.customer+'"',
      '"'+s.sampleName+'"',s.lotNumber||'',s.extRef||'',s.matrix,s.type,s.tempUponReceipt||'',s.units,
      s.receivedBy,s.tat,s.tatDeadline,s.status,'"'+cats+'"','"'+(s.remarks||'')+'"'].join(',');
  }).join('\n');
  var blob=new Blob([hdr+rows],{type:'text/csv;charset=utf-8;'});
  var url=URL.createObjectURL(blob);
  var a=document.createElement('a'); a.href=url; a.download='Samples_'+todayStr()+'.csv';
  document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url);
}

/* ════════════════════════════════════════════════════════════
   GLOBAL SEARCH
════════════════════════════════════════════════════════════ */
var globalSearchHits=[];
var globalSearchShown=0;
var GLOBAL_SEARCH_PAGE=10;

function globalSearchRows(samples){
  return samples.map(function(s){
    return '<tr><td><span class="sid-wrap"><strong>'+s.sampleID+'</strong>'+editedPill(s.sampleID)+'</span></td><td>'+escHtml(s.customer)+'</td>'
      +'<td>'+escHtml(s.sampleName)+'</td><td>'+s.dateReceived+'</td>'
      +'<td><span class="badge badge-'+badgeCls(s.status)+'">'+s.status+'</span></td>'
      +'<td><button class="btn-primary btn-sm" onclick="openModal(\''+s.sampleID+'\')">View</button></td></tr>';
  }).join('');
}

function updateGlobalSearchLoadMore(){
  document.getElementById('globalSearchLoadMoreWrap').style.display=
    globalSearchShown<globalSearchHits.length?'':'none';
}

function paintGlobalSearch(pool,q,el){
  globalSearchHits=pool.filter(function(s){
    return s.sampleID.toLowerCase().includes(q)||s.customer.toLowerCase().includes(q)||
           (s.lotNumber||'').toLowerCase().includes(q)||s.sampleName.toLowerCase().includes(q);
  });
  globalSearchShown=0;
  if(!globalSearchHits.length){
    el.innerHTML='<div class="card"><div class="empty-state">No samples match "'+escHtml(q)+'"</div></div>';
    updateGlobalSearchLoadMore(); return;
  }
  globalSearchShown=Math.min(GLOBAL_SEARCH_PAGE,globalSearchHits.length);
  el.innerHTML='<div class="card"><h2>Search Results ('+globalSearchHits.length+')</h2>'
    +'<div class="table-wrap"><table><thead><tr><th>Sample ID</th><th>Customer</th><th>Sample</th><th>Date</th><th>Status</th><th></th></tr></thead><tbody>'
    +globalSearchRows(globalSearchHits.slice(0,globalSearchShown))
    +'</tbody></table></div></div>';
  updateGlobalSearchLoadMore();
}

function loadMoreGlobalSearch(){
  var next=globalSearchHits.slice(globalSearchShown,globalSearchShown+GLOBAL_SEARCH_PAGE);
  var tbody=document.querySelector('#globalSearchResults tbody');
  if(tbody) tbody.insertAdjacentHTML('beforeend',globalSearchRows(next));
  globalSearchShown+=next.length;
  updateGlobalSearchLoadMore();
}
function runGlobalSearch(){
  var raw=document.getElementById('globalSearch').value.trim();
  var q=raw.toLowerCase();
  var el=document.getElementById('globalSearchResults');
  if(!q){ el.innerHTML=''; globalSearchHits=[]; globalSearchShown=0; updateGlobalSearchLoadMore(); return; }
  if(!samplesAtCap){ paintGlobalSearch(allSamples,q,el); return; }
  // Local cache may not have everything -- since this is an explicit click
  // (not per-keystroke), also check live SharePoint and merge the results.
  var btn=document.getElementById('globalSearchBtn');
  var orig=btn.innerHTML;
  btn.disabled=true; btn.innerHTML='Searching&#8230;';
  searchSamplesServerSide(raw,function(results){
    btn.disabled=false; btn.innerHTML=orig;
    if(results) deepSearchSeenSamples=mergeSamplesUnique(deepSearchSeenSamples,results);
    paintGlobalSearch(results===null?allSamples:mergeSamplesUnique(allSamples,results),q,el);
  });
}

/* ════════════════════════════════════════════════════════════
   UPDATE STATUS
════════════════════════════════════════════════════════════ */
var statusListFiltered=[];
var statusListShown=0;
var STATUS_PAGE=10;

function statusListRows(samples){
  return samples.map(function(s){
    var chk=selectedStatusIDs.indexOf(s.sampleID)>-1;
    return '<tr class="'+(chk?'status-row-selected':'')+'">'
      +'<td data-label=""><input type="checkbox" class="status-chk" '+(chk?'checked':'')+' onchange="toggleStatusRow(\''+s.sampleID+'\',this.checked)"></td>'
      +'<td data-label="Sample ID"><span class="sid-wrap"><strong>'+s.sampleID+'</strong>'+editedPill(s.sampleID)+'</span></td>'
      +'<td data-label="Customer">'+escHtml(s.customer)+'</td>'
      +'<td data-label="Sample">'+escHtml(s.sampleName)+'</td>'
      +'<td data-label="Status"><span class="badge badge-'+badgeCls(s.status)+'">'+s.status+'</span></td>'
      +'<td data-label="Date">'+s.dateReceived+'</td>'
      +'</tr>';
  }).join('');
}

function updateStatusLoadMore(){
  document.getElementById('statusLoadMoreWrap').style.display=
    statusListShown<statusListFiltered.length?'':'none';
}

var statusListLastQuery=null;

function renderStatusList(){
  var q=(document.getElementById('statusSearch').value||'').toLowerCase();
  var pool=poolFor('status',q,allSamples);
  statusListFiltered=pool.filter(function(s){
    return !q||s.sampleID.toLowerCase().includes(q)||s.customer.toLowerCase().includes(q)||s.sampleName.toLowerCase().includes(q);
  });
  // Only reset back to page 1 when the search itself actually changed --
  // re-renders triggered by checkbox selection (same query) keep however
  // many rows were already loaded instead of collapsing the list.
  var queryChanged=q!==statusListLastQuery;
  statusListLastQuery=q;
  var el=document.getElementById('statusListContainer');
  if(!statusListFiltered.length){
    statusListShown=0;
    el.innerHTML='<div class="card"><div class="empty-state">No samples found.</div></div>';
    updateStatusLoadMore(); return;
  }
  statusListShown=queryChanged||statusListShown<=0
    ?Math.min(STATUS_PAGE,statusListFiltered.length)
    :Math.min(statusListShown,statusListFiltered.length);
  el.innerHTML='<div class="card"><h2>Sample Status List</h2>'
    +'<div class="table-wrap"><table><thead><tr>'
    +'<th style="width:44px"></th>'
    +'<th>Sample ID</th><th>Customer</th><th>Sample</th><th>Status</th><th>Date</th>'
    +'</tr></thead><tbody>'
    +statusListRows(statusListFiltered.slice(0,statusListShown))
    +'</tbody></table></div></div>';
  updateStatusLoadMore();
}

function loadMoreStatusList(){
  var next=statusListFiltered.slice(statusListShown,statusListShown+STATUS_PAGE);
  var tbody=document.querySelector('#statusListContainer tbody');
  if(tbody) tbody.insertAdjacentHTML('beforeend',statusListRows(next));
  statusListShown+=next.length;
  updateStatusLoadMore();
}
function toggleStatusRow(sid, checked){
  if(checked){
    if(selectedStatusIDs.indexOf(sid)===-1) selectedStatusIDs.push(sid);
  } else {
    selectedStatusIDs=selectedStatusIDs.filter(function(id){ return id!==sid; });
  }
  refreshStatusEditCard();
  renderStatusList();
}
function refreshStatusEditCard(){
  var card=document.getElementById('statusEditCard');
  if(selectedStatusIDs.length===0){
    card.style.display='none';
    return;
  }
  document.getElementById('newStatusSel').value='';
  document.getElementById('statusNotes').value='';
  var prevHtml=selectedStatusIDs.map(function(sid){
    var s=allSamples.find(function(x){ return x.sampleID===sid; })
      ||deepSearchSeenSamples.find(function(x){ return x.sampleID===sid; });
    if(!s) return '';
    return '<span class="status-id-capsule">'
      +'<strong>'+escHtml(sid)+'</strong>'
      +' <span class="badge badge-'+badgeCls(s.status)+'">'+s.status+'</span>'
      +'</span>';
  }).join('');
  document.getElementById('statusPrevList').innerHTML=prevHtml;
  if(card.style.display==='none'){
    card.style.display='block';
    card.scrollIntoView({behavior:'smooth'});
  }
}
function saveStatus(){
  var ns=document.getElementById('newStatusSel').value;
  var notes=document.getElementById('statusNotes').value;
  if(!ns){ showAlert('alertStatus','Select a new status','error'); scrollAlertIntoView('alertStatus'); return; }
  if(!selectedStatusIDs.length){ showAlert('alertStatus','No samples selected','error'); scrollAlertIntoView('alertStatus'); return; }
  var toUpdate=selectedStatusIDs.map(function(sid){
    var s=allSamples.find(function(x){ return x.sampleID===sid; })
      ||deepSearchSeenSamples.find(function(x){ return x.sampleID===sid; });
    return s||null;
  }).filter(Boolean);
  var missing=toUpdate.filter(function(s){ return !s._spID; });
  if(missing.length){ showAlert('alertStatus','SharePoint ID missing for some samples - try refreshing','error'); scrollAlertIntoView('alertStatus'); return; }
  showLoading('Updating '+(toUpdate.length>1?toUpdate.length+' samples':'status')+' in SharePoint...');
  // Auto-stamp TestDate the moment a sample's status is set to Testing Complete —
  // no separate manual entry needed, piggybacks on this existing action.
  var patchBody={Status:ns,StatusNotes:notes};
  var stampTestDate=ns==='Testing Complete';
  if(stampTestDate) patchBody.TestDate=todayStr();
  var promises=toUpdate.map(function(s){
    return spPatch(PATH_SAMPLES,s._spID,patchBody)
      .then(function(){
        var idx=allSamples.findIndex(function(x){ return x.sampleID===s.sampleID; });
        if(idx>-1){
          allSamples[idx].status=ns; allSamples[idx].statusNotes=notes;
          if(stampTestDate) allSamples[idx].testDate=patchBody.TestDate;
        }
        var dIdx=deepSearchSeenSamples.findIndex(function(x){ return x.sampleID===s.sampleID; });
        if(dIdx>-1){
          deepSearchSeenSamples[dIdx].status=ns; deepSearchSeenSamples[dIdx].statusNotes=notes;
          if(stampTestDate) deepSearchSeenSamples[dIdx].testDate=patchBody.TestDate;
        }
      });
  });
  Promise.all(promises)
    .then(function(){
      hideLoading();
      showAlert('alertStatus','Status updated to: '+ns+(toUpdate.length>1?' for '+toUpdate.length+' samples':''),'success');
      scrollAlertIntoView('alertStatus');
      cancelStatusEdit(); renderStatusList();
    })
    .catch(function(e){
      hideLoading();
      showAlert('alertStatus','Error: '+e.message,'error');
      scrollAlertIntoView('alertStatus');
    });
}
function cancelStatusEdit(){
  editingSampleID=null; editingSPID=null;
  selectedStatusIDs=[];
  document.getElementById('statusEditCard').style.display='none';
  renderStatusList();
}
function reloadAndStatusList(){ selectedStatusIDs=[]; loadSamples(renderStatusList); }

/* ════════════════════════════════════════════════════════════
   IN-HOUSE TESTING
════════════════════════════════════════════════════════════ */
var allInhouseTests=[];
var inhouseEditMode=false;
var inhouseDirty={};
var inhouseNewRows=[];
var inhouseNewCounter=0;
var inhouseDeleted=[];

function loadInhouseTests(cb){
  showLoading('Loading tests from SharePoint...');
  spGet(PATH_VERTEX_TESTS+'?$expand=SampleTestID&$select=ID,Method,Status,AccreditationStatus,SampleTestIDId,SampleTestID/ID,SampleTestID/Title&$top=500')
  .then(function(d){
    allInhouseTests=(d.value||[]).map(function(item){
      var st=item.SampleTestID||{};
      var stId=item.SampleTestIDId||st.ID||null;
      var stEntry=stId?allSampleTests.find(function(x){ return x._spID===stId; }):null;
      return {
        _spID:item.ID,
        _sampleTestId:stId,
        title:st.Title||'',
        category:stEntry?stEntry.category:'',
        method:item.Method||'',
        status:item.Status||'',
        accreditation:item.AccreditationStatus===true
      };
    });
    allInhouseTests.sort(function(a,b){ return a.title.localeCompare(b.title); });
    hideLoading();
    if(cb) cb();
  })
  .catch(function(e){
    hideLoading();
    showAlert('alertInhouse','Error loading tests: '+e.message,'error');
    scrollAlertIntoView('alertInhouse');
  });
}

function toggleInhouseEditMode(){
  inhouseEditMode=!inhouseEditMode;
  inhouseDirty={};
  inhouseNewRows=[];
  inhouseDeleted=[];

  if(inhouseEditMode){
    allInhouseTests.forEach(function(t){
      if(!t.status){
        if(!inhouseDirty[t._spID]) inhouseDirty[t._spID]={};
        inhouseDirty[t._spID].Status='Pending';
      }
    });
    ihUpdateSaveBtn();
  }

  var btn=document.getElementById('ihEditModeBtn');
  if(btn){
    btn.classList.toggle('active',inhouseEditMode);
    btn.innerHTML=inhouseEditMode
      ?'<svg class="icon" aria-hidden="true"><use href="#icon-x-outline"></use></svg> Exit Edit Mode'
      :'<svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode';
  }
  renderInhouseTests();
}

function ihMarkDirty(spID, field, value){
  if(!inhouseDirty[spID]) inhouseDirty[spID]={};
  inhouseDirty[spID][field]=value;
  var el=document.getElementById('ih-'+field+'-'+spID);
  if(el) el.classList.remove('ih-field-error');
  ihUpdateSaveBtn();
}
function ihUpdateSaveBtn(){
  var btn=document.getElementById('ihSaveBtn');
  if(!btn) return;
  var hasWork=Object.keys(inhouseDirty).length>0||inhouseNewRows.length>0||inhouseDeleted.length>0;
  btn.disabled=!hasWork;
}
function ihDeleteRow(spID){
  if(inhouseDeleted.indexOf(spID)===-1) inhouseDeleted.push(spID);
  ihUpdateSaveBtn();
  renderInhouseTests();
}
function ihUndoDelete(spID){
  inhouseDeleted=inhouseDeleted.filter(function(id){ return id!==spID; });
  ihUpdateSaveBtn();
  renderInhouseTests();
}
function ihNewRowChange(tempId,field,value){
  var r=inhouseNewRows.find(function(x){ return x._tempId===tempId; });
  if(r) r[field]=value;
  ihUpdateSaveBtn();
}
function ihAddNewRow(){
  inhouseNewCounter++;
  var tempId='new-'+inhouseNewCounter;
  inhouseNewRows.push({_tempId:tempId,title:'',method:'',status:'Pending',accreditation:false,category:'',_sampleTestId:null});
  renderInhouseTests();
  setTimeout(function(){
    var el=document.getElementById('ih-Title-'+tempId);
    if(el) el.focus();
  },40);
}
function ihCancelNew(tempId){
  inhouseNewRows=inhouseNewRows.filter(function(r){ return r._tempId!==tempId; });
  ihUpdateSaveBtn();
  renderInhouseTests();
}

function ihStatusCapsule(status){
  var s=status||'';
  var cls='ih-status-default';
  var label='Undefined';
  if(s==='Active'){ cls='ih-status-active'; label='Active'; }
  else if(s==='Inactive'){ cls='ih-status-not-active'; label='Inactive'; }
  else if(s==='Pending'){ cls='ih-status-pending'; label='Pending'; }
  return '<span class="ih-status-capsule '+cls+'">'+label+'</span>';
}
var IH_STATUS_ORDER={Active:0,Pending:1,Inactive:2};
function ihStatusSort(a,b){
  var ao=IH_STATUS_ORDER[a.status]!==undefined?IH_STATUS_ORDER[a.status]:3;
  var bo=IH_STATUS_ORDER[b.status]!==undefined?IH_STATUS_ORDER[b.status]:3;
  return ao-bo;
}

/* ════════════════════════════════════════════════════════════
   SAMPLE TESTS COMBOBOX
════════════════════════════════════════════════════════════ */
var CAT_CODE_TO_ST={
  'assay':'Assay','general':'General Tests','metals':'Heavy Metals',
  'micro':'Microbiology','pest':'Pesticides','solv':'Residual Solvents',
  'spec':'Specialty Testing','Mnr':'Minerals','id':'Identity'
};

function normalizeSampleTestCategories(){
  var lookup={};
  Object.keys(CAT_CODE_TO_ST).forEach(function(code){
    var full=CAT_CODE_TO_ST[code];
    lookup[code.toLowerCase()]=full;
    lookup[full.toLowerCase()]=full;
  });
  allSampleTests.forEach(function(t){
    var canonical=lookup[(t.category||'').toLowerCase()];
    if(canonical) t.category=canonical;
  });
}

function sampleTestsForCategory(catCode){
  var catName=CAT_CODE_TO_ST[catCode]||catCode;
  return allSampleTests.filter(function(t){ return t.category===catName; });
}

function initCategoryCombobox(inputEl,dropdownEl,catCode){
  if(sampleTestsForCategory(catCode).length===0) return;
  inputEl.dataset.originalPlaceholder=inputEl.placeholder;
  function showDropdown(){
    if(inputEl.dataset.otherMode==='true') return;
    var q=(inputEl.value||'').toLowerCase();
    var matches=sampleTestsForCategory(catCode).filter(function(t){ return !q||t.title.toLowerCase().includes(q); });
    var html='';
    matches.forEach(function(t){
      html+='<div class="st-dropdown-item" data-id="'+t._spID+'" data-title="'+escHtml(t.title)+'">'+escHtml(t.title)+'</div>';
    });
    html+='<div class="st-dropdown-other">Other (type freely)</div>';
    dropdownEl.innerHTML=html;
    dropdownEl.querySelectorAll('.st-dropdown-item').forEach(function(el){
      el.addEventListener('mousedown',function(e){
        e.preventDefault();
        inputEl.value=el.dataset.title;
        inputEl.dataset.selectedId=el.dataset.id;
        inputEl.dataset.otherMode='';
        dropdownEl.classList.remove('open');
        checkPanelDirty(catCode);
      });
    });
    var otherEl=dropdownEl.querySelector('.st-dropdown-other');
    if(otherEl) otherEl.addEventListener('mousedown',function(e){
      e.preventDefault();
      inputEl.value='';
      inputEl.dataset.selectedId='';
      inputEl.dataset.otherMode='true';
      inputEl.placeholder='Type test name';
      dropdownEl.classList.remove('open');
      inputEl.focus();
    });
    dropdownEl.classList.add('open');
  }
  inputEl.addEventListener('focus',showDropdown);
  inputEl.addEventListener('input',showDropdown);
  document.addEventListener('click',function(e){
    if(!inputEl.contains(e.target)&&!dropdownEl.contains(e.target)) dropdownEl.classList.remove('open');
  });
}

function resetCombobox(inputEl,dropdownEl){
  inputEl.value='';
  inputEl.dataset.selectedId='';
  inputEl.dataset.otherMode='';
  if(inputEl.dataset.originalPlaceholder) inputEl.placeholder=inputEl.dataset.originalPlaceholder;
  if(dropdownEl) dropdownEl.classList.remove('open');
}

// Modifier suggestion list — value is what gets stored, label is what's shown
// (so the symbol form is visible without polluting the stored/canonical value).
// Uses \uXXXX escapes (not literal characters) so the symbols render
// correctly regardless of how this file's encoding gets interpreted.
var MODIFIER_OPTIONS=[
  {value:'NMT',label:'NMT (\u2264)'},
  {value:'NLT',label:'NLT (\u2265)'},
  {value:'Range',label:'Range'},
  {value:'Nominal',label:'Nominal'},
  {value:'<',label:'< (strict upper bound)'},
  {value:'>',label:'> (strict lower bound)'},
  {value:'Negative',label:'Negative'},
  {value:'Report',label:'Report'},
  {value:'Absence',label:'Absence'},
  {value:'Presence',label:'Presence'},
  {value:'Conforms to Reference Standard',label:'Conforms to Reference Standard'},
  {value:'Conforms to Reference Spectrum',label:'Conforms to Reference Spectrum'}
];

// Generic combobox for a static suggestion list (used for the Modifier
// fields) — same look/behavior as the catalog-backed comboboxes
// (initCategoryCombobox), including an "Other (type freely)" option.
// Unlike the catalog comboboxes, the typed value is validated on submit
// (see validateModifierField) — outside of "Other" mode, only an exact
// match against `options` is accepted; "Other" mode unlocks free text.
// onSelect (optional) runs after a value is chosen — used instead of
// dispatching a synthetic 'input' event, since that would immediately
// re-trigger showDropdown() via the input listener below and reopen the
// dropdown right after closing it.
function initStaticCombobox(inputEl,dropdownEl,options,onSelect){
  inputEl.dataset.originalPlaceholder=inputEl.placeholder;
  function showDropdown(){
    if(inputEl.dataset.otherMode==='true') return;
    var q=(inputEl.value||'').toLowerCase();
    var matches=options.filter(function(o){ return !q||o.label.toLowerCase().includes(q)||o.value.toLowerCase().includes(q); });
    var html='';
    matches.forEach(function(o){
      html+='<div class="st-dropdown-item" data-val="'+escHtml(o.value)+'">'+escHtml(o.label)+'</div>';
    });
    html+='<div class="st-dropdown-other">Other (type freely)</div>';
    dropdownEl.innerHTML=html;
    dropdownEl.querySelectorAll('.st-dropdown-item').forEach(function(el){
      el.addEventListener('mousedown',function(e){
        e.preventDefault();
        inputEl.value=el.dataset.val;
        inputEl.dataset.otherMode='';
        dropdownEl.classList.remove('open');
        if(onSelect) onSelect();
      });
    });
    var otherEl=dropdownEl.querySelector('.st-dropdown-other');
    if(otherEl) otherEl.addEventListener('mousedown',function(e){
      e.preventDefault();
      inputEl.value='';
      inputEl.dataset.otherMode='true';
      inputEl.placeholder='Type a custom comparator';
      dropdownEl.classList.remove('open');
      inputEl.focus();
      if(onSelect) onSelect();
    });
    dropdownEl.classList.add('open');
  }
  inputEl.addEventListener('focus',showDropdown);
  inputEl.addEventListener('input',showDropdown);
  document.addEventListener('click',function(e){
    if(!inputEl.contains(e.target)&&!dropdownEl.contains(e.target)) dropdownEl.classList.remove('open');
  });
}
// Resets a Modifier combobox field back to its initial state — clears the
// value, exits "Other" mode, restores the original placeholder, and hides
// any validation error showing for it.
function resetModifierField(cat){
  var el=document.getElementById(cat+'_mod');
  if(!el) return;
  el.value='';
  el.dataset.otherMode='';
  if(el.dataset.originalPlaceholder) el.placeholder=el.dataset.originalPlaceholder;
  var errEl=document.getElementById(cat+'_modError');
  if(errEl) errEl.style.display='none';
}
// Validates a category's Modifier field before a test is added. Empty is
// always valid (Modifier is optional). In "Other" mode, any free text is
// valid. Otherwise the value must match one of MODIFIER_OPTIONS exactly —
// no case-insensitive or partial matching — so a typo or wrong case is
// caught here instead of silently saved or silently auto-corrected.
function validateModifierField(cat){
  var errEl=document.getElementById(cat+'_modError');
  if(errEl) errEl.style.display='none';
  return true;
}
function initAllModifierComboboxes(){
  ['assay','general','metals','micro','Mnr','pest','solv','spec'].forEach(function(cat){
    var inp=document.getElementById(cat+'_mod');
    var dd=document.getElementById(cat+'_mod_dd');
    if(inp&&dd) initStaticCombobox(inp,dd,MODIFIER_OPTIONS,function(){
      toggleUpperField(cat);
      autoSplitSpecFields(cat);
    });
  });
  var idInp=document.getElementById('id_mod');
  var idDd=document.getElementById('id_mod_dd');
  if(idInp&&idDd) initStaticCombobox(idInp,idDd,MODIFIER_OPTIONS,function(){
    normalizeModifierField('id_mod');
  });
}

// Suggested values for the Stability category's Test Type field — not tied
// to the SampleTests catalog like other category names, since these are
// fixed study-type labels rather than analyte/test names. Free typing is
// still allowed (no strict validation like the Modifier field has).
var STABILITY_TYPE_OPTIONS=[
  {value:'Stress Testing',label:'Stress Testing'},
  {value:'Accelerated',label:'Accelerated'},
  {value:'Real Time',label:'Real Time'}
];
function initStabilityCombobox(){
  var inp=document.getElementById('stability_name');
  var dd=document.getElementById('stability_name_dd');
  if(inp&&dd) initStaticCombobox(inp,dd,STABILITY_TYPE_OPTIONS,function(){
    checkPanelDirty('stability');
  });
}

function initAllComboboxes(){
  var panels=[
    {code:'assay',inputId:'assay_analyte',ddId:'assay_analyte_dd'},
    {code:'general',inputId:'general_test',ddId:'general_test_dd'},
    {code:'metals',inputId:'metals_test',ddId:'metals_test_dd'},
    {code:'micro',inputId:'micro_test',ddId:'micro_test_dd'},
    {code:'pest',inputId:'pest_name',ddId:'pest_name_dd'},
    {code:'solv',inputId:'solv_name',ddId:'solv_name_dd'},
    {code:'spec',inputId:'spec_name',ddId:'spec_name_dd'},
    {code:'Mnr',inputId:'Mnr_name',ddId:'Mnr_name_dd'},
    {code:'id',inputId:'id_ingredient',ddId:'id_ingredient_dd'}
  ];
  panels.forEach(function(p){
    var inp=document.getElementById(p.inputId);
    var dd=document.getElementById(p.ddId);
    if(inp&&dd) initCategoryCombobox(inp,dd,p.code);
  });
}

function initIHCombobox(tempId){
  var inputEl=document.getElementById('ih-Title-'+tempId);
  var dropdownEl=document.getElementById('ih-Title-dd-'+tempId);
  var catSelect=document.getElementById('ih-Cat-'+tempId);
  if(!inputEl||!dropdownEl) return;
  dropdownEl.classList.add('up');
  function showDropdown(){
    var q=(inputEl.value||'').toLowerCase();
    var usedIds=allInhouseTests
      .filter(function(t){ return inhouseDeleted.indexOf(t._spID)===-1; })
      .map(function(t){ return t._sampleTestId; });
    var matches=allSampleTests.filter(function(t){
      return usedIds.indexOf(t._spID)===-1&&(!q||t.title.toLowerCase().includes(q));
    });
    var html='';
    matches.slice(0,20).forEach(function(t){
      html+='<div class="st-dropdown-item" data-id="'+t._spID+'" data-title="'+escHtml(t.title)+'" data-cat="'+escHtml(t.category)+'">'+escHtml(t.title)+'<small style="color:#999;margin-left:8px">'+escHtml(t.category)+'</small></div>';
    });
    dropdownEl.innerHTML=html;
    dropdownEl.querySelectorAll('.st-dropdown-item').forEach(function(el){
      el.addEventListener('mousedown',function(e){
        e.preventDefault();
        inputEl.value=el.dataset.title;
        inputEl.dataset.selectedId=el.dataset.id;
        dropdownEl.classList.remove('open');
        var r=inhouseNewRows.find(function(x){ return x._tempId===tempId; });
        if(r){ r.title=el.dataset.title; r._sampleTestId=parseInt(el.dataset.id); r.category=el.dataset.cat; }
        if(catSelect){ catSelect.value=el.dataset.cat; catSelect.disabled=true; }
        ihUpdateSaveBtn();
      });
    });
    if(html) dropdownEl.classList.add('open');
    else dropdownEl.classList.remove('open');
  }
  inputEl.addEventListener('focus',showDropdown);
  inputEl.addEventListener('input',function(){
    var r=inhouseNewRows.find(function(x){ return x._tempId===tempId; });
    if(r){ r.title=inputEl.value; r._sampleTestId=null; r.category=catSelect?catSelect.value:''; }
    if(catSelect) catSelect.disabled=false;
    ihUpdateSaveBtn();
    showDropdown();
  });
  document.addEventListener('click',function(e){
    if(!inputEl.contains(e.target)&&!dropdownEl.contains(e.target)) dropdownEl.classList.remove('open');
  });
}

function ihClearFilters(){
  var s=document.getElementById('inhouseSearch');
  var af=document.getElementById('inhouseAccrFilter');
  var sf=document.getElementById('inhouseStatusFilter');
  if(s) s.value='';
  if(af) af.value='';
  if(sf) sf.value='';
  renderInhouseTests();
}
function ihAccreditationCapsule(val){
  return val
    ?'<span class="ih-status-capsule ih-accred-yes">Accredited</span>'
    :'<span class="ih-status-capsule ih-accred-no">Not Accredited</span>';
}
function ihMarkAccreditation(spID,checked){
  if(!inhouseDirty[spID]) inhouseDirty[spID]={};
  inhouseDirty[spID].AccreditationStatus=checked;
  ihUpdateSaveBtn();
}
function ihNewRowAccreditation(tempId,checked){
  var r=inhouseNewRows.find(function(x){ return x._tempId===tempId; });
  if(r) r.accreditation=checked;
  ihUpdateSaveBtn();
}
function renderInhouseTests(){
  var editBtn=document.getElementById('ihEditModeBtn');
  if(editBtn) editBtn.style.display=currentUserIsOwner?'':'none';
  var q=(document.getElementById('inhouseSearch').value||'').toLowerCase();
  var statusFilter=(document.getElementById('inhouseStatusFilter').value||'');
  var accrFilter=(document.getElementById('inhouseAccrFilter').value||'');
  var filtered=allInhouseTests.filter(function(t){
    var matchText=!q||t.title.toLowerCase().includes(q)||t.method.toLowerCase().includes(q);
    var matchStatus=!statusFilter||(t.status||'')===statusFilter;
    var matchAccr=!accrFilter||(accrFilter==='true'?t.accreditation:!t.accreditation);
    return matchText&&matchStatus&&matchAccr;
  });
  filtered=filtered.slice().sort(ihStatusSort);
  var el=document.getElementById('inhouseListContainer');
  var plusSvg='<svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg>';
  var trashSvg='<svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg>';
  var undoSvg='<svg class="icon" aria-hidden="true"><use href="#icon-undo-outline"></use></svg>';
  var saveBar=inhouseEditMode
    ?'<div class="ih-save-controls">'
      +'<span id="ihSaveStatus" class="ih-save-status"></span>'
      +'<button id="ihSaveBtn" class="ih-save-btn" onclick="saveInhouseChanges()" disabled>Save Changes</button>'
      +'</div>'
    :'';
  var statusTh='<th style="min-width:200px;white-space:nowrap">Status</th>';
  var accrTh='<th style="white-space:nowrap;width:max-content">Accreditation Status (17025)</th>';
  var catTh='<th style="white-space:nowrap;min-width:200px">Category</th>';
  var delTh=inhouseEditMode?'<th style="width:1%;white-space:nowrap"></th>':'';
  var rows=filtered.map(function(t){
    var isDeleted=inhouseDeleted.indexOf(t._spID)!==-1;
    if(inhouseEditMode){
      var cur=inhouseDirty[t._spID]||{};
      var methodVal=cur.Method!==undefined?cur.Method:t.method;
      var statusVal=cur.Status!==undefined?cur.Status:t.status;
      var effectiveStatus=statusVal||'Pending';
      var accrVal=cur.AccreditationStatus!==undefined?cur.AccreditationStatus:t.accreditation;
      var dis=isDeleted?' disabled':'';
      var statusSelect='<select class="ih-edit-input" id="ih-Status-'+t._spID+'"'+dis+' onchange="ihMarkDirty('+t._spID+',\'Status\',this.value)">'
        +'<option value="Active"'+(effectiveStatus==='Active'?' selected':'')+'>Active</option>'
        +'<option value="Pending"'+(effectiveStatus==='Pending'?' selected':'')+'>Pending</option>'
        +'<option value="Inactive"'+(effectiveStatus==='Inactive'?' selected':'')+'>Inactive</option>'
        +'</select>';
      var accrChk='<label style="display:inline-flex;align-items:center;gap:6px;cursor:pointer;font-size:13px">'
        +'<input type="checkbox" id="ih-Accr-'+t._spID+'" style="width:17px;height:17px;accent-color:#0072B2;cursor:pointer"'+(accrVal?' checked':'')+dis+' onchange="ihMarkAccreditation('+t._spID+',this.checked)">'
        +'<span style="color:#555">Accredited</span>'
        +'</label>';
      var actionBtn=isDeleted
        ?'<button class="ih-undo-btn" onclick="ihUndoDelete('+t._spID+')" title="Undo delete">'+undoSvg+'</button>'
        :'<button class="ih-del-btn" onclick="ihDeleteRow('+t._spID+')" title="Delete row">'+trashSvg+'</button>';
      var rowCls=isDeleted?' class="ih-row-deleted-edit"':'';
      return '<tr'+rowCls+'>'
        +'<td data-label="Test Name" style="white-space:nowrap"><strong>'+escHtml(t.title)+'</strong></td>'
        +'<td data-label="Method">'
        +'<input id="ih-Method-'+t._spID+'" class="ih-edit-input" value="'+escHtml(methodVal)+'"'+dis+' oninput="ihMarkDirty('+t._spID+',\'Method\',this.value)">'
        +'</td>'
        +'<td data-label="Category" style="white-space:nowrap"><span class="ih-cat-badge">'+(t.category ? escHtml(t.category) : '&#8212;')+'</span></td>'
        +'<td data-label="Accreditation Status (17025)" style="vertical-align:middle">'+accrChk+'</td>'
        +'<td data-label="Status" style="white-space:nowrap">'+statusSelect+'</td>'
        +'<td style="text-align:center;vertical-align:middle">'+actionBtn+'</td>'
        +'</tr>';
    }
    var rowCls=isDeleted?' class="ih-row-deleted-view"':'';
    return '<tr'+rowCls+'>'
      +'<td data-label="Test Name" style="white-space:nowrap"><strong>'+escHtml(t.title)+'</strong></td>'
      +'<td data-label="Method">'+escHtml(t.method)+'</td>'
      +'<td data-label="Category" style="white-space:nowrap"><span class="ih-cat-badge">'+(t.category ? escHtml(t.category) : '&#8212;')+'</span></td>'
      +'<td data-label="Accreditation Status (17025)" style="white-space:nowrap">'+ihAccreditationCapsule(t.accreditation)+'</td>'
      +'<td data-label="Status" style="white-space:nowrap">'+ihStatusCapsule(t.status)+'</td>'
      +'</tr>';
  }).join('');
  var newRows=inhouseEditMode?inhouseNewRows.map(function(nr){
    var statusSelect='<select class="ih-edit-input" id="ih-Status-'+nr._tempId+'" onchange="ihNewRowChange(\''+nr._tempId+'\',\'status\',this.value)">'
      +'<option value="Active"'+(nr.status==='Active'?' selected':'')+'>Active</option>'
      +'<option value="Pending"'+(nr.status!=='Active'&&nr.status!=='Inactive'?' selected':'')+'>Pending</option>'
      +'<option value="Inactive"'+(nr.status==='Inactive'?' selected':'')+'>Inactive</option>'
      +'</select>';
    var catSelect='<select class="ih-edit-input" id="ih-Cat-'+nr._tempId+'" onchange="ihNewRowChange(\''+nr._tempId+'\',\'category\',this.value)">'
      +'<option value="">Select category</option>'
      +'<option value="Assay"'+(nr.category==='Assay'?' selected':'')+'>Assay</option>'
      +'<option value="General Tests"'+(nr.category==='General Tests'?' selected':'')+'>General Tests</option>'
      +'<option value="Heavy Metals"'+(nr.category==='Heavy Metals'?' selected':'')+'>Heavy Metals</option>'
      +'<option value="Microbiology"'+(nr.category==='Microbiology'?' selected':'')+'>Microbiology</option>'
      +'<option value="Pesticides"'+(nr.category==='Pesticides'?' selected':'')+'>Pesticides</option>'
      +'<option value="Residual Solvents"'+(nr.category==='Residual Solvents'?' selected':'')+'>Residual Solvents</option>'
      +'<option value="Specialty Testing"'+(nr.category==='Specialty Testing'?' selected':'')+'>Specialty Testing</option>'
      +'<option value="Minerals"'+(nr.category==='Minerals'?' selected':'')+'>Minerals</option>'
      +'<option value="Identity"'+(nr.category==='Identity'?' selected':'')+'>Identity</option>'
      +'</select>';
    setTimeout(function(){ initIHCombobox(nr._tempId); }, 40);
    return '<tr>'
      +'<td data-label="Test Name" style="white-space:nowrap;min-width:180px">'
      +'<div class="st-combobox-wrap">'
      +'<input id="ih-Title-'+nr._tempId+'" class="ih-edit-input" value="'+escHtml(nr.title)+'" placeholder="Search or type test name" autocomplete="off">'
      +'<div class="st-dropdown" id="ih-Title-dd-'+nr._tempId+'"></div>'
      +'</div>'
      +'</td>'
      +'<td data-label="Method">'
      +'<input id="ih-Method-'+nr._tempId+'" class="ih-edit-input" value="'+escHtml(nr.method)+'" placeholder="Method" oninput="ihNewRowChange(\''+nr._tempId+'\',\'method\',this.value)">'
      +'</td>'
      +'<td data-label="Category">'+catSelect+'</td>'
      +'<td data-label="Accreditation Status (17025)" style="vertical-align:middle">'
      +'<label style="display:inline-flex;align-items:center;gap:6px;cursor:pointer;font-size:13px">'
      +'<input type="checkbox" id="ih-Accr-'+nr._tempId+'" style="width:17px;height:17px;accent-color:#0072B2;cursor:pointer"'+(nr.accreditation?' checked':'')+' onchange="ihNewRowAccreditation(\''+nr._tempId+'\',this.checked)">'
      +'<span style="color:#555">Accredited</span>'
      +'</label>'
      +'</td>'
      +'<td data-label="Status" style="white-space:nowrap">'+statusSelect+'</td>'
      +'<td style="text-align:center;vertical-align:middle">'
      +'<button class="ih-del-btn" onclick="ihCancelNew(\''+nr._tempId+'\')" title="Remove row">'+trashSvg+'</button>'
      +'</td>'
      +'</tr>';
  }).join(''):'';
  var addRow=inhouseEditMode
    ?'<tr class="ih-add-row-tr"><td colspan="6">'
      +'<button class="ih-add-row-btn" onclick="ihAddNewRow()">'+plusSvg+' Add Test</button>'
      +'</td></tr>'
    :'';
  if(!filtered.length&&inhouseNewRows.length===0&&!inhouseEditMode){
    el.innerHTML='<div class="card">'
      +'<h2><svg class="icon" aria-hidden="true"><use href="#icon-microscope-outline"></use></svg> Test Catalog</h2>'
      +'<div class="empty-state">No tests match the selected filters.</div>'
      +saveBar+'</div>';
    return;
  }
  el.innerHTML='<div class="card">'
    +'<h2><svg class="icon" aria-hidden="true"><use href="#icon-microscope-outline"></use></svg> Test Catalog</h2>'
    +'<div class="table-wrap"><table><thead><tr>'
    +'<th style="white-space:nowrap;min-width:200px">Test Name</th><th style="width:100%">Method</th>'
    +catTh+accrTh
    +statusTh
    +delTh
    +'</tr></thead><tbody>'
    +rows
    +newRows
    +addRow
    +'</tbody></table></div>'
    +saveBar+'</div>';
  ihUpdateSaveBtn();
}

function saveInhouseChanges(){
  var saveBtn=document.getElementById('ihSaveBtn');
  var statusEl=document.getElementById('ihSaveStatus');
  checkCurrentUserIsOwner().then(function(isOwner){
    if(!isOwner){
      currentUserIsOwner=false;
      inhouseEditMode=false;
      inhouseDirty={};
      inhouseNewRows=[];
      inhouseDeleted=[];
      var btn=document.getElementById('ihEditModeBtn');
      if(btn){ btn.style.display='none'; btn.classList.remove('active'); btn.innerHTML='<svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode'; }
      renderInhouseTests();
      showAlert('alertInhouse','You no longer have permission to edit tests.','error');
      scrollAlertIntoView('alertInhouse');
      return;
    }
    _doSaveInhouseChanges(saveBtn,statusEl);
  });
}
function _doSaveInhouseChanges(saveBtn,statusEl){
  var errorSvg='<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#c62828" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>';
  var checkSvg='<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#2e7d32" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0"><circle cx="12" cy="12" r="10"/><polyline points="9 12 11.5 14.5 15 9.5"/></svg>';
  function showError(msg){ if(statusEl) statusEl.innerHTML=errorSvg+'<span style="color:#c62828">'+msg+'</span>'; if(saveBtn) saveBtn.disabled=false; }
  function showSuccess(msg){ if(statusEl) statusEl.innerHTML=checkSvg+'<span style="color:#2e7d32">'+msg+'</span>'; }

  var keys=Object.keys(inhouseDirty);
  var hasWork=keys.length>0||inhouseNewRows.length>0||inhouseDeleted.length>0;
  if(!hasWork){ showError('No changes to save.'); return; }

  // Validate edits to existing rows
  var hasErrors=false;
  keys.forEach(function(spID){
    ['Title','Method'].forEach(function(field){
      var val=inhouseDirty[spID][field];
      if(val!==undefined&&!String(val).trim()){
        var el=document.getElementById('ih-'+field+'-'+spID);
        if(el) el.classList.add('ih-field-error');
        hasErrors=true;
      }
    });
  });
  // Validate new rows
  inhouseNewRows.forEach(function(nr){
    if(!nr.title.trim()){
      var el=document.getElementById('ih-Title-'+nr._tempId);
      if(el) el.classList.add('ih-field-error');
      hasErrors=true;
    }
    if(!nr.method.trim()){
      var el=document.getElementById('ih-Method-'+nr._tempId);
      if(el) el.classList.add('ih-field-error');
      hasErrors=true;
    }
  });
  if(hasErrors){ showError('Some fields are empty. Fill in all highlighted fields before saving.'); return; }

  if(saveBtn){ saveBtn.disabled=true; saveBtn.textContent='Saving...'; }
  if(statusEl) statusEl.innerHTML='';

  var ops=[];
  // PATCH dirty existing rows
  keys.forEach(function(spID){
    var fields={};
    if(inhouseDirty[spID].Title!==undefined) fields.Title=inhouseDirty[spID].Title.trim();
    if(inhouseDirty[spID].Method!==undefined) fields.Method=inhouseDirty[spID].Method.trim();
    if(inhouseDirty[spID].Status!==undefined) fields.Status=inhouseDirty[spID].Status;
    if(inhouseDirty[spID].AccreditationStatus!==undefined) fields.AccreditationStatus=inhouseDirty[spID].AccreditationStatus;
    ops.push(spPatch(PATH_VERTEX_TESTS,parseInt(spID),fields).then(function(){
      var t=allInhouseTests.find(function(x){ return x._spID===parseInt(spID); });
      if(t){
        if(fields.Title!==undefined) t.title=fields.Title;
        if(fields.Method!==undefined) t.method=fields.Method;
        if(fields.Status!==undefined) t.status=fields.Status;
        if(fields.AccreditationStatus!==undefined) t.accreditation=fields.AccreditationStatus;
      }
    }));
  });
  // POST new rows
  inhouseNewRows.forEach(function(nr){
    var titleVal=nr.title.trim();
    var methodVal=nr.method.trim();
    var catVal=nr.category||'';
    if(nr._sampleTestId){
      // SampleTests entry already selected via combobox
      var body={SampleTestIDId:nr._sampleTestId,Method:methodVal,LabName:IH_LAB_NAME,Status:nr.status||'',AccreditationStatus:nr.accreditation};
      ops.push(spPost(PATH_VERTEX_TESTS,body).then(function(d){
        allInhouseTests.push({_spID:d.ID,_sampleTestId:nr._sampleTestId,title:titleVal,category:catVal,method:methodVal,status:nr.status||'',accreditation:nr.accreditation});
      }));
    } else {
      // Free-typed test — first create SampleTests entry, then VertexTests
      ops.push(
        spPost(PATH_SAMPLE_TESTS,{Title:titleVal,Category:catVal})
        .then(function(stData){
          allSampleTests.push({_spID:stData.ID,title:titleVal,category:catVal});
          var body={SampleTestIDId:stData.ID,Method:methodVal,LabName:IH_LAB_NAME,Status:nr.status||'',AccreditationStatus:nr.accreditation};
          return spPost(PATH_VERTEX_TESTS,body).then(function(d){
            allInhouseTests.push({_spID:d.ID,_sampleTestId:stData.ID,title:titleVal,category:catVal,method:methodVal,status:nr.status||'',accreditation:nr.accreditation});
          });
        })
      );
    }
  });
  // DELETE removed rows
  inhouseDeleted.forEach(function(spID){
    var delT=allInhouseTests.find(function(x){ return x._spID===spID; });
    var delStId=delT?delT._sampleTestId:null;
    ops.push(spDelete(PATH_VERTEX_TESTS,spID).then(function(){
      allInhouseTests=allInhouseTests.filter(function(x){ return x._spID!==spID; });
      // Also remove the SampleTests catalog entry if no other In-House row
      // still links to it, so it stops showing up as a suggestion on the
      // New Sample form after being deleted here.
      if(delStId){
        var stillUsed=allInhouseTests.some(function(x){ return x._sampleTestId===delStId; });
        if(!stillUsed){
          return spDelete(PATH_SAMPLE_TESTS,delStId).then(function(){
            allSampleTests=allSampleTests.filter(function(x){ return x._spID!==delStId; });
          }).catch(function(e){ console.warn('SampleTests cleanup failed:',e); });
        }
      }
    }));
  });

  Promise.all(ops)
    .then(function(){
      inhouseDirty={};
      inhouseNewRows=[];
      inhouseDeleted=[];

      showSuccess('Changes saved successfully.');
      setTimeout(function(){
        inhouseEditMode=false;
        var btn=document.getElementById('ihEditModeBtn');
        if(btn){
          btn.classList.remove('active');
          btn.innerHTML='<svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode';
        }
        renderInhouseTests();
      },2000);
    })
    .catch(function(e){ showError('Error saving: '+e.message); });
}

function reloadAndInhouse(){ inhouseEditMode=false; inhouseDirty={}; inhouseNewRows=[]; inhouseDeleted=[]; var btn=document.getElementById('ihEditModeBtn'); if(btn){ btn.classList.remove('active'); btn.innerHTML='<svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode'; } loadInhouseTests(renderInhouseTests); }

var tatEditMode=false;
var tatDirty={};

function toggleTATEditMode(){
  tatEditMode=!tatEditMode;
  tatDirty={};
  var btn=document.getElementById('tatEditModeBtn');
  if(btn){
    btn.classList.toggle('active',tatEditMode);
    btn.innerHTML=tatEditMode
      ?'<svg class="icon" aria-hidden="true"><use href="#icon-x-outline"></use></svg> Exit Edit Mode'
      :'<svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode';
  }
  renderTATCats();
}

function tatMarkDirty(spID,field,value){
  if(!tatDirty[spID]) tatDirty[spID]={};
  tatDirty[spID][field]=value;
  var el=document.getElementById('tat-'+field+'-'+spID);
  if(el) el.classList.remove('ih-field-error');
  var btn=document.getElementById('tatSaveBtn');
  if(btn) btn.disabled=Object.keys(tatDirty).length===0;
}

function saveTATChanges(){
  var saveBtn=document.getElementById('tatSaveBtn');
  var statusEl=document.getElementById('tatSaveStatus');
  _doSaveTATChanges(saveBtn,statusEl);
}

function _doSaveTATChanges(saveBtn,statusEl){
  var errorSvg='<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#c62828" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>';
  var checkSvg='<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#2e7d32" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0"><circle cx="12" cy="12" r="10"/><polyline points="9 12 11.5 14.5 15 9.5"/></svg>';
  function showError(msg){ if(statusEl) statusEl.innerHTML=errorSvg+'<span style="color:#c62828">'+msg+'</span>'; if(saveBtn) saveBtn.disabled=false; }
  function showSuccess(msg){ if(statusEl) statusEl.innerHTML=checkSvg+'<span style="color:#2e7d32">'+msg+'</span>'; }

  var keys=Object.keys(tatDirty);
  if(!keys.length){ showError('No changes to save.'); return; }

  var hasErrors=false;
  keys.forEach(function(spID){
    ['Title','Code','Description','TATByDays'].forEach(function(field){
      var val=tatDirty[spID][field];
      if(val!==undefined&&!String(val).trim()){
        var el=document.getElementById('tat-'+field+'-'+spID);
        if(el) el.classList.add('ih-field-error');
        hasErrors=true;
      }
    });
  });
  if(hasErrors){ showError('Some fields are empty. Fill in all highlighted fields before saving.'); return; }

  if(saveBtn){ saveBtn.disabled=true; saveBtn.textContent='Saving...'; }
  if(statusEl) statusEl.innerHTML='';

  var patches=keys.map(function(spID){
    var fields={};
    var d=tatDirty[spID];
    if(d.Title!==undefined) fields.Title=d.Title.trim();
    if(d.Code!==undefined) fields.Code=d.Code.trim();
    if(d.Description!==undefined) fields.Description=d.Description.trim();
    if(d.TATByDays!==undefined) fields.TATByDays=String(d.TATByDays).trim();
    return spPatch(PATH_TEST_CATS,parseInt(spID),fields).then(function(){
      var tc=testCategories.find(function(x){ return x.ID===parseInt(spID); });
      if(tc){
        if(fields.Title!==undefined) tc.Title=fields.Title;
        if(fields.Code!==undefined) tc.Code=fields.Code;
        if(fields.Description!==undefined) tc.Description=fields.Description;
        if(fields.TATByDays!==undefined){ tc.TATByDays=fields.TATByDays; buildCatTATMap(); }

      }
    });
  });

  Promise.all(patches)
    .then(function(){
      tatDirty={};
      showSuccess('Changes saved successfully.');
      setTimeout(function(){
        tatEditMode=false;
        var btn=document.getElementById('tatEditModeBtn');
        if(btn){ btn.classList.remove('active'); btn.innerHTML='<svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode'; }
        renderTATCats();
      },2000);
    })
    .catch(function(e){ showError('Error saving: '+e.message); });
}

function reloadAndTATCats(){
  tatEditMode=false; tatDirty={};
  var btn=document.getElementById('tatEditModeBtn');
  if(btn){ btn.classList.remove('active'); btn.innerHTML='<svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode'; }
  loadTestCategories(renderTATCats);
}

/* ════════════════════════════════════════════════════════════
   TAT & RUSH ORDERS
════════════════════════════════════════════════════════════ */
var rushOrdersPage=0;
var RUSH_PAGE_SIZE=10;
var rushOrdersFiltered=[];

function populateRushCatSelect(){
  var sel=document.getElementById('rushFilterCat');
  if(!sel||sel.options.length>1) return;
  testCategories.slice().sort(function(a,b){ return (a.Title||'').localeCompare(b.Title||''); })
  .forEach(function(tc){
    var o=document.createElement('option');
    o.value=tc.Code||tc.Title;
    o.textContent=tc.Title;
    sel.appendChild(o);
  });
}

function clearRushFilters(){
  document.getElementById('rushSearch').value='';
  document.getElementById('rushFilterType').value='';
  document.getElementById('rushFilterCat').value='';
  renderRushOrders();
}

function renderRushOrders(){
  rushOrdersPage=0;
  populateRushCatSelect();
  var q=(document.getElementById('rushSearch').value||'').toLowerCase().trim();
  var fType=(document.getElementById('rushFilterType').value||'');
  var fCat=(document.getElementById('rushFilterCat').value||'');
  var pool=poolFor('rush',q,allSamples);
  rushOrdersFiltered=pool.filter(function(s){
    if(!s.isRush) return false;
    if(q&&!(s.sampleID.toLowerCase().includes(q)||s.customer.toLowerCase().includes(q))) return false;
    if(fType&&s.rushType!==fType) return false;
    if(fCat){
      var codes=s.testCategoryCodes.split(',').map(function(x){ return x.trim(); });
      if(codes.indexOf(fCat)===-1) return false;
    }
    return true;
  });
  _paintRushOrders();
}

function loadMoreRush(){
  rushOrdersPage++;
  _paintRushOrders();
}

function _paintRushOrders(){
  var el=document.getElementById('rushOrdersContainer');
  var moreWrap=document.getElementById('rushLoadMoreWrap');
  if(!el) return;
  if(!rushOrdersFiltered.length){
    el.innerHTML='<div class="empty-state">No rush orders found.</div>';
    moreWrap.style.display='none';
    return;
  }
  var visible=rushOrdersFiltered.slice(0,(rushOrdersPage+1)*RUSH_PAGE_SIZE);
  var rows=visible.map(function(s){
    return '<tr>'
      +'<td data-label="Sample ID"><span class="sid-wrap"><strong>'+escHtml(s.sampleID)+'</strong>'+editedPill(s.sampleID)+'</span></td>'
      +'<td data-label="Report ID">'+escHtml(s.reportID)+'</td>'
      +'<td data-label="Batch ID">'+escHtml(s.batchID)+'</td>'
      +'<td data-label="Customer">'+escHtml(s.customer)+'</td>'
      +'<td data-label="Received By">'+escHtml(s.receivedBy)+'</td>'
      +'<td data-label="TAT Deadline">'+escHtml(s.tatDeadline)+'</td>'
      +'<td data-label="Status"><span class="badge badge-'+badgeCls(s.status)+'">'+s.status+'</span></td>'
      +'<td data-label=""><button class="btn-primary btn-sm" onclick="openModal(\''+escHtml(s.sampleID)+'\')">View</button></td>'
      +'</tr>';
  }).join('');
  el.innerHTML='<div class="table-wrap"><table style="width:100%"><thead><tr>'
    +'<th>Sample ID</th><th>Report ID</th><th>Batch ID</th><th>Customer</th><th>Received By</th><th>TAT Deadline</th><th>Status</th>'
    +'<th style="width:1%;white-space:nowrap"></th>'
    +'</tr></thead><tbody>'+rows+'</tbody></table></div>';
  moreWrap.style.display=visible.length<rushOrdersFiltered.length?'block':'none';
}

function renderTATCats(){
  var editBtn=document.getElementById('tatEditModeBtn');
  if(editBtn) editBtn.style.display='';
  var el=document.getElementById('tatCatsContainer');
  if(!el) return;
  var hasDirty=Object.keys(tatDirty).length>0;
  var saveBar=tatEditMode
    ?'<div class="ih-save-controls">'
      +'<span id="tatSaveStatus" class="ih-save-status"></span>'
      +'<button id="tatSaveBtn" class="ih-save-btn" onclick="saveTATChanges()" disabled>Save Changes</button>'
      +'</div>'
    :'';
  if(!testCategories||!testCategories.length){
    el.innerHTML='<div class="empty-state">No test categories found.</div>'+saveBar;
    return;
  }
  var sorted=testCategories.slice().sort(function(a,b){ return (a.Title||'').localeCompare(b.Title||''); });
  var rows=sorted.map(function(tc){
    var id=tc.ID;
    if(tatEditMode){
      var cur=tatDirty[id]||{};
      var tVal=cur.Title!==undefined?cur.Title:(tc.Title||'');
      var cVal=cur.Code!==undefined?cur.Code:(tc.Code||'');
      var dVal=cur.Description!==undefined?cur.Description:(tc.Description||'');
      var daysVal=cur.TATByDays!==undefined?cur.TATByDays:(tc.TATByDays||'');
      return '<tr>'
        +'<td data-label="Category"><input id="tat-Title-'+id+'" class="ih-edit-input" value="'+escHtml(tVal)+'" oninput="tatMarkDirty('+id+',\'Title\',this.value)"></td>'
        +'<td data-label="Code"><input id="tat-Code-'+id+'" class="ih-edit-input" value="'+escHtml(cVal)+'" oninput="tatMarkDirty('+id+',\'Code\',this.value)"></td>'
        +'<td data-label="Description"><input id="tat-Description-'+id+'" class="ih-edit-input" value="'+escHtml(dVal)+'" oninput="tatMarkDirty('+id+',\'Description\',this.value)"></td>'
        +'<td data-label="TAT (Days)"><input id="tat-TATByDays-'+id+'" class="ih-edit-input" value="'+escHtml(String(daysVal))+'" oninput="tatMarkDirty('+id+',\'TATByDays\',this.value)"></td>'
        +'</tr>';
    }
    return '<tr>'
      +'<td data-label="Category">'+escHtml(tc.Title||'')+'</td>'
      +'<td data-label="Code">'+escHtml(tc.Code||'')+'</td>'
      +'<td data-label="Description">'+escHtml(tc.Description||'')+'</td>'
      +'<td data-label="TAT (Days)">'+(tc.TATByDays||'&#8212;')+'</td>'
      +'</tr>';
  }).join('');
  el.innerHTML='<div class="table-wrap"><table style="table-layout:fixed;width:100%"><thead><tr>'
    +'<th style="width:20%">Category</th><th style="width:20%">Code</th><th style="width:40%">Description</th><th style="width:20%">TAT (Days)</th>'
    +'</tr></thead><tbody>'+rows+'</tbody></table></div>'
    +saveBar;
  if(tatEditMode&&hasDirty){
    var btn=document.getElementById('tatSaveBtn');
    if(btn) btn.disabled=false;
  }
}

/* ════════════════════════════════════════════════════════════
   MODAL
════════════════════════════════════════════════════════════ */
var CAT_DISPLAY_NAMES = {
  assay  : 'Assay / Potency',
  id     : 'Identification',
  micro  : 'Microbiology',
  metals : 'Heavy Metals',
  Mnr    : 'Minerals',
  general: 'General Tests',
  pest   : 'Pesticides',
  solv   : 'Residual Solvents',
  spec   : 'Specialty Testing',
  stability : 'Stability'
};

/* ════════════════════════════════════════════════════════════
   SAMPLE DETAIL MODAL — read / edit
════════════════════════════════════════════════════════════ */
var MODAL_CAT_ORDER=['assay','id','micro','metals','Mnr','general','pest','solv','spec','stability'];
var MODAL_FIELDS=[
  {key:'sampleID',       label:'Sample ID',                editable:false},
  {key:'reportID',       label:'Report ID',                editable:false},
  {key:'customer',       label:'Customer',                 editable:true, required:true, type:'select', dynamicOptions:'customers'},
  {key:'sampleName',     label:'Sample Name',              editable:true, required:true},
  {key:'lotNumber',      label:'Lot Number',               editable:true},
  {key:'matrix',         label:'Matrix',                    editable:true, required:true, type:'select',
   options:['Tablet','Capsule','Liquid','Powder','Gummy','Beverage','Other']},
  {key:'type',           label:'Sample Type',              editable:true, type:'select',
   options:['Finished Product','Raw Material','In-Process']},
  {key:'units',          label:'Units',                     editable:true, required:true, type:'number'},
  {key:'servingSize',    label:'Serving Size',              editable:true},
  {key:'extRef',         label:'External Reference Number', editable:true},
  {key:'status',         label:'Status',                    editable:false},
  {key:'tat',            label:'TAT',                        editable:false},
  {key:'dateReceived',   label:'Date Received',             editable:true, type:'date'},
  {key:'tempUponReceipt',label:'Temp. Upon Receipt',         editable:true, type:'number'},
  {key:'batchID',        label:'Batch ID',                   editable:false},
  {key:'receivedBy',     label:'Received By',                editable:false},
  {key:'tatDeadline',    label:'TAT Deadline',               editable:false},
  {key:'statusNotes',    label:'Status Notes',               editable:false},
  {key:'testDate',       label:'Test Date',                  editable:false}
];

var modalCurrentSample=null;
var modalLiveResults=[];   // real LS-QP08.01_TestResults rows for the open sample
var modalCurrentInspection=null;  // the LS-QP08.01_BatchInspection row linked to this sample's batch, if any
var modalEditDirty=false;
var modalEditTests={};     // {cat: [{...row state...}]} while in edit mode
var modalPendingDeleteIds={}; // {testResultId: true} marked for delete on Save

function modalFieldValueText(s,f){
  var v=s[f.key];
  if(f.key==='units') v=v||0;
  if(v===undefined||v===null||v==='') return '';
  return String(v);
}
function modalRushDisplay(s){
  if(!s.isRush) return 'No';
  return 'Yes'+(s.rushType?' ('+s.rushType+')':'');
}
function modalFieldRow(label,v,fullWidth){
  return '<div class="modal-field"'+(fullWidth?' style="grid-column:1/-1"':'')+'>'
    +'<span class="modal-field-label">'+escHtml(label)+':</span>'
    +'<span class="modal-field-value'+(v?'':' empty')+'">'+(v?escHtml(v):'&#8212;')+'</span></div>';
}
function fmtChangeDate(iso){
  if(!iso) return '';
  var d=new Date(iso);
  var mo=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return mo[d.getMonth()]+' '+d.getDate()+', '+d.getFullYear();
}

function renderModalChangeLog(entries){
  var sec=document.getElementById('m_changeLogSection');
  var el=document.getElementById('m_changeLog');
  if(!sec||!el) return;
  if(!entries||!entries.length){ sec.style.display='none'; return; }
  sec.style.display='';
  el.innerHTML=entries.map(function(e){
    return '<div class="changelog-entry">'
      +'<span class="changelog-author">'+escHtml((e.Author&&e.Author.Title)||'Unknown')+'</span>'
      +'<span class="changelog-reason">'+escHtml(e.Reason||'')+'</span>'
      +'<span class="changelog-date">'+fmtChangeDate(e.Created)+'</span>'
      +'</div>';
  }).join('');
}

function renderModalReadFields(s){
  var html='';
  MODAL_FIELDS.forEach(function(f){
    var v=modalFieldValueText(s,f);
    if(f.key==='sampleID'&&editedSampleIds.has(s.sampleID)){
      html+='<div class="modal-field-row"><span class="modal-field-label">'+escHtml(f.label)+':</span>'
        +'<span class="modal-field-value"><span class="sid-wrap">'+escHtml(v)+'<span class="edited-pill">Edited</span></span></span></div>';
    } else {
      html+=modalFieldRow(f.label,v);
    }
  });
  html+=modalFieldRow('Rush Order',modalRushDisplay(s));
  html+=modalFieldRow('Remarks',s.remarks||'',true);
  document.getElementById('m_readFields').innerHTML=html;
}
function renderModalEditFields(s){
  var html='';
  MODAL_FIELDS.forEach(function(f){
    var v=modalFieldValueText(s,f);
    var id='me_'+f.key;
    if(!f.editable){
      html+='<div class="form-group"><label>'+f.label+'</label>'
        +'<input type="text" value="'+escHtml(v)+'" disabled>';
      if(f.key==='status') html+='<p style="font-size:12px;color:#7f8c8d;margin:4px 0 0">To change this, use the <strong>Update Status</strong> tab instead.</p>';
      html+='</div>';
      return;
    }
    var req=f.required?' <span class="req">*</span>':'';
    html+='<div class="form-group"><label>'+f.label+req+'</label>';
    if(f.type==='select'){
      html+='<select id="'+id+'" oninput="modalMarkDirty()">';
      var opts=f.dynamicOptions==='customers'?allCustomerNames:f.options;
      opts.forEach(function(o){ html+='<option'+(v===o?' selected':'')+'>'+o+'</option>'; });
      html+='</select>';
    } else if(f.type==='date'){
      html+='<input type="date" id="'+id+'" value="'+escHtml(v)+'" oninput="modalMarkDirty()">';
    } else if(f.type==='number'){
      var extraOi=f.key==='tempUponReceipt'?';syncModalTemp(\'me\')':'';
      html+='<input type="number" id="'+id+'" value="'+escHtml(v)+'" oninput="modalMarkDirty()'+extraOi+'">';
    } else {
      html+='<input type="text" id="'+id+'" value="'+escHtml(v)+'" oninput="modalMarkDirty()">';
    }
    html+='</div>';
  });
  html+='<div class="form-group"><label class="rush-chk-label"><input type="checkbox" id="me_isRush" class="status-chk" '
    +(s.isRush?'checked':'')+' onchange="modalToggleRush();modalMarkDirty()"> Rush Order</label></div>';
  html+='<div class="form-group" id="me_rushTypeGroup" style="display:'+(s.isRush?'':'none')+'">'
    +'<label>Rush Type <span class="req">*</span></label>'
    +'<select id="me_rushType" oninput="modalMarkDirty()">'
    +'<option value="">&#8212; Select Rush Type &#8212;</option>'
    +'<option value="3-Day Rush"'+(s.rushType==='3-Day Rush'?' selected':'')+'>3-Day Rush</option>'
    +'<option value="2-Day Rush"'+(s.rushType==='2-Day Rush'?' selected':'')+'>2-Day Rush</option>'
    +'<option value="1-Day Rush"'+(s.rushType==='1-Day Rush'?' selected':'')+'>1-Day Rush</option>'
    +'</select></div>';
  html+='<div class="form-group" style="grid-column:1/-1"><label>Remarks</label>'
    +'<textarea id="me_remarks" oninput="modalMarkDirty()">'+escHtml(s.remarks||'')+'</textarea></div>';
  document.getElementById('m_editFields').innerHTML=html;
}
function modalToggleRush(){
  var grp=document.getElementById('me_rushTypeGroup');
  if(grp) grp.style.display=document.getElementById('me_isRush').checked?'':'none';
}
function modalMarkDirty(){ modalEditDirty=true; }
function syncModalTemp(from){
  var me=document.getElementById('me_tempUponReceipt');
  var mb=document.getElementById('mb_tempUponReceipt');
  if(!me||!mb) return;
  if(from==='me') mb.value=me.value;
  else me.value=mb.value;
}

// Live TestResults rows matched to TestsJSON entries by ID (when present).
// Entries with no ID (old format, not yet backfilled) show spec only --
// same as the original behavior -- since there's nothing safe to match by.
function modalResultFor(testId){
  if(!testId) return null;
  return modalLiveResults.find(function(r){ return r.ID===testId; })||null;
}
function renderModalTestsRead(s){
  var tests=s.tests||{};
  var html='';
  MODAL_CAT_ORDER.forEach(function(cat){
    var items=tests[cat];
    if(!items||!items.length) return;
    html+='<div class="modal-cat"><div class="modal-cat-title">'+CAT_DISPLAY_NAMES[cat]+'</div>';
    items.forEach(function(entry){
      var label=testEntryLabel(entry);
      var p=parseTestLabel(label);
      var spec=p.specDisplay||'';
      var res=modalResultFor(testEntryId(entry));
      var resTxt=res&&res.ResultsDisplay?res.ResultsDisplay:'';
      html+='<div class="modal-test-row">'
        +'<span class="modal-test-name">'+escHtml(p.test)+'</span>'
        +(spec?'<span class="modal-test-spec">'+escHtml(spec)+'</span>':'')
        +(SHOW_TEST_RESULTS&&resTxt?'<span class="modal-test-result">Result: '+escHtml(resTxt)+'</span>':'')
        +'</div>';
    });
    html+='</div>';
  });
  var list=document.getElementById('m_testsList');
  list.innerHTML=html||'<div class="empty-state" style="padding:12px 0;font-size:13px">No tests recorded for this sample.</div>';
}

function modalToggleAcc(headerEl){
  var item=headerEl.closest('.m-acc-item');
  if(item) item.classList.toggle('active');
}
var BATCH_CHECKLIST_FIELDS=[
  {key:'LabelsLegible', label:'Labels legible and complete'},
  {key:'ContainersIntact', label:'Containers intact and properly sealed'},
  {key:'NoContamination', label:'No visible contamination or leakage'},
  {key:'Temperature', label:'Temperature acceptable upon receipt'},
  {key:'QuantityMatches', label:'Quantity matches documentation'},
  {key:'DocumentationComplete', label:'All documentation complete and accurate'}
];
function renderModalBatchInfoRead(s){
  var el=document.getElementById('m_batchInfoRead');
  var insp=modalCurrentInspection;
  if(!insp){
    el.innerHTML='<div class="empty-state" style="padding:8px 0;font-size:13px">No inspection recorded for batch '+escHtml(s.batchID||'')+'.</div>';
    return;
  }
  var html='';
  html+='<div class="modal-field"><span class="modal-field-label">Inspection Date:</span><span class="modal-field-value">'+escHtml(insp.InspectionDate||'')+'</span></div>';
  html+='<div class="modal-field"><span class="modal-field-label">Inspected By:</span><span class="modal-field-value">'+escHtml(insp.InspectedBy||'')+'</span></div>';
  html+='<div class="modal-field"><span class="modal-field-label">Temperature Upon Receipt:</span><span class="modal-field-value">'+escHtml(insp.TempUponReceipt||'')+'</span></div>';
  html+='<div class="modal-checklist" style="margin:10px 0">'+BATCH_CHECKLIST_FIELDS.map(function(f){
    return '<div class="checklist-item"><input type="checkbox" disabled'+(insp[f.key]?' checked':'')+'><label>'+f.label+'</label></div>';
  }).join('')+'</div>';
  html+='<div class="modal-field"><span class="modal-field-label">Inspection Notes:</span><span class="modal-field-value'+(insp.InspectionNotes?'':' empty')+'">'+escHtml(insp.InspectionNotes||'(none)')+'</span></div>';
  html+='<div class="modal-field"><span class="modal-field-label">Documents Attached:</span><span class="modal-field-value'+(insp.DocumentsAttached?'':' empty')+'">'+escHtml(insp.DocumentsAttached||'(none)')+'</span></div>';
  el.innerHTML=html;
}
function renderModalBatchInfoEdit(s){
  var el=document.getElementById('m_batchInfoEdit');
  var insp=modalCurrentInspection;
  if(!s.batchID){
    el.innerHTML='<div class="empty-state" style="padding:8px 0;font-size:13px">This sample has no Batch ID.</div>';
    return;
  }
  var html='';
  html+='<div class="form-group"><label>Inspection Date</label><input type="date" id="mb_date" value="'+escHtml((insp&&insp.InspectionDate)||'')+'" oninput="modalMarkDirty()"></div>';
  html+='<h4 style="margin:14px 0 8px;font-size:13px;color:#374151">Sample Condition Checklist</h4>'
    +BATCH_CHECKLIST_FIELDS.map(function(f){
      var checked=insp?!!insp[f.key]:true;
      return '<div class="checklist-item"><input type="checkbox" id="mb_'+f.key+'"'+(checked?' checked':'')+' onchange="modalMarkDirty()"><label for="mb_'+f.key+'">'+f.label+'</label></div>';
    }).join('');
  html+='<div class="form-group" style="margin-top:14px"><label>Temperature Upon Receipt</label><input type="number" step="0.1" id="mb_tempUponReceipt" value="'+escHtml((insp&&insp.TempUponReceipt)||'')+'" oninput="modalMarkDirty();syncModalTemp(\'mb\')"></div>';
  html+='<div class="form-group"><label>Inspection Notes / Observations</label><textarea id="mb_notes" oninput="modalMarkDirty()">'+escHtml((insp&&insp.InspectionNotes)||'')+'</textarea></div>';
  html+='<div class="form-group"><label>Documents Attached</label><input type="text" id="mb_docsAttached" value="'+escHtml((insp&&insp.DocumentsAttached)||'')+'" oninput="modalMarkDirty()"></div>';
  el.innerHTML=html;
}
function openModal(sid){
  var s=allSamples.find(function(x){ return x.sampleID===sid; })
    ||deepSearchSeenSamples.find(function(x){ return x.sampleID===sid; });
  if(!s) return;
  modalCurrentSample=s;
  modalLiveResults=[];
  modalEditDirty=false;
  modalEditTests={};
  modalPendingDeleteIds={};
  document.getElementById('m_readView').style.display='';
  document.getElementById('m_editView').style.display='none';
  modalSetEditBtnState(false);
  document.getElementById('alertModal').innerHTML='';
  renderModalReadFields(s);
  renderModalTestsRead(s);
  modalCurrentInspection=allInspections.find(function(i){ return i.BatchID===s.batchID; })||null;
  renderModalBatchInfoRead(s);
  renderModalChangeLog([]);
  document.getElementById('sampleModal').classList.add('open');
  document.getElementById('modalBox').scrollTop=0;

  // Fetch this sample's real TestResults rows (cheap -- filtered to one
  // Sample ID) so Completed tests can show their actual recorded result.
  var fields='ID,Status,TestResults,ResultsDisplay,TestMethod';
  spGet(PATH_TEST_RESULTS+"?$select="+fields+"&$filter=Title eq '"+sid.replace(/'/g,"''")+"'&$top=500")
    .then(function(d){
      modalLiveResults=d.value||[];
      if(modalCurrentSample===s) renderModalTestsRead(s);
    })
    .catch(function(e){ console.warn('openModal results fetch:',e); });

  // Fetch change log entries for this sample.
  spGet(PATH_EDIT_LOG+"?$select=Title,Reason,Created,Author/Title&$expand=Author&$filter=Title eq '"+sid.replace(/'/g,"''")+"'&$orderby=Created desc&$top=50")
    .then(function(d){ if(modalCurrentSample===s) renderModalChangeLog(d.value||[]); })
    .catch(function(e){ console.warn('openModal changelog fetch:',e); });

  // Re-fetch the batch inspection directly so modalCurrentInspection is always
  // accurate -- the allInspections cache is capped at 200 and may be stale for
  // older batches or when an inspection was just created in this session.
  if(s.batchID){
    var inspFields='ID,Title,BatchID,InspectionDate,InspectedBy,LabelsLegible,ContainersIntact,'
      +'NoContamination,Temperature,QuantityMatches,DocumentationComplete,TempUponReceipt,InspectionNotes,DocumentsAttached';
    spGet(PATH_INSPECT+"?$select="+inspFields+"&$filter=BatchID eq '"+s.batchID.replace(/'/g,"''")+"'&$top=1")
      .then(function(d){
        if(modalCurrentSample!==s) return;
        var rec=d.value&&d.value[0];
        if(rec) modalCurrentInspection=rec;
        renderModalBatchInfoRead(s);
      })
      .catch(function(e){ console.warn('openModal inspection fetch:',e); });
  }
}
function closeModalImmediate(){
  document.getElementById('sampleModal').classList.remove('open');
  modalCurrentSample=null; modalEditDirty=false; modalEditTests={}; modalPendingDeleteIds={};
}
function requestCloseModal(){
  if(modalEditDirty&&!confirm('You have unsaved changes. Close without saving?')) return;
  closeModalImmediate();
}
function requestExitModalEdit(){
  if(modalEditDirty&&!confirm('You have unsaved changes. Discard them?')) return;
  modalEditDirty=false;
  document.getElementById('m_editView').style.display='none';
  document.getElementById('m_readView').style.display='';
  modalSetEditBtnState(false);
}
function modalSetEditBtnState(active){
  var btn=document.getElementById('modalEditBtn');
  if(!btn) return;
  btn.classList.toggle('active',active);
  btn.innerHTML=active
    ?'<svg class="icon" aria-hidden="true"><use href="#icon-x-outline"></use></svg> Exit Edit Mode'
    :'<svg class="icon" aria-hidden="true"><use href="#icon-edit-outline"></use></svg> Edit Mode';
}
function modalEditModeToggleClick(){
  var inEdit=document.getElementById('m_editView').style.display!=='none';
  if(inEdit) requestExitModalEdit();
  else enterModalEditMode();
}
function enterModalEditMode(){
  if(!modalCurrentSample) return;
  var s=modalCurrentSample;
  renderModalEditFields(s);
  modalEditTests={};
  MODAL_CAT_ORDER.forEach(function(cat){
    var items=(s.tests||{})[cat]||[];
    modalEditTests[cat]=items.map(function(entry){
      var label=testEntryLabel(entry);
      var id=testEntryId(entry);
      var p=parseTestLabel(label);
      var res=modalResultFor(id);
      return{ id:id, isNew:false, removed:false, originalLabel:label,
        testName:p.test, modifier:p.specModifier||'', lower:p.specValueLower||'',
        upper:p.specValueUpper||'', units:p.units||'',
        status:(res&&res.Status)||'Pending', result:(res&&res.TestResults)||'',
        method:(res&&res.TestMethod)||'' };
    });
  });
  renderModalCatGrid();
  renderModalBatchInfoEdit(s);
  document.getElementById('me_editorName').textContent=currentUserName||'(unknown user)';
  document.getElementById('me_editReason').value='';
  document.getElementById('m_readView').style.display='none';
  document.getElementById('m_editView').style.display='';
  modalSetEditBtnState(true);
  modalEditDirty=false;
}
function goToStatusEdit(){
  if(!modalCurrentSample) return;
  var sid=modalCurrentSample.sampleID;
  closeModalImmediate();
  document.querySelectorAll('.sb-item').forEach(function(i){ i.classList.remove('active'); });
  document.querySelector('[data-page="update-status"]').classList.add('active');
  document.querySelectorAll('.page').forEach(function(p){ p.classList.remove('active'); });
  document.getElementById('page-update-status').classList.add('active');
  selectedStatusIDs=[sid];
  renderStatusList(); refreshStatusEditCard();
}
// Only closes on a full click that both starts and ends on the overlay
// itself -- a mousedown inside the modal box that happens to release
// outside it (e.g. while selecting text) must not count as "clicking
// outside" and close the modal.
var modalMousedownOnOverlay=false;
document.getElementById('sampleModal').addEventListener('mousedown',function(e){
  modalMousedownOnOverlay=(e.target===this);
});
document.getElementById('sampleModal').addEventListener('click',function(e){
  if(e.target===this&&modalMousedownOnOverlay) requestCloseModal();
  modalMousedownOnOverlay=false;
});
var rrModalMousedownOnOverlay=false;
document.getElementById('rrModal').addEventListener('mousedown',function(e){
  rrModalMousedownOnOverlay=(e.target===this);
});
document.getElementById('rrModal').addEventListener('click',function(e){
  if(e.target===this&&rrModalMousedownOnOverlay) rrCloseModal();
  rrModalMousedownOnOverlay=false;
});

/* ── Modal test editor: checkbox category grid + per-category panels ── */
function renderModalCatGrid(){
  var grid=document.getElementById('m_catGrid');
  var html='';
  testCategories.forEach(function(tc){
    var cat=tc.Code;
    var hasItems=(modalEditTests[cat]||[]).some(function(t){ return !t.removed; });
    html+='<div class="checklist-item" onclick="modalChecklistRowClick(event,\''+cat+'\')">'
      +'<input type="checkbox" id="mchk-'+cat+'" '+(hasItems?'checked':'')+' onchange="modalToggleCat(\''+cat+'\')">'
      +'<label for="mchk-'+cat+'">'+escHtml(tc.Title)+'</label>'
      +(tc.Description?'<span class="modal-checklist-desc">&#8212; '+escHtml(tc.Description)+'</span>':'')
      +'</div>';
  });
  grid.innerHTML=html;
  // Clear leftover panels before re-adding -- a category panel is only ever
  // (re)created below for categories that have items on *this* sample, so
  // without this, a panel rendered while viewing a previous, different
  // sample (e.g. Assay) would stay sitting in the DOM forever once that
  // category has no items here, making it look like categories from an
  // earlier sample "carried over" into this one.
  document.getElementById('m_catPanels').innerHTML='';
  testCategories.forEach(function(tc){
    var cat=tc.Code;
    if((modalEditTests[cat]||[]).some(function(t){ return !t.removed; })) renderModalCatPanel(cat);
  });
}
function modalChecklistRowClick(e,cat){
  // Clicking anywhere in the row toggles the checkbox (matching the old
  // card behavior) -- but let the checkbox/label's own native click handle
  // itself, so it doesn't get toggled twice.
  if(e.target.tagName==='INPUT'||e.target.tagName==='LABEL') return;
  var chk=document.getElementById('mchk-'+cat);
  if(chk){ chk.checked=!chk.checked; modalToggleCat(cat); }
}
function modalToggleCat(cat){
  var chk=document.getElementById('mchk-'+cat);
  var willOpen=chk.checked;
  if(willOpen){
    if(!modalEditTests[cat]) modalEditTests[cat]=[];
    renderModalCatPanel(cat);
  } else {
    // Unchecking removes every test currently listed for this category too
    // -- not just hiding the panel -- same per-row delete/undo rule as the
    // trash button (existing tests get marked removed=true and can still
    // be restored by re-checking the box before Save; brand-new unsaved
    // ones are dropped outright).
    (modalEditTests[cat]||[]).forEach(function(row){
      if(row.isNew) return;
      row.removed=true;
    });
    if(modalEditTests[cat]) modalEditTests[cat]=modalEditTests[cat].filter(function(row){ return !row.isNew; });
    var panel=document.getElementById('mpanel-'+cat);
    if(panel) panel.remove();
  }
  modalMarkDirty();
}
function modalFg(label,inputHtml,extraStyle,required){
  return '<div class="form-group spec-field"'+(extraStyle?' style="'+extraStyle+'"':'')+'><label>'+label
    +(required?' <span class="req">*</span>':'')+'</label>'+inputHtml+'</div>';
}
function modalComboWrapHTML(id,placeholder,value,onblurExtra){
  return '<div class="st-combobox-wrap" style="flex:1"><input type="text" id="'+id+'" value="'+escHtml(value||'')+'" placeholder="'+escHtml(placeholder)+'" autocomplete="off" oninput="modalRowFieldChanged(this)"'
    +(onblurExtra?' onblur="'+onblurExtra+'"':'')+'><div class="st-dropdown" id="'+id+'_dd"></div></div>';
}
// Two-row layout matching the New Sample form: the name/ingredient/test-type
// field always takes the full width on its own row; modifier/lower/upper/
// units (or modifier/method) share a second row beneath it.
function modalSpecFieldsHTML(pfx,row){
  var shape=fieldShapeFor(row._cat);
  var modBlur="modalAutoSplitSpecFields('"+pfx+"')";
  if(shape==='typed'){
    return modalFg('Test Type',modalComboWrapHTML(pfx+'name','Test type',row.testName),'width:100%',true);
  }
  if(shape==='single'){
    return modalFg('Ingredient',modalComboWrapHTML(pfx+'name','Ingredient',row.testName),'width:100%',true)
      +'<div class="test-fields-flex">'
      +modalFg('Comparator',modalComboWrapHTML(pfx+'mod','e.g., NLT, NMT',row.modifier,modBlur))
      +modalFg('Method','<input type="text" id="'+pfx+'method" value="'+escHtml(row.method)+'" placeholder="Method" oninput="modalRowFieldChanged(this)">')
      +'</div>';
  }
  var modVal=(row.modifier||'').trim();
  var isQualitative=QUALITATIVE_MODIFIERS.some(function(q){ return q.toLowerCase()===modVal.toLowerCase(); });
  var showUpper=UPPER_CAPABLE_MODIFIERS.some(function(m){ return m.toLowerCase()===modVal.toLowerCase(); });
  return modalFg('Test Name',modalComboWrapHTML(pfx+'name','Test name',row.testName),'width:100%',true)
    +'<div class="test-fields-flex">'
    +modalFg('Comparator',modalComboWrapHTML(pfx+'mod','e.g., NMT, NLT, Range',row.modifier,modBlur))
    +modalFg('Lower / Value','<input type="text" id="'+pfx+'lower" value="'+escHtml(row.lower)+'" placeholder="Lower" oninput="modalRowFieldChanged(this)" onblur="modalAutoSplitSpecFields(\''+pfx+'\')">',isQualitative?'display:none':'')
    +modalFg('Upper','<input type="text" id="'+pfx+'upper" value="'+escHtml(row.upper)+'" placeholder="Upper" oninput="modalRowFieldChanged(this)" onblur="modalAutoSplitSpecFields(\''+pfx+'\')">',showUpper?'':'display:none')
    +modalFg('Units','<input type="text" id="'+pfx+'units" value="'+escHtml(row.units)+'" placeholder="Units" oninput="modalRowFieldChanged(this)" onblur="modalAutoSplitSpecFields(\''+pfx+'\')">')
    +'</div>';
}
function modalClearStaging(cat){
  var pfx='mnew_'+cat+'_';
  ['name','mod','lower','upper','units','method'].forEach(function(suf){
    var el=document.getElementById(pfx+suf);
    if(el) el.value='';
  });
  modalToggleUpperField(pfx);
}
function modalRowFieldChanged(el){
  // Generic dirty marker for any field with an id we don't need to parse
  // back into a row object immediately -- rows are read fully at Save
  // time (saveModalEdits) and at "Add Test" commit time, so this just
  // needs to flag that something changed.
  modalMarkDirty();
}
function modalToggleUpperField(pfx){
  var modEl=document.getElementById(pfx+'mod');
  if(!modEl) return;
  var modVal=(modEl.value||'').trim();
  var upGroup=document.getElementById(pfx+'upperGroup')||(document.getElementById(pfx+'upper')?document.getElementById(pfx+'upper').closest('.spec-field'):null);
  var lowGroup=document.getElementById(pfx+'lowerGroup')||(document.getElementById(pfx+'lower')?document.getElementById(pfx+'lower').closest('.spec-field'):null);
  var showUpper=UPPER_CAPABLE_MODIFIERS.some(function(m){ return m.toLowerCase()===modVal.toLowerCase(); });
  var isQualitative=QUALITATIVE_MODIFIERS.some(function(q){ return q.toLowerCase()===modVal.toLowerCase(); });
  if(upGroup){
    upGroup.style.display=showUpper?'':'none';
    if(!showUpper){ var u=document.getElementById(pfx+'upper'); if(u) u.value=''; }
  }
  if(lowGroup){
    lowGroup.style.display=isQualitative?'none':'';
    if(isQualitative){ var l=document.getElementById(pfx+'lower'); if(l) l.value=''; }
  }
}
function modalAutoSplitSpecFields(pfx){
  var modEl=document.getElementById(pfx+'mod'), lowEl=document.getElementById(pfx+'lower'),
      upEl=document.getElementById(pfx+'upper'), untEl=document.getElementById(pfx+'units');
  if(!modEl||!lowEl||!upEl||!untEl) return;
  var combined=[modEl.value,lowEl.value,upEl.value,untEl.value]
    .map(function(v){ return (v||'').trim(); }).filter(function(v){ return v; })
    .join(' ').replace(/(\d),(?=\d{3})/g,'$1');
  if(!combined) return;
  var p=parseSpecRaw(combined);
  if(!p.matched) return;
  modEl.value=normalizeModifier(p.specModifier)||'';
  lowEl.value=p.specValueLower||'';
  upEl.value=p.specValueUpper||'';
  untEl.value=p.units||'';
  modalToggleUpperField(pfx);
}
function modalValidateModifier(pfx){
  return true;
}
// Wires the Modifier combobox (always, free-text-with-suggestions, same
// options/Other behavior as the New Sample form) and the name/ingredient
// combobox (sourced from SampleTests when available, or the fixed Stability
// suggestions, or left as plain free-text when no catalog entries exist for
// that category -- exactly how the New Sample form already behaves).
function modalWireCombos(pfx,cat){
  var shape=fieldShapeFor(cat);
  var modInp=document.getElementById(pfx+'mod'), modDd=document.getElementById(pfx+'mod_dd');
  if(modInp&&modDd&&shape!=='typed') initStaticCombobox(modInp,modDd,MODIFIER_OPTIONS,function(){
    modalToggleUpperField(pfx); modalAutoSplitSpecFields(pfx); modalMarkDirty();
  });
  var nameInp=document.getElementById(pfx+'name'), nameDd=document.getElementById(pfx+'name_dd');
  if(!nameInp||!nameDd) return;
  if(shape==='typed') initStaticCombobox(nameInp,nameDd,STABILITY_TYPE_OPTIONS,function(){ modalMarkDirty(); });
  else initCategoryCombobox(nameInp,nameDd,cat);
  modalToggleUpperField(pfx);
}
function modalReadSpecFieldsFromDOM(pfx,row){
  var shape=fieldShapeFor(row._cat);
  var nameEl=document.getElementById(pfx+'name');
  if(nameEl) row.testName=nameEl.value.trim();
  var modEl=document.getElementById(pfx+'mod');
  if(modEl) row.modifier=modEl.value.trim();
  if(shape==='single'){
    var methodEl=document.getElementById(pfx+'method');
    if(methodEl) row.method=methodEl.value.trim();
  } else if(shape!=='typed'){
    var lowerEl=document.getElementById(pfx+'lower');
    if(lowerEl) row.lower=lowerEl.value.trim();
    var upperEl=document.getElementById(pfx+'upper');
    if(upperEl) row.upper=upperEl.value.trim();
    var unitsEl=document.getElementById(pfx+'units');
    if(unitsEl) row.units=unitsEl.value.trim();
  }
  return row;
}
function modalCatOrderIndex(cat){
  var i=testCategories.findIndex(function(tc){ return tc.Code===cat; });
  return i===-1?9999:i;
}
function renderModalCatPanel(cat){
  var existing=document.getElementById('mpanel-'+cat);
  if(existing) existing.remove();
  var rows=modalEditTests[cat]||[];
  var div=document.createElement('div');
  div.className='test-panel open';
  div.id='mpanel-'+cat;
  div.dataset.catIndex=modalCatOrderIndex(cat);
  var html='<h4 style="text-align:center">'+CAT_DISPLAY_NAMES[cat]+'</h4>';
  if(rows.length) html+='<h5 style="font-size:12px;font-weight:700;color:#64748b;text-transform:uppercase;letter-spacing:.5px;margin:0 0 10px">Existing Tests</h5>';
  rows.forEach(function(row,idx){
    row._cat=cat;
    if(row.removed){
      var summary=row.testName+(row.modifier?' '+String.fromCharCode(8212)+' '+[row.modifier,row.lower,row.upper,row.units].filter(function(v){return v;}).join(' '):'');
      html+='<div class="modal-test-entry ih-row-deleted-edit" style="display:flex;align-items:center;gap:8px">'
        +'<span style="text-decoration:line-through;color:#999;flex:1">'+escHtml(summary)+'</span>'
        +'<button class="ih-undo-btn" onclick="modalUndoDeleteRow(\''+cat+'\','+idx+')" title="Undo delete"><svg class="icon" aria-hidden="true"><use href="#icon-undo-outline"></use></svg></button>'
        +'</div>';
      return;
    }
    var pfx='mt_'+cat+'_'+idx+'_';
    html+='<div class="modal-test-entry">'
      +modalSpecFieldsHTML(pfx,row);
    if(!row.isNew){
      html+='<div class="modal-test-row-actions">'
        +(SHOW_TEST_RESULTS?'<input type="text" class="mt-result" id="'+pfx+'result" value="'+escHtml(row.result)+'" placeholder="Result" oninput="modalRowFieldChanged(this)">':'')
        +'<select class="mt-status" id="'+pfx+'status" oninput="modalRowFieldChanged(this)">'
        +['Pending','Completed','Cancelled'].map(function(opt){ return '<option'+(row.status===opt?' selected':'')+'>'+opt+'</option>'; }).join('')
        +'</select>'
        +'<button class="ih-del-btn mt-del" onclick="modalDeleteRow(\''+cat+'\','+idx+')" title="Delete test"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>'
        +'</div>';
    } else {
      html+='<div class="modal-test-row-actions" style="justify-content:flex-end">'
        +'<button class="ih-del-btn" onclick="modalDeleteRow(\''+cat+'\','+idx+')" title="Remove"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>'
        +'</div>';
    }
    html+='</div>';
  });
  // Staging "add new" row -- not committed to modalEditTests until the
  // Add Test button validates and pushes it, mirroring the New Sample
  // form's pattern exactly (a typo'd or empty name never gets added).
  var newPfx='mnew_'+cat+'_';
  html+='<div class="modal-new-test-section"><h5>Add a New Test</h5>'
    +'<div class="modal-test-entry" style="background:#f8f9fa">'
    +modalSpecFieldsHTML(newPfx,{testName:'',modifier:'',lower:'',upper:'',units:'',method:'',_cat:cat})
    +'<div style="display:flex;align-items:center;justify-content:flex-end;gap:8px;margin-top:10px">'
    +'<button type="button" class="ih-del-btn" onclick="modalClearStaging(\''+cat+'\')" title="Clear"><svg class="icon" aria-hidden="true"><use href="#icon-trash-outline"></use></svg></button>'
    +'<button class="btn-add-test" onclick="modalCommitNewTest(\''+cat+'\')"><svg class="icon" aria-hidden="true"><use href="#icon-plus-outline"></use></svg> Add Test</button>'
    +'</div></div></div>';
  div.innerHTML=html;
  // Insert at the position matching the category's canonical order,
  // instead of always appending at the end -- re-rendering a panel (on
  // every add/edit/delete) must not bump it out of its proper place.
  var container=document.getElementById('m_catPanels');
  var myIdx=Number(div.dataset.catIndex);
  var sibling=Array.prototype.find.call(container.children,function(c){
    return Number(c.dataset.catIndex)>myIdx;
  });
  if(sibling) container.insertBefore(div,sibling);
  else container.appendChild(div);
  rows.forEach(function(row,idx){
    if(row.removed) return;
    modalWireCombos('mt_'+cat+'_'+idx+'_',cat);
  });
  modalWireCombos(newPfx,cat);
}
function modalCommitNewTest(cat){
  var pfx='mnew_'+cat+'_';
  var row={ id:null, isNew:true, removed:false, _cat:cat,
    testName:'', modifier:'', lower:'', upper:'', units:'', method:'', status:'Pending', result:'' };
  modalReadSpecFieldsFromDOM(pfx,row);
  if(!row.testName){ alert('Enter a test name before adding it.'); return; }
  if(!modalValidateModifier(pfx)){
    alert('"'+document.getElementById(pfx+'mod').value+'" is not a recognized Comparator. Select one from the list, or choose "Other (type freely)" to enter a custom value.');
    return;
  }
  if(!modalEditTests[cat]) modalEditTests[cat]=[];
  modalEditTests[cat].push(row);
  renderModalCatPanel(cat);
  modalMarkDirty();
}
function modalDeleteRow(cat,idx){
  var row=modalEditTests[cat][idx];
  var pfx='mt_'+cat+'_'+idx+'_';
  modalReadSpecFieldsFromDOM(pfx,row);
  if(row.isNew){
    // Never saved to SharePoint yet -- just drop it, no undo needed.
    modalEditTests[cat].splice(idx,1);
  } else {
    row.removed=true;
  }
  renderModalCatPanel(cat);
  modalMarkDirty();
}
function modalUndoDeleteRow(cat,idx){
  modalEditTests[cat][idx].removed=false;
  renderModalCatPanel(cat);
  modalMarkDirty();
}
// Mirrors the exact label format each category's addTest() branch already
// produces, so a regenerated label after editing parses back identically
// via the existing parseTestLabel()/parseSpecRaw() (used both for display
// and for deriving SpecModifier/Lower/Upper/Units/SpecDisplay on save).
function modalBuildLabel(cat,row){
  var emdash=' '+String.fromCharCode(8212)+' ';
  var shape=fieldShapeFor(cat);
  var name=row.testName||'';
  if(shape==='typed') return name;
  if(shape==='single'){
    var mod=normalizeModifier(row.modifier||'');
    var mth=row.method||'';
    var spec=mod?(mod+(mth?' ('+mth+')':'')):mth;
    return name+(spec?emdash+spec:'');
  }
  var frag=[row.modifier,row.lower,row.upper,row.units].filter(function(v){ return v; }).join(' ');
  return name+(frag?emdash+frag:'');
}
function saveModalBatchInfo(s,testWriteFailures){
  if(!s.batchID) return Promise.resolve();
  var dateEl=document.getElementById('mb_date');
  if(!dateEl) return Promise.resolve(); // batch info accordion wasn't rendered
  var body={
    BatchID:s.batchID,
    InspectionDate:dateEl.value,
    InspectionNotes:document.getElementById('mb_notes').value.trim(),
    DocumentsAttached:document.getElementById('mb_docsAttached').value.trim(),
    TempUponReceipt:document.getElementById('mb_tempUponReceipt').value.trim()
  };
  BATCH_CHECKLIST_FIELDS.forEach(function(f){
    var el=document.getElementById('mb_'+f.key);
    body[f.key]=el?el.checked===true:false;
  });
  var insp=modalCurrentInspection;
  if(insp&&insp.ID){
    return spPatch(PATH_INSPECT,insp.ID,body)
      .then(function(){ Object.keys(body).forEach(function(k){ insp[k]=body[k]; }); })
      .catch(function(e){ console.error('batch info patch failed:',e); testWriteFailures.push('batch info: '+e.message); });
  }
  if(!body.InspectionDate) body.InspectionDate=todayStr(); // default to today if no date set
  body.Title=s.batchID+'_'+body.InspectionDate;
  body.InspectedBy=currentUserName||'';
  return spPost(PATH_INSPECT,body)
    .then(function(d){ body.ID=d&&d.ID; modalCurrentInspection=body; allInspections.unshift(body); })
    .catch(function(e){ console.error('batch info post failed:',e); testWriteFailures.push('batch info: '+e.message); });
}
function saveModalEdits(){
  var s=modalCurrentSample;
  if(!s) return;
  clearFieldErrors();
  var hasErrors=false;
  MODAL_FIELDS.forEach(function(f){
    if(!f.editable||!f.required) return;
    var el=document.getElementById('me_'+f.key);
    if(el&&!String(el.value||'').trim()){ markFieldError('me_'+f.key); hasErrors=true; }
  });
  var isRush=document.getElementById('me_isRush').checked;
  var rushType=isRush?document.getElementById('me_rushType').value:'';
  if(isRush&&!rushType){ markFieldError('me_rushType'); hasErrors=true; }
  // Re-read every active row's current field values from the DOM first --
  // they're only synced on commit (new tests) or delete, not on every
  // keystroke, so Save needs a fresh read right before validating/sending.
  // Rows with no linked ID yet (pre-backfill) are intentionally excluded
  // from validation too, since they're left untouched either way below --
  // an unrelated old test with a blank name should never block saving
  // something else on the same sample.
  Object.keys(modalEditTests).forEach(function(cat){
    modalEditTests[cat].forEach(function(row,idx){
      if(row.removed) return;
      if(!row.isNew&&!row.id) return;
      modalReadSpecFieldsFromDOM('mt_'+cat+'_'+idx+'_',row);
      if(!row.isNew){
        var resEl=document.getElementById('mt_'+cat+'_'+idx+'_result');
        if(resEl) row.result=resEl.value.trim();
        var statEl=document.getElementById('mt_'+cat+'_'+idx+'_status');
        if(statEl) row.status=statEl.value;
      }
      if(!row.testName){ hasErrors=true; }
    });
  });
  var editReason=document.getElementById('me_editReason').value.trim();
  if(!editReason){ markFieldError('me_editReason'); hasErrors=true; }
  if(hasErrors){ showAlert('alertModal','Please fill all required fields marked with *','error'); modalScrollAlertIntoView(); return; }

  showLoading('Saving changes...');
  var newCustomer=document.getElementById('me_customer').value;
  var newDateReceived=document.getElementById('me_dateReceived').value;
  var newResultPosts=[]; // {cat,idx,body,newId}
  var deletes=[];
  var patches=[];
  var skippedNoId=[]; // existing tests with no linked TestResults ID yet --
                       // can't be safely edited/removed until the backfill
                       // script runs; everything else still saves normally.

  Object.keys(modalEditTests).forEach(function(cat){
    modalEditTests[cat].forEach(function(row,idx){
      if(!row.isNew&&!row.id){
        // Existing test from before the editable-tests feature -- TestsJSON
        // has no linked TestResults ID for it yet (needs the one-time
        // backfill script). Can't safely edit or delete it without risking
        // touching the wrong row, so it's left exactly as it was.
        skippedNoId.push(row.originalLabel||row.testName);
        return;
      }
      if(row.removed){
        if(row.id) deletes.push(row.id);
        return;
      }
      var label=modalBuildLabel(cat,row);
      var p=parseTestLabel(label);
      var body={
        Title:s.sampleID, DateReceived:newDateReceived, Customer:newCustomer,
        LotNumber:document.getElementById('me_lotNumber').value.trim(),
        TestCategory:CAT_CODE_TO_LABEL[cat]||cat, Test:p.test,
        SpecModifier:p.specModifier, SpecValueLower:p.specValueLower,
        SpecValueUpper:p.specValueUpper, Units:p.units, SpecDisplay:p.specDisplay
      };
      if(row.isNew){
        body.Status='Pending'; body.TestResults=''; body.ResultsDisplay='';
        newResultPosts.push({cat:cat,idx:idx,body:body});
      } else {
        body.Status=row.status;
        body.TestResults=row.result;
        body.ResultsDisplay=row.result?(row.result+(p.units?' '+p.units:'')):'';
        patches.push({id:row.id,body:body});
      }
    });
  });

  var testWriteFailures=[]; // collected instead of swallowed, so a real
                             // SharePoint rejection never looks like success
  var failedPatchIds={};    // id -> true, so a failed edit keeps its
                             // original label/id in TestsJSON instead of
                             // the unsaved edited one
  var failedPostKeys={};    // 'cat|idx' -> true, so a failed new-test POST
                             // never gets written into TestsJSON at all
  Promise.all(deletes.map(function(id){
    return spDelete(PATH_TEST_RESULTS,id).catch(function(e){
      console.error('delete test',id,e); testWriteFailures.push('delete #'+id+': '+e.message);
    });
  }))
  .then(function(){
    return Promise.all(patches.map(function(p){
      return spPatch(PATH_TEST_RESULTS,p.id,p.body).catch(function(e){
        console.error('patch test',p.id,e); testWriteFailures.push('update "'+p.body.Test+'": '+e.message);
        failedPatchIds[p.id]=true;
      });
    }));
  })
  .then(function(){
    function postNext(i){
      if(i>=newResultPosts.length) return Promise.resolve();
      return spPost(PATH_TEST_RESULTS,newResultPosts[i].body).then(function(d){
        newResultPosts[i].newId=d&&d.ID;
        return postNext(i+1);
      }).catch(function(e){
        console.error('post new test',e); testWriteFailures.push('add "'+newResultPosts[i].body.Test+'": '+e.message);
        failedPostKeys[newResultPosts[i].cat+'|'+newResultPosts[i].idx]=true;
        return postNext(i+1);
      });
    }
    return postNext(0);
  })
  .then(function(){
    var newTests={};
    Object.keys(modalEditTests).forEach(function(cat){
      var arr=[];
      modalEditTests[cat].forEach(function(row,idx){
        if(!row.isNew&&!row.id){
          // Couldn't safely edit/delete this one (see skippedNoId above) --
          // keep it exactly as it already was, untouched.
          arr.push(row.originalLabel||row.testName);
          return;
        }
        if(row.removed) return;
        if(!row.isNew&&failedPatchIds[row.id]){
          // The edit didn't actually save -- keep the original, not the
          // unsaved edited text, so the two never drift apart.
          arr.push(row.originalLabel||makeTestEntry(row.testName,row.id));
          return;
        }
        var label=modalBuildLabel(cat,row);
        var id=row.id;
        if(row.isNew){
          if(failedPostKeys[cat+'|'+idx]) return; // never saved -- drop it, don't fake an entry
          var match=newResultPosts.find(function(np){ return np.cat===cat&&np.idx===idx; });
          id=match?match.newId:null;
        }
        arr.push(makeTestEntry(label,id));
      });
      if(arr.length) newTests[cat]=arr;
    });
    var cats=Object.keys(newTests).join(',');

    var sampleBody={
      SampleName:document.getElementById('me_sampleName').value.trim(),
      Customer:newCustomer,
      LotNumber:document.getElementById('me_lotNumber').value.trim(),
      Matrix:document.getElementById('me_matrix').value,
      SampleType:document.getElementById('me_type').value,
      Units:parseInt(document.getElementById('me_units').value)||0,
      ServingSize:document.getElementById('me_servingSize').value.trim(),
      ExtRef:document.getElementById('me_extRef').value.trim(),
      DateReceived:newDateReceived,
      TempUponReceipt:document.getElementById('me_tempUponReceipt').value.trim(),
      IsRush:isRush, RushType:rushType,
      Remarks:document.getElementById('me_remarks').value.trim(),
      TestsJSON:JSON.stringify(newTests), TestCategories:cats
    };
    return spPatch(PATH_SAMPLES,s._spID,sampleBody).then(function(){
      s.sampleName=sampleBody.SampleName; s.customer=sampleBody.Customer; s.lotNumber=sampleBody.LotNumber; s.matrix=sampleBody.Matrix;
      s.type=sampleBody.SampleType; s.units=sampleBody.Units; s.servingSize=sampleBody.ServingSize;
      s.extRef=sampleBody.ExtRef; s.dateReceived=sampleBody.DateReceived; s.tempUponReceipt=sampleBody.TempUponReceipt;
      s.isRush=isRush; s.rushType=rushType; s.remarks=sampleBody.Remarks;
      s.tests=newTests; s.testCategoryCodes=cats;
      editedSampleIds.add(s.sampleID);
      return spPost(PATH_EDIT_LOG,{Title:s.sampleID,Reason:editReason})
        .catch(function(e){ console.error('SampleEditLog post failed:',e); })
        .then(function(){ return saveModalBatchInfo(s,testWriteFailures); });
    });
  })
  .then(function(){
    hideLoading();
    modalEditDirty=false;
    document.getElementById('m_editView').style.display='none';
    document.getElementById('m_readView').style.display='';
    modalSetEditBtnState(false);
    renderModalReadFields(s);
    renderModalBatchInfoRead(s);
    renderMasterList();
    renderStatusList();
    renderRushOrders();
    spGet(PATH_EDIT_LOG+"?$select=Title,Reason,Created,Author/Title&$expand=Author&$filter=Title eq '"+s.sampleID.replace(/'/g,"''")+"'&$orderby=Created desc&$top=50")
      .then(function(d){ renderModalChangeLog(d.value||[]); })
      .catch(function(){})
    var msg=testWriteFailures.length
      ?'Saved, but '+testWriteFailures.length+' test change(s) failed and were not applied: '+testWriteFailures.join('; ')
      :'Changes saved.';
    if(skippedNoId.length) msg+=' ('+skippedNoId.length+' older test(s) left unchanged -- run the backfill script first to make them editable.)';
    showAlert('alertModal',msg,testWriteFailures.length?'error':'success');
    modalScrollAlertIntoView();
    var fields='ID,Status,TestResults,ResultsDisplay,TestMethod';
    spGet(PATH_TEST_RESULTS+"?$select="+fields+"&$filter=Title eq '"+s.sampleID.replace(/'/g,"''")+"'&$top=500")
      .then(function(d){ modalLiveResults=d.value||[]; renderModalTestsRead(s); });
  })
  .catch(function(e){
    hideLoading();
    showAlert('alertModal','Error saving: '+e.message,'error');
    modalScrollAlertIntoView();
    console.error('saveModalEdits:',e);
  });
}
// alertModal sits at the top of #modalBox (the scrollable area inside the
// Sample Detail modal) -- if the user was scrolled down editing tests near
// the bottom when they hit Save, the success/error banner is invisible
// without this.
function modalScrollAlertIntoView(){
  var box=document.getElementById('modalBox');
  if(box) box.scrollTo({top:0,behavior:'smooth'});
}

/* ════════════════════════════════════════════════════════════
   BATCH INSPECTION
════════════════════════════════════════════════════════════ */
function saveInspection(){
  var bid=document.getElementById('in_batchID').value.trim();
  var by=document.getElementById('in_by').value.trim();
  var date=document.getElementById('in_date').value;
  if(!bid||!date){ showAlert('alertInspect','Batch ID and Inspection Date are required','error'); return; }
  showLoading('Saving inspection to SharePoint...');
  spPost(PATH_INSPECT,{
    Title:bid+'_'+date,
    BatchID:bid,
    InspectionDate:date,
    InspectedBy:by,
    LabelsLegible:document.getElementById('in_labels').checked === true,
    ContainersIntact:document.getElementById('in_containers').checked === true,
    NoContamination:document.getElementById('in_contam').checked === true,
    Temperature:document.getElementById('in_temp').checked === true,
    QuantityMatches:document.getElementById('in_qty').checked === true,
    DocumentationComplete:document.getElementById('in_docs').checked === true,
    TempUponReceipt:document.getElementById('in_tempUponReceipt').value.trim(),
    InspectionNotes:document.getElementById('in_notes').value.trim(),
    DocumentsAttached:document.getElementById('in_docs_attached').value.trim()
  })
  .then(function(){
    hideLoading();
    batchTempUponReceipt=document.getElementById('in_tempUponReceipt').value.trim();
    loadInspections(renderInspectionHistory);
    nsScrollToStepper();
    setTimeout(function(){
      showAlert('alertInspect','Inspection saved for batch '+bid,'success');
      setTimeout(function(){
        nsShowStep(3);
        // nsShowStep's own fade-out/hide sequence takes ~850ms (350ms delay
        // before fading starts + 500ms for the fade/swap). Wait past that
        // before resetting the form, so the checkbox reset happens while
        // Step 2 is already hidden, not visibly mid-fade.
        setTimeout(clearInspection, 900);
        // If a prefill is active, load the first sample after the transition
        if(rrPrefillData&&rrPrefillQueueIdx===0) setTimeout(function(){ nsLoadPrefillSample(0); },950);
      },1500);
    },500);
  })
  .catch(function(e){
    hideLoading();
    showAlert('alertInspect','Error: '+e.message,'error');
  });
}
function clearInspection(){
  // Restore auto-filled batch ID rather than blanking it
  document.getElementById('in_batchID').value=batchID||'';
  document.getElementById('in_date').value=todayStr();
  document.getElementById('in_by').value=currentUserName;
  ['in_labels','in_containers','in_contam','in_temp','in_qty','in_docs'].forEach(function(id){ document.getElementById(id).checked=true; });
  document.getElementById('in_tempUponReceipt').value='';
  document.getElementById('in_notes').value='';
  document.getElementById('in_docs_attached').value='';
}
function renderInspectionHistory(){
  var el=document.getElementById('inspectionHistory');
  if(!allInspections.length){ el.innerHTML='<div class="empty-state">No inspections recorded yet.</div>'; return; }
  el.innerHTML='<div class="table-wrap"><table><thead><tr>'
    +'<th>Batch ID</th><th>Date</th><th>Inspected By</th><th>Checks Passed</th><th>Documents</th><th>Notes</th>'
    +'</tr></thead><tbody>'+allInspections.slice(0,15).map(function(r){
      var chks=[r.LabelsLegible,r.ContainersIntact,r.NoContamination,r.Temperature,r.QuantityMatches,r.DocumentationComplete];
      var notes=r.InspectionNotes||'';
      return '<tr>'
        +'<td data-label="Batch ID"><strong>'+(r.BatchID||r.Title)+'</strong></td>'
        +'<td data-label="Date">'+(r.InspectionDate||'')+'</td>'
        +'<td data-label="Inspected By">'+(r.InspectedBy||'')+'</td>'
        +'<td data-label="Checks Passed">'+chks.filter(Boolean).length+' / 6</td>'
        +'<td data-label="Documents"><small>'+(r.DocumentsAttached||' - ')+'</small></td>'
        +'<td data-label="Notes"><small>'+escHtml(notes.slice(0,60))+(notes.length>60?'...':'')+'</small></td></tr>';
    }).join('')+'</tbody></table></div>';
}

/* ════════════════════════════════════════════════════════════
   LAB ORDER — VERTEX  (tests loaded from 'VertexTests' SharePoint list)
════════════════════════════════════════════════════════════ */
function activeInhouseTestNames(){
  var s=new Set();
  allInhouseTests.forEach(function(t){ if(t.status==='Active') s.add(t.title); });
  return s;
}
function getTestsForLab(labName){
  return externalLabTests.filter(function(t){ return t.LabName === labName; }).map(function(t){ return t.Title; });
}
var loBatchesFiltered=[];
var loBatchesShown=0;
var LO_PAGE=10;

function loBatchRows(batches){
  return batches.map(function(b){
    return '<tr>'
      +'<td data-label="Batch ID"><strong>'+escHtml(b.batchID)+'</strong></td>'
      +'<td data-label="Customer">'+escHtml(b.customer)+'</td>'
      +'<td data-label="Date">'+b.date+'</td>'
      +'<td data-label="Samples">'+b.samples.length+'</td>'
      +'<td data-label=""><button class="btn-primary btn-sm" onclick="generateBatchOrder(\''+b.batchID+'\')">Generate Order</button></td></tr>';
  }).join('');
}

function updateLoLoadMore(){
  document.getElementById('loLoadMoreWrap').style.display=
    loBatchesShown<loBatchesFiltered.length?'':'none';
}

function renderLabOrderList(){
  var q=(document.getElementById('loSearch').value||'').toLowerCase();

  // Group samples by batchID
  var batchMap={};
  var pool=poolFor('lab',q,allSamples);
  pool.forEach(function(s){
    if(!s.batchID) return;
    if(q && !s.batchID.toLowerCase().includes(q) && !s.customer.toLowerCase().includes(q)) return;
    if(!batchMap[s.batchID]) batchMap[s.batchID]={ batchID:s.batchID, customer:s.customer, date:s.dateReceived, samples:[] };
    batchMap[s.batchID].samples.push(s);
  });

  var ihNames=activeInhouseTestNames();
  loBatchesFiltered=Object.values(batchMap).filter(function(b){
    return b.samples.some(function(s){
      if(!s.tests) return false;
      return Object.values(s.tests).some(function(arr){
        return Array.isArray(arr)&&arr.some(function(entry){
          var name=parseTestLabel(testEntryLabel(entry)).test;
          return name&&ihNames.has(name);
        });
      });
    });
  });
  loBatchesShown=0;
  var el=document.getElementById('loSampleList');

  if(!loBatchesFiltered.length){
    el.innerHTML='<div class="card"><div class="empty-state">No batches found.</div></div>';
    updateLoLoadMore(); return;
  }

  loBatchesShown=Math.min(LO_PAGE,loBatchesFiltered.length);
  el.innerHTML='<div class="card"><h2>Available Batches</h2>'
    +'<div class="table-wrap"><table><thead><tr>'
    +'<th>Batch ID</th><th>Customer</th><th>Date</th><th>Samples</th><th></th>'
    +'</tr></thead><tbody>'
    +loBatchRows(loBatchesFiltered.slice(0,loBatchesShown))
    +'</tbody></table></div></div>';
  updateLoLoadMore();
}

function loadMoreLabOrderBatches(){
  var next=loBatchesFiltered.slice(loBatchesShown,loBatchesShown+LO_PAGE);
  var tbody=document.querySelector('#loSampleList tbody');
  if(tbody) tbody.insertAdjacentHTML('beforeend',loBatchRows(next));
  loBatchesShown+=next.length;
  updateLoLoadMore();
}
function generateLabOrder(sid){
  var s=allSamples.find(function(x){ return x.sampleID===sid; });
  if(!s) return;
  var vertexTests=getTestsForLab('Vertex');
  var allTests=[];
  if(s.tests){
    Object.values(s.tests).forEach(function(arr){
      if(Array.isArray(arr)) allTests=allTests.concat(arr);
    });
  }
  var vt=allTests.filter(function(t){
    return vertexTests.some(function(v){ return t.toLowerCase().includes(v.toLowerCase()); });
  });
  document.getElementById('loContent').innerHTML=
    '<div style="text-align:center;margin-bottom:20px;padding-bottom:14px;border-bottom:2px solid #333">'
    +'<h2 style="font-size:18px">LABORATORY ORDER FORM &#8212; VERTEX</h2>'
    +'<p style="font-size:12px;color:#666">Vertex Laboratory Services | ISO 17025 Accredited</p></div>'
    +'<div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:16px">'
    +'<div><strong>Order Date:</strong> '+todayStr()+'<br><strong>Sample ID:</strong> '+s.sampleID+'<br><strong>Report ID:</strong> '+s.reportID+'</div>'
    +'<div><strong>Customer:</strong> '+escHtml(s.customer)+'<br><strong>Sample:</strong> '+escHtml(s.sampleName)+'<br><strong>Lot:</strong> '+(s.lotNumber||'N/A')+'<br><strong>Serving Size:</strong> '+(s.servingSize||'N/A')+'</div></div>'
    +'<hr style="margin:14px 0"><h3 style="margin-bottom:10px;font-size:14px">Vertex Tests Required</h3>'
    +'<div class="table-wrap"><table><thead><tr><th>#</th><th>Test</th><th>Method</th></tr></thead><tbody>'
    +vt.map(function(t,i){
    var method = (externalLabTests.find(function(x){
      return x.Title && t.toLowerCase().includes(x.Title.toLowerCase());
    })||{}).Method || 'HPLC';
    return '<tr><td>'+(i+1)+'</td><td>'+escHtml(t).replace(/—/g,'&#8212;')
    +'</td><td>'+escHtml(method)+'</td></tr>';
    }).join('')
    +'</tbody></table></div>'
    +'<div class="print-only" style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-top:28px">'
    +'<div><strong>Prepared By:</strong><br><br>___________________________<br><small>Name / Date</small></div>'
    +'<div><strong>Authorized By:</strong><br><br>___________________________<br><small>Name / Date</small></div></div>';
  document.getElementById('loPrintArea').style.display='block';
  document.getElementById('loPrintArea').scrollIntoView({behavior:'smooth'});
}
function generateBatchOrder(batchID){
  var q=(document.getElementById('loSearch').value||'').toLowerCase();
  var pool=poolFor('lab',q,allSamples);
  var samples=pool.filter(function(s){ return s.batchID===batchID; });
  if(!samples.length){ alert('No samples found for batch '+batchID); return; }

  // Fetch this batch's real TestResults rows in one shot -- OR'd across the
  // batch's Sample IDs, all on the same indexed Title column, so it stays
  // safe under the List View Threshold even once the list is large. Lets
  // the document show each test's actual recorded result, resolved by the
  // linked TestResults ID stored on each TestsJSON entry, not by ambiguous
  // name-matching.
  var titleFilter=samples.map(function(s){ return "Title eq '"+s.sampleID.replace(/'/g,"''")+"'"; }).join(' or ');
  showLoading('Loading test results...');
  spGet(PATH_TEST_RESULTS+"?$select=ID,Status,ResultsDisplay&$filter=("+titleFilter+")&$top=5000")
    .then(function(d){ hideLoading(); _paintBatchOrder(batchID,samples,d.value||[]); })
    .catch(function(e){ hideLoading(); console.warn('generateBatchOrder results fetch:',e); _paintBatchOrder(batchID,samples,[]); });
}
function _paintBatchOrder(batchID,samples,liveResults){
  function resultFor(id){ return id?liveResults.find(function(r){ return r.ID===id; }):null; }
  var html=''
    +'<div style="text-align:center;margin-bottom:20px;padding-bottom:14px;border-bottom:3px solid #1a3a5c">'
    +'<h2 style="font-size:20px;font-weight:700;color:#1a3a5c;letter-spacing:1px">LABORATORY ORDER FORM &#8212; VERTEX</h2>'
    +'<p style="font-size:11px;color:#666;margin-top:4px">Vertex Analytical Labs LLC | ISO 17025 Accredited</p>'
    +'</div>'
    +'<table style="width:100%;border-collapse:collapse;font-size:12px;margin-bottom:16px">'
    +'<tr>'
    +'<td style="padding:4px 8px"><strong>Batch ID:</strong> '+escHtml(batchID)+'</td>'
    +'<td style="padding:4px 8px"><strong>Total Samples:</strong> '+samples.length+'</td>'
    +'</tr>'
    +'<tr>'
    +'<td style="padding:4px 8px"><strong>Customer:</strong> '+escHtml(samples[0].customer)+'</td>'
    +'<td style="padding:4px 8px"><strong>Order Date:</strong> '+todayStr()+'</td>'
    +'</tr>'
    +'<tr>'
    +'<td style="padding:4px 8px"><strong>Date Received:</strong> '+samples[0].dateReceived+'</td>'
    +'<td style="padding:4px 8px"><strong>Temp. Upon Receipt:</strong> '+(samples[0].tempUponReceipt||(allInspections.find(function(i){return i.BatchID===batchID;})||{}).TempUponReceipt||'&#8212;')+'</td>'
    +'</tr>'
    +'</table>'
    +'<hr style="margin:12px 0;border:none;border-top:1px solid #ccc">';

  html+='<div class="table-wrap" style="margin:16px 20px"><table>'
    +'<thead><tr>'
    +'<th>#</th>'
    +'<th>Sample ID</th>'
    +'<th>Sample Name</th>'
    +'<th>Lot #</th>'
    +'<th>Ext. Ref.</th>'
    +'<th>Serving Size</th>'
    +'<th>Test</th>'
    +'<th style="text-align:center">Comparator</th>'
    +'<th style="text-align:right">Lower</th>'
    +'<th style="text-align:right">Upper</th>'
    +'<th>Units</th>'
    +(SHOW_TEST_RESULTS?'<th>Result</th>':'')
    +'</tr></thead>'
    +'<tbody>';

  var ihNames=activeInhouseTestNames();
  var rowNum=0;
  samples.forEach(function(s){
    var allTests=[];
    if(s.tests) Object.keys(s.tests).forEach(function(cat){
      var arr=s.tests[cat];
      if(Array.isArray(arr)) arr.forEach(function(entry){
        var p=parseTestLabel(testEntryLabel(entry));
        if(p.test&&ihNames.has(p.test)){ p._id=testEntryId(entry); allTests.push(p); }
      });
    });
    allTests.forEach(function(t){
      rowNum++;
      var res=resultFor(t._id);
      var resTxt=res&&res.ResultsDisplay?res.ResultsDisplay:'';
      html+='<tr>'
        +'<td data-label="#">'+rowNum+'</td>'
        +'<td data-label="Sample ID">'+escHtml(s.sampleID)+'</td>'
        +'<td data-label="Sample Name">'+escHtml(s.sampleName)+'</td>'
        +'<td data-label="Lot #">'+(s.lotNumber||'-')+'</td>'
        +'<td data-label="Ext. Ref.">'+(s.extRef||'-')+'</td>'
        +'<td data-label="Serving Size">'+(s.servingSize||'-')+'</td>'
        +'<td data-label="Test">'+escHtml(t.test)+'</td>'
        +'<td data-label="Comparator" style="text-align:center">'+escHtml(t.specModifier||'-')+'</td>'
        +'<td data-label="Lower" style="text-align:right">'+escHtml(t.specValueLower||'-')+'</td>'
        +'<td data-label="Upper" style="text-align:right">'+escHtml(t.specValueUpper||'-')+'</td>'
        +'<td data-label="Units">'+escHtml(t.units||'-')+'</td>'
        +(SHOW_TEST_RESULTS?'<td data-label="Result">'+(resTxt?escHtml(resTxt):'-')+'</td>':'')
        +'</tr>';
    });
  });

  html+='</tbody></table></div>';

  html+=''
    +'<div class="print-only" style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-top:20px;font-size:12px">'
    +'<div><strong>Prepared By:</strong><br><br>___________________________<br><small style="color:#95a5a6">Name / Date</small></div>'
    +'<div><strong>Authorized By:</strong><br><br>___________________________<br><small style="color:#95a5a6">Name / Date</small></div>'
    +'</div>';

  document.getElementById('loContent').innerHTML=html;
  document.getElementById('loPrintArea').style.display='block';
  document.getElementById('loPrintArea').scrollIntoView({behavior:'smooth'});
}

/* ════════════════════════════════════════════════════════════
   UTILITIES
════════════════════════════════════════════════════════════ */
function todayStr(){
  var d=new Date();
  return d.getFullYear()+'-'+String(d.getMonth()+1).padStart(2,'0')+'-'+String(d.getDate()).padStart(2,'0');
}
function showAlert(id,msg,type){
  var el=document.getElementById(id);
  if(!el) return;
  el.textContent=msg;
  el.className='alert show '+type;
  clearTimeout(el._t);
  el._t=setTimeout(function(){ el.className='alert'; },7000);
}
function clearFieldErrors() {
  document.querySelectorAll('.field-error').forEach(function(el) {
    el.classList.remove('field-error');
  });
  document.querySelectorAll('.field-error-label').forEach(function(el) {
    el.classList.remove('field-error-label');
  });
}

function markFieldError(fieldId) {
  var el = document.getElementById(fieldId);
  if (el) {
    el.classList.add('field-error');
    var label = el.closest('.form-group') 
      ? el.closest('.form-group').querySelector('label') 
      : null;
    if (label) label.classList.add('field-error-label');
  }
}

['ns_sampleName','ns_matrix','ns_units','ns_receivedBy'].forEach(function(id){
  var el = document.getElementById(id);
  if(el) el.addEventListener('change', function(){ 
    this.classList.remove('field-error');
    var label = this.closest('.form-group') 
      ? this.closest('.form-group').querySelector('label') 
      : null;
    if(label) label.classList.remove('field-error-label');
  });
});
function badgeCls(status){ return (status||'').replace(/\s|\//g,'-'); }
function tatDisplay(s){
  if(s.status==='Approved/Released') return{cls:'tat-ok',txt:'Done'};
  if(!s.tatDeadline) return{cls:'tat-ok',txt:' - '};
  var p=parseDateParts(s.tatDeadline);
  var dl=new Date(p.y,p.m-1,p.d);
  var today=new Date(); today.setHours(0,0,0,0);
  var diff=Math.ceil((dl-today)/864e5);
  return diff<0?{cls:'tat-over',txt:'Exceeded'}:diff<=2?{cls:'tat-warn',txt:diff+'d left'}:{cls:'tat-ok',txt:diff+'d left'};
}
function escHtml(str){
  return String(str||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

/* ════════════════════════════════════════════════════════════
   SUBCONTRACTED TESTS  —  v2.1
════════════════════════════════════════════════════════════ */
function loadApprovedLabs(cb){
  spGet(PATH_APPROVED_LABS+'?$select=Title&$orderby=Title&$top=200')
  .then(function(d){
    var labs=(d.value||[]).map(function(l){ return l.Title; });
    var sel=document.getElementById('sub_lab');
    sel.innerHTML='<option value="">&#8212; Select Approved Lab &#8212;</option>';
    labs.forEach(function(n){
      var o=document.createElement('option'); o.textContent=n; sel.appendChild(o);
    });
    if(cb) cb();
  })
  .catch(function(e){ console.warn('loadApprovedLabs:',e); if(cb) cb(); });
}

function populateSubcontractSampleDropdown(){
  var sel=document.getElementById('sub_sampleID');
  var current=sel.value;
  sel.innerHTML='<option value="">&#8212; Select Sample &#8212;</option>';
  allSamples.forEach(function(s){
    var o=document.createElement('option');
    o.value=s.sampleID;
    o.textContent=s.sampleID+' - '+escHtml(s.customer)+' | '+escHtml(s.sampleName);
    sel.appendChild(o);
  });
  if(current) sel.value=current;
}

function loadSubcontractEntries(cb){
  var flds='ID,Title,TestsRequested,ShippedTo,DateShipped,ResultsReceivedOn,CoAID,Flags,Created';
  spGet(PATH_SUBCONTRACT+'?$select='+flds+'&$orderby=Created+desc&$top=500')
  .then(function(d){ allSubcontractEntries=d.value||[]; if(cb) cb(); })
  .catch(function(e){ console.warn('loadSubcontractEntries:',e); if(cb) cb(); });
}

function renderSubcontractLog(){
  var q=(document.getElementById('sub_search').value||'').toLowerCase();
  var rows=allSubcontractEntries.filter(function(e){
    return !q
      ||(e.Title||'').toLowerCase().includes(q)
      ||(e.ShippedTo||'').toLowerCase().includes(q)
      ||(e.CoAID||'').toLowerCase().includes(q);
  });
  var el=document.getElementById('subcontractLogContainer');
  if(!rows.length){
    el.innerHTML='<div class="empty-state">No subcontracted test entries found.</div>'; return;
  }
  var html='<div class="table-wrap"><table>'
    +'<thead><tr>'
    +'<th>Sample ID</th><th>Lab</th><th>Date Shipped</th>'
    +'<th>Results Received</th><th>CoA ID</th><th>Tests Requested</th><th>Flags</th>'
    +'</tr></thead><tbody>';
  rows.forEach(function(e){
    var received=e.ResultsReceivedOn
      ?'<span class="badge badge-Approved-Released">'+e.ResultsReceivedOn.split('T')[0]+'</span>'
      :'<span class="badge badge-Pending">Pending</span>';
    var coaID=e.CoAID
      ?'<span style="font-weight:600;color:#155724">'+escHtml(e.CoAID)+'</span>'
      :'<span style="color:#999;font-size:11px">Awaiting</span>';
    html+='<tr>'
      +'<td><strong>'+escHtml(e.Title)+'</strong></td>'
      +'<td>'+escHtml(e.ShippedTo||' - ')+'</td>'
      +'<td>'+(e.DateShipped?e.DateShipped.split('T')[0]:' - ')+'</td>'
      +'<td>'+received+'</td>'
      +'<td>'+coaID+'</td>'
      +'<td style="max-width:220px;white-space:pre-wrap;font-size:12px">'+escHtml(e.TestsRequested||'')+'</td>'
      +'<td style="max-width:180px;white-space:pre-wrap;font-size:12px;color:#c0392b">'+escHtml(e.Flags||'')+'</td>'
      +'</tr>';
  });
  html+='</tbody></table></div>';
  el.innerHTML=html;
}

function saveSubcontractEntry(){
  var sid=document.getElementById('sub_sampleID').value.trim();
  var lab=document.getElementById('sub_lab').value.trim();
  var shipped=document.getElementById('sub_dateShipped').value;
  var received=document.getElementById('sub_dateReceived').value;
  var coa=document.getElementById('sub_coaID').value.trim();
  var tests=document.getElementById('sub_testsRequested').value.trim();
  var flags=document.getElementById('sub_flags').value.trim();

  if(!sid){ showAlert('alertSubcontract','Select a Sample ID','error'); scrollAlertIntoView('alertSubcontract'); return; }
  if(!lab){ showAlert('alertSubcontract','Select an Approved Lab','error'); scrollAlertIntoView('alertSubcontract'); return; }
  if(!shipped){ showAlert('alertSubcontract','Enter Date Shipped','error'); scrollAlertIntoView('alertSubcontract'); return; }
  if(!tests){ showAlert('alertSubcontract','Enter Tests Requested','error'); scrollAlertIntoView('alertSubcontract'); return; }

  showLoading('Saving subcontract entry...');
  var body={
    Title: sid,
    TestsRequested: tests,
    ShippedTo: lab,
    DateShipped: shipped,
    Flags: flags||''
  };
  if(received) body.ResultsReceivedOn=received;
  if(coa)      body.CoAID=coa;

  spPost(PATH_SUBCONTRACT, body)
  .then(function(){
    hideLoading();
    showAlert('alertSubcontract','Subcontract entry saved for '+sid,'success');
    scrollAlertIntoView('alertSubcontract');
    clearSubcontractForm();
    loadSubcontractEntries(renderSubcontractLog);
  })
  .catch(function(e){
    hideLoading();
    showAlert('alertSubcontract','Error saving: '+e.message,'error');
    scrollAlertIntoView('alertSubcontract');
  });
}

function clearSubcontractForm(){
  document.getElementById('sub_sampleID').value='';
  document.getElementById('sub_lab').value='';
  document.getElementById('sub_dateShipped').value='';
  document.getElementById('sub_dateReceived').value='';
  document.getElementById('sub_coaID').value='';
  document.getElementById('sub_testsRequested').value='';
  document.getElementById('sub_flags').value='';
}

/* ════════════════════════════════════════════════════════════
   SSF → NEW SAMPLE PREFILL
════════════════════════════════════════════════════════════ */
function rrStartPrefill(confNum,specificRows,stayOpen){
  if(!confNum) return;
  // If prefill already set for this batch (e.g. from a recent accept), reuse it — don't rebuild with all accepted rows.
  if(!specificRows&&rrPrefillData&&rrPrefillData.confNum===confNum){
    if(stayOpen) return;
    rrCloseModal();
    document.querySelector('.sb-item[data-page="new-sample"]').click();
    return;
  }
  var allRows=rrBatchGroups[confNum]||[];
  if(!allRows.length) return;
  // specificRows: only queue these rows (e.g. newly accepted on this run).
  // If omitted, queue all Accepted rows in the batch.
  var queueRows=specificRows||allRows.filter(function(r){ return r.Status==='Accepted'; });
  if(!queueRows.length) return;
  if(!stayOpen&&batchSamples.length>0){
    if(!confirm('You have an in-progress batch with '+batchSamples.length+' sample'+(batchSamples.length!==1?'s':'')+'. Continuing will clear it. Proceed?')) return;
    clearBatch();
  }
  rrPrefillData={
    confNum:confNum,
    customer:allRows[0].Customer||'',
    date:allRows[0].SubmittedAt?(allRows[0].SubmittedAt.substring(0,10)):'',
    samples:queueRows.map(function(r){
      return {
        sampleName:r.SampleName||'',
        lotNumber:r.LotNumber||'',
        extRef:r.ExtRef||'',
        matrix:r.Matrix||'',
        sampleType:r.SampleType||'',
        servingSize:r.ServingSize||'',
        remarks:r.Remarks||'',
        isRush:r.IsRush||false,
        rushType:r.RushType||'',
        testsJSON:r.TestsJSON||''
      };
    })
  };
  try{ sessionStorage.setItem('rrPrefillData',JSON.stringify(rrPrefillData)); }catch(e){}
  if(stayOpen){
    var newBStatus=rrBatchStatus(allRows);
    rrRenderModalFooter(newBStatus);
  } else {
    rrCloseModal();
    document.querySelector('.sb-item[data-page="new-sample"]').click();
  }
}

function nsCheckPrefill(){
  if(!rrPrefillData){
    try{
      var stored=sessionStorage.getItem('rrPrefillData');
      if(stored) rrPrefillData=JSON.parse(stored);
    }catch(e){}
  }
  if(rrPrefillData) nsApplyPrefill();
}

function nsApplyPrefill(){
  if(!rrPrefillData) return;
  rrPrefillQueueIdx=0;
  nsUpdatePrefillBanner();
  // Fill Step 1: customer
  var custSel=document.getElementById('batchCustomer');
  if(custSel){
    var match=Array.from(custSel.options).find(function(o){ return o.text===rrPrefillData.customer||o.value===rrPrefillData.customer; });
    if(match) custSel.value=match.value;
  }
  // Fill Step 1: date
  var dateEl=document.getElementById('batchDate');
  if(dateEl&&rrPrefillData.date) dateEl.value=rrPrefillData.date;
  // Trigger batch init
  initBatch();
}

function nsUpdateSampleCounter(){
  var el=document.getElementById('nsSampleCounter');
  if(!el) return;
  var num=batchSamples.length+1;
  var ofTotal=rrPrefillData?' of '+rrPrefillData.samples.length:'';
  el.innerHTML=''
    +'<div style="width:40px;height:40px;border-radius:50%;background:#0072B2;color:white;'
      +'display:flex;align-items:center;justify-content:center;font-size:16px;font-weight:700;'
      +'flex-shrink:0;box-shadow:0 0 0 4px rgba(0,114,178,0.14)">'+num+'</div>'
    +'<div style="line-height:1.2">'
      +'<div style="font-size:1.25rem;font-weight:700;color:#2c3e50">Sample '+num+ofTotal+'</div>'
      +'<div style="font-size:12px;color:#64748b;margin-top:2px">Adding to batch</div>'
    +'</div>';
  var biBannerEl=document.getElementById('biBanner');
  if(biBannerEl) biBannerEl.style.display=rrPrefillData?'none':'';
}
function nsUpdatePrefillBanner(){
  var banner=document.getElementById('nsPrefillBanner');
  if(!banner) return;
  if(!rrPrefillData){ banner.style.display='none'; return; }
  var total=rrPrefillData.samples.length;
  var remaining=total-rrPrefillQueueIdx;
  banner.style.display='';
  banner.className='rr-prefill-banner';
  banner.innerHTML='<svg class="icon" aria-hidden="true"><use href="#icon-folder-outline"></use></svg>'
    +'<span>Pre-filling from request <strong>'+escHtml(rrPrefillData.confNum)+'</strong> ('+escHtml(rrPrefillData.customer)+')'
    +(remaining<total?' &mdash; <span class="rr-prefill-queue-badge">'+remaining+' of '+total+' remaining</span>':'')
    +'</span>'
    +'<button class="rr-prefill-banner-dismiss" onclick="nsClearPrefill()">Start Fresh &times;</button>';
}

function nsLoadPrefillSample(idx){
  if(!rrPrefillData||idx>=rrPrefillData.samples.length) return;
  var s=rrPrefillData.samples[idx];
  // Basic fields
  document.getElementById('ns_sampleName').value=s.sampleName;
  document.getElementById('ns_lotNumber').value=s.lotNumber;
  document.getElementById('ns_extRef').value=s.extRef;
  document.getElementById('ns_servingSize').value=s.servingSize;
  document.getElementById('ns_remarks').value=s.remarks;
  // Sample Type
  if(s.sampleType) document.getElementById('ns_type').value=s.sampleType;
  // Matrix — match against select options
  var matrixSel=document.getElementById('ns_matrix');
  if(matrixSel&&s.matrix){
    var mOpt=Array.from(matrixSel.options).find(function(o){ return o.value.toLowerCase()===s.matrix.toLowerCase(); });
    matrixSel.value=mOpt?mOpt.value:'';
  }
  // Rush
  var rushChk=document.getElementById('ns_rushChk');
  if(rushChk){
    rushChk.checked=!!s.isRush;
    toggleRushOrder();
    if(s.isRush&&s.rushType) document.getElementById('ns_rushType').value=s.rushType;
  }
  // Tests from TestsJSON
  nsLoadPrefillTests(s.testsJSON);
  nsUpdatePrefillBanner();
}

function nsLoadPrefillTests(testsJSON){
  if(!testsJSON) return;
  var tests;
  try{ tests=JSON.parse(testsJSON); }catch(e){ return; }
  var cats=Object.keys(tests);
  cats.forEach(function(cat){
    var items=tests[cat];
    if(!items||!items.length) return;
    // Select the category card
    var chkEl=document.getElementById('chk-'+cat);
    var catEl=document.getElementById('cat-'+cat);
    var panelEl=document.getElementById('panel-'+cat);
    if(!chkEl) return; // Category not in this SMS site's list
    if(!chkEl.checked){
      chkEl.checked=true;
      if(catEl) catEl.classList.add('selected');
      if(panelEl) panelEl.classList.add('open');
    }
    // Add tests to the list
    if(!currentTestLists[cat]) currentTestLists[cat]=[];
    items.forEach(function(t){
      var label=rrBuildTestLabel(t);
      if(label) currentTestLists[cat].push(label);
    });
    renderTestList(cat);
  });
  updateTATDisplay();
}

function rrBuildTestLabel(t){
  if(typeof t==='string') return t;
  var label=t.label||'';
  if(!label) return '';
  var spec=[];
  if(t.modifier) spec.push(String(t.modifier));
  if(t.lower!==undefined&&t.lower!==null&&t.lower!=='') spec.push(String(t.lower));
  if(t.upper!==undefined&&t.upper!==null&&t.upper!=='') spec.push('– '+String(t.upper));
  if(t.units) spec.push(String(t.units));
  return spec.length?(label+' — '+spec.join(' ')):label;
}

function nsClearPrefill(){
  rrPrefillData=null; rrPrefillQueueIdx=0;
  try{ sessionStorage.removeItem('rrPrefillData'); }catch(e){}
  var banner=document.getElementById('nsPrefillBanner');
  if(banner) banner.style.display='none';
}

function nsClearPrefillQueue(){
  // Called when last sample in queue is added — clear prefill but leave banner hidden
  nsClearPrefill();
}

/* ════════════════════════════════════════════════════════════
   RECEIVED REQUESTS
════════════════════════════════════════════════════════════ */
var RR_FIELDS='ID,Title,Customer,SSFConfirmationNumber,SubmittedAt,SampleName,LotNumber,ExtRef,Matrix,SampleType,ServingSize,AmountSubmitted,Remarks,IsRush,RushType,TestsJSON,TestCategories,SequenceNumber,TotalSamplesInSession,Status,ReviewedBy,ReviewNotes,BusinessEmail';
var RR_PAGE=10;
var rrBatchGroups={};
var rrBatchOrder=[];
var rrShown=0;
var rrModalConfNum=null;
var rrModalRegistered=false;
var rrModalAccepted=false;
var rrHadPriorRegistration=false;
var rrLocalRejected=new Set();
var rrModalRowOriginalStatus={};

function loadReceivedRequests(cb){
  spGet(PATH_REQUESTS+'?$select='+RR_FIELDS+'&$orderby=SubmittedAt desc,SequenceNumber asc&$top=500')
    .then(function(d){
      allRequests=d.value||[];
      var btn=document.getElementById('rrLoadAllBtn');
      if(btn) btn.style.display=d['odata.nextLink']?'':'none';
      if(cb) cb();
    })
    .catch(function(e){ showAlert('alertReceivedRequests','Error loading requests: '+e.message,'error'); });
}

function rrLoadAllRequests(){
  var btn=document.getElementById('rrLoadAllBtn');
  if(btn){ btn.disabled=true; btn.textContent='Loading\u2026'; }
  function fetchPage(url,acc){
    return spGet(url).then(function(d){
      acc=acc.concat(d.value||[]);
      if(d['odata.nextLink']) return fetchPage(d['odata.nextLink'],acc);
      return acc;
    });
  }
  fetchPage(PATH_REQUESTS+'?$select='+RR_FIELDS+'&$orderby=SubmittedAt desc,SequenceNumber asc&$top=500',[])
    .then(function(all){
      allRequests=all;
      if(btn){ btn.style.display='none'; }
      renderRequestGroups();
    })
    .catch(function(e){
      if(btn){ btn.disabled=false; btn.innerHTML='<svg class="icon" aria-hidden="true"><use href="#icon-folder-outline"></use></svg> Load All'; }
      showAlert('alertReceivedRequests','Error loading all requests: '+e.message,'error');
    });
}

function rrBatchStatus(rows){
  var s=rows.map(function(r){ return r.Status; });
  if(s.every(function(v){ return v==='Accepted'; })) return 'Accepted';
  if(s.every(function(v){ return v==='Rejected'; })) return 'Rejected';
  if(s.every(function(v){ return v==='Pending'; })) return 'Pending';
  if(s.every(function(v){ return v==='Accepted'||v==='Rejected'; })) return 'Partial';
  return 'In Review';
}

function rrStatusClass(status){
  return {'Pending':'rr-s-pending','In Review':'rr-s-in-review','Accepted':'rr-s-accepted','Rejected':'rr-s-rejected','Partial':'rr-s-partial'}[status]||'rr-s-pending';
}

function renderRequestGroups(){
  var statusFilter=(document.getElementById('rrStatusFilter')||{}).value||'';
  var search=((document.getElementById('rrSearch')||{}).value||'').toLowerCase();

  rrBatchGroups={}; var allOrder=[];
  allRequests.forEach(function(r){
    var k=r.SSFConfirmationNumber||String.fromCharCode(8212);
    if(!rrBatchGroups[k]){ rrBatchGroups[k]=[]; allOrder.push(k); }
    rrBatchGroups[k].push(r);
  });


  rrBatchOrder=allOrder.filter(function(k){
    var bStatus=rrBatchStatus(rrBatchGroups[k]);
    if(statusFilter&&bStatus!==statusFilter) return false;
    if(search){
      var first=rrBatchGroups[k][0];
      var hay=((first.Customer||'')+(k||'')+rrBatchGroups[k].map(function(r){ return r.SampleName||''; }).join('')).toLowerCase();
      if(hay.indexOf(search)<0) return false;
    }
    return true;
  });

  rrShown=0;
  rrRenderTable(true);
}

function rrRenderTable(reset){
  var container=document.getElementById('rrListContainer');
  if(!rrBatchOrder.length){
    container.innerHTML='<div class="empty-state">No requests found.</div>';
    return;
  }
  var page=rrBatchOrder.slice(rrShown,rrShown+RR_PAGE);
  rrShown+=page.length;
  var hasMore=rrShown<rrBatchOrder.length;

  var rows=page.map(function(confNum){
    var bRows=rrBatchGroups[confNum];
    var first=bRows[0];
    var bStatus=rrBatchStatus(bRows);
    var isRush=bRows.some(function(r){ return r.IsRush; });
    return '<tr>'
      +'<td data-label="Date">'+dateOnly(first.SubmittedAt)+'</td>'
      +'<td data-label="Confirmation #"><strong>'+escHtml(confNum)+'</strong></td>'
      +'<td data-label="Customer">'+(first.Customer?escHtml(first.Customer):'&#8212;')+'</td>'
      +'<td data-label="Samples" class="rr-tc">'+bRows.length+'</td>'
      +'<td data-label="Rush" class="rr-tc">'+(isRush?'<span class="rr-rush-icon" title="Rush Order"><svg style="width:20px;height:20px;color:#a16207" aria-hidden="true"><use href="#icon-rush-outline"></use></svg></span>':'<span style="color:#94a3b8">&#8212;</span>')+'</td>'
      +'<td data-label="Status"><span class="rr-batch-status '+rrStatusClass(bStatus)+'">'+escHtml(bStatus)+'</span></td>'
      +'<td data-label=""><button class="btn-primary btn-sm" onclick="rrOpenModal(\''+escHtml(confNum)+'\')">View</button></td>'
      +'</tr>';
  }).join('');

  var loadMoreBtn=hasMore
    ?'<div style="text-align:center;margin-top:14px"><button class="btn-export" id="rrLoadMoreBtn" onclick="rrLoadMore()">Load More ('+(rrBatchOrder.length-rrShown)+' remaining)</button></div>'
    :'';

  var rrTitleMap={'':'All Requests','Pending':'Pending Requests','In Review':'Requests in Review','Accepted':'Accepted Requests','Rejected':'Rejected Requests','Partial':'Partial Requests'};
  var rrCurrentFilter=(document.getElementById('rrStatusFilter')||{}).value||'';
  var rrTitle=rrTitleMap[rrCurrentFilter]||'Received Requests';

  if(reset){
    container.innerHTML='<div class="card">'
      +'<h2>'+rrTitle+'</h2>'
      +'<div class="table-wrap"><table>'
      +'<thead><tr><th>Date</th><th>Confirmation #</th><th>Customer</th><th class="rr-tc">Samples</th><th class="rr-tc">Rush</th><th>Status</th><th></th></tr></thead>'
      +'<tbody id="rrTableBody">'+rows+'</tbody>'
      +'</table></div>'
      +loadMoreBtn
      +'</div>';
  } else {
    var tbody=document.getElementById('rrTableBody');
    if(tbody) tbody.insertAdjacentHTML('beforeend',rows);
    var btn=document.getElementById('rrLoadMoreBtn');
    if(hasMore){
      if(btn) btn.textContent='Load More ('+(rrBatchOrder.length-rrShown)+' remaining)';
    } else {
      if(btn) btn.parentElement.remove();
    }
  }
}

function rrLoadMore(){ rrRenderTable(false); }

function rrDetailContent(r){
  var html='<div class="rr-detail-grid">';
  html+=rrField('Lot Number',r.LotNumber);
  html+=rrField('Ext. Reference',r.ExtRef);
  html+=rrField('Matrix',r.Matrix);
  html+=rrField('Serving Size',r.ServingSize);
  html+=rrField('Amount Submitted',r.AmountSubmitted);
  if(r.IsRush) html+=rrField('Rush Type',r.RushType||'Rush');
  if(r.Remarks) html+=rrField('Remarks',r.Remarks);
  if(r.ReviewedBy) html+=rrField('Reviewed By',r.ReviewedBy);
  if(r.ReviewNotes) html+=rrField('Review Notes',r.ReviewNotes);
  html+='</div>';
  if(r.TestsJSON){
    try{
      var tests=JSON.parse(r.TestsJSON);
      var cats=Object.keys(tests);
      if(cats.length){
        html+='<div class="rr-tests-section"><h4>Tests Requested</h4>';
        cats.forEach(function(cat){
          var items=tests[cat];
          html+='<div class="rr-cat-block"><div class="rr-cat-title">'+escHtml(cat.toUpperCase())+'</div>';
          items.forEach(function(t){
            var label=typeof t==='string'?t:(t.label||'');
            if(!label) return;
            var spec='';
            if(typeof t==='object'){
              var parts=[];
              if(t.modifier) parts.push(escHtml(String(t.modifier)));
              if(t.lower!==undefined&&t.lower!==null&&t.lower!=='') parts.push(escHtml(String(t.lower)));
              if(t.upper!==undefined&&t.upper!==null&&t.upper!=='') parts.push('&#8211; '+escHtml(String(t.upper)));
              if(t.units) parts.push(escHtml(String(t.units)));
              spec=parts.join(' ');
            }
            html+='<div class="rr-test-item"><span class="rr-test-name">'+escHtml(label)+'</span>';
            if(spec) html+='<span class="rr-test-spec">'+spec+'</span>';
            html+='</div>';
          });
          html+='</div>';
        });
        html+='</div>';
      }
    }catch(e){ html+='<p style="font-size:12px;color:#c62828;margin-top:10px">Could not parse test data.</p>'; }
  }
  return html;
}

function rrField(label,val){
  if(val===null||val===undefined||val==='') return '';
  return '<div class="rr-detail-field"><div class="rr-detail-label">'+escHtml(label)+'</div><div class="rr-detail-val">'+escHtml(String(val))+'</div></div>';
}

function rrOpenModal(confNum){
  rrModalConfNum=confNum;
  var rows=rrBatchGroups[confNum]||[];
  if(!rows.length) return;
  var first=rows[0];
  var isRush=rows.some(function(r){ return r.IsRush; });

  // Snapshot DB state and seed local reject set from already-Rejected rows
  rrModalRowOriginalStatus={};
  rrLocalRejected=new Set();
  rows.forEach(function(r){
    rrModalRowOriginalStatus[r.ID]=r.Status;
    if(r.Status==='Rejected') rrLocalRejected.add(r.ID);
  });

  var titleEl=document.getElementById('rrModalTitle');
  titleEl.style.display='flex';
  titleEl.style.alignItems='center';
  titleEl.style.gap='10px';
  titleEl.innerHTML=escHtml(confNum)+(isRush?'<span class="rr-rush-icon"><svg style="width:20px;height:20px;color:#a16207" aria-hidden="true"><use href="#icon-rush-outline"></use></svg></span>':'');
  document.getElementById('rrModalMeta').innerHTML=(first.Customer?escHtml(first.Customer):'&#8212;')+' &middot; '+dateOnly(first.SubmittedAt)+' &middot; '+rows.length+' sample'+(rows.length!==1?'s':'');

  var html='<div class="table-wrap">'
    +'<table><thead><tr><th>#</th><th>Sample Name</th><th>Lot #</th><th>Matrix</th><th>Tests</th><th></th></tr></thead><tbody>';
  rows.forEach(function(r){
    var origStatus=rrModalRowOriginalStatus[r.ID];
    var isLocked=origStatus==='Accepted';
    var isRejected=rrLocalRejected.has(r.ID);
    var trClass='rr-modal-sample-row'+(isRejected?' rr-row-rejected':'');
    var rejectCell=isLocked
      ?'<td class="rr-tc" data-label="Reject"><span class="rr-accepted-lock">&#10003;</span></td>'
      :'<td class="rr-tc" data-label="Reject"><button class="rr-reject-toggle'+(isRejected?' active':'')+'" onclick="event.stopPropagation();rrToggleReject('+r.ID+')">'+(isRejected?'Rejected':'Reject')+'</button></td>';
    html+='<tr class="'+trClass+'" id="rrMR_'+r.ID+'" onclick="rrToggleModalDetail('+r.ID+')">'
      +'<td>'+r.SequenceNumber+'</td>'
      +'<td><span style="display:inline-flex;align-items:center;gap:8px"><strong>'+(r.SampleName?escHtml(r.SampleName):'&#8212;')+'</strong>'+(r.IsRush?'<span class="rr-rush-icon"><svg style="width:18px;height:18px;color:#a16207" aria-hidden="true"><use href="#icon-rush-outline"></use></svg></span>':'')+'</span></td>'
      +'<td>'+(r.LotNumber?escHtml(r.LotNumber):'&#8212;')+'</td>'
      +'<td>'+(r.Matrix?escHtml(r.Matrix):'&#8212;')+'</td>'
      +'<td style="font-size:12px;color:#64748b">'+(r.TestCategories?escHtml(r.TestCategories):'&#8212;')+'</td>'
      +rejectCell
      +'</tr>'
      +'<tr class="rr-modal-detail-row rr-expanded" id="rrMD_'+r.ID+'">'
      +'<td colspan="6" style="padding:0"><div style="padding-bottom:8px">'+rrDetailContent(r)+'</div></td>'
      +'</tr>';
  });
  html+='</tbody></table></div>';
  document.getElementById('rrModalContent').innerHTML=html;

  var bStatus=rrBatchStatus(rows);
  rrModalRegistered=false;
  rrModalAccepted=false;
  rrHadPriorRegistration=false;
  rrRenderModalFooter(bStatus);
  document.getElementById('rrModal').classList.add('open');
  requestAnimationFrame(function(){
    var rrBox=document.getElementById('rrModalBox');
    if(rrBox) rrBox.scrollTop=0;
  });

  // Check if samples are already registered (used to show Register vs. &#10003; registered).
  // Fires for Accepted and Partial batches. Quick local cache check first,
  // then a live SP query if not found locally.
  if(bStatus==='Accepted'||bStatus==='Partial'){
    var localFound=allSamples.some(function(s){ return s.ssfConfirmationNumber===confNum; });
    if(localFound){
      rrModalRegistered=true;
      rrHadPriorRegistration=true;
      rrRenderModalFooter(bStatus);
    } else {
      spGet(PATH_SAMPLES+"?$select=ID&$filter=SSFConfirmationNumber eq '"+confNum.replace(/'/g,"''")+"'&$top=1")
        .then(function(d){
          if(rrModalConfNum!==confNum||rrModalAccepted) return;
          if(d.value&&d.value.length){ rrModalRegistered=true; rrHadPriorRegistration=true; rrRenderModalFooter(bStatus); }
        })
        .catch(function(){});
    }
  }
}

function rrToggleModalDetail(id){
  var detailRow=document.getElementById('rrMD_'+id);
  var sampleRow=document.getElementById('rrMR_'+id);
  if(!detailRow) return;
  var open=detailRow.style.display!=='none';
  detailRow.style.display=open?'none':'';
  if(sampleRow) sampleRow.classList.toggle('rr-expanded',!open);
}

function rrToggleReject(id){
  if(rrLocalRejected.has(id)){ rrLocalRejected.delete(id); } else { rrLocalRejected.add(id); }
  var row=document.getElementById('rrMR_'+id);
  var rejected=rrLocalRejected.has(id);
  if(row){
    row.classList.toggle('rr-row-rejected',rejected);
    var btn=row.querySelector('.rr-reject-toggle');
    if(btn){
      btn.classList.toggle('active',rejected);
      btn.textContent=rejected?'Rejected':'Reject';
    }
  }
  rrRefreshAcceptCount();
}

function rrRefreshAcceptCount(){
  var rows=rrBatchGroups[rrModalConfNum]||[];
  var n=rows.filter(function(r){
    return !rrLocalRejected.has(r.ID)&&rrModalRowOriginalStatus[r.ID]!=='Accepted';
  }).length;
  var btn=document.getElementById('rrAcceptBtn');
  var countEl=document.getElementById('rrAcceptCount');
  if(countEl){ countEl.textContent=' ('+n+')'; countEl.style.display=n>0?'':'none'; }
  if(btn) btn.disabled=n===0;
  // For Partial batches: show/hide the accept button entirely
  var wrap=document.getElementById('rrAcceptBtnWrap');
  if(wrap) wrap.style.display=n>0?'':'none';
}

function rrRenderModalFooter(bStatus){
  var rows=rrBatchGroups[rrModalConfNum]||[];
  var n=rows.filter(function(r){
    return !rrLocalRejected.has(r.ID)&&rrModalRowOriginalStatus[r.ID]!=='Accepted';
  }).length;
  var alreadyAccepted=rows.filter(function(r){ return rrModalRowOriginalStatus[r.ID]==='Accepted'; });
  var acceptBtn='<button class="btn-success btn-sm" id="rrAcceptBtn"'+(n===0?' disabled':'')+' onclick="rrModalAccept()">'
    +'<svg class="icon icon-sm" aria-hidden="true"><use href="#icon-check-outline"></use></svg>'
    +' Accept<span id="rrAcceptCount"'+(n===0?' style="display:none"':'')+'>'+' ('+n+')'+'</span></button>';

  var html='<div class="rr-modal-footer-inner">'
    +'<span class="rr-batch-status '+rrStatusClass(bStatus)+'">'+escHtml(bStatus)+'</span>'
    +'<div class="rr-modal-footer-actions">';

  if(bStatus==='Pending'){
    html+='<button class="btn-secondary btn-sm" onclick="rrModalSetStatus(\'In Review\')">Mark In Review</button>';
    html+=acceptBtn;
  } else if(bStatus==='In Review'){
    html+=acceptBtn;
    html+='<button class="btn-secondary btn-sm" onclick="rrModalSetStatus(\'Pending\')">Reopen as Pending</button>';
  } else if(bStatus==='Partial'){
    if(alreadyAccepted.length>0&&rrModalRegistered){
      html+='<span style="font-size:12px;color:#16a34a;display:inline-flex;align-items:center;gap:5px">'
        +'<svg class="icon icon-sm" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Registered in system</span>';
    }
    html+='<span id="rrAcceptBtnWrap" style="display:'+(n>0?'':'none')+'">'+acceptBtn+'</span>';
    if(alreadyAccepted.length>0&&!rrModalRegistered){
      html+='<button class="btn-primary btn-sm" onclick="rrStartPrefill(rrModalConfNum)">'
        +'<svg class="icon icon-sm" aria-hidden="true"><use href="#icon-check-outline"></use></svg>'
        +' Register Accepted ('+alreadyAccepted.length+')</button>';
    }
    if(alreadyAccepted.length===0){
      html+='<button class="btn-secondary btn-sm" onclick="rrModalSetStatus(\'Pending\')">Reopen as Pending</button>';
    }
  } else if(bStatus==='Accepted'){
    if(rrModalRegistered){
      html+='<span style="font-size:12px;color:#16a34a;display:inline-flex;align-items:center;gap:5px">'
        +'<svg class="icon icon-sm" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Samples registered in system</span>';
    } else {
      html+='<button class="btn-primary btn-sm" onclick="rrStartPrefill(rrModalConfNum)">'
        +'<svg class="icon icon-sm" aria-hidden="true"><use href="#icon-check-outline"></use></svg> Register Samples</button>';
      if(!rrHadPriorRegistration){
        html+='<button class="btn-secondary btn-sm" onclick="rrModalSetStatus(\'Pending\')">Reopen as Pending</button>';
      }
    }
  } else {
    html+='<button class="btn-secondary btn-sm" onclick="rrModalSetStatus(\'Pending\')">Reopen as Pending</button>';
  }

  html+='</div></div>';
  document.getElementById('rrModalFooter').innerHTML=html;
}

function rrCloseModal(){
  document.getElementById('rrModal').classList.remove('open');
  rrModalConfNum=null;
  rrModalRegistered=false;
  rrModalAccepted=false;
  rrHadPriorRegistration=false;
  rrLocalRejected=new Set();
  rrModalRowOriginalStatus={};
}

function rrModalPatch(status,notes){
  var rows=allRequests.filter(function(r){ return r.SSFConfirmationNumber===rrModalConfNum; });
  var body={Status:status,ReviewedBy:currentUserName||''};
  if(notes!==undefined) body.ReviewNotes=notes;
  return Promise.all(rows.map(function(r){ return spPatch(PATH_REQUESTS,r.ID,body); }))
    .then(function(){
      var savedConfNum=rrModalConfNum;
      rows.forEach(function(r){ r.Status=status; r.ReviewedBy=currentUserName||''; if(notes!==undefined) r.ReviewNotes=notes; });
      renderRequestGroups();
      rrOpenModal(savedConfNum);
    })
    .catch(function(err){ showAlert('alertReceivedRequests','Error: '+err.message,'error'); });
}

function rrModalSetStatus(status){
  if(!rrModalConfNum) return;
  // If reopening to Pending while a registration prefill is active for this
  // batch, cancel it so the in-progress batch form doesn't keep the data.
  if(status==='Pending'&&rrPrefillData&&rrPrefillData.confNum===rrModalConfNum) nsClearPrefill();
  rrModalPatch(status);
}
function rrModalAccept(){
  if(!rrModalConfNum) return;
  var acceptBtn=document.getElementById('rrAcceptBtn');
  if(batchSamples.length>0){
    if(!confirm('You have an in-progress batch with '+batchSamples.length+' sample'+(batchSamples.length!==1?'s':'')+'. Accepting will clear it. Proceed?')) return;
    clearBatch();
  }
  if(acceptBtn) acceptBtn.disabled=true;
  var rows=allRequests.filter(function(r){ return r.SSFConfirmationNumber===rrModalConfNum; });
  var toReject=rows.filter(function(r){ return rrLocalRejected.has(r.ID)&&rrModalRowOriginalStatus[r.ID]!=='Rejected'; });
  var toAccept=rows.filter(function(r){ return !rrLocalRejected.has(r.ID)&&rrModalRowOriginalStatus[r.ID]!=='Accepted'; });
  var patches=[];
  toReject.forEach(function(r){ patches.push(spPatch(PATH_REQUESTS,r.ID,{Status:'Rejected',ReviewedBy:currentUserName||''})); });
  toAccept.forEach(function(r){ patches.push(spPatch(PATH_REQUESTS,r.ID,{Status:'Accepted',ReviewedBy:currentUserName||''})); });
  return Promise.all(patches)
    .then(function(){
      var isUpdate=rows.some(function(r){ return rrModalRowOriginalStatus[r.ID]==='Accepted'||rrModalRowOriginalStatus[r.ID]==='Rejected'; });
      toReject.forEach(function(r){ r.Status='Rejected'; r.ReviewedBy=currentUserName||''; rrModalRowOriginalStatus[r.ID]='Rejected'; });
      toAccept.forEach(function(r){
        r.Status='Accepted'; r.ReviewedBy=currentUserName||''; rrModalRowOriginalStatus[r.ID]='Accepted';
        var row=document.getElementById('rrMR_'+r.ID);
        if(row){
          row.classList.remove('rr-row-rejected');
          var td=row.querySelector('[data-label="Reject"]');
          if(td) td.innerHTML='<span class="rr-accepted-lock">&#10003;</span>';
        }
      });
      renderRequestGroups();
      var bRows=allRequests.filter(function(r){ return r.SSFConfirmationNumber===rrModalConfNum; });
      var triggerRow=bRows.find(function(r){ return r.SequenceNumber===1; })||bRows[0];
      if(triggerRow){
        spPatch(PATH_REQUESTS,triggerRow.ID,{BatchReviewed:true,BatchIsUpdate:isUpdate}).catch(function(){});
      }
      if(toAccept.length>0){
        rrModalRegistered=false;
        rrModalAccepted=true;
        rrStartPrefill(rrModalConfNum,toAccept,true);
      } else {
        var newBStatus=rrBatchStatus(rows);
        rrRenderModalFooter(newBStatus);
        showAlert('alertReceivedRequests','All samples in this batch were rejected.','info');
      }
    })
    .catch(function(err){
      var b=document.getElementById('rrAcceptBtn');
      if(b) b.disabled=false;
      showAlert('alertReceivedRequests','Error: '+err.message,'error');
    });
}
</script>
</body>
</html>
