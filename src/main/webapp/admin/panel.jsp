
<!doctype html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>پنل ادمین - OR Consumables</title>
    <style>
        body { font-family: sans-serif; margin: 16px; }
        .tabs { display: flex; gap: 8px; margin-bottom: 12px; flex-wrap: wrap; }
        .tab { padding: 8px 12px; border-radius: 8px; background: #eee; cursor: pointer; }
        .tab.active { background: #4285f4; color: #fff; }
        .panel { border: 1px solid #ddd; border-radius: 12px; padding: 16px; }
        .row { margin: 8px 0; }
        .msg { padding: 10px; border-radius: 8px; margin: 10px 0; }
        .msg.ok { background: #e6f4ea; border: 1px solid #81c995; }
        .msg.err { background: #fde7e9; border: 1px solid #f28b82; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 6px; }
        th { background: #f8f8f8; }
        input[type=text], select { padding: 6px; border-radius: 6px; border: 1px solid #ccc; min-width: 240px; }
        input[type=file] { padding: 4px; }
        button { padding: 8px 12px; border: 0; border-radius: 8px; background: #4285f4; color: #fff; cursor: pointer; }
        button.secondary { background: #666; }
    </style>
    <script>
        function showTab(id){
            document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active'));
            document.querySelectorAll('.panel').forEach(p=>p.style.display='none');
            document.getElementById('tab-'+id).classList.add('active');
            document.getElementById('panel-'+id).style.display='block';
            history.replaceState(null,'','#'+id);
        }
        window.addEventListener('DOMContentLoaded', ()=>{
            const hash = location.hash?.substring(1) || 'import';
            showTab(hash);
        });
    </script>
</head>
<body>

<h2>پنل ادمین – ثبت و مدیریت کاتالوگ اقلام</h2>

<c:if test="${not empty ok}">
    <div class="msg ok">${ok}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="msg err">${error}</div>
</c:if>

<div class="tabs">
    <div class="tab" id="tab-import" onclick="showTab('import')">ایمپورت کاتالوگ (Excel)</div>
    <div class="tab" id="tab-search" onclick="showTab('search')">جستجوی کالا</div>
    <div class="tab" id="tab-rooms" onclick="showTab('rooms')">اتاق‌های عمل</div>
    <div class="tab" id="tab-staff" onclick="showTab('staff')">پرسنل</div>
    <div class="tab" id="tab-settings" onclick="showTab('settings')">تنظیمات</div>
</div>

<!-- Tab: Import -->
<div class="panel" id="panel-import" style="display:none">
    <form method="post" action="<c:url value='/admin/catalog/import'/>" enctype="multipart/form-data">
        <div class="row">
            <label>فایل Excel:</label>
            <input type="file" name="file" accept=".xlsx,.xls" required />
        </div>
        <div class="row">
            <label>نام شیت (اختیاری):</label>
            <input type="text" name="sheet" placeholder="مثلاً Sheet1" />
        </div>
        <div class="row">
            <button type="submit">آپلود و ایمپورت</button>
        </div>
    </form>

    <c:if test="${not empty importResult}">
        <h3>نتیجهٔ ایمپورت</h3>
        <table>
            <tr><th>کل سطرها</th><td>${importResult.totalRows}</td></tr>
            <tr><th>جدید</th><td>${importResult.inserted}</td></tr>
            <tr><th>به‌روزرسانی</th><td>${importResult.updated}</td></tr>
        </table>
        <c:if test="${not empty importResult.messages}">
            <h4>پیام‌ها</h4>
            <ul>
                <c:forEach var="m" items="${importResult.messages}">
                    <li><pre style="white-space: pre-wrap">${m}</pre></li>
                </c:forEach>
            </ul>
        </c:if>
    </c:if>
</div>

<!-- Tab: Search -->
<div class="panel" id="panel-search" style="display:none">
    <form method="get" action="<c:url value='/admin/catalog/search'/>">
        <div class="row">
            <input type="text" name="q" placeholder="جستجو بر اساس IRC/نام..." />
            <button type="submit" class="secondary">جستجو</button>
        </div>
    </form>

    <!-- این بخش را می‌توانی با یک Servlet ساده پر کنی که نتایج را در request قرار دهد -->
    <c:if test="${not empty results}">
        <table>
            <thead><tr><th>IRC</th><th>نام</th><th>قیمت</th></tr></thead>
            <tbody>
            <c:forEach var="it" items="${results}">
                <tr>
                    <td>${it.ircCode}</td>
                    <td>${it.itemName}</td>
                    <td>${it.itemPrice}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

<!-- Tab: OR Rooms -->
<div class="panel" id="panel-rooms" style="display:none">
    <p>مدیریت اتاق‌های عمل (CRUD ساده):</p>
    <ul>
        <li>افزودن/ویرایش/حذف OperatingRoom (کد، نام، موقعیت)</li>
        <li>اتصال OR به SurgeryCase‌های برنامه‌ریزی‌شده</li>
    </ul>
    <!-- بعداً فرم‌ها و جدول فهرست را اضافه می‌کنیم -->
</div>

<!-- Tab: Staff -->
<div class="panel" id="panel-staff" style="display:none">
    <p>مدیریت پرسنل (جراح، بیهوشی، پرستار):</p>
    <ul>
        <li>افزودن/ویرایش/حذف Staff (کد پرسنلی، نام، نقش)</li>
        <li>انتساب به پروندهٔ عمل (SurgeryCase)</li>
    </ul>
</div>

<!-- Tab: Settings -->
<div class="panel" id="panel-settings" style="display:none">
    <p>تنظیمات ایمپورت/برنامه:</p>
    <ul>
        <li>نام پیش‌فرض Sheet برای ایمپورت</li>
        <li>الگوهای تشخیص ستون‌های IRC/نام/قیمت (override)</li>
        <li>تعیین فرمت تاریخ/ارقام</li>
    </ul>
</div>

</body>
</html>
