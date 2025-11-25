<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="utf-8">
    <title>ثبت اقلام اتاق عمل</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        :root {
            --primary: #1976d2;
            --primary-soft: #e3f2fd;
            --danger: #d32f2f;
            --bg: #f5f7fb;
            --radius-lg: 18px;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 16px;
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: var(--bg);
            color: #222;
        }

        .page {
            max-width: 1200px;
            margin: 0 auto;
        }

        header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 16px;
        }

        header h1 {
            font-size: 1.4rem;
            margin: 0;
        }

        header small {
            color: #666;
        }

        .layout {
            display: flex;
            flex-wrap: wrap-reverse;
            gap: 20px;
        }

        .card {
            background: #fff;
            border-radius: var(--radius-lg);
            box-shadow: 0 6px 18px rgba(0,0,0,0.06);
            padding: 16px 18px;
        }

        .card-main {
            flex: 1 1 360px;
        }

        .card-help {
            flex: 0 0 300px;
        }

        .step-header {
            display: flex;
            gap: 8px;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }

        .step-chip {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: .85rem;
            background: #eee;
            color: #555;
        }

        .step-chip.active {
            background: var(--primary);
            color: #fff;
        }

        .step-chip span.num {
            background: rgba(0,0,0,.08);
            border-radius: 999px;
            width: 20px;
            height: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: .8rem;
        }

        .step-chip.active span.num {
            background: rgba(255,255,255,.2);
        }

        .section-title {
            font-size: 1rem;
            margin: 10px 0 6px;
        }

        .pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            border-radius: 999px;
            background: #eee;
            font-size: .9rem;
            margin-bottom: 8px;
        }

        .pill.ok {
            background: var(--primary-soft);
            color: #0d47a1;
        }

        .pill-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #aaa;
        }

        .pill.ok .pill-dot {
            background: var(--primary);
        }

        video {
            width: 100%;
            max-width: 520px;
            border-radius: 16px;
            background: #000;
        }

        .camera-wrapper {
            position: relative;
        }

        .scan-overlay {
            position: absolute;
            inset: 12%;
            border-radius: 16px;
            border: 2px dashed rgba(255,255,255,.7);
            pointer-events: none;
        }

        .controls {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin: 10px 0 4px;
        }

        button {
            border: 0;
            border-radius: 999px;
            padding: 8px 14px;
            font-size: .9rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        button.primary {
            background: var(--primary);
            color: #fff;
        }

        button.ghost {
            background: #fff;
            border: 1px solid #ddd;
            color: #333;
        }

        button.danger {
            background: var(--danger);
            color: #fff;
        }

        button:disabled {
            opacity: .55;
            cursor: not-allowed;
        }

        .items {
            margin-top: 10px;
            max-height: 220px;
            overflow-y: auto;
            border-radius: 12px;
            border: 1px solid #eee;
            background: #fafafa;
        }

        .items table {
            width: 100%;
            border-collapse: collapse;
            font-size: .85rem;
        }

        .items th, .items td {
            padding: 6px 8px;
            border-bottom: 1px solid #eee;
        }

        .items th {
            background: #f4f4f4;
            position: sticky;
            top: 0;
        }

        .items tfoot td {
            font-weight: bold;
            background: #f4f4f4;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 20px;
            padding: 2px 6px;
            border-radius: 999px;
            background: #eee;
            font-size: .75rem;
        }

        .log {
            margin-top: 8px;
            font-size: .8rem;
            max-height: 80px;
            overflow-y: auto;
            direction: ltr;
            background: #fff;
            border-radius: 10px;
            border: 1px dashed #ddd;
            padding: 6px 8px;
        }

        .log div {
            margin-bottom: 2px;
        }

        /* help panel */

        .help-title {
            font-size: 1rem;
            margin-top: 0;
            margin-bottom: 10px;
        }

        .step-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .step-list li {
            display: flex;
            gap: 10px;
            margin-bottom: 12px;
            align-items: flex-start;
        }

        .step-icon {
            width: 30px;
            height: 30px;
            border-radius: 999px;
            background: var(--primary-soft);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }

        .step-text strong {
            display: block;
            margin-bottom: 2px;
        }

        .hint-box {
            margin-top: 12px;
            font-size: .85rem;
            background: #fff7e6;
            border-radius: 10px;
            padding: 8px 10px;
            border: 1px solid #ffe0b2;
        }

        @media (max-width: 768px) {
            body { padding: 10px; }
            header { flex-direction: column; align-items: flex-start; }
            .card-help { flex: 1 1 100%; }
        }
    </style>
</head>
<body>
<div class="page">

    <header>
        <div>
            <h1>ثبت خودکار اقلام مصرفی اتاق عمل</h1>
            <small>مرحله‌به‌مرحله: اسکن مچ‌بند ⟵ اسکن اقلام ⟵ تأیید نهایی</small>
        </div>
        <div class="badge" id="sessionInfo">سشن فعال نیست</div>
    </header>

    <div class="layout">
        <!-- MAIN CARD (camera + items) -->
        <section class="card card-main">
            <div class="step-header">
                <div id="chipStep1" class="step-chip active">
                    <span class="num">۱</span> اسکن مچ‌بند بیمار
                </div>
                <div id="chipStep2" class="step-chip">
                    <span class="num">۲</span> اسکن اقلام مصرفی
                </div>
                <div id="chipStep3" class="step-chip">
                    <span class="num">۳</span> مرور و نهایی‌سازی
                </div>
            </div>

            <div class="section-title">وضعیت بیمار</div>
            <div id="patientPill" class="pill">
                <div class="pill-dot"></div>
                بیمار انتخاب نشده
            </div>

            <div class="camera-wrapper" style="margin-top:8px;">
                <video id="cam" autoplay playsinline muted></video>
                <div class="scan-overlay"></div>
            </div>

            <div class="controls">
                <button id="btnPatient" class="primary">
                    🎫 اسکن مچ‌بند بیمار
                </button>
                <button id="btnItem" class="ghost" disabled>
                    📦 اسکن کالای مصرفی
                </button>
                <button id="btnFinalize" class="danger" disabled>
                    ✅ ثبت نهایی اقلام این عمل
                </button>

                <button id="btnClear" class="ghost">
                    🧹 شروع دوباره
                </button>
            </div>

            <div class="items" id="itemsBox" style="display:none;">
                <table>
                    <thead>
                    <tr>
                        <th style="width:40px;">#</th>
                        <th>کد/بارکد</th>
                        <th>نام کالا</th>
                        <th style="width:60px;">تعداد</th>
                    </tr>
                    </thead>
                    <tbody id="itemsBody"></tbody>
                    <tfoot>
                    <tr>
                        <td colspan="3">تعداد اقلام ثبت‌شده</td>
                        <td id="itemsCount">0</td>
                    </tr>
                    </tfoot>
                </table>
            </div>

            <div class="log" id="logBox"></div>
        </section>

        <!-- HELP / STEP-BY-STEP CARD -->
        <aside class="card card-help">
            <h3 class="help-title">راهنمای سریع کاربر</h3>
            <ol class="step-list">
                <li>
                    <div class="step-icon">👤</div>
                    <div class="step-text">
                        <strong>گام ۱ – اسکن مچ‌بند بیمار</strong>
                        <span>گوشی / دوربین را نزدیک مچ‌بند بیمار بگیرید تا بارکد یا QR روی مچ‌بند خوانده شود. بعد از موفقیت، نام بیمار و شماره کیس بالای صفحه نمایش داده می‌شود.</span>
                    </div>
                </li>
                <li>
                    <div class="step-icon">📦</div>
                    <div class="step-text">
                        <strong>گام ۲ – اسکن اقلام مصرفی</strong>
                        <span>روی دکمه «اسکن کالای مصرفی» بزنید و بارکد تمام اقلام مورد استفاده (استپلر، مش، کیت‌ها و …) را یکی‌یکی روبه‌روی دوربین قرار دهید. هر بارکد در لیست جدول پایین اضافه می‌شود.</span>
                    </div>
                </li>
                <li>
                    <div class="step-icon">✅</div>
                    <div class="step-text">
                        <strong>گام ۳ – مرور و ثبت نهایی</strong>
                        <span>در پایان عمل، لیست اقلام را مرور کنید. اگر درست بود، روی «ثبت نهایی اقلام این عمل» بزنید تا اطلاعات به HIS / سیستم مالی ارسال شود.</span>
                    </div>
                </li>
            </ol>

            <div class="hint-box">
                نکات ایمنی:<br>
                • اگر بارکدی اشتباه خوانده شد، می‌توان آن را بعداً در پنل ادمین اصلاح کرد.<br>
                • در صورت قطع اینترنت یا مشکل سرور، می‌توانیم در نسخه‌های بعدی قابلیت ذخیرهٔ محلی را اضافه کنیم.
            </div>
        </aside>
    </div>
</div>

<!-- ZXing (گوگل) – پشتیبان بارکد و QR -->
<script src="https://unpkg.com/@zxing/browser@latest"></script>

<script>
// base path بر اساس contextPath برنامه (جایگزین <c:url> که داخل js اذیت می‌کرد)
    const CONTEXT_PATH = '${pageContext.request.contextPath}';
    const API_BASE = CONTEXT_PATH + '/api/scans';

    const video = document.getElementById('cam');
    const logBox = document.getElementById('logBox');

    const patientPill = document.getElementById('patientPill');
    const sessionInfo = document.getElementById('sessionInfo');

    const btnPatient  = document.getElementById('btnPatient');
    const btnItem     = document.getElementById('btnItem');
    const btnFinalize = document.getElementById('btnFinalize');
    const btnClear    = document.getElementById('btnClear');

    const chip1 = document.getElementById('chipStep1');
    const chip2 = document.getElementById('chipStep2');
    const chip3 = document.getElementById('chipStep3');

    const itemsBox  = document.getElementById('itemsBox');
    const itemsBody = document.getElementById('itemsBody');
    const itemsCount= document.getElementById('itemsCount');

    let mode = 'patient';       // 'patient' | 'item'
    let codeReader = null;      // ZXing reader
    let controls = null;        // برای stop کردن
    let lastDecoded = '';
    let lastScanTime = 0;

    const state = {
    patient: null,          // پاسخ PatientScanResponse
    items: []              // {code, name, qty}
    };

    function log(msg) {
    const time = new Date().toLocaleTimeString('fa-IR', {hour12:false});
    logBox.insertAdjacentHTML('afterbegin', `<div>[${time}] ${msg}</div>`);
    }

    function setStep(step) {
    chip1.classList.remove('active');
    chip2.classList.remove('active');
    chip3.classList.remove('active');
    if (step === 1) chip1.classList.add('active');
    else if (step === 2) chip2.classList.add('active');
    else chip3.classList.add('active');
    }

    async function startScanner() {
    if (controls) return; // قبلاً فعال شده
    try {
    if (!codeReader) {
    codeReader = new ZXing.BrowserMultiFormatReader();
    }
    // انتخاب اولین دوربین (معمولاً پشت گوشی)
    const devices = await ZXing.BrowserCodeReader.listVideoInputDevices();
    const deviceId = devices.length ? devices[0].deviceId : null;

    controls = await codeReader.decodeFromVideoDevice(deviceId, video, (result, err, _controls) => {
    if (result) {
    const txt = (result.text || (result.getText ? result.getText() : '') || '').trim();
    if (txt) {
    handleDecoded(txt);
    }
    }
    // errorهای «NotFound» را لازم نیست لاگ کنیم، یعنی فقط هنوز چیزی پیدا نشده
    });
    log('📷 اسکنر فعال شد.');
    } catch (e) {
    log('❌ دسترسی به دوربین یا راه‌اندازی ZXing ممکن نیست: ' + e.message);
    }
    }

    function stopScanner() {
    if (controls && typeof controls.stop === 'function') {
    controls.stop();
    }
    controls = null;
    if (codeReader) {
    codeReader.reset();
    }
    }

    async function postJSON(url, data) {
    const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: data ? JSON.stringify(data) : '{}'
    });
    if (!res.ok) {
    const txt = await res.text();
    throw new Error(txt || ('HTTP ' + res.status));
    }
    return res.json();
    }

    function upsertItem(payload) {
    // فرض: backend در ItemScanResponse حداقل code و name و qty را برمی‌گرداند
    const code = payload.code || (payload.consumable && payload.consumable.gtin) || '—';
    const name = payload.name || (payload.consumable && payload.consumable.name) || '—';

    let item = state.items.find(i => i.code === code);
    if (!item) {
    item = {code, name, qty: 0};
    state.items.push(item);
    }
    item.qty += (payload.qty || 1);
    renderItems();
    }

    function renderItems() {
    if (!state.items.length) {
    itemsBox.style.display = 'none';
    itemsBody.innerHTML = '';
    itemsCount.textContent = '0';
    btnFinalize.disabled = true;
    setStep(state.patient ? 2 : 1);
    return;
    }
    itemsBox.style.display = 'block';
    itemsBody.innerHTML = '';
    state.items.forEach((it, idx) => {
    itemsBody.insertAdjacentHTML('beforeend', `
    <tr>
    <td>${idx + 1}</td>
    <td>${it.code}</td>
    <td>${it.name}</td>
    <td>${it.qty}</td>
    </tr>
    `);
    });
    itemsCount.textContent = state.items.length.toString();
    btnFinalize.disabled = !(state.patient && state.items.length);
    setStep(state.patient && state.items.length ? 3 : 2);
    }

    function clearAll() {
    state.patient = null;
    state.items = [];
    renderItems();
    patientPill.classList.remove('ok');
    patientPill.innerHTML =
    '<div class="pill-dot"></div> بیمار انتخاب نشده';
    sessionInfo.textContent = 'سشن فعال نیست';
    btnItem.disabled = true;
    btnFinalize.disabled = true;
    setStep(1);
    lastDecoded = '';
    lastScanTime = 0;
    log('🔄 سشن جدید آغاز شد.');
    }

    async function handleDecoded(code) {
    const now = Date.now();
    if (code === lastDecoded && now - lastScanTime < 1500) return; // debouncing
    lastDecoded = code;
    lastScanTime = now;

    if (mode === 'patient') {
    log('در حال اعتبارسنجی مچ‌بند/کد بیمار: ' + code);
    try {
    const p = await postJSON(API_BASE + '/patient', { code: code });
    state.patient = p;

    patientPill.classList.add('ok');
    const caseText = p.caseNo ? ` | کیس: ${p.caseNo}` :
    (p.surgeryCaseId ? ` | CaseId: ${p.surgeryCaseId}` : '');
    patientPill.innerHTML =
    `<div class="pill-dot"></div> بیمار: ${p.fullName || '—'}${caseText}`;

    sessionInfo.textContent = 'سشن فعال برای بیمار';
    btnItem.disabled = false;
    setStep(2);
    log('✅ مچ‌بند بیمار تأیید شد.');
    } catch (e) {
    log('❌ خطا در ثبت مچ‌بند: ' + e.message);
    }
    } else if (mode === 'item') {
    if (!state.patient) {
    log('⚠️ ابتدا مچ‌بند بیمار را اسکن کنید.');
    setStep(1);
    return;
    }
    log('در حال ثبت کالای مصرفی: ' + code);
    try {
    const x = await postJSON(API_BASE + '/item', { code: code });
    upsertItem(x);
    const nm = x.name || (x.consumable && x.consumable.name) || code;
    log('📦 کالا ثبت شد: ' + nm);
    } catch (e) {
    log('❌ خطا در ثبت کالا: ' + e.message);
    }
    }
    }

    // event handlers
    btnPatient.onclick = () => {
    mode = 'patient';
    setStep(1);
    btnPatient.classList.add('primary');
    btnItem.classList.remove('primary');
    startScanner();
    log('🎫 حالت اسکن مچ‌بند فعال شد.');
    };

    btnItem.onclick = () => {
    if (!state.patient) {
    log('⚠️ ابتدا مچ‌بند بیمار را اسکن کنید.');
    return;
    }
    mode = 'item';
    setStep(state.items.length ? 3 : 2);
    btnItem.classList.add('primary');
    btnPatient.classList.remove('primary');
    startScanner();
    log('📦 حالت اسکن اقلام فعال شد.');
    };

    btnFinalize.onclick = async () => {
    if (!state.patient || !state.items.length) return;
    btnFinalize.disabled = true;
    log('⏳ در حال ارسال لیست اقلام به سرور...');
    try {
    // backend از سشن ACTIVE_SURGERY_CASE_ID استفاده می‌کند
    await postJSON(API_BASE + '/finalize', {});
    log('✅ ثبت نهایی با موفقیت انجام شد.');
    alert('ثبت نهایی اقلام این عمل انجام شد.');
    clearAll();
    } catch (e) {
    log('❌ خطا در نهایی‌سازی: ' + e.message);
    btnFinalize.disabled = false;
    }
    };

    btnClear.onclick = () => {
    clearAll();
    };

    window.addEventListener('beforeunload', () => {
    stopScanner();
    });

    // init
    clearAll();
    </script>
    </body>
    </html>
