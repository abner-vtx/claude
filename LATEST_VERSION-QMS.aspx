<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Vertex Analytical Labs &mdash; QMS Platform</title>
<style>
:root{
 --blue:#0072B2; --blue-lt:#56B4E9; --blue-bg:#E0F4FF; --gold:#E69F00;
 --red-tint:#FEEAEA; --amber-tint:#FFF7D9; --green-tint:#DFFCED; --blue-tint:#E8F6FF;
 --green:#2E7D32; --green-bg:#D1FAE5; --amber:#92400E; --amber-bg:#FEF3C7;
 --red:#991B1B; --red-bg:#FEE2E2; --info:#0C3254;
 --text:#0F172A; --label:#374151; --muted:#6B7280; --bg:#F9F9F9;
 --border:#E2E8F0; --inputbd:#CBD5E1; --rowhover:#F9FAFB; --sect:#F8FAFC;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
body{font-family:"Segoe UI","Segoe UI Web (West European)",-apple-system,BlinkMacSystemFont,Roboto,"Helvetica Neue",Helvetica,Arial,sans-serif;background:var(--bg);color:var(--text);font-size:13px;line-height:1.5;}
h1,h2,h3{font-weight:600;}
.mono{font-family:Consolas,"Courier New",monospace;font-size:12px;}

/* sticky wrapper -- header + tabs move/hide together on scroll, single source of truth
   for "stuck to top", no more independent top:74px offset that can drift out of sync */
.app-nav-wrap{position:sticky;top:0;z-index:200;transform:translateY(0);transition:transform .3s ease;}
.app-nav-wrap.nav-hidden{transform:translateY(-100%);}

/* header (gradient allowed for header only) */
.app-header{background:linear-gradient(135deg,#0072B2 0%,#56B4E9 100%);padding:14px 24px;box-shadow:0 2px 10px rgba(0,114,178,.2);}
.header-content{max-width:1400px;margin:0 auto;width:100%;display:flex;align-items:center;gap:16px;}
.header-brand{display:flex;align-items:center;gap:16px;min-width:0;}
.header-text{min-width:0;}
.h1-short{display:none;}
.hdr-logo{height:46px;width:auto;flex-shrink:0;}
.hdr-logo-icon{display:none;}
.app-header h1{color:#fff;font-size:1.5rem;letter-spacing:.5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
.cpl-left,.cpl-right{display:none;}
.cpl-left{font-size:1.25rem;font-weight:600;color:#fff;line-height:1.2;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;min-width:0;}
.cpl-right{font-size:14px;font-weight:500;color:rgba(255,255,255,.9);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:180px;}
.app-header p{color:rgba(255,255,255,.92);font-size:13px;}
.app-header .spacer{flex:1;}
.app-header .ver{background:rgba(255,255,255,.16);border:1px solid rgba(255,255,255,.4);color:#fff;border-radius:20px;padding:3px 11px;font-size:11px;font-weight:600;}
.app-header .who{text-align:right;}
.app-header .who .name{font-size:13px;color:rgba(255,255,255,.92);font-weight:500;}
.app-header .who .role{font-size:11px;color:rgba(255,255,255,.65);}
.app-header .avatar{height:36px;width:36px;border-radius:50%;background:rgba(255,255,255,.2);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;flex-shrink:0;}
.hamburger-btn{display:none;background:rgba(255,255,255,.15);border:none;border-radius:6px;color:#fff;padding:8px 11px;font-size:18px;cursor:pointer;align-items:center;justify-content:center;transition:background .2s;flex-shrink:0;}
.hamburger-btn:hover{background:rgba(255,255,255,.28);}

/* tabs */
.tabs{background:#fff;border-bottom:2px solid var(--blue);box-shadow:0 2px 5px rgba(0,0,0,.05);position:relative;}
.tabs-wrap{max-width:1400px;margin:0 auto;display:flex;overflow-x:auto;padding:0 24px;}
.tab-btn{padding:16px 22px;border:none;background:none;cursor:pointer;font-size:15px;font-weight:400;color:#666;border-bottom:3px solid transparent;transition:all .25s;white-space:nowrap;font-family:inherit;display:flex;align-items:center;gap:8px;}
.tab-btn:hover{color:var(--blue);background:#F0F8FF;}
.tab-btn.active{color:var(--blue);border-bottom-color:var(--gold);}

/* user info, shown in the navbar instead of the header once the header hides it -- visual only, not a nav control */
.tabs-user{display:none;align-items:center;gap:10px;padding:14px 20px;flex-shrink:0;cursor:default;background:var(--sect);border-bottom:2px solid var(--border);}
.tabs-user .who{text-align:left;}
.tabs-user .who .name{font-size:14px;color:var(--text);font-weight:600;}
.tabs-user .who .role{font-size:12px;color:var(--muted);}
.tabs-user .avatar{height:40px;width:40px;border-radius:50%;background:var(--blue);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:14px;flex-shrink:0;}

/* mobile nav: hamburger + dropdown, single breakpoint (QMS has 4 tabs, not RS's 7+).
   Header stays one row always (never stacks) -- subtitle and user-info drop out instead. */
@media(max-width:860px){
 .header-text p{display:none;}
 .h1-full{display:none;}
 .h1-short{display:inline;}
 .cpl-right{display:block;}
 .app-header .who{display:none;}
 .app-header .avatar{display:none;}
 .hamburger-btn{display:flex;}
 .tabs-user{display:flex;}
 .tabs-wrap{flex-direction:column;position:absolute;left:0;right:0;top:100%;background:#fff;box-shadow:0 4px 16px rgba(0,0,0,.18);z-index:201;opacity:0;visibility:hidden;transform:translateY(-6px);transition:opacity .25s ease,visibility .25s ease,transform .25s ease;overflow-x:visible;padding:0;}
 .tabs-wrap.nav-open{opacity:1;visibility:visible;transform:translateY(0);}
 .tab-btn{justify-content:flex-start;border-bottom:1px solid #F1F5F9;border-left:3px solid transparent;padding:14px 20px;}
 .tab-btn:last-child{border-bottom:none;}
 .tab-btn.active{border-left-color:var(--gold);background:#F0F8FF;}
}

/* second, narrower tier -- matches RS/TRR's own second breakpoint */
@media(max-width:560px){
 .hdr-logo-full{display:none;}
 .hdr-logo-icon{display:block;height:36px;}
 .header-text{display:none;}
 .cpl-left{display:block;}
 .cpl-right{display:none;}
 main{padding:20px 14px 30px;}
}

main{max-width:1400px;margin:0 auto;padding:28px 24px;}
.view{display:none;} .view.active{display:block;animation:fade .25s;}
.subview{display:none;} .subview.active{display:block;animation:fade .22s;}
@keyframes fade{from{opacity:0;transform:translateY(6px);}to{opacity:1;transform:none;}}

.page-intro{margin-bottom:20px;}
.page-intro h2{font-size:1.5rem;font-weight:700;color:var(--text);}
.page-intro p{color:var(--muted);font-size:13px;margin-top:3px;max-width:920px;}

/* subnav */
.subnav{display:flex;gap:6px;flex-wrap:wrap;margin-bottom:22px;}
.subnav button{padding:8px 15px;border:1.5px solid var(--border);background:#fff;border-radius:6px;cursor:pointer;font-size:12.5px;font-weight:600;color:var(--label);font-family:inherit;transition:all .18s;}
.subnav button:hover{border-color:var(--blue);color:var(--blue);}
.subnav button.active{background:var(--blue);border-color:var(--blue);color:#fff;}

/* KPI cards -- LEFT-BORDER ACCENT (design system; no gradient) */
.metrics-row-3{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;margin-bottom:20px;}
.metrics-row-3 .metric-card{min-height:190px;}
.metrics-row-4{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;margin-bottom:12px;}
.metrics-row-4 .metric-card{min-height:155px;}
.doc-stats{margin-bottom:28px;color:var(--muted);font-size:12.5px;}
.doc-stats strong{color:var(--text);font-weight:600;}
.doc-stats .sep{margin:0 10px;color:var(--muted);}
.metric-card{background:var(--blue-tint);border-left:4px solid var(--blue);border-radius:8px;padding:20px;transition:box-shadow .2s;display:flex;flex-direction:column;justify-content:flex-start;gap:2px;}
.metric-top{display:flex;align-items:flex-start;gap:10px;margin-bottom:4px;}
.metric-ic{flex-shrink:0;color:var(--blue);}
.metric-card:hover{box-shadow:0 4px 12px rgba(0,0,0,.08);}
.metric-card.green{background:var(--green-tint);border-left-color:var(--green);} .metric-card.amber{background:var(--amber-tint);border-left-color:var(--gold);} .metric-card.red{background:var(--red-tint);border-left-color:#DC2626;}
.metric-card.green .metric-ic{color:var(--green);} .metric-card.amber .metric-ic{color:var(--amber);} .metric-card.red .metric-ic{color:var(--red);}
.metric-val{font-size:32px;font-weight:700;line-height:1;color:var(--text);}
.metric-lbl{font-size:13px;font-weight:700;color:var(--text);}
.metric-sub{font-size:11px;color:var(--muted);margin-top:2px;}

/* cards */
.card{background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,114,178,.08);margin-bottom:20px;padding:0 20px;transition:box-shadow .2s;}
.card:hover{box-shadow:0 4px 16px rgba(0,114,178,.13);}
.card-hd{padding:16px 0 14px;border-bottom:3px solid var(--gold);display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;}
.card-hd h3{font-size:18px;font-weight:600;color:var(--blue);display:flex;align-items:center;gap:8px;}
.card-bd{padding:18px 0;}
.grid-2{display:grid;grid-template-columns:1fr 1fr;gap:20px;}
.right-col{display:flex;flex-direction:column;gap:20px;}
.grid-2>.card{margin-bottom:0;}
.card.grow{flex:1;}
.grid-3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:18px;}

/* tables */
table{width:100%;border-collapse:collapse;font-size:13px;}
thead th{background:var(--blue);color:#fff;font-size:.8125rem;font-weight:600;text-align:left;padding:9px 13px;}
thead th:first-child{border-radius:8px 0 0 0;} thead th:last-child{border-radius:0 8px 0 0;}
tbody td{padding:10px 13px;border-bottom:1px solid var(--border);}
tbody tr:hover{background:var(--rowhover);}
.id-cell{font-family:Consolas,"Courier New",monospace;font-weight:700;color:var(--blue);}

/* badges (design system) */
.badge{display:inline-flex;align-items:center;padding:3px 9px;border-radius:20px;font-size:11px;font-weight:600;white-space:nowrap;}
.b-green{background:var(--green-bg);color:#065F46;border:1px solid #A7F3D0;}
.b-amber{background:var(--amber-bg);color:var(--amber);border:1px solid #FDE68A;}
.b-red{background:var(--red-bg);color:var(--red);border:1px solid #FCA5A5;}
.b-blue{background:var(--blue-bg);color:var(--info);border:1px solid #BAE6FD;}
.b-gray{background:#F1F5F9;color:#475569;border:1px solid #E2E8F0;}

/* buttons */
.btn{display:inline-flex;align-items:center;gap:6px;padding:8px 18px;border:none;border-radius:6px;font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;transition:transform .2s,box-shadow .2s;}
.btn-primary{background:linear-gradient(135deg,#0072B2,#56B4E9);color:#fff;}
.btn-primary:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(0,114,178,.3);}
.btn-outline{background:#fff;color:var(--blue);border:1.5px solid var(--blue);}
.btn-outline:hover{background:#EBF2FB;}
.btn-sm{padding:5px 12px;font-size:12px;}

/* info boxes */
.info-box{border-radius:4px;padding:.8rem 1rem;font-size:.85rem;line-height:1.5;margin-top:12px;}
.info-box.blue{background:var(--blue-bg);border-left:4px solid var(--blue);color:var(--info);}
.info-box.amber{background:#FFF3E0;border-left:4px solid var(--gold);color:#78350F;}
.info-box.green{background:#E8F5E9;border-left:4px solid var(--green);color:#155724;}
.info-box strong{display:block;margin-bottom:4px;}

/* notification banner */
.notif-banner{background:#FFF3E0;border-left:4px solid var(--gold);border-radius:4px;padding:14px 16px;margin-bottom:22px;display:flex;align-items:center;gap:12px;flex-wrap:wrap;}
.notif-count{color:#B45309;font-size:13px;font-weight:700;}
.notif-pill{background:var(--gold);border:1px solid var(--gold);border-radius:5px;padding:3px 10px;font-size:12px;color:#fff;cursor:pointer;}
.notif-pill:hover{filter:brightness(.92);}

/* global toast */
.global-alert{display:none;padding:12px 16px;border-radius:6px;margin-bottom:20px;align-items:center;gap:10px;font-size:13px;font-weight:500;}
.global-alert.success{background:var(--green-bg);color:#065F46;border-left:4px solid #059669;}
.global-alert.info{background:var(--blue-bg);color:var(--info);border-left:4px solid var(--blue);}

.compliance-stmt{border-left:4px solid var(--gold);padding-left:14px;line-height:1.75;font-size:13.5px;color:var(--label);}
.activity-item{display:flex;gap:12px;padding:10px 0;border-bottom:1px solid #F1F5F9;}
.activity-item:last-child{border-bottom:none;}
.activity-dot{width:9px;height:9px;border-radius:50%;margin-top:5px;flex-shrink:0;}
.activity-item p{font-size:13px;} .activity-item .t{font-size:11px;color:var(--muted);margin-top:2px;}

/* SOP viewer */
.two-panel{display:grid;grid-template-columns:320px 1fr;gap:20px;}
.list-panel{background:#fff;border:1px solid var(--border);border-radius:8px;padding:12px;max-height:640px;overflow-y:auto;}
.list-item{padding:11px 13px;border:1px solid var(--border);border-radius:7px;margin-bottom:8px;cursor:pointer;transition:all .18s;}
.list-item:hover{border-color:var(--blue);box-shadow:0 2px 8px rgba(0,114,178,.08);}
.list-item.selected{background:var(--blue-bg);border-color:var(--blue);}
.list-item .id{font-family:Consolas,"Courier New",monospace;font-weight:700;color:var(--blue);font-size:12px;}
.list-item .ti{font-size:12.5px;color:var(--text);margin-top:2px;}
.detail-panel{background:#fff;border:1px solid var(--border);border-radius:8px;padding:22px;min-height:420px;}
.step-item{background:var(--sect);border:1px solid #EEF2F7;border-left:3px solid var(--blue);border-radius:6px;padding:11px 13px;margin-bottom:8px;}
.step-num{font-family:Consolas,"Courier New",monospace;font-weight:700;color:#B45309;font-size:12px;}
.step-title{font-weight:600;font-size:13.5px;margin:2px 0 4px;}
.step-sum{font-size:12.5px;color:var(--label);line-height:1.5;}
.step-meta{margin-top:6px;display:flex;flex-wrap:wrap;gap:6px;}
.chip{background:#fff;border:1px solid var(--border);border-radius:4px;padding:2px 7px;font-size:11px;color:var(--muted);}
.chip.form{color:var(--info);border-color:#BAE6FD;background:var(--blue-bg);}
.chip.role{color:#5B21B6;border-color:#DDD6FE;background:#F5F3FF;}
.doc-viewer{background:var(--sect);border:1px dashed var(--inputbd);border-radius:8px;padding:26px;text-align:center;color:var(--muted);margin-top:16px;font-size:12.5px;}

/* clause matrix */
.matrix-wrap{overflow-x:auto;}
.matrix{border-collapse:collapse;font-size:12px;}
.matrix th{background:var(--blue-bg);color:var(--blue);border:1px solid var(--border);padding:7px 9px;}
.matrix td{border:1px solid #EEF2F7;text-align:center;padding:8px 11px;}
.matrix td.hit{background:var(--blue);color:#fff;font-weight:700;}
.matrix td.rowh{background:var(--blue-bg);color:var(--blue);font-weight:700;text-align:left;white-space:nowrap;font-family:Consolas,"Courier New",monospace;}

/* network */
#netCanvas{width:100%;height:520px;display:block;background:#fff;border:1px solid var(--border);border-radius:8px;cursor:pointer;}
.net-legend{display:flex;gap:16px;flex-wrap:wrap;margin-bottom:12px;font-size:12px;color:var(--muted);}
.net-legend span{display:inline-flex;align-items:center;gap:6px;}
.dot{width:11px;height:11px;border-radius:3px;display:inline-block;}

/* lab compass */
.search-lg{width:100%;max-width:640px;padding:13px 16px;font-size:15px;border:1.5px solid var(--inputbd);border-radius:8px;font-family:inherit;}
.search-lg:focus{outline:none;border-color:var(--blue);box-shadow:0 0 0 3px rgba(0,114,178,.12);}
.ac{position:relative;max-width:640px;margin:0 auto;}
.ac-list{position:absolute;left:0;right:0;background:#fff;border:1px solid var(--border);border-radius:8px;box-shadow:0 6px 18px rgba(0,0,0,.12);margin-top:5px;max-height:300px;overflow-y:auto;z-index:20;display:none;text-align:left;}
.ac-list.show{display:block;}
.ac-item{padding:10px 14px;border-bottom:1px solid #F1F5F9;cursor:pointer;}
.ac-item:hover{background:var(--blue-bg);}
.act-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:14px;}
.act-card{background:#fff;border:1px solid var(--border);border-radius:8px;padding:18px;text-align:center;cursor:pointer;transition:all .18s;}
.act-card:hover{transform:translateY(-3px);box-shadow:0 6px 14px rgba(0,0,0,.1);border-color:var(--blue);}
.act-ic{color:var(--blue);margin-bottom:8px;}
.act-ti{font-weight:600;font-size:13.5px;color:var(--text);}
.act-sops{margin-top:8px;display:flex;gap:5px;justify-content:center;flex-wrap:wrap;}

/* modal (design system: light header) */
.modal-backdrop{display:none;position:fixed;inset:0;background:rgba(15,23,42,.55);z-index:200;align-items:flex-start;justify-content:center;padding:40px 16px;overflow-y:auto;}
.modal-backdrop.open{display:flex;}
.modal{background:#fff;border-radius:8px;box-shadow:0 20px 60px rgba(0,0,0,.25);width:100%;max-width:720px;margin:auto;}
.modal-header{padding:16px 20px;border-bottom:1px solid var(--border);display:flex;align-items:flex-start;justify-content:space-between;background:var(--sect);border-radius:8px 8px 0 0;}
.modal-header h2{font-size:16px;color:var(--blue);}
.modal-header p{font-size:11px;color:var(--muted);margin-top:2px;font-family:Consolas,monospace;}
.modal-close{background:none;border:none;cursor:pointer;color:var(--muted);width:28px;height:28px;border-radius:6px;font-size:20px;line-height:1;}
.modal-close:hover{background:var(--border);color:var(--text);}
.modal-body{padding:20px 22px;max-height:70vh;overflow-y:auto;}
.modal-footer{padding:14px 20px;border-top:1px solid var(--border);display:flex;justify-content:flex-end;gap:10px;background:var(--sect);border-radius:0 0 8px 8px;}
.section-title{font-size:15px;font-weight:600;color:var(--blue);border-bottom:2px solid var(--gold);padding-bottom:6px;margin-bottom:14px;display:block;}
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:14px;}
.form-group{display:flex;flex-direction:column;gap:5px;margin-bottom:14px;}
.form-group.span-2,.form-grid.cols-1{grid-column:1/-1;}
label{font-size:.875rem;font-weight:500;color:var(--label);}
.req{color:#DC2626;font-weight:700;}
.form-input{width:100%;padding:9px 10px;border:1.5px solid var(--inputbd);border-radius:.5rem;font-family:inherit;font-size:.875rem;background:#fff;}
.form-input:focus{outline:none;border-color:var(--blue);box-shadow:0 0 0 3px rgba(0,114,178,.12);}
textarea.form-input{resize:vertical;min-height:72px;}

.sp-footer{text-align:right;padding:16px 24px;font-size:11px;color:#A19F9D;}
@media(max-width:900px){.grid-2,.grid-3,.two-panel{grid-template-columns:1fr;}.form-grid{grid-template-columns:1fr;}}
@media(max-width:640px){.metrics-row-3{grid-template-columns:1fr;}.metrics-row-4{grid-template-columns:1fr 1fr;}}
</style>
</head>
<body>

<div class="app-nav-wrap" id="appNavWrap">

<header class="app-header">
 <div class="header-content">
  <div class="header-brand">
   <img id="hdrLogoFull" src="logo_vertex_secondary.svg" alt="Vertex Analytical Labs" class="hdr-logo hdr-logo-full">
   <img id="hdrLogoIcon" src="logo_vertex_icon_app_secondary.svg" alt="Vertex Analytical Labs" class="hdr-logo hdr-logo-icon">
   <div class="header-text"><h1><span class="h1-full">Quality Management System Platform</span><span class="h1-short">Quality Management System</span></h1><p>ISO/IEC 17025:2017</p></div>
   <span class="cpl-left" id="cplLeft">Dashboard</span>
  </div>
  <div class="spacer"></div>
  <div class="who"><div class="name" id="hdrName">Loading&hellip;</div><div class="role" id="hdrRole"></div></div>
  <div class="avatar" id="hdrAvatar">?</div>
  <span class="cpl-right" id="cplRight">Dashboard</span>
  <button class="hamburger-btn" id="hamburgerBtn" onclick="toggleMobileNav()" aria-label="Toggle navigation"><svg width="20" height="20"><use href="#icon-menu-outline"/></svg></button>
 </div>
</header>

<nav class="tabs">
 <div class="tabs-wrap" id="tabsWrap" role="tablist">
  <div class="tabs-user"><div class="avatar" id="navAvatar">?</div><div class="who"><div class="name" id="navName">Loading&hellip;</div><div class="role" id="navRole"></div></div></div>
  <button class="tab-btn active" data-tab="dashboard"><svg width="17" height="17"><use href="#icon-gauge-outline"/></svg> Dashboard</button>
  <button class="tab-btn" data-tab="docs"><svg width="17" height="17"><use href="#icon-document-outline"/></svg> Document Control</button>
  <button class="tab-btn" data-tab="ops"><svg width="17" height="17"><use href="#icon-warning-outline"/></svg> Quality Operations</button>
  <button class="tab-btn" data-tab="compass"><svg width="17" height="17"><use href="#icon-search-outline"/></svg> Lab Compass</button>
 </div>
</nav>

</div>

<main>
 <div id="global-alert" class="global-alert" role="alert"><span class="alert-msg"></span></div>

 <!-- S1 DASHBOARD -->
 <section id="v-dashboard" class="view active">
  <div class="page-intro"><h2>QMS at a Glance</h2><p>Organization-wide view of the management system: documented processes, ISO coverage, open quality events, and accreditation status. (Dashboard &amp; Governance subsystem.)</p></div>
  <div class="notif-banner">
   <svg width="20" height="20" style="color:var(--gold);flex-shrink:0"><use href="#icon-warning-outline"/></svg>
   <span class="notif-count">3 items need attention</span>
   <span class="notif-pill" onclick="go('ops','audits')">Surveillance assessment &mdash; May 2026</span>
   <span class="notif-pill" onclick="go('ops','ca')">CAR26001 verification due</span>
   <span class="notif-pill" onclick="go('ops','ncw')">NC26003 awaiting PT result</span>
  </div>
  <div class="metrics-row-3" id="kpiRow"></div>
  <div class="metrics-row-4" id="kpiRow2"></div>
  <div class="doc-stats" id="docStats"></div>
  <div class="grid-2">
   <div class="card"><div class="card-hd"><h3><svg width="18" height="18"><use href="#icon-document-outline"/></svg> Compliance Statement</h3></div><div class="card-bd"><div class="compliance-stmt" id="complianceStmt"></div></div></div>
   <div class="right-col">
    <div class="card" style="margin-bottom:0"><div class="card-hd"><h3><svg width="18" height="18"><use href="#icon-chart-outline"/></svg> Management Review</h3></div><div class="card-bd">
     <p style="font-size:13px;color:var(--label)">Last review <strong>MR-25-02</strong> (Dec 2025). Next scheduled <strong>Jun 2026</strong>.</p>
     <div class="info-box blue"><strong>2 open review actions</strong>Cross-train a second HPLC analyst (due Q3); formalize the PT enrollment deadline in PM-04 (linked to CAR26001).</div>
    </div></div>
    <div class="card grow" style="margin-bottom:0"><div class="card-hd"><h3>Recent Activity</h3></div><div class="card-bd" id="activityFeed"></div></div>
   </div>
  </div>
 </section>

 <!-- S2 DOCUMENT CONTROL -->
 <section id="v-docs" class="view">
  <div class="page-intro"><h2>Document Control &amp; Compliance Map</h2><p>The controlled documentation system: register, change requests, per-SOP process steps, the SOP relationships network, and the ISO clause-to-clause map.</p></div>
  <div class="subnav" id="docsNav">
   <button class="active" data-sub="register">Document Register</button>
   <button data-sub="viewer">SOP Viewer</button>
   <button data-sub="network">Relationships Network</button>
   <button data-sub="clause">Clause-to-Clause Map</button>
   <button data-sub="dcr">Change Requests</button>
  </div>
  <div id="s-register" class="subview active">
   <div class="card"><div class="card-hd"><h3>Master List of Documents</h3><span class="mono" style="color:var(--muted)" id="regCount"></span></div>
    <div class="card-bd"><table><thead><tr><th>Doc ID</th><th>Title</th><th>Type</th><th>Rev</th><th>Steps</th><th>Status</th></tr></thead><tbody id="registerBody"></tbody></table></div>
   </div>
  </div>
  <div id="s-viewer" class="subview">
   <div class="two-panel">
    <div class="list-panel" id="sopList"></div>
    <div class="detail-panel" id="sopDetail"><p style="color:var(--muted);text-align:center;padding:44px 10px">Select a procedure to view its process steps, forms, responsible roles, and the full document.</p></div>
   </div>
  </div>
  <div id="s-network" class="subview">
   <div class="net-legend">
    <span><i class="dot" style="background:#0C3254"></i> Quality Manual</span>
    <span><i class="dot" style="background:#0072B2"></i> Quality Procedure</span>
    <span><i class="dot" style="background:#2E7D32"></i> Equipment Procedure</span>
    <span><i class="dot" style="background:#E69F00"></i> Laboratory Procedure</span>
    <span style="margin-left:auto">Click a node to highlight its connections</span>
   </div>
   <canvas id="netCanvas"></canvas>
   <div class="info-box blue" id="netInfo"><strong>SOP Relationships Network</strong>Nodes are controlled documents (from the register); edges are citations extracted from the SOP text, weighted by mention count.</div>
  </div>
  <div id="s-clause" class="subview">
   <div class="card"><div class="card-hd"><h3>Vertex QMS to ISO/IEC 17025:2017 Clause Map</h3></div><div class="card-bd"><div class="matrix-wrap"><table class="matrix" id="clauseMatrix"></table></div></div></div>
  </div>
  <div id="s-dcr" class="subview">
   <div class="card"><div class="card-hd"><h3>Document Change Requests</h3><button class="btn btn-primary btn-sm" onclick="openModal('m-dcr')"><svg width="14" height="14"><use href="#icon-plus-outline"/></svg> New Request</button></div>
    <div class="card-bd"><table><thead><tr><th>DCR #</th><th>Title</th><th>Type</th><th>Driver</th><th>Stage</th><th>Requested</th></tr></thead><tbody id="dcrBody"></tbody></table></div>
   </div>
  </div>
 </section>

 <!-- S3 QUALITY OPERATIONS -->
 <section id="v-ops" class="view">
  <div class="page-intro"><h2>Quality Operations</h2><p>The live quality-event lifecycle: complaints, nonconforming work, corrective actions, risks &amp; opportunities, improvement, and audits &mdash; all natively linked.</p></div>
  <div class="subnav" id="opsNav">
   <button class="active" data-sub="complaints">Complaints</button>
   <button data-sub="ncw">Nonconforming Work</button>
   <button data-sub="ca">Corrective Actions</button>
   <button data-sub="risks">Risks &amp; Opportunities</button>
   <button data-sub="ofi">Improvement</button>
   <button data-sub="audits">Audits</button>
  </div>
  <div id="s-complaints" class="subview active"></div>
  <div id="s-ncw" class="subview"></div>
  <div id="s-ca" class="subview"></div>
  <div id="s-risks" class="subview"></div>
  <div id="s-ofi" class="subview"></div>
  <div id="s-audits" class="subview"></div>
 </section>

 <!-- S4 LAB COMPASS -->
 <section id="v-compass" class="view">
  <div class="page-intro"><h2>Lab Compass</h2><p>Quick instructions for everyday lab work. Search for what you are doing today, or pick a common task, to see the exact procedure steps, forms, and responsible roles.</p></div>
  <div style="text-align:center;margin-bottom:26px">
   <div class="ac"><input class="search-lg" id="compassSearch" placeholder="What are you doing today?  (e.g. calibrate a balance, log a complaint)" autocomplete="off"><div class="ac-list" id="compassAc"></div></div>
  </div>
  <div id="compassResult"></div>
  <h3 style="color:var(--blue);margin-bottom:14px;font-size:16px">Common tasks</h3>
  <div class="act-grid" id="actGrid"></div>
  <div class="grid-3" style="margin-top:26px">
   <div class="card"><div class="card-hd"><h3>Service Standards</h3></div><div class="card-bd" style="font-size:12.5px;color:var(--label);line-height:1.8">Complaint acknowledgement within <strong>24 h</strong>.<br>100% confidentiality of customer information.<br>Results reported per QP-11.<br>Impartiality safeguarded (POL-02).</div></div>
   <div class="card"><div class="card-hd"><h3>Confidentiality</h3></div><div class="card-bd" style="font-size:12.5px;color:var(--label);line-height:1.8">All customer data is handled per the Impartiality &amp; Confidentiality Policy. Access is role-scoped; records retained per QP-14.</div></div>
   <div class="card"><div class="card-hd"><h3>Contacts</h3></div><div class="card-bd" style="font-size:12.5px;color:var(--label);line-height:1.8">Quality: quality@vertexanalytical.com<br>Support: customersupport@vertexanalytical.com<br>9335 Airway Road, Suite 208, San Diego CA</div></div>
  </div>
 </section>
</main>

<!-- DCR modal -->
<div class="modal-backdrop" id="m-dcr">
 <div class="modal">
  <div class="modal-header"><div><h2>New Document Change Request</h2><p>LS_QP1402r01 &middot; QP-14</p></div><button class="modal-close" onclick="closeModal('m-dcr')">&times;</button></div>
  <div class="modal-body">
   <div class="section-title">Requester</div>
   <div class="form-group span-2"><label>Document / Request Title <span class="req">*</span></label><input class="form-input" placeholder="e.g. Revise PM-04 to add PT enrollment deadline"></div>
   <div class="form-grid">
    <div class="form-group"><label>Type of Request <span class="req">*</span></label><select class="form-input"><option>New Document</option><option selected>Revision</option><option>Withdrawal</option></select></div>
    <div class="form-group"><label>Change Driver <span class="req">*</span></label><select class="form-input"><option>Improvement</option><option selected>Preventive Action</option><option>Nonconforming Work</option><option>Other</option></select></div>
   </div>
   <div class="form-group span-2"><label>Proposed Change &amp; Rationale <span class="req">*</span></label><textarea class="form-input" placeholder="Describe the change and why it is needed"></textarea></div>
   <div class="info-box amber"><strong>Two-stage approval</strong>Technical review then Quality Assurance approval, followed by the issuing checklist and implementation/training record.</div>
  </div>
  <div class="modal-footer"><button class="btn btn-outline" onclick="closeModal('m-dcr')">Cancel</button><button class="btn btn-primary" onclick="demoSave('m-dcr')">Submit Request</button></div>
 </div>
</div>

<!-- Complaint modal -->
<div class="modal-backdrop" id="m-cmp">
 <div class="modal">
  <div class="modal-header"><div><h2>Log Complaint / Feedback</h2><p>LS_QP1201r01 &middot; Clause 7.9</p></div><button class="modal-close" onclick="closeModal('m-cmp')">&times;</button></div>
  <div class="modal-body">
   <div class="section-title">General Information</div>
   <div class="form-grid">
    <div class="form-group"><label>Category <span class="req">*</span></label><select class="form-input"><option>Complaint</option><option>Feedback</option></select></div>
    <div class="form-group"><label>Received Through <span class="req">*</span></label><select class="form-input"><option>Phone</option><option>Email</option><option>Website</option><option>In-Person</option></select></div>
   </div>
   <div class="form-group span-2"><label>Company <span class="req">*</span></label><input class="form-input" placeholder="Submitter company"></div>
   <div class="form-group span-2"><label>Description <span class="req">*</span></label><textarea class="form-input" placeholder="Record the complaint exactly as received"></textarea></div>
   <div class="info-box blue"><strong>Independence (7.9.6)</strong>The outcome must be reviewed by someone not involved in the original work before the record can be closed.</div>
  </div>
  <div class="modal-footer"><button class="btn btn-outline" onclick="closeModal('m-cmp')">Cancel</button><button class="btn btn-primary" onclick="demoSave('m-cmp')">Save</button></div>
 </div>
</div>

<!-- Improvement modal -->
<div class="modal-backdrop" id="m-ofi">
 <div class="modal">
  <div class="modal-header"><div><h2>Submit Opportunity for Improvement</h2><p>LS_QP1503r01 &middot; Clause 8.6</p></div><button class="modal-close" onclick="closeModal('m-ofi')">&times;</button></div>
  <div class="modal-body">
   <div class="section-title">Idea</div>
   <div class="form-group span-2"><label>Idea (short title) <span class="req">*</span></label><input class="form-input" placeholder="e.g. Add a QC check step to the pH meter procedure"></div>
   <div class="form-group span-2"><label>Description</label><textarea class="form-input" placeholder="Fuller explanation of the improvement and its expected benefit"></textarea></div>
   <div class="form-grid">
    <div class="form-group"><label>Source</label><select class="form-input"><option>Staff Suggestion</option><option>Management Review</option><option>Customer Feedback</option><option>Feedback Trend Analysis</option><option>Audit Output</option><option>Other</option></select></div>
    <div class="form-group"><label>Affected Area</label><select class="form-input"><option>Scope &amp; Test Methods</option><option>QMS</option><option>Personnel</option><option>Equipment</option><option>Facilities &amp; Environment</option><option>Business</option><option>Regulations</option><option>Other</option></select></div>
   </div>
   <div class="form-group"><label>Estimated Impact <span class="req">*</span></label><select class="form-input"><option>Low</option><option selected>Medium</option><option>High</option></select></div>
   <div class="info-box green"><strong>Low-friction intake (8.6)</strong>Only Idea and Impact are required &mdash; anyone can submit. High-impact ideas needing resources or a risk assessment get promoted to a managed Action Plan during review.</div>
  </div>
  <div class="modal-footer"><button class="btn btn-outline" onclick="closeModal('m-ofi')">Cancel</button><button class="btn btn-primary" onclick="demoSave('m-ofi')">Submit Idea</button></div>
 </div>
</div>

<!-- List data (prototype seed = what the SharePoint Lists return). Production reads these via _api REST. -->
<script id="lists" type="application/json">{"register":[{"id":"EP-01","title":"Use, Maintenance and Intermediate checks of Balances","type":"Equipment Procedure","rev":"Rev02","steps":7,"scanned":"No"},{"id":"EP-02","title":"Use, Maintenance and Intermediate checks for Micropipettes","type":"Equipment Procedure","rev":"Rev02","steps":6,"scanned":"No"},{"id":"EP-03","title":"Use, Maintenance and Intermediate checks of Thermometers","type":"Equipment Procedure","rev":"Rev02","steps":4,"scanned":"No"},{"id":"EP-04","title":"Use, Maintenance and Intermediate Checks of pH Meters","type":"Equipment Procedure","rev":"Rev02","steps":3,"scanned":"No"},{"id":"EP-05","title":"Use, Maintenance and Intermediate Checks of Temperature Controlled Chambers","type":"Equipment Procedure","rev":"Rev02","steps":6,"scanned":"No"},{"id":"EP-06","title":"Operation and Maintenance of HPLC Systems","type":"Equipment Procedure","rev":"Rev02","steps":11,"scanned":"No"},{"id":"LP-01","title":"Laboratory Safety","type":"Laboratory Procedure","rev":"Rev02","steps":6,"scanned":"No"},{"id":"LP-02","title":"Analytical Data - Interpreation and Treatment","type":"Laboratory Procedure","rev":"Rev02","steps":6,"scanned":"No"},{"id":"LP-03","title":"Management of Out-of-Specification Results","type":"Laboratory Procedure","rev":"Rev02","steps":5,"scanned":"No"},{"id":"LP-04","title":"Validation of Spreadsheets Used for Calculations","type":"Laboratory Procedure","rev":"Rev02","steps":4,"scanned":"No"},{"id":"LP-05","title":"Management of Reference Materials","type":"Laboratory Procedure","rev":"Rev02","steps":5,"scanned":"No"},{"id":"LP-06","title":"Management of Reagents and Prepared Solutions","type":"Laboratory Procedure","rev":"Rev02","steps":6,"scanned":"No"},{"id":"LP-07","title":"Management of Volumetric Glassware","type":"Laboratory Procedure","rev":"Rev02","steps":4,"scanned":"No"},{"id":"LS-02","title":"List of Approved Vendors","type":"List/Register","rev":"","steps":0,"scanned":"Yes"},{"id":"QM","title":"Quality Manual","type":"Quality Manual","rev":"Rev03","steps":0,"scanned":"No"},{"id":"QP-01","title":"Management of Personnel","type":"Quality Procedure","rev":"Rev02","steps":11,"scanned":"No"},{"id":"QP-02","title":"Facilities and Environmental Conditions","type":"Quality Procedure","rev":"Rev02","steps":6,"scanned":"No"},{"id":"QP-03","title":"Management of Equipment","type":"Quality Procedure","rev":"Rev02","steps":12,"scanned":"No"},{"id":"QP-04","title":"Metrological Traceability","type":"Quality Procedure","rev":"Rev02","steps":2,"scanned":"No"},{"id":"QP-05","title":"Externally Provided Products and Services","type":"Quality Procedure","rev":"Rev01","steps":7,"scanned":"No"},{"id":"QP-06","title":"Review of Requests, Tenders and Contracts","type":"Quality Procedure","rev":"Rev02","steps":6,"scanned":"No"},{"id":"QP-07","title":"Test Methods Selection, Verification and Validation","type":"Quality Procedure","rev":"Rev02","steps":8,"scanned":"No"},{"id":"QP-08","title":"Management of Samples","type":"Quality Procedure","rev":"","steps":8,"scanned":"No"},{"id":"QP-09","title":"Evaluation of Measurement Uncertainty","type":"Quality Procedure","rev":"Rev02","steps":8,"scanned":"No"},{"id":"QP-10","title":"Validity of Test Results","type":"Quality Procedure","rev":"Rev02","steps":7,"scanned":"No"},{"id":"QP-11","title":"Reporting of Results","type":"Quality Procedure","rev":"Rev03","steps":12,"scanned":"No"},{"id":"QP-12","title":"Management of Complaints and Feedback","type":"Quality Procedure","rev":"Rev03","steps":6,"scanned":"No"},{"id":"QP-13","title":"Management of Nonconforming Work","type":"Quality Procedure","rev":"Rev02","steps":8,"scanned":"No"},{"id":"QP-14","title":"Control of Management System Documents","type":"Quality Procedure","rev":"Rev02","steps":10,"scanned":"No"},{"id":"QP-15","title":"Actions to Address Risks and Opportunities","type":"Quality Procedure","rev":"Rev02","steps":4,"scanned":"No"},{"id":"QP-16","title":"Corrective Actions","type":"Quality Procedure","rev":"Rev02","steps":7,"scanned":"No"},{"id":"QP-17","title":"Audits","type":"Quality Procedure","rev":"Rev02","steps":9,"scanned":"No"},{"id":"QP-18","title":"Management Reviews","type":"Quality Procedure","rev":"Rev02","steps":5,"scanned":"No"}],"steps":[{"sop":"EP-01","num":"8.1","title":"General Requirements","order":1,"sum":"Intermediate checks and calibration of balances shall be performed under monitored environmental conditions which represent the operational working conditions (normal conditions of use).","forms":"","role":""},{"sop":"EP-01","num":"8.2","title":"Preparation before verification","order":2,"sum":"Visually inspect the balance (identification, labeling, contamination, damage) in order to ensure the condition of the instrument is suitable.","forms":"","role":""},{"sop":"EP-01","num":"8.3","title":"Verification of Repeatability","order":3,"sum":"8.3.1 The test is performed by reading the values of repeated weighing of at least one weight in a range between 50% of maximum capacity or the maximum operational range (80% of maximum capacity is sufficient).","forms":"","role":""},{"sop":"EP-01","num":"8.4","title":"Verification of Accuracy","order":4,"sum":"8.4.1 Accuracy of a balance is satisfactory if its weighing value, when tested with a suitable weight(s), is within 0.10% of the test weight value or the maximum permissible error of the weight (from calibration certificate).","forms":"FM EP01.01","role":""},{"sop":"EP-01","num":"8.5","title":"Verification of Eccentricity","order":5,"sum":"8.5.1 Place a test weight equal to approximately one-third of the maximum capacity of the balance on the center of the weighing pan and record the reading.","forms":"FM EP01.01","role":""},{"sop":"EP-01","num":"8.6","title":"Usage","order":6,"sum":"8.6.1 Make sure the equipment is verified and clean before utilizing the balances.","forms":"FM EP01.02","role":""},{"sop":"EP-01","num":"8.7","title":"Maintenance","order":7,"sum":"The maintenance is performed by a specialist vendor.","forms":"FM EP01.01; FM EP01.02","role":""},{"sop":"EP-02","num":"8.1","title":"General Requirements","order":1,"sum":"The test (intermediate check) is carried out by determining the volume which is dispensed into a container (weighing vessel).","forms":"FM EP02.01","role":""},{"sop":"EP-02","num":"8.2","title":"Use of Micropipettes","order":2,"sum":"8.2.1 Make sure that the pipette is in good condition.","forms":"","role":""},{"sop":"EP-02","num":"8.3","title":"Verification of Accuracy and Repeatability","order":3,"sum":"8.3.1 Ensure the dispenser is clean and, if necessary, decontaminated.","forms":"","role":""},{"sop":"EP-02","num":"8.4","title":"Cleaning of Micropipettes","order":4,"sum":"8.4.1 To clean micropipettes, use water/ethanol and a soft cloth or lint-free tissue.","forms":"","role":""},{"sop":"EP-02","num":"8.5","title":"Maintenance of Micropipettes","order":5,"sum":"8.5.1 Hold down the tip ejector.","forms":"","role":""},{"sop":"EP-02","num":"8.6","title":"Troubleshooting","order":6,"sum":"Trouble Possible Cause Possible Solution Unsuitable tip Use original tips Droplets left inside the tip Non-uniform wetting of the plastic Attach new tip Tip incorrectly attached Attach firmly Unsuitable tip Use original tip Foreign particle","forms":"FM EP02.01","role":""},{"sop":"EP-03","num":"8.1","title":"General Requirements","order":1,"sum":"Mercury thermometers are not allowed in the Laboratory unless they are coated with Teflon.","forms":"FM EP03.01","role":""},{"sop":"EP-03","num":"8.2","title":"Intermediate Checks of Thermometers and Thermohygrometers","order":2,"sum":"8.2.1 Preparation of Ice-Water Bath (Ice Melting Point Method \u2013 0 \u00b0C) 8.2.2 Only place clean equipment and distilled water inside the container.","forms":"","role":""},{"sop":"EP-03","num":"8.3","title":"Temperature Verification","order":3,"sum":"8.3.1 Insert the thermometer into the ice.","forms":"","role":""},{"sop":"EP-03","num":"8.4","title":"Thermohygrometer Verification","order":4,"sum":"8.4.1 Check the thermohygrometer for any visual defect.","forms":"FM EP03.01","role":""},{"sop":"EP-04","num":"8.1","title":"General Requirements","order":1,"sum":"The measurement system shall be capable of performing a two-point calibration or more.","forms":"","role":"Laboratory Manager"},{"sop":"EP-04","num":"8.2","title":"pH Meter Calibration","order":2,"sum":"8.2.1 Perform a two-point calibration with calibration buffers 7 plus 4 or 10 (whichever is nearest to the expected sample value).","forms":"FM EP04.01","role":""},{"sop":"EP-04","num":"8.3","title":"pH Meter Operation","order":3,"sum":"8.3.1 All test samples should be prepared using Purified Water, unless otherwise specified in the test method.","forms":"FM EP04.01","role":""},{"sop":"EP-05","num":"8.1","title":"General Requirements","order":1,"sum":"Keep door(s) closed to prevent heat loss (incubators) and heat gain (refrigerators and freezers).","forms":"","role":""},{"sop":"EP-05","num":"8.2","title":"Data Logging of Temperatures","order":2,"sum":"8.2.1 From the software of the datalogger, set the sampling every 60 minutes.","forms":"","role":""},{"sop":"EP-05","num":"8.3","title":"Monitoring of Temperature in Water Baths","order":3,"sum":"8.3.1 Use a calibrated thermometer to monitor temperature inside the water bath.","forms":"FM EP05.01","role":""},{"sop":"EP-05","num":"8.4","title":"Quality Control (Performance Checks) of Incubators, Refrigerators and Freezers","order":4,"sum":"8.4.1 Environmental parameters of incubators, refrigerators and freezers are monitored continually by using dataloggers.","forms":"","role":""},{"sop":"EP-05","num":"8.5","title":"Quality Control (Performance Checks) of Water Baths or Equipment Monitored with Regular Thermometers","order":5,"sum":"8.5.1 Fill the chamber with water.","forms":"FM EP05.02","role":""},{"sop":"EP-05","num":"8.6","title":"Cleaning of Chambers","order":6,"sum":"8.6.1 Disconnect the equipment before initiating the cleaning process.","forms":"FM LP03.01","role":""},{"sop":"EP-06","num":"8.1","title":"Mobile Phase Preparation","order":1,"sum":"Use only HPLC-grade or LC-MS-grade solvents for mobile phase preparation.","forms":"","role":""},{"sop":"EP-06","num":"8.2","title":"Operation of HPLC Systems","order":2,"sum":"Make sure the inline tubing and filters reach the bottom of the mobile phase bottles (previously filtered and degassed).","forms":"FM EP06.01","role":""},{"sop":"EP-06","num":"8.3","title":"Creating a New Method","order":3,"sum":"To create a new method, click on method file menu, open \u201cEdit Entire Method\u201d displayed and click \u201cOK\u201d.","forms":"","role":""},{"sop":"EP-06","num":"8.4","title":"Running a Sample","order":4,"sum":"Open the \u2018Method\u2019 file and select \u201cLoad Method\u201d.","forms":"","role":""},{"sop":"EP-06","num":"8.5","title":"Setting Up a Sequence","order":5,"sum":"To create a new sequence, click on the Sequence file menu, then click \u201cNew Sequence\u201d.","forms":"","role":""},{"sop":"EP-06","num":"8.6","title":"Running Samples with Sequence","order":6,"sum":"Place vials in the plate holder of auto-sampler.","forms":"","role":""},{"sop":"EP-06","num":"8.7","title":"Post-run Cleaning","order":7,"sum":"Flushing-out salts After finishing an analysis with a buffer, it is important to flush the HPLC system thoroughly to remove any residual salts or compounds.","forms":"","role":""},{"sop":"EP-06","num":"8.8","title":"Data Analysis","order":8,"sum":"Open the HPLC Software icon on desktop.","forms":"","role":""},{"sop":"EP-06","num":"8.9","title":"Shutting down the HPLC","order":9,"sum":"Turn off the modular pumps, detector, autosampler, and any other module, and close the HPLC Software.","forms":"","role":""},{"sop":"EP-06","num":"8.10","title":"HPLC Intermediate Checks","order":10,"sum":"Prepare the system suitability solution as directed in the applicable test method or analytical procedure.","forms":"FM EP06.02","role":""},{"sop":"EP-06","num":"8.11","title":"Performance Maintenance Tasks","order":11,"sum":"Regular maintenance ensures optimum performance and uninterrupted, trouble-free operation.","forms":"","role":""},{"sop":"LP-01","num":"7.1","title":"Safe Techniques and Practices","order":1,"sum":"The Laboratory enforces the following safety rules: A.","forms":"","role":""},{"sop":"LP-01","num":"7.2","title":"Handling of Hazardous Chemicals","order":2,"sum":"In diluting, always add acid to water unless otherwise directed in method.","forms":"","role":""},{"sop":"LP-01","num":"7.3","title":"Engineering","order":3,"sum":"Laboratory Management or designated personnel: A.","forms":"","role":""},{"sop":"LP-01","num":"7.4","title":"Safety Audits","order":4,"sum":"Laboratory Management or designated personnel perform weekly safety audits to ensure the application of this procedure, using the form FM LP01.01 Laboratory Safety Checklist.","forms":"FM LP01.01","role":""},{"sop":"LP-01","num":"7.5","title":"Emergency Response Procedures","order":5,"sum":"Chemical Spill: Notify the Laboratory Manager immediately.","forms":"","role":"Laboratory Manager"},{"sop":"LP-01","num":"7.6","title":"First Aidt Procedures","order":6,"sum":"First aid procedures for common laboratory incidents are provided below and shall be applied pending the arrival of professional medical assistance.","forms":"FM LP01.01","role":"Laboratory Manager"},{"sop":"LP-02","num":"7.1","title":"Definitions and Rules for Significant Figures","order":1,"sum":"All non-zero digits are significant.","forms":"","role":""},{"sop":"LP-02","num":"7.2","title":"Significant Figures in Calculated Results","order":2,"sum":"Most analytical results in the Laboratory are obtained by arithmetic combination of numbers: addition, subtraction, multiplication, and division.","forms":"","role":""},{"sop":"LP-02","num":"7.3","title":"Rounding","order":3,"sum":"The number of digits used for calculations and the number of digits appearing in a reportable value should be considered separately.","forms":"","role":""},{"sop":"LP-02","num":"7.4","title":"Expression of Weights and Measures","order":4,"sum":"In general, weights and measurements are expressed in the International System of Units.","forms":"","role":""},{"sop":"LP-02","num":"7.5","title":"Basic Statistical Principles","order":5,"sum":"All results from studies using analytical data are, at best, estimates of the true value because they contain uncertainty.","forms":"","role":""},{"sop":"LP-02","num":"7.6","title":"Estimating the center and dispersion from a sample","order":6,"sum":"Let Y1, Y2, \u2026,Yn represent a sample of (n) observation from a population of interest.","forms":"","role":""},{"sop":"LP-03","num":"7.1","title":"Overview of OOS Investigation","order":1,"sum":"Although Laboratory management is the overall responsible for OOS investigation, the first responsibility for achieving accurate laboratory testing results lies with the analyst who is performing the test.","forms":"FE LP03.01; FM LP03.01","role":""},{"sop":"LP-03","num":"7.2","title":"Phase I: Identification of the Assigned Cause","order":2,"sum":"The objective of Phase I is to identify an assigned cause linked to a laboratory issue or not.","forms":"FM LP03.01","role":""},{"sop":"LP-03","num":"7.3","title":"Phase II: Verification of OOS by retesting","order":3,"sum":"If no laboratory-assigned cause is identified in Phase I of the OOS investigation, the result is confirmed by retesting.","forms":"","role":""},{"sop":"LP-03","num":"7.4","title":"Closing of Investigation","order":4,"sum":"The following scenarios are possible: A.","forms":"","role":""},{"sop":"LP-03","num":"7.5","title":"Timeframes to Complete OOS Investigations","order":5,"sum":"Unless otherwise justified and documented, the following default timelines apply to OOS investigations: A.","forms":"FE LP03.01; FM LP03.01","role":"Laboratory Manager"},{"sop":"LP-04","num":"7.1","title":"General Requirements","order":1,"sum":"Laboratory management shall guarantee that only the latest validated version of the spreadsheet is being used and maintain the validated state of the spreadsheet.","forms":"FM LP04.01","role":""},{"sop":"LP-04","num":"7.2","title":"Preparing the Excel Spreadsheet for Validation","order":2,"sum":"Cells used for calculation shall be locked to prevent unauthorized or unintentional modifications, except for those used for data input.","forms":"","role":""},{"sop":"LP-04","num":"7.3","title":"Validation of the Protections","order":3,"sum":"Verify and document the following points: \u25aa Access rights to the spreadsheet (e.g., on the file directory) are correct: the file cannot be modified or deleted by users.","forms":"","role":""},{"sop":"LP-04","num":"7.4","title":"Validation of the Calculations with a Calculator (Manual Calculation)","order":4,"sum":"Using the printed formulas from the spreadsheet, calculate all the values using a scientific calculator and compare with the results given by the spreadsheet;","forms":"FM LP04.01","role":""},{"sop":"LP-05","num":"7.1","title":"Selection of Reference Materials and Standards","order":1,"sum":"Reference materials are selected based on their intended use (i.e., test method requirements).","forms":"","role":""},{"sop":"LP-05","num":"7.2","title":"Documentation Accompanying a Certified Reference Material","order":2,"sum":"At receipt, Laboratory Management or designated Laboratory Analyst verifies the documentation accompanying a RM.","forms":"","role":"Laboratory Analyst"},{"sop":"LP-05","num":"7.3","title":"Identification of Reference Materials","order":3,"sum":"The Laboratory uniquely identifies reference materials as follows: RS or RMYY# Where RS/RM stands for Reference Material;","forms":"FM LP05.01","role":""},{"sop":"LP-05","num":"7.4","title":"Handling, Use, Storage and Transport of Reference Materials","order":4,"sum":"Laboratory personnel have access to the RMs required to carry out their activities according to the respective authorizations for each position.","forms":"FE LP05.01; FM LP05.02","role":""},{"sop":"LP-05","num":"7.5","title":"Reference Materials Records","order":5,"sum":"The Laboratory keeps the following records of Reference Materials: \u25aa Identification, \u25aa Manufacturer, lot, or batch number, \u25aa Evaluation that the RM meets the specified requirements, \u25aa Location \u25aa Documentation of RMs (see 6.2), \u25aa Details of ","forms":"FE LP05.01; FM LP05.01; FM LP05.02","role":""},{"sop":"LP-06","num":"7.1","title":"Verification on Receipt of Reagents and Consumables","order":1,"sum":"Laboratory management or authorized personnel conducts a verification at receipt, on the basis of: \u25aa Checking the material against the purchase request;","forms":"FM QP05.05","role":""},{"sop":"LP-06","num":"7.2","title":"Purchased Reagents and in their Original Container","order":2,"sum":"An identification number is assigned each reagent as follows: RGYY# where # is a consecutive number starting at 001 and \u201cYY\u201d are the two last numbers of the current year;","forms":"FE LP06.01; FM LP06.01","role":""},{"sop":"LP-06","num":"7.3","title":"In-House Prepared Reagents (Solutions)","order":3,"sum":"In-house prepared solutions (in-house prepared reagents and media) used in analyses are prepared according to associated SOP and/or method of analysis instructions.","forms":"FM LP06.02; FM LP06.03","role":""},{"sop":"LP-06","num":"7.4","title":"Expiry Date","order":4,"sum":"The expiry date (before opening) given by the manufacturer is considered valid.","forms":"","role":""},{"sop":"LP-06","num":"7.5","title":"Storage","order":5,"sum":"Store reagents and media in accordance with manufacturer\u2019s recommendations and prepared solutions according to SOP or method of analysis instructions.","forms":"","role":""},{"sop":"LP-06","num":"7.6","title":"Disposal of Reagents and Prepared Reagents","order":6,"sum":"Reagents are disposed of when the expiry date is exceeded, or when they are no longer required.","forms":"FE LP06.01; FM LP06.01; FM LP06.02; FM LP06.03; FM LP06.04; FM LP06.05","role":""},{"sop":"LP-07","num":"7.1","title":"General Requirements","order":1,"sum":"Before being introduced for use, laboratory volumetric instruments should be calibrated or checked to demonstrate that they meet the laboratory\u2019s requirements and comply with the relevant standard specification.","forms":"","role":""},{"sop":"LP-07","num":"7.2","title":"Cleaning of Labware","order":2,"sum":"Labware should be cleaned immediately after use, at low temperatures, with brief soaking times, and low alkaline detergents.","forms":"","role":""},{"sop":"LP-07","num":"7.3","title":"Volumetric Glassware Calibration","order":3,"sum":"Calibration of volumetric glassware is documented using the form FM LP07.01 Calibration of Volumetric Glassware.","forms":"FE LP07.01; FE LP07.02; FM LP07.01","role":""},{"sop":"LP-07","num":"7.4","title":"Identification of Volumetric Apparatus","order":4,"sum":"Identify each internally calibrated volumetric apparatus using the following format: GW# Where GW stands for glassware;","forms":"FE LP07.01; FE LP07.02; FM LP07.01","role":""},{"sop":"QP-01","num":"5.1","title":"Definition of the Organizational Structure","order":1,"sum":"The organizational structure of the Laboratory is defined based on the need to carry out activities within the scope of the Laboratory.","forms":"","role":"Quality Assurance Manager"},{"sop":"QP-01","num":"5.2","title":"Definition of Personnel Responsibilities","order":2,"sum":"Personnel responsibilities are defined using the following information as long as it is available: \u25aa Recommendations from other laboratories.","forms":"FM QP01.02","role":"Personnel"},{"sop":"QP-01","num":"5.3","title":"Definition of Job Descriptions","order":3,"sum":"Job Descriptions are determined based on the following information as long as it is available: \u25aa Recommendations from other laboratories.","forms":"FM QP01.02","role":""},{"sop":"QP-01","num":"5.4","title":"Selection of Personnel","order":4,"sum":"The Laboratory selects its personnel based on: A.","forms":"FM QP01.03","role":"Personnel"},{"sop":"QP-01","num":"5.5","title":"Personnel Training","order":5,"sum":"Principally, there are four types of situations where training is needed: 5.5.1.","forms":"FM QP01.03; FM QP01.04; FM QP01.05; FM QP01.06; FM QP01.07; FM QP01.12","role":"Personnel"},{"sop":"QP-01","num":"5.6","title":"Supervision of Personnel","order":6,"sum":"The Laboratory supervises the technical personnel in charge of carrying out the services of the Laboratory, including those who are newly admitted and those who are in the process of being trained.","forms":"FM QP01.08; PM-01","role":"Personnel"},{"sop":"QP-01","num":"5.7","title":"Personnel Authorization","order":7,"sum":"Laboratory Director makes authorizations of the personnel to: \u25aa Develop, modify, verify, and validate methods.","forms":"FM QP01.10; FM QP01.11","role":"Quality Assurance Manager"},{"sop":"QP-01","num":"5.8","title":"Monitoring Personnel Competence","order":8,"sum":"Measuring the Effectiveness of Training The effectiveness of the training provided is evaluated as satisfactory if the proposed objectives are achieved once it is completed.","forms":"FM QP01.08","role":""},{"sop":"QP-01","num":"5.9","title":"Contract and Temporary Personnel","order":9,"sum":"Personnel performing work (for the Laboratory) under contract or temporary arrangements shall meet the same competency requirements as permanent staff.","forms":"","role":"Personnel"},{"sop":"QP-01","num":"5.10","title":"Conflict of Interest","order":10,"sum":"All personnel involved in laboratory activities shall declare any potential conflicts of interest.","forms":"FM QP01.06","role":"Laboratory Director"},{"sop":"QP-01","num":"5.11","title":"Quality Management System Awareness","order":11,"sum":"All personnel shall be made aware of the relevance and importance of their activities and how they contribute to the achievement of the management system objectives.","forms":"FM QP01.01; FM QP01.02; FM QP01.03; FM QP01.04; FM QP01.05; FM QP01.06; FM QP01.07; FM QP01.08; FM QP01.09; FM QP01.10; FM QP01.11; FM QP01.12; PM-01","role":"Laboratory Manager"},{"sop":"QP-02","num":"5.1","title":"General","order":1,"sum":"The Laboratory provides access to bench space and equipment, including but not limited, to HPLC and stirrers/mixers.","forms":"","role":""},{"sop":"QP-02","num":"5.2","title":"Access Control","order":2,"sum":"Access to laboratory areas shall be controlled and restricted to authorized personnel.","forms":"FM QP02.03","role":""},{"sop":"QP-02","num":"5.3","title":"Suitability of Facilities and Environmental Conditions","order":3,"sum":"Laboratory management assesses the suitability of facilities for the services it offers and documents them using the form FM QP02.01 Assessment of Suitability of Facilities and Environmental Conditions.","forms":"FM QP02.01; FM QP02.02","role":"Laboratory Manager"},{"sop":"QP-02","num":"5.4","title":"Cross Contamination Prevention","order":4,"sum":"Laboratory Management ensures effective separation between incompatible laboratory activities by planning laboratory work.","forms":"","role":""},{"sop":"QP-02","num":"5.5","title":"Segregation","order":5,"sum":"Hazardous chemical reagents are stored in appropriate cabinets (i.e., flammable, corrosive).","forms":"","role":""},{"sop":"QP-02","num":"5.6","title":"Housekeeping","order":6,"sum":"Housekeeping, as a minimum, includes the following activities: \u25aa Sweeping or mopping floors;","forms":"FM QP02.01; FM QP02.02; FM QP02.03","role":"Analyst"},{"sop":"QP-03","num":"5.1","title":"Selection of Equipment","order":1,"sum":"The Laboratory selects the equipment it requires based on the services it performs or it intends to perform.","forms":"FM QP03.01","role":""},{"sop":"QP-03","num":"5.2","title":"Compliance with Specified Requirements and Uncertainty","order":2,"sum":"Equipment requirements are defined in accordance with the services offered by the Laboratory.","forms":"FE QP03.01; FM QP03.01; FM QP03.02; FM QP03.03","role":"Laboratory Manager"},{"sop":"QP-03","num":"5.3","title":"Handling, Use, Storage and Transport of Equipment","order":3,"sum":"Laboratory personnel have access to the equipment required to carry out their activities, according to the respective authorizations for each position.","forms":"FE QP03.01; FM QP03.02","role":"Laboratory Manager"},{"sop":"QP-03","num":"5.4","title":"Equipment Identification","order":4,"sum":"The Laboratory uniquely identifies measuring equipment and general service equipment, as follows: B.","forms":"FM QP03.04","role":""},{"sop":"QP-03","num":"5.5","title":"Equipment Leaving Direct Control of the Laboratory","order":5,"sum":"When, for whatever reason, i.e., repair or calibration, equipment goes outside the direct control of the laboratory, the laboratory ensures that the function and calibration status of the equipment and its software (if applicable) are check","forms":"FM QP03.03","role":""},{"sop":"QP-03","num":"5.6","title":"Damaged or Out of Service Equipment and Equipment Decommissioning","order":6,"sum":"Equipment damaged, out of the specification required or equipment that is not in use, and therefore has not been calibrated, verified, or not operating properly must be clearly tagged using the label indicated in the form FM QP03.05 Identif","forms":"FM QP03.03; FM QP03.05; FM QP03.06; FM QP03.07","role":""},{"sop":"QP-03","num":"5.7","title":"Equipment Calibration and Qualification (AIQ)","order":7,"sum":"There are many ways of demonstrating that an instrument is qualified and under control, and these can include qualification, calibration, validation, and maintenance.","forms":"FE QP14.01; FM QP03.08; PM-02","role":""},{"sop":"QP-03","num":"5.8","title":"Equipment Maintenance","order":8,"sum":"The Laboratory performs maintenance of equipment in accordance with the manufacturer\u2019s instructions and international guidelines recommendations i.e., Eurachem, ICH, USP, etc.","forms":"PM-02","role":"Laboratory Manager"},{"sop":"QP-03","num":"5.9","title":"Update of Reference Values and Correction Factors","order":9,"sum":"Updating of reference values and correction factors is done by the Laboratory Manager, immediately to the calibration of equipment and at the most before the equipment is put back into service.","forms":"","role":"Laboratory Manager"},{"sop":"QP-03","num":"5.10","title":"Protection of laboratory equipment against unwanted adjustments","order":10,"sum":"Page 9 of 22 The inappropriate use and total or partial reproduction of this document is strictly forbidden, except if expressly authorized by Vertex Analytical Labs.","forms":"","role":"Laboratory Manager"},{"sop":"QP-03","num":"5.11","title":"Equipment Records","order":11,"sum":"The Laboratory keeps the following records for equipment: \u25aa Identification, including software and firmware version;","forms":"","role":""},{"sop":"QP-03","num":"5.12","title":"Guidelines on Equipment Validation ()","order":12,"sum":"In order to ensure \u201cfitness for purpose\u201d an integrated approach, based upon risk assessment is recommended.","forms":"","role":""},{"sop":"QP-04","num":"5.1","title":"Metrological Traceability General Guidelines","order":1,"sum":"The Laboratory evidences the metrological traceability of the services it performs, through the issuance of a metrological traceability chart for each of them, according to the form FM QP04.01 Metrological Traceability Tracking.","forms":"FM QP04.01","role":""},{"sop":"QP-04","num":"5.2","title":"Cases of Exception of Metrological Traceability","order":2,"sum":"In cases where it is not technically possible to achieve metrological traceability to units of the International System, the Laboratory evidences its metrological traceability to an appropriate reference, such as: A.","forms":"FM QP04.01","role":""},{"sop":"QP-05","num":"5.1","title":"Overview of the Process to Procure Products and Services","order":1,"sum":"The Laboratory defines, internally, its requirements for externally provided products and services using the form FM QP05.01 Purchase Request.","forms":"FM QP05.01; FM QP05.02; FM QP05.03; FM QP05.04; FM QP05.05","role":""},{"sop":"QP-05","num":"5.2","title":"Definition of Purchase Specifications","order":2,"sum":"Laboratory Manager and Analysts identify the key products and services for the development of laboratory activities and record them using the form FM QP05.01 Purchase Request.","forms":"FM QP05.01","role":"Laboratory Manager"},{"sop":"QP-05","num":"5.3","title":"Criteria for Selection of External Providers","order":3,"sum":"Once the products and/or services have been defined, the external providers are initially evaluated and selected based on the ability to meet contract conditions and quality system criteria using the form FM QP05.02 Evaluation of External V","forms":"FM QP05.02; FM QP05.03","role":""},{"sop":"QP-05","num":"5.4","title":"Additional Requirements for Subcontracting Testing Services","order":4,"sum":"The Laboratory Manager and Quality Assurance Manager shall use the form FM QP05.04 Testing Service Provider Assessment to document the selection and evaluation of testing service providers.","forms":"FM QP05.04","role":"Laboratory Manager"},{"sop":"QP-05","num":"5.5","title":"External Provider Monitoring and Re-evaluation","order":5,"sum":"The Laboratory evaluates the suppliers of the products and services that affect the quality of the services in case of a change in the fulfillment of the purchase specifications, a re-evaluation of the supplier is made using the form FM QP0","forms":"FM QP05.03; FM QP05.06","role":"Laboratory Manager"},{"sop":"QP-05","num":"5.6","title":"Communicating requirements","order":6,"sum":"The laboratory communicates the following requirements to providers of products and services if/as applicable: \u25aa Specific products or services to be provided, \u25aa Acceptance criteria, \u25aa Competency requirements, \u25aa Any activities that would be ","forms":"FE QP05.01; FM QP05.05","role":""},{"sop":"QP-05","num":"5.7","title":"Inspection and Verifications of Products and Services at Reception","order":7,"sum":"The Laboratory Manager ensures that purchased supplies, reagents, consumable materials, and services that affect the quality of tests are not used until they have been inspected or otherwise verified as complying with pre-established requir","forms":"FE QP05.01; FM QP05.01; FM QP05.02; FM QP05.03; FM QP05.04; FM QP05.05; FM QP05.06","role":"Laboratory Manager"},{"sop":"QP-06","num":"5.1","title":"Definition of Requirements (Review of Requests)","order":1,"sum":"Prior to accepting any services, all customer requirements will be adequately understood, documented, and agreed upon: \u25aa The Laboratory has all necessary resources available to carry out the agreed requirements;","forms":"FE QP06.01; FM QP06.01; FM QP06.02","role":"Laboratory Manager"},{"sop":"QP-06","num":"5.2","title":"Review of the Contract","order":2,"sum":"Once the requirements of the customer are fully understood and documented by the Laboratory, Customer Service Representative sends a proposal using the form FM QP06.02 Quotation of Services and a copy of the form FM QP06.03 Sample Submissio","forms":"FM QP06.02; FM QP06.03; FM QP06.04; FM QP06.05","role":"Customer Support"},{"sop":"QP-06","num":"5.3","title":"Review of Subcontracted Services","order":3,"sum":"If the Laboratory is going to subcontract part or the whole of a service, the contract review shall include the subcontracted service and must be endorsed by the customer.","forms":"","role":"Laboratory Manager"},{"sop":"QP-06","num":"5.4","title":"Deviations to the Contract","order":4,"sum":"When the laboratory is unable to comply with a contracted requirement (e.g., due to sample condition, equipment failure, or method limitation), the customer shall be notified promptly by the Laboratory Manager or the Customer Support Repres","forms":"","role":"Laboratory Manager"},{"sop":"QP-06","num":"5.5","title":"Modifications to Contract once Started the Service","order":5,"sum":"If once a service is started, and the initial contract must be modified, the adjustments made to the contract, including the new reviews, are recorded.","forms":"","role":""},{"sop":"QP-06","num":"5.6","title":"Cooperation with the Customer","order":6,"sum":"The laboratory cooperates with its customers for any clarification about the service offered.","forms":"FE QP06.01; FM QP06.01; FM QP06.02; FM QP06.03; FM QP06.04; FM QP06.05","role":"Laboratory Director"},{"sop":"QP-07","num":"5.1","title":"Method Selection","order":1,"sum":"An integral part of the Laboratory Quality System is the use of standard and appropriate methods and procedures for all services offered within its scope, including for the evaluation of measurement uncertainty (when required).","forms":"FM QP07.01","role":""},{"sop":"QP-07","num":"5.2","title":"Minimum Performance Parameters for Test Method Verification","order":2,"sum":"The process of assessing the suitability of compendial/reference analytical test methods under the conditions of actual use may or may not require actual laboratory performance of each analytical performance characteristic.","forms":"FM QP07.01","role":"Laboratory Manager"},{"sop":"QP-07","num":"5.3","title":"Minimum Performance Parameters for Test Method Validation","order":3,"sum":"Non-standard and laboratory-developed methods must be validated.","forms":"","role":""},{"sop":"QP-07","num":"5.4","title":"Test Method Verification / Validation Documentation","order":4,"sum":"Methods allocated for verification or validation are included in the form PM-03 Test Method Validation/Verification Program by the Laboratory Manager.","forms":"FM QP07.02; PM-03","role":"Laboratory Manager"},{"sop":"QP-07","num":"5.5","title":"Analytical Determination of Test Method Performance Parameters","order":5,"sum":"Specific procedures for the determination of the performance parameters of Test Method have been issued by authoritative sources.","forms":"","role":""},{"sop":"QP-07","num":"5.6","title":"Continued Test Method Performance Verification","order":6,"sum":"Once a method is in routine use, its continued fitness for purpose shall be monitored through: A.","forms":"","role":""},{"sop":"QP-07","num":"5.7","title":"Changes to Validated Test Methods","order":7,"sum":"Changes to Validated Test Methods that may affect the final result shall be communicated to the Customer by the Laboratory Manager.","forms":"","role":"Laboratory Manager"},{"sop":"QP-07","num":"5.8","title":"Validation Tools","order":8,"sum":"The following tools can be used to substantiate a method\u2019s ability to meet satisfactory specifications or performance: A.","forms":"FM QP07.01; FM QP07.02; PM-03","role":""},{"sop":"QP-08","num":"5.1","title":"Transportation of Samples","order":1,"sum":"The Laboratory does not perform transportation of samples from the customer facilities to the Laboratory.","forms":"","role":"Laboratory Manager"},{"sop":"QP-08","num":"5.2","title":"Reception and Identification of Samples","order":2,"sum":"Samples are received in the Front Desk area.","forms":"FM QP06.03","role":"Laboratory Manager"},{"sop":"QP-08","num":"5.3","title":"Identification of Samples","order":3,"sum":"If the sample complies with the previous requirements, an identification number is assigned using the following format: SYYMMX# Where YY are the two last numbers of the current year, MM, two digits for the current month, add letter X and # ","forms":"","role":""},{"sop":"QP-08","num":"5.4","title":"Recording of Received Samples","order":4,"sum":"The Laboratory Manager or designated personnel uses the sheet 1 \u201cReceived Samples\u201d of electronic form FE QP08.01__List__of Received Samples, available VERT Ge ralytical Labs LLC/6_Software_and_Spreadsheets to record the following: Jan Er EE","forms":"FE QP08.01","role":"Laboratory Manager"},{"sop":"QP-08","num":"5.5","title":"Sample Storage","order":5,"sum":"Samples awaiting analysis.","forms":"","role":""},{"sop":"QP-08","num":"5.6","title":"Handling of Samples","order":6,"sum":"Sample transfer within the laboratory A.","forms":"FE QP08.01","role":"Analyst"},{"sop":"QP-08","num":"5.7","title":"Sample Retention","order":7,"sum":"Samples are retained for 30 days after the report of testing (Analytical Report) is issued.","forms":"","role":""},{"sop":"QP-08","num":"5.8","title":"Disposal or Return of Samples","order":8,"sum":"Samples are disposed of in accordance with Federal, State and Local regulations.","forms":"FE QP08.01","role":"Laboratory Manager"},{"sop":"QP-09","num":"5.1","title":"Method Category Classification","order":1,"sum":"Before developing an MU budget, each quantitative method on the scope of accreditation shall be classified into one of three categories.","forms":"","role":""},{"sop":"QP-09","num":"5.2","title":"GUM Bottom-up Procedure (Category 3 \u2013 Full Budget)","order":2,"sum":"For Category 3 methods, apply the following five-step GUM-compliant process.","forms":"","role":""},{"sop":"QP-09","num":"5.3","title":"Top-Down / Empirical Approach (Simplified \u2013 Category 2 & 3)","order":3,"sum":"As an alternative to the full GUM bottom-up analysis the Laboratory may use an empirical top-down approach based on method performance data.","forms":"","role":""},{"sop":"QP-09","num":"5.4","title":"Measurement Uncertainty Budget Management","order":4,"sum":"Initial Establishment A new MU budget shall be established prior to first use of any quantitative method that enters the scope of accreditation.","forms":"FE QP09.01","role":""},{"sop":"QP-09","num":"5.5","title":"Periodic Review and Update Triggers","order":5,"sum":"An MU budget shall be reviewed and updated whenever any of the following occur: \u25aa A new or replaced major instrument is introduced.","forms":"","role":""},{"sop":"QP-09","num":"5.6","title":"Reporting of Measurement Uncertainty","order":6,"sum":"MU shall be reported in test reports and calibration certificates as follows, in accordance with QP-11 and ISO/IEC 17025:2017 \u00a7\u00a77.8.2\u20137.8.4: Context Requirement Reporting Format Required \u2014 report U with Result \u00b1 U (unit), 95% confidence, k ","forms":"","role":""},{"sop":"QP-09","num":"5.7","title":"Issuing Spreadsheets for Calculation of Uncertainty of Measurement","order":7,"sum":"Spreadsheets for calculation of uncertainty of measurement are prepared by trained personnel.","forms":"","role":""},{"sop":"QP-09","num":"5.8","title":"Tracking of Uncertainty of Measurement","order":8,"sum":"The Laboratory tracks the uncertainty of measurement for its services (when applicable) using the form FE QP09.01 Tracking of Uncertainty of Measurement.","forms":"FE QP09.01","role":"Laboratory Manager"},{"sop":"QP-10","num":"5.1","title":"Quality Control Materials","order":1,"sum":"Quality control materials may include, but are not limited to, Certified Reference Materials (CRMs), Reference Materials (RMs), replicate analysis, positive/negative control samples, laboratory control samples, blanks, and matrix spikes.","forms":"","role":""},{"sop":"QP-10","num":"5.2","title":"Internal Quality Control","order":2,"sum":"Quality Control is used to measure accuracy, precision, contamination, and matrix effects.","forms":"","role":""},{"sop":"QP-10","num":"5.3","title":"External Quality Control Program","order":3,"sum":"The laboratory participates in Proficiency Tests (PT), and if possible, in inter-laboratory comparisons (ILC), according to the plan indicated in the form PM-04 Proficiency Test Program.","forms":"PM-04","role":"Quality Assurance Manager"},{"sop":"QP-10","num":"5.4","title":"Other Quality Control Monitoring Activities","order":4,"sum":"Other QC procedures that are used include: A.","forms":"","role":""},{"sop":"QP-10","num":"5.5","title":"Evaluation of Quality Control Data","order":5,"sum":"All Analytical Worksheets are submitted to the Laboratory Manager for review.","forms":"","role":"Laboratory Manager"},{"sop":"QP-10","num":"5.6","title":"Quality Control Charts","order":6,"sum":"The control chart is a graphical presentation of QC efficiency.","forms":"","role":""},{"sop":"QP-10","num":"5.7","title":"Statistical Process Control","order":7,"sum":"Statistical limits are determined at the 99% confidence interval.","forms":"PM-04","role":""},{"sop":"QP-11","num":"5.1","title":"Reporting Raw Data","order":1,"sum":"Use of Logbooks and Worksheets A.","forms":"","role":"Laboratory Manager"},{"sop":"QP-11","num":"5.2","title":"Attachments","order":2,"sum":"Attachments can consist of: \u25aa Instrument generated reports and charts;","forms":"","role":"Analyst"},{"sop":"QP-11","num":"5.3","title":"Instrument Generated Reports and Charts","order":3,"sum":"When instrument generated reports are included in the analytical package, print the report in a way that provides information needed to interpret its graphic, tabular, or computational output, such as: absorbency Page 6 of 12 The inappropri","forms":"","role":"Analyst"},{"sop":"QP-11","num":"5.4","title":"Deviations and Modifications","order":4,"sum":"Whenever there is a need to (a) Deviate from or add to an official method, (b) Use an entirely new method for a sample analysis or (c) Modify test conditions such that it may affect the integrity of the analysis and interpretation of result","forms":"","role":"Analyst"},{"sop":"QP-11","num":"5.5","title":"Additional Analysis","order":5,"sum":"Whenever a check or additional analysis is performed, a new Analytical Worksheet or a new entry in the logbooks is made to report the results.","forms":"","role":""},{"sop":"QP-11","num":"5.6","title":"Reviewing Analytical Results","order":6,"sum":"A second qualified Analyst or Laboratory Manager will review the package prior to it being forwarded to final report.","forms":"","role":"Laboratory Manager"},{"sop":"QP-11","num":"5.7","title":"Authorizing Analytical Results","order":7,"sum":"Analytical packages (Analytical worksheets and attachments) are approved by the Laboratory Manager.","forms":"","role":"Laboratory Manager"},{"sop":"QP-11","num":"5.8","title":"Reporting Results (Test Report)","order":8,"sum":"The Laboratory presents analytical findings on the FM QP11.01 Analytical Testing Report, in a clear and concise manner to expedite interpretation of the results, especially by non-technical and non-scientific personnel.","forms":"FM QP11.01","role":"Laboratory Manager"},{"sop":"QP-11","num":"5.9","title":"Electronic Report Security and Integrity","order":9,"sum":"Test reports transmitted electronically shall be protected by the following measures: A.","forms":"","role":""},{"sop":"QP-11","num":"5.10","title":"Additional Requirements to Report Subcontracted Tests","order":10,"sum":"The test report shall include a statement indicating that it contains subcontracted tests e.g., \u201cThis report contains data that were produced under subcontract by Laboratory [Name of the Laboratory], accredited by [Name of the Accreditation","forms":"","role":""},{"sop":"QP-11","num":"5.11","title":"Opinions and Interpretations","order":11,"sum":"Analytical findings are interpreted by the Laboratory Manager and are comprised, but not limited to: A.","forms":"","role":"Laboratory Manager"},{"sop":"QP-11","num":"5.12","title":"Issuing Modifications or Amendments to Analytical Reports","order":12,"sum":"To issue a modification or amendment to an analytical report, Laboratory Manager: A.","forms":"FM QP11.01","role":"Laboratory Manager"},{"sop":"QP-12","num":"5.1","title":"Reception of Complaints","order":1,"sum":"The Laboratory has the following ways for receive any expression of dissatisfaction from the customers: \u25aa Web page, \u25aa Mail contact (customersupport@vertexanalytical.com), \u25aa Phone call to +1 888-316-1414, and \u25aa In facilities (9335 Airway Roa","forms":"FE QP12.01; FM QP12.01","role":"Quality Assurance Manager"},{"sop":"QP-12","num":"5.2","title":"Validation of Complaints","order":2,"sum":"To ensure impartiality, the Quality Assurance Manager shall conduct an independent investigation of the complaint when they have not been involved in the activities related to the complaint.","forms":"FM QP12.01; FM QP12.02","role":"Laboratory Manager"},{"sop":"QP-12","num":"5.3","title":"Communicating with the Complainant","order":3,"sum":"Whenever possible, Quality Assurance staff or Customer Service Representatives acknowledge the receipt of a complaint and provide the individual filing the complaint with progress reports.","forms":"FM QP12.01","role":"Quality Assurance Manager"},{"sop":"QP-12","num":"5.4","title":"Appeals to Complaints","order":4,"sum":"If the complainant appeals against the result of the complaint, the Quality Assurance Manager and/or Customer Service Representative shall request evidence of the reason why the complaint is being debated.","forms":"","role":"Quality Assurance Manager"},{"sop":"QP-12","num":"5.5","title":"Feedback","order":5,"sum":"The Laboratory collects customer feedback, positive or negative, through the Customer Service Representative using the form FM QP12.02 Customer Feedback Survey.","forms":"FE QP12.02; FM QP12.01; FM QP12.02","role":"Laboratory Manager"},{"sop":"QP-12","num":"5.6","title":"Complaints and Feedback Trend Analysis","order":6,"sum":"Complaint and feedback data, both from customers and lab staff, shall be analyzed at minimum annually by the Quality Assurance Manager to identify trends and systemic issues.","forms":"FE QP12.01; FE QP12.02; FM QP12.01; FM QP12.02","role":"Quality Assurance Manager"},{"sop":"QP-13","num":"5.1","title":"General","order":1,"sum":"Nonconformance logs are initiated by the person detecting or receiving (externally detected) the nonconformity.","forms":"FE QP13.01; FM QP13.01","role":"Quality Assurance Manager"},{"sop":"QP-13","num":"5.2","title":"Identification and Initial Documentation of Nonconforming Work","order":2,"sum":"Nonconformances are assigned an identification number using the following format: NCRYY# Where YY are the two final digits of the current year, e.g.","forms":"","role":""},{"sop":"QP-13","num":"5.3","title":"Categories of Nonconforming Work","order":3,"sum":"The Laboratory uses the following categories of Nonconforming Work to refer to the different ways in which a laboratory's operations, processes, or results can fail to meet specified standards or expectations: A.","forms":"","role":"Personnel"},{"sop":"QP-13","num":"5.4","title":"Severity Classification of Nonconforming Work","order":4,"sum":"All nonconforming work shall be classified according to the following severity levels: A.","forms":"","role":""},{"sop":"QP-13","num":"5.5","title":"Nonconforming Work Investigation and Evaluation","order":5,"sum":"Area management (QA, QC) conducts a preliminary investigation to determine if the nonconforming work presented proceeds;","forms":"FM QP13.01","role":"Laboratory Manager"},{"sop":"QP-13","num":"5.6","title":"Application of Corrective Actions","order":6,"sum":"If possible, an immediate correction is applied to eliminate nonconforming work.","forms":"","role":"Laboratory Manager"},{"sop":"QP-13","num":"5.7","title":"Investigating Out-of-Specification Results (OOS)","order":7,"sum":"If the nonconforming work detected is an Out-of-Specification Result, the Laboratory Manager uses the procedure LP-03 Management of Out-of-Specification Results to conduct an objective and timely assessment of the NC.","forms":"","role":"Laboratory Manager"},{"sop":"QP-13","num":"5.8","title":"Records of Nonconforming Work","order":8,"sum":"The records associated with nonconforming work, including corrective action reports, are retained by the Quality Assurance personnel for at least 5 years.","forms":"FE QP13.01; FM QP13.01","role":""},{"sop":"QP-14","num":"5.1","title":"General","order":1,"sum":"All documents issued in the Laboratory as part of the management system are reviewed and approved for use by authorized personnel prior to use.","forms":"FE QP14.01; FM QP14.01; FM QP14.02","role":"Quality Assurance Manager"},{"sop":"QP-14","num":"5.2","title":"Control of Internal Documents","order":2,"sum":"The laboratory issues and controls the following types of internal documents: A.","forms":"","role":""},{"sop":"QP-14","num":"5.3","title":"Development and Revision of Internal Documents","order":3,"sum":"Authors, reviewers, and approvers are identified by Laboratory Manager, Quality Assurance Manager, and/or Laboratory Director.","forms":"FM QP14.02","role":"Laboratory Manager"},{"sop":"QP-14","num":"5.4","title":"Internal Documents Formatting","order":4,"sum":"The Laboratory uses the following templates to issue its documents: ID Type of Document Template TMP-SOP SOP Quality and Technical SOP Template TMP-FM Forms Forms Template TMP-TM Test Methods Test Methods Template Templates are electronic f","forms":"","role":""},{"sop":"QP-14","num":"5.5","title":"Identification of Documents","order":5,"sum":"Quality System personnel uses the following guidelines to identify internal documents: Identification Revision Type of Document Use Example Structure [ID] Start Describe how quality management system is Quality Management Procedures QP-# 01","forms":"FE QP14.01; FM LP01.01; FM QP01.01; PM-01","role":""},{"sop":"QP-14","num":"5.6","title":"Issuing Documents","order":6,"sum":"Staff responsible for preparing a new document or new revision of a document shall request the appropriate template from the Quality System Manager.","forms":"FE QP14.01; FM QP14.01","role":""},{"sop":"QP-14","num":"5.7","title":"Control of External Documents","order":7,"sum":"Documents from external sources are tracked through Master List of Documents.","forms":"FE QP14.01","role":""},{"sop":"QP-14","num":"5.8","title":"Removal of Documents","order":8,"sum":"Expired documents are stamped with \u201cOBSOLET DOCUMENT\u201d in red ink by Quality Assurance Manager.","forms":"FM QP14.01","role":"Quality Assurance Manager"},{"sop":"QP-14","num":"5.9","title":"Document Retention and Archival","order":9,"sum":"Documents are retained for at least 5 years.","forms":"","role":""},{"sop":"QP-14","num":"5.10","title":"Management of Electronic Signatures","order":10,"sum":"Electronic signatures may be used on laboratory documents, procedures, and forms as an alternative to handwritten signatures, subject to the following requirements: A.","forms":"FE QP14.01; FM QP14.01; FM QP14.02","role":"Quality Assurance Manager"},{"sop":"QP-15","num":"5.1","title":"Overall Description of the Process to Adress Risks and Opportunities","order":1,"sum":"Action plans can be initiated by any member of the Laboratory by using the form FM QP15.01 Change Request form and submitting it to their manager or Quality Assurance Manager.","forms":"FE QP15.01; FE QP15.02; FM QP15.01","role":"Quality Assurance Manager"},{"sop":"QP-15","num":"5.2","title":"Identification of Actions to Address Risks and Opportunities","order":2,"sum":"Potential undesired impacts and failures and areas for improvement may be identified using any of the following: A.","forms":"","role":""},{"sop":"QP-15","num":"5.3","title":"Action Plan and Management of Change","order":3,"sum":"The Laboratory implements actions to address risks and opportunities through a Change Management process which consists of: 1) Determining the potential cause of the problems (risk assessment);","forms":"","role":""},{"sop":"QP-15","num":"5.4","title":"Tools for Risk Assessment \u2013 Failure Mode Effects Analysis","order":4,"sum":"The Laboratory uses, as a main tool, Failure Modes Effects Analysis.","forms":"","role":""},{"sop":"QP-16","num":"5.1","title":"General Steps for Corrective Action Implementation","order":1,"sum":"Define the Problem Identify the internal/external problem in quantifiable terms;","forms":"","role":""},{"sop":"QP-16","num":"5.2","title":"Initiating a Corrective Action Plan","order":2,"sum":"Any member of staff can initiate a request for a corrective action plan using the form FM QP16.01 Corrective Action Plan and logging the corrective action to FE QP16.01 Corrective Action Tracking.","forms":"FE QP16.01; FM QP16.01","role":""},{"sop":"QP-16","num":"5.3","title":"Correction","order":3,"sum":"A nonconformance detected where a service was not affected but absolute compliance to a statement of intent or clause standard was not met on basis of objective evidence is corrected only with rectification actions and is closed by the Labo","forms":"","role":"Laboratory Manager"},{"sop":"QP-16","num":"5.4","title":"Root Cause & Corrective Action","order":4,"sum":"Once a nonconformance that impacts Laboratory processes or services is detected an evaluation of the need for action to eliminate the cause(s) shall be conducted and/or coordinated by Laboratory Supervision.","forms":"FM QP16.02; FM QP16.03","role":"Laboratory Manager"},{"sop":"QP-16","num":"5.5","title":"Root Cause Analysis Methodologies","order":5,"sum":"Root cause analysis (RCA) for nonconformities shall be documented using one or more of the following methodologies.","forms":"FM QP16.02; FM QP16.03; FM QP16.04","role":""},{"sop":"QP-16","num":"5.6","title":"Monitoring for Effectiveness","order":6,"sum":"Corrective actions that are implemented are monitored to determine if they are and/or continue to be effective.","forms":"","role":""},{"sop":"QP-16","num":"5.7","title":"Corrective Action Timelines","order":7,"sum":"Corrective action implementation timelines shall be based on the severity classification of the nonconformity (as defined in QP-13).","forms":"FE QP16.01; FM QP16.01; FM QP16.02; FM QP16.03; FM QP16.04","role":"Laboratory Director"},{"sop":"QP-17","num":"5.1","title":"General","order":1,"sum":"Internal audits scheduled shall be agreed between Quality Assurance Manager and Laboratory Manager.","forms":"FM QP17.01; FM QP17.02; FM QP17.03","role":"Laboratory Manager"},{"sop":"QP-17","num":"5.2","title":"Internal Audits","order":2,"sum":"Internal auditors must remain objective and independent of the specific laboratory activities they are assigned to audit.","forms":"PM-05","role":"Quality Assurance Manager"},{"sop":"QP-17","num":"5.3","title":"Quality Management System Audits","order":3,"sum":"Audits of the entire Quality Management System are conducted at a minimum of once per year.","forms":"","role":"Personnel"},{"sop":"QP-17","num":"5.4","title":"Process (Technical) Audits","order":4,"sum":"The information from specific process (Laboratory Services) audits supports the completion of the comprehensive internal audit and shows performance throughout the year instead of only at one sampling point.","forms":"","role":"Laboratory Manager"},{"sop":"QP-17","num":"5.5","title":"Internal Audit (Follow-Up/Focused)","order":5,"sum":"Follow-up or focused audits may be in response to prior audits, detected nonconformances, complaints, or as effectiveness reviews for planned or completed corrective or preventive actions.","forms":"","role":""},{"sop":"QP-17","num":"5.6","title":"Training Requirements","order":6,"sum":"Audits shall be carried out by trained and qualified personnel who are, when resources permit, independent of the activity audited.","forms":"","role":"Personnel"},{"sop":"QP-17","num":"5.7","title":"External \u2013 Second Party Audits","order":7,"sum":"Page 10 of 13 The inappropriate use and total or partial reproduction of this document is strictly forbidden, except if expressly authorized by Vertex Analytical Labs.","forms":"","role":"Laboratory Manager"},{"sop":"QP-17","num":"5.8","title":"External \u2013 Third Party Audits","order":8,"sum":"Performed by accreditation organization auditors.","forms":"","role":"Laboratory Manager"},{"sop":"QP-17","num":"5.9","title":"Nonconformances","order":9,"sum":"Nonconformances may be corrected on the spot if the issue is minor, isolated, and can be easily corrected.","forms":"FM QP17.01; FM QP17.02; FM QP17.03; PM-05","role":""},{"sop":"QP-18","num":"5.1","title":"General","order":1,"sum":"The management review process is a platform for determining and providing the resources needed to implement and maintain the quality management system, to continually improve its effectiveness, and to better meet customer requirements.","forms":"FM QP18.01; FM QP18.02","role":"Quality Assurance Manager"},{"sop":"QP-18","num":"5.2","title":"Review Period","order":2,"sum":"The Laboratory conduct management reviews at least once per year, generally, at the end of the year (final quarter).","forms":"","role":"Laboratory Director"},{"sop":"QP-18","num":"5.3","title":"Management Review Input","order":3,"sum":"Quality Assurance Manager coordinates the reviewing of the following data (at a minimum): \u25aa Fulfillment of objectives Quality objectives established through the review period are systematically evaluated to assess progress.","forms":"","role":"Quality Assurance Manager"},{"sop":"QP-18","num":"5.4","title":"Management Review Output","order":4,"sum":"The outputs of the management review are documented by the Quality Assurance Manager and shall include all the decision and actions related to at least: \u25aa The effectiveness of the management system and its processes \u25aa Improvement of the lab","forms":"FM QP18.01","role":"Quality Assurance Manager"},{"sop":"QP-18","num":"5.5","title":"Tracking and Monitoring of Action Items","order":5,"sum":"All action items identified during the management review must be systematically tracked and monitored to ensure completion and effectiveness.","forms":"FM QP18.01; FM QP18.02","role":"Quality Assurance Manager"}],"edges":[{"s":"EP-01","t":"QP-03","type":"References","w":1},{"s":"EP-01","t":"QP-13","type":"References","w":1},{"s":"EP-02","t":"QP-13","type":"References","w":1},{"s":"EP-03","t":"QP-13","type":"References","w":1},{"s":"EP-04","t":"LP-06","type":"References","w":1},{"s":"EP-04","t":"QP-13","type":"References","w":1},{"s":"EP-05","t":"QP-13","type":"References","w":1},{"s":"EP-06","t":"QP-13","type":"References","w":1},{"s":"QM","t":"LP-04","type":"Governs","w":2},{"s":"QM","t":"QP-01","type":"Governs","w":5},{"s":"QM","t":"QP-02","type":"Governs","w":3},{"s":"QM","t":"QP-03","type":"Governs","w":12},{"s":"QM","t":"QP-04","type":"Governs","w":3},{"s":"QM","t":"QP-05","type":"Governs","w":3},{"s":"QM","t":"QP-06","type":"Governs","w":6},{"s":"QM","t":"QP-07","type":"Governs","w":3},{"s":"QM","t":"QP-08","type":"Governs","w":4},{"s":"QM","t":"QP-09","type":"Governs","w":2},{"s":"QM","t":"QP-10","type":"Governs","w":3},{"s":"QM","t":"QP-11","type":"Governs","w":2},{"s":"QM","t":"QP-12","type":"Governs","w":1},{"s":"QM","t":"QP-13","type":"Governs","w":2},{"s":"QM","t":"QP-14","type":"Governs","w":5},{"s":"QM","t":"QP-15","type":"Governs","w":6},{"s":"QM","t":"QP-16","type":"Governs","w":1},{"s":"QM","t":"QP-17","type":"Governs","w":2},{"s":"QM","t":"QP-18","type":"Governs","w":1},{"s":"QP-03","t":"QP-05","type":"References","w":1},{"s":"QP-03","t":"QP-13","type":"References","w":1},{"s":"QP-06","t":"QP-05","type":"References","w":1},{"s":"QP-07","t":"QP-15","type":"References","w":1},{"s":"QP-08","t":"QP-06","type":"References","w":1},{"s":"QP-09","t":"QP-07","type":"References","w":3},{"s":"QP-09","t":"QP-10","type":"References","w":2},{"s":"QP-09","t":"QP-11","type":"References","w":1},{"s":"QP-09","t":"QP-14","type":"References","w":2},{"s":"QP-09","t":"QP-18","type":"References","w":1},{"s":"QP-10","t":"QP-13","type":"References","w":1},{"s":"QP-10","t":"QP-14","type":"References","w":1},{"s":"QP-12","t":"QP-13","type":"References","w":1},{"s":"QP-12","t":"QP-15","type":"References","w":1},{"s":"QP-12","t":"QP-18","type":"References","w":1},{"s":"QP-13","t":"LP-03","type":"References","w":1},{"s":"QP-13","t":"QP-16","type":"References","w":2},{"s":"QP-14","t":"EP-01","type":"References","w":1},{"s":"QP-14","t":"LP-01","type":"References","w":1},{"s":"QP-14","t":"QP-01","type":"References","w":3},{"s":"QP-15","t":"QP-14","type":"References","w":1},{"s":"QP-16","t":"QP-13","type":"References","w":1},{"s":"QP-16","t":"QP-15","type":"References","w":1},{"s":"QP-17","t":"QP-13","type":"References","w":1},{"s":"QP-17","t":"QP-16","type":"References","w":1},{"s":"QP-18","t":"QP-13","type":"References","w":1},{"s":"QP-18","t":"QP-16","type":"References","w":1}],"clausecols":["4.1","5","6.2","6.3","6.4","6.5","6.6","7.1","7.2","7.4","7.6","7.7","7.8","7.9","7.10","8.3","8.5","8.7","8.8","8.9"],"clausemap":[{"sop":"QP-01","clause":"6.2"},{"sop":"QP-02","clause":"6.3"},{"sop":"QP-03","clause":"6.4"},{"sop":"QP-04","clause":"6.5"},{"sop":"QP-05","clause":"6.6"},{"sop":"QP-06","clause":"7.1"},{"sop":"QP-07","clause":"7.2"},{"sop":"QP-08","clause":"7.4"},{"sop":"QP-09","clause":"7.6"},{"sop":"QP-10","clause":"7.7"},{"sop":"QP-11","clause":"7.8"},{"sop":"QP-12","clause":"7.9"},{"sop":"QP-13","clause":"7.10"},{"sop":"QP-14","clause":"8.3"},{"sop":"QP-15","clause":"8.5"},{"sop":"QP-16","clause":"8.7"},{"sop":"QP-17","clause":"8.8"},{"sop":"QP-18","clause":"8.9"}],"complaints":[{"id":"CMP26001","c1":"The Client","c2":"Turnaround / delivery","st":"Closed - Resolved","stc":"b-green","d":"2026-03-31"},{"id":"CMP26002","c1":"City Water Dept","c2":"Report formatting","st":"Under Evaluation","stc":"b-blue","d":"2026-05-12"}],"ncw":[{"id":"NC26003","c1":"PT annual frequency missed (PM-04)","c2":"Escalated to CA","stc":"b-red","d":"2026-03-31"},{"id":"NC26002","c1":"Incubator temp excursion (weekend)","c2":"Closed","stc":"b-green","d":"2026-02-10"}],"ca":[{"id":"CAR26001","c1":"NC26003 &mdash; PT scheduling control","c2":"Verification","stc":"b-amber","d":"2026-03-31"},{"id":"CAR26002","c1":"PT evidence compilation","c2":"In Progress","stc":"b-blue","d":"2026-04-10"}],"risks":[{"id":"AARO2501","c1":"SharePoint customer-service portal","c2":"Approved - In Progress","stc":"b-amber","d":"2025-02-03"},{"id":"AARO2601","c1":"Single HPLC analyst (SPOF)","c2":"Mitigating","stc":"b-blue","d":"2026-01-15"}],"ofi":[{"id":"OFI2601","c1":"Automate media temperature logging","c2":"Approved","stc":"b-green","d":"2026-01-20"},{"id":"OFI2602","c1":"Consolidate chemistry bench sheets","c2":"Under Review","stc":"b-blue","d":"2026-02-28"}],"audits":[{"id":"AUD-26-01","c1":"Full-system internal audit (ISO 17025)","c2":"Completed - 1 finding","stc":"b-green","d":"2026-03-30"},{"id":"AUD-25-04","c1":"Sample receiving","c2":"Completed","stc":"b-green","d":"2025-11-05"}],"dcr":[{"id":"DCR-26001","title":"Revise PM-04 &mdash; PT enrollment deadline","type":"Revision","driver":"Preventive Action","stage":"QA Review","stc":"b-amber","date":"2026-04-06"},{"id":"DCR-25012","title":"2-year QMS revision cycle (batch)","type":"Revision","driver":"Other","stage":"Issued","stc":"b-green","date":"2026-02-03"}],"activity":[{"color":"#0072B2","text":"Document <strong>QP-16 Rev02</strong> issued via DCR-26001.","when":"2 hours ago"},{"color":"#DC2626","text":"<strong>NC26003</strong> raised from the 2026 internal audit.","when":"Yesterday"},{"color":"#2E7D32","text":"<strong>CAR26001</strong> actions verified effective.","when":"Apr 12"},{"color":"#E69F00","text":"Audit <strong>AUD-26-01</strong> closed with 1 finding.","when":"Apr 3"}],"activity_tasks":[{"icon":"icon-check-outline","ti":"Calibrate / check a balance","sops":["EP-01"]},{"icon":"icon-flask-outline","ti":"Run an HPLC analysis","sops":["EP-06","QP-10"]},{"icon":"icon-folder-outline","ti":"Receive & log a sample","sops":["QP-08","QP-06"]},{"icon":"icon-comment-outline","ti":"Handle a customer complaint","sops":["QP-12","QP-13"]},{"icon":"icon-warning-outline","ti":"Report nonconforming work","sops":["QP-13","QP-16"]},{"icon":"icon-document-outline","ti":"Change a controlled document","sops":["QP-14"]},{"icon":"icon-vials-outline","ti":"Prepare a reagent / solution","sops":["LP-06"]},{"icon":"icon-gauge-outline","ti":"Check a pH meter","sops":["EP-04"]}]}</script>
<script>
"use strict";
(function(){

/* ----- Mock SharePoint data-access layer -----
   In production, SP.items(listTitle) issues:
   GET _api/web/lists/getbytitle('<listTitle>')/items?$select=...
   Here it returns the embedded seed so render logic contains NO hardcoded data. */
var LISTS = JSON.parse(document.getElementById('lists').textContent);
var SP = { items:function(name){ return (LISTS[name] || []).slice(); } };

function esc(s){return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');}
function byId(id){return document.getElementById(id);}
function showAlert(type,msg){var el=byId('global-alert');el.className='global-alert '+type;el.style.display='flex';el.querySelector('.alert-msg').textContent=msg;clearTimeout(el._t);el._t=setTimeout(function(){el.style.display='none';},4000);}

var TYPECOLOR={'Quality Manual':'#0C3254','Quality Procedure':'#0072B2','Equipment Procedure':'#2E7D32','Laboratory Procedure':'#E69F00','List/Register':'#6B7280'};
var OPS_META={
 complaints:{list:'complaints',h:['ID','Submitter','Type','Status','Date'],title:'Complaints & Feedback',clause:'7.9',modal:'m-cmp',btn:'Log Complaint'},
 ncw:{list:'ncw',h:['NC #','Description','Status','_','Date'],title:'Nonconforming Work',clause:'7.10',btn:'Log NCW'},
 ca:{list:'ca',h:['CAR #','Source / Root cause','Status','_','Date'],title:'Corrective Actions',clause:'8.7',btn:'Initiate CA'},
 risks:{list:'risks',h:['ID','Description','Status','_','Date'],title:'Risks & Opportunities',clause:'8.5',btn:'Log Risk/Opp'},
 ofi:{list:'ofi',h:['OFI #','Idea','Status','_','Date'],title:'Improvement',clause:'8.6',modal:'m-ofi',btn:'Submit OFI'},
 audits:{list:'audits',h:['Audit ID','Scope','Status','_','Date'],title:'Audits & Reviews',clause:'8.8',btn:'Schedule Audit'}
};

var TAB_LABELS={dashboard:'Dashboard',docs:'Document Control',ops:'Quality Operations',compass:'Lab Compass'};
function switchTab(tab){
 document.querySelectorAll('.tab-btn').forEach(function(b){b.classList.toggle('active',b.dataset.tab===tab);});
 document.querySelectorAll('.view').forEach(function(v){v.classList.remove('active');});
 byId('v-'+tab).classList.add('active');window.scrollTo(0,0);
 byId('tabsWrap').classList.remove('nav-open');
 var lbl=TAB_LABELS[tab]||'';
 byId('cplLeft').textContent=lbl;
 byId('cplRight').textContent=lbl;
}
function switchSub(group,sub){
 byId(group+'Nav').querySelectorAll('button').forEach(function(b){b.classList.toggle('active',b.dataset.sub===sub);});
 var views={docs:['register','viewer','network','clause','dcr'],ops:['complaints','ncw','ca','risks','ofi','audits']}[group];
 views.forEach(function(s){byId('s-'+s).classList.toggle('active',s===sub);});
 if(sub==='network')setTimeout(drawNetwork,30);
}
window.go=function(tab,sub){switchTab(tab);if(sub)switchSub(tab,sub);};
window.openModal=function(id){byId(id).classList.add('open');};
window.closeModal=function(id){byId(id).classList.remove('open');};
window.demoSave=function(id){closeModal(id);showAlert('info','Prototype: the built page saves this to the SharePoint list and routes approvals via Power Automate.');};
window.demoNew=function(){showAlert('info','Prototype: opens the record form for this process (built from its list specification).');};

function resolveSiteUrl() {
  if (window._spPageContextInfo && _spPageContextInfo.webAbsoluteUrl) return _spPageContextInfo.webAbsoluteUrl;
  var href = window.location.href;
  var idx = href.indexOf("/SiteAssets");
  if (idx !== -1) return href.substring(0, idx);
  idx = href.indexOf("/SitePages");
  if (idx !== -1) return href.substring(0, idx);
  return location.origin;
}
var siteUrl = resolveSiteUrl();

/* Brand icon sprite (SiteAssets/brand-icons.svg, sibling to this page). Fetched as text and
   injected as a hidden node so same-document <use href="#icon-name"> references resolve --
   matches the pattern already used in ReceivedSamples.aspx/TestResultsReporting.aspx. Loaded
   now so it's ready the first time a card actually references an icon from it; no icon in this
   page uses it yet -- the existing i-flask/i-gauge/etc. symbols above stay inline as-is. */
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
loadIconSprite(siteUrl);

function setLogoSrc(base) {
  if (!base) return;
  var logo = byId('hdrLogoFull');
  var logoIcon = byId('hdrLogoIcon');
  if (logo) logo.src = base + '/SiteAssets/logo_vertex_secondary.svg';
  if (logoIcon) logoIcon.src = base + '/SiteAssets/logo_vertex_icon_app_secondary.svg';
}
setLogoSrc(siteUrl);

/* Current user + position, matching Personnel_Training_System.aspx's PTS_Users pattern:
   real name/id from _api/web/currentuser, then position looked up from PTS_Users by the
   numeric SharePoint User ID (not by name -- avoids display-name collisions/typos).
   ASSUMPTION: PTS_Users lives on this same site. If it's actually on a different site,
   set PTS_SITE_URL below to that site's full URL instead of leaving it null. */
var PTS_SITE_URL = null;
function ptsSiteUrl(){ return PTS_SITE_URL || siteUrl; }

function getCurrentUserInfo(){
  return fetch(siteUrl + "/_api/web/currentuser?$select=Id,Title", {
    headers: { "Accept": "application/json;odata=verbose" },
    credentials: "same-origin"
  })
  .then(function(r){ return r.json(); })
  .then(function(j){ var d=j.d||{}; return { id:d.Id, name:d.Title }; })
  .catch(function(){ return null; });
}

function getUserPosition(spUserId){
  var url = ptsSiteUrl() + "/_api/web/lists/getbytitle('PTS_Users')/items?$filter=SharePointUserId eq " + spUserId + "&$select=Position&$top=1";
  return fetch(url, {
    headers: { "Accept": "application/json;odata=verbose" },
    credentials: "same-origin"
  })
  .then(function(r){ return r.json(); })
  .then(function(j){ var results=(j.d&&j.d.results)||[]; return results.length ? (results[0].Position||"") : ""; })
  .catch(function(){ return ""; });
}

function setUserDisplay(name, role){
  var initials = (name||"").split(" ").slice(0,2).map(function(w){return w[0]||"";}).join("").toUpperCase() || "?";
  ["hdrName","navName"].forEach(function(id){ var el=byId(id); if(el) el.textContent = name || "Unknown User"; });
  ["hdrRole","navRole"].forEach(function(id){ var el=byId(id); if(el) el.textContent = role || ""; });
  ["hdrAvatar","navAvatar"].forEach(function(id){ var el=byId(id); if(el) el.textContent = initials; });
}

function loadCurrentUserInfo(){
  getCurrentUserInfo().then(function(cu){
    if (!cu || !cu.id) return;
    setUserDisplay(cu.name, "");
    getUserPosition(cu.id).then(function(pos){ setUserDisplay(cu.name, pos); });
  });
}
loadCurrentUserInfo();

/* Smart sticky nav: header+tabs hide on scroll-down, reappear on scroll-up -- matches
   the pattern in ReceivedSamples.aspx/TestResultsReporting.aspx. */
(function(){
  var navWrap = byId('appNavWrap');
  var lastY = 0, ticking = false;
  window.addEventListener('scroll', function(){
    if (!ticking) {
      requestAnimationFrame(function(){
        var y = window.scrollY;
        if (y > lastY && y > 80) navWrap.classList.add('nav-hidden');
        else navWrap.classList.remove('nav-hidden');
        lastY = y; ticking = false;
      });
      ticking = true;
    }
  });
})();
window.toggleMobileNav=function(){byId('tabsWrap').classList.toggle('nav-open');};

/* Digest token required by SharePoint REST for any write (POST/MERGE/DELETE). Not called by
   anything yet -- demoSave()/demoNew() above are still stubs -- but scaffolded now so the first
   real write (Complaints/DCR) doesn't also have to invent this. */
function getRequestDigest() {
  return fetch(siteUrl + "/_api/contextinfo", {
    method: "POST",
    headers: { "Accept": "application/json;odata=verbose" },
    credentials: "same-origin"
  })
  .then(function(r) { return r.json(); })
  .then(function(j) { return j.d.GetContextWebInformation.FormDigestValue; });
}

function renderDashboard(){
 var reg=SP.items('register');
 var sops=reg.filter(function(n){return /^(QP|EP|LP)/.test(n.id);}).length;
 var procs=SP.items('steps').length;
 var clauses=SP.items('clausemap').length;
 var kpisTop=[
  {v:SP.items('ncw').length,l:'Open NCW',sub:'Nonconformances',c:'red',icon:'icon-warning-outline'},
  {v:SP.items('ca').length,l:'Open CAPAs',sub:'Corrective actions',c:'amber',icon:'icon-refresh-outline'},
  {v:SP.items('complaints').length,l:'Customer Complaints',sub:'Complaints & feedback',c:'',icon:'icon-comment-outline'}
 ];
 var kpisBottom=[
  {v:SP.items('risks').length,l:'Risks & Opportunities',sub:'Action plans',c:'amber',icon:'icon-chart-histogram-outline'},
  {v:SP.items('ofi').length,l:'Improvements',sub:'Improvement ideas',c:'green',icon:'icon-hint-outline'},
  {v:'1',l:'Pending DCRs',sub:'Change requests',c:'amber',icon:'icon-edit-outline'},
  {v:'May 2026',l:'Next Assessment',sub:'Surveillance',c:'',icon:'icon-calendar-outline'}
 ];
 var docStats=[
  {v:sops,l:'Procedures'},
  {v:'86',l:'Forms & Records'},
  {v:(clauses+2)+' / 20',l:'ISO Clause Areas'},
  {v:procs,l:'Process Steps'}
 ];
 function metricCard(k){return '<div class="metric-card '+k.c+'"><div class="metric-top"><svg class="metric-ic" width="30" height="30"><use href="#'+k.icon+'"/></svg><span class="metric-val">'+esc(k.v)+'</span></div><div class="metric-lbl">'+esc(k.l)+'</div><div class="metric-sub">'+esc(k.sub)+'</div></div>';}
 byId('kpiRow').innerHTML=kpisTop.map(metricCard).join('');
 byId('kpiRow2').innerHTML=kpisBottom.map(metricCard).join('');
 byId('docStats').innerHTML=docStats.map(function(d){return '<strong>'+esc(d.v)+'</strong> '+esc(d.l);}).join('<span class="sep">&middot;</span>');
 byId('complianceStmt').textContent='Vertex Analytical Labs has designed and implemented its Quality Management System in full conformance with ISO/IEC 17025:2017. '+sops+' Standard Operating Procedures (across '+procs+' documented process steps) address the general, structural, resource, process, and management-system requirements of the standard, supported by 86 controlled forms and records. One minor finding (Clause 7.7 \u2014 Proficiency Testing frequency) is under corrective action (CAR26001), scheduled for closure before the May 2026 surveillance assessment.';
 var acts=SP.items('activity');
 byId('activityFeed').innerHTML=acts.map(function(a){return '<div class="activity-item"><span class="activity-dot" style="background:'+esc(a.color)+'"></span><div><p>'+a.text+'</p><div class="t">'+esc(a.when)+'</div></div></div>';}).join('');
}
function renderRegister(){
 var reg=SP.items('register');
 byId('regCount').textContent=reg.length+' controlled documents';
 byId('registerBody').innerHTML=reg.map(function(n){
  var st=n.scanned==='Yes'?'<span class="badge b-amber">Scanned</span>':'<span class="badge b-green">Approved</span>';
  return '<tr><td class="id-cell">'+esc(n.id)+'</td><td>'+esc(n.title)+'</td><td>'+esc(n.type)+'</td><td>'+esc(n.rev||'\u2014')+'</td><td>'+(n.steps?('<span class="badge b-blue">'+n.steps+'</span>'):'\u2014')+'</td><td>'+st+'</td></tr>';
 }).join('');
}
function renderSopList(){
 var w=SP.items('register').filter(function(n){return n.steps;});
 byId('sopList').innerHTML=w.map(function(n){return '<div class="list-item" data-sop="'+esc(n.id)+'"><div class="id">'+esc(n.id)+'</div><div class="ti">'+esc(n.title)+'</div></div>';}).join('');
 byId('sopList').querySelectorAll('.list-item').forEach(function(it){it.addEventListener('click',function(){byId('sopList').querySelectorAll('.list-item').forEach(function(x){x.classList.remove('selected');});it.classList.add('selected');showSop(it.dataset.sop);});});
}
function showSop(sid){
 var reg=SP.items('register'),n=reg.find(function(x){return x.id===sid;});
 var steps=SP.items('steps').filter(function(s){return s.sop===sid;});
 var edges=SP.items('edges');
 var rel=edges.filter(function(e){return e.s===sid||e.t===sid;}).map(function(e){return e.s===sid?e.t:e.s;});
 var uniq=rel.filter(function(v,i){return rel.indexOf(v)===i;});
 var html='<div style="display:flex;justify-content:space-between;align-items:flex-start"><div><div class="mono" style="color:#B45309;font-weight:700">'+esc(sid)+' &middot; '+esc(n.rev||'')+'</div><h3 style="font-size:19px;color:var(--blue);margin-top:2px">'+esc(n.title)+'</h3></div><span class="badge b-blue">'+steps.length+' steps</span></div>';
 html+='<div style="margin:16px 0 8px;font-weight:700;color:var(--label)">Process Steps</div>';
 html+=steps.map(function(s){var meta='';if(s.role)meta+='<span class="chip role">'+esc(s.role)+'</span>';if(s.forms)s.forms.split(';').forEach(function(f){if(f.trim())meta+='<span class="chip form">'+esc(f.trim())+'</span>';});return '<div class="step-item"><span class="step-num">Step '+esc(s.num)+'</span><div class="step-title">'+esc(s.title)+'</div>'+(s.sum?'<div class="step-sum">'+esc(s.sum)+'</div>':'')+(meta?'<div class="step-meta">'+meta+'</div>':'')+'</div>';}).join('');
 if(uniq.length)html+='<div style="margin:16px 0 8px;font-weight:700;color:var(--label)">Related documents</div><div class="step-meta">'+uniq.map(function(r){return '<span class="chip">'+esc(r)+'</span>';}).join('')+'</div>';
 html+='<div class="doc-viewer"><svg width="26" height="26" style="color:#94A3B8"><use href="#icon-document-outline"/></svg><div style="margin-top:6px">Document viewer \u2014 the controlled PDF of '+esc(sid)+' renders here (SharePoint file preview in the built page).</div></div>';
 byId('sopDetail').innerHTML=html;
}
function renderClauseMatrix(){
 var cm=SP.items('clausemap');
 var cols=SP.items('clausecols');
 var map={};cm.forEach(function(c){map[c.sop]=c.clause;});
 var h='<thead><tr><th class="rowh">SOP \\ Clause</th>'+cols.map(function(c){return '<th>'+esc(c)+'</th>';}).join('')+'</tr></thead><tbody>';
 cm.forEach(function(c){h+='<tr><td class="rowh">'+esc(c.sop)+'</td>'+cols.map(function(col){return map[c.sop]===col?'<td class="hit">&#10003;</td>':'<td></td>';}).join('')+'</tr>';});
 byId('clauseMatrix').innerHTML=h+'</tbody>';
}
function renderDcr(){
 byId('dcrBody').innerHTML=SP.items('dcr').map(function(r){return '<tr><td class="id-cell">'+esc(r.id)+'</td><td>'+r.title+'</td><td>'+esc(r.type)+'</td><td>'+esc(r.driver)+'</td><td><span class="badge '+esc(r.stc)+'">'+esc(r.stage)+'</span></td><td>'+esc(r.date)+'</td></tr>';}).join('');
}
function renderOps(){
 Object.keys(OPS_META).forEach(function(k){
  var m=OPS_META[k],rows=SP.items(m.list);
  var head=m.h.map(function(x){return '<th>'+(x==='_'?'&nbsp;':esc(x))+'</th>';}).join('');
  var body=rows.map(function(r){
   var mid=(k==='complaints')?('<td>'+r.c2+'</td><td><span class="badge '+esc(r.stc)+'">'+esc(r.st)+'</span></td>'):('<td><span class="badge '+esc(r.stc)+'">'+r.c2+'</span></td><td></td>');
   return '<tr><td class="id-cell">'+esc(r.id)+'</td><td>'+r.c1+'</td>'+mid+'<td>'+esc(r.d)+'</td></tr>';
  }).join('');
  var act=m.modal?("openModal('"+m.modal+"')"):"demoNew()";
  byId('s-'+k).innerHTML='<div class="card"><div class="card-hd"><h3>'+esc(m.title)+' <span class="mono" style="color:var(--muted);font-weight:400">&middot; Clause '+esc(m.clause)+'</span></h3><button class="btn btn-primary btn-sm" onclick="'+act+'"><svg width="14" height="14"><use href=\"#icon-plus-outline\"/></svg> '+esc(m.btn)+'</button></div><div class="card-bd"><table><thead><tr>'+head+'</tr></thead><tbody>'+body+'</tbody></table></div></div>';
 });
}
function renderCompass(){
 var acts=SP.items('activity_tasks');
 byId('actGrid').innerHTML=acts.map(function(a,i){return '<div class="act-card" data-i="'+i+'"><div class="act-ic"><svg width="26" height="26"><use href="#'+esc(a.icon)+'"/></svg></div><div class="act-ti">'+esc(a.ti)+'</div><div class="act-sops">'+a.sops.map(function(s){return '<span class="chip">'+esc(s)+'</span>';}).join('')+'</div></div>';}).join('');
 byId('actGrid').querySelectorAll('.act-card').forEach(function(c){c.addEventListener('click',function(){showGuidance(acts[c.dataset.i]);});});
 var inp=byId('compassSearch'),ac=byId('compassAc'),steps=SP.items('steps'),reg=SP.items('register');
 inp.addEventListener('input',function(){
  var q=inp.value.toLowerCase().trim();if(q.length<2){ac.classList.remove('show');return;}
  var hits=steps.filter(function(s){return (s.title+' '+s.sop).toLowerCase().indexOf(q)>=0;}).slice(0,8);
  if(!hits.length){ac.classList.remove('show');return;}
  ac.innerHTML=hits.map(function(s){return '<div class="ac-item" data-sop="'+esc(s.sop)+'"><strong>'+esc(s.title)+'</strong> <span class="mono" style="color:var(--muted)">'+esc(s.sop)+' '+esc(s.num)+'</span></div>';}).join('');
  ac.classList.add('show');
  ac.querySelectorAll('.ac-item').forEach(function(it){it.addEventListener('click',function(){var n=reg.find(function(x){return x.id===it.dataset.sop;});showGuidance({ti:n.title,sops:[it.dataset.sop]});ac.classList.remove('show');inp.value=n.title;});});
 });
 document.addEventListener('click',function(e){if(!ac.contains(e.target)&&e.target!==inp)ac.classList.remove('show');});
}
function showGuidance(act){
 var sid=act.sops[0],reg=SP.items('register'),n=reg.find(function(x){return x.id===sid;});
 var steps=SP.items('steps').filter(function(s){return s.sop===sid;});
 var html='<div class="card"><div class="card-hd"><h3>'+esc(act.ti)+' <span class="mono" style="color:var(--muted);font-weight:400">&middot; '+esc(sid)+' '+esc(n?n.title:'')+'</span></h3></div><div class="card-bd">';
 if(steps.length){html+=steps.map(function(s){var meta='';if(s.forms)s.forms.split(';').forEach(function(f){if(f.trim())meta+='<span class="chip form">'+esc(f.trim())+'</span>';});return '<div class="step-item"><span class="step-num">Step '+esc(s.num)+'</span><div class="step-title">'+esc(s.title)+'</div>'+(s.sum?'<div class="step-sum">'+esc(s.sum)+'</div>':'')+(meta?'<div class="step-meta">'+meta+'</div>':'')+'</div>';}).join('');}
 else{html+='<p style="color:var(--muted)">Steps for '+esc(sid)+' will appear here once available.</p>';}
 byId('compassResult').innerHTML=html+'</div>';byId('compassResult').scrollIntoView({behavior:'smooth',block:'start'});
}

/* network canvas (built-in renderer; no external library) */
var netSel=null;
function layoutNetwork(w,h){
 var reg=SP.items('register');
 var g={'Quality Manual':[],'Quality Procedure':[],'Equipment Procedure':[],'Laboratory Procedure':[]};
 reg.forEach(function(n){if(g[n.type])g[n.type].push(n);});
 var pos={},cx=w/2,cy=h/2;
 (g['Quality Manual']||[]).forEach(function(n){pos[n.id]={x:cx,y:cy};});
 function ring(list,r,off){var N=list.length;list.forEach(function(n,i){var a=off+(i/N)*Math.PI*2;pos[n.id]={x:cx+r*Math.cos(a),y:cy+r*Math.sin(a)};});}
 ring(g['Quality Procedure'],Math.min(w,h)*0.28,-Math.PI/2);
 ring(g['Equipment Procedure'],Math.min(w,h)*0.44,-Math.PI/2+0.3);
 ring(g['Laboratory Procedure'],Math.min(w,h)*0.44,Math.PI/2);
 return pos;
}
function drawNetwork(){
 var cv=byId('netCanvas');if(!cv.offsetWidth)return;
 var reg=SP.items('register'),edges=SP.items('edges');
 var w=cv.offsetWidth,h=520,dpr=window.devicePixelRatio||1;
 cv.width=w*dpr;cv.height=h*dpr;var ctx=cv.getContext('2d');ctx.setTransform(dpr,0,0,dpr,0,0);ctx.clearRect(0,0,w,h);
 var pos=layoutNetwork(w,h);
 edges.forEach(function(e){var a=pos[e.s],b=pos[e.t];if(!a||!b)return;var on=netSel&&(e.s===netSel||e.t===netSel);ctx.strokeStyle=on?'#E69F00':'rgba(100,116,139,0.16)';ctx.lineWidth=on?2:Math.min(1+e.w*0.3,3);ctx.beginPath();ctx.moveTo(a.x,a.y);ctx.lineTo(b.x,b.y);ctx.stroke();});
 reg.forEach(function(n){var p=pos[n.id];if(!p)return;var isQM=n.type==='Quality Manual';var r=isQM?15:9;var dim=netSel&&netSel!==n.id&&!edges.some(function(e){return (e.s===netSel&&e.t===n.id)||(e.t===netSel&&e.s===n.id);});ctx.globalAlpha=dim?0.25:1;ctx.fillStyle=TYPECOLOR[n.type]||'#64748B';ctx.beginPath();ctx.arc(p.x,p.y,r,0,Math.PI*2);ctx.fill();if(n.id===netSel){ctx.strokeStyle='#E69F00';ctx.lineWidth=3;ctx.stroke();}ctx.globalAlpha=dim?0.4:1;ctx.fillStyle='#0F172A';ctx.font=(isQM?'bold 11px':'10px')+' Segoe UI, sans-serif';ctx.textAlign='center';ctx.fillText(n.id,p.x,p.y+r+11);ctx.globalAlpha=1;});
 cv._pos=pos;
}
function netClick(ev){
 var cv=byId('netCanvas'),rect=cv.getBoundingClientRect();var x=ev.clientX-rect.left,y=ev.clientY-rect.top,pos=cv._pos;if(!pos)return;
 var reg=SP.items('register'),edges=SP.items('edges'),hit=null;
 reg.forEach(function(n){var p=pos[n.id];if(p&&Math.hypot(p.x-x,p.y-y)<14)hit=n.id;});
 netSel=(hit===netSel)?null:hit;drawNetwork();
 if(netSel){var n=reg.find(function(x){return x.id===netSel;});var deg=edges.filter(function(e){return e.s===netSel||e.t===netSel;}).length;byId('netInfo').innerHTML='<strong>'+esc(netSel)+' \u2014 '+esc(n.title)+'</strong>'+deg+' connection(s). Click the node again to clear.';}
 else byId('netInfo').innerHTML='<strong>SOP Relationships Network</strong>Nodes are controlled documents; edges are citations extracted from the SOP text.';
}

document.querySelectorAll('.tab-btn').forEach(function(b){b.addEventListener('click',function(){switchTab(b.dataset.tab);});});
byId('docsNav').querySelectorAll('button').forEach(function(b){b.addEventListener('click',function(){switchSub('docs',b.dataset.sub);});});
byId('opsNav').querySelectorAll('button').forEach(function(b){b.addEventListener('click',function(){switchSub('ops',b.dataset.sub);});});
document.querySelectorAll('.modal-backdrop').forEach(function(m){m.addEventListener('click',function(e){if(e.target===m)m.classList.remove('open');});});
document.addEventListener('keydown',function(e){if(e.key==='Escape')document.querySelectorAll('.modal-backdrop.open').forEach(function(m){m.classList.remove('open');});});
byId('netCanvas').addEventListener('click',netClick);
window.addEventListener('resize',function(){if(byId('s-network').classList.contains('active'))drawNetwork();});

renderDashboard();renderRegister();renderSopList();renderClauseMatrix();renderDcr();renderOps();renderCompass();
})();
</script>
</body>
</html>
