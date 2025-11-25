<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>پنل ادمین - OR Consumables</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        :root{
            --primary:#2563eb;
            --primary-light:#eff6ff;
            --bg:#f3f4f6;
            --border:#e5e7eb;
            --danger:#ef4444;
        }

        *{box-sizing:border-box;}

        body{
            margin:0;
            padding:16px;
            font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
            background:var(--bg);
        }

        .layout{
            max-width:1100px;
            margin:0 auto;
        }

        h1{
            font-size:1.4rem;
            margin:0 0 12px;
        }

        .tabs{
            display:flex;
            flex-wrap:wrap;
            gap:8px;
            margin-bottom:12px;
        }
        .tab{
            padding:8px 14px;
            border-radius:999px;
            background:#e5e7eb;
            font-size:.9rem;
            cursor:pointer;
        }
        .tab.active{
            background:var(--primary);
            color:#fff;
        }

        .card{
            background:#fff;
            border-radius:16px;
            padding:16px;
            margin-bottom:16px;
            box-shadow:0 4px 10px rgba(15,23,42,.08);
        }

        .panel{display:none;}
        .panel.active{display:block;}

        .row{
            display:flex;
            flex-wrap:wrap;
            gap:8px;
            margin:8px 0;
            align-items:center;
        }
        label{
            min-width:110px;
            font-size:.9rem;
        }
        input[type=text],input[type=number],select{
            padding:6px 10px;
            border-radius:8px;
            border:1px solid var(--border);
            font-size:.9rem;
            min-width:220px;
        }
        input[type=file]{
            font-size:.85rem;
        }

        button{
            border:0;
            border-radius:999px;
            padding:8px 14px;
            font-size:.9rem;
            cursor:pointer;
        }
        .btn-primary{
            background:var(--primary);
            color:#fff;
        }
        .btn-secondary{
            background:#6b7280;
            color:#fff;
        }
        .btn-danger{
            background:var(--danger);
            color:#fff;
        }

        .msg{
            padding:10px 12px;
            border-radius:12px;
            margin-bottom:12px;
            font-size:.9rem;
        }
        .msg.ok{
            background:#e6f4ea;
            border:1px solid #81c995;
        }
        .msg.err{
            background:#fee2e2;
            border:1px solid #fca5a5;
        }

        table{
            width:100%;
            border-collapse:collapse;
            font-size:.85rem;
            margin-top:8px;
        }
        th,td{
            border-bottom:1px solid var(--border);
            padding:6px 8px;
            text-align:center;
        }
        th{background:#f9fafb;}

        .muted{color:#6b7280;font-size:.8rem;}
        .danger-text{color:var(--danger);}

        @media (max-width:640px){
            body{padding:8px;}
            .row{flex-direction:column; align-items:flex-start;}
            label{min-width:0;}
        }
    </style>

    <script>
        function showTab(id){
            document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active'));
            document.querySelectorAll('.panel').forEach(p=>p.classList.remove('active'));

            document.getElementById('tab-'+id).classList.add('active');
            document.getElementById('panel-'+id).classList.add('active');
            history.replaceState(null,'','#'+id);
        }

        window.addEventListener('DOMContentLoaded', ()=>{
            const hash = (location.hash || '#import').substring(1);
            showTab(hash);
        });
    </script>
</head>
<body>
<div class="layout">
    <h1>پنل ادمین – کاتالوگ اقلام مصرفی OR</h1>

    <c:if test="${not empty ok}">
        <div class="msg ok">${ok}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="msg err">${error}</div>
    </c:if>

    <div class="tabs">
        <div class="tab" id="tab-import"   onclick="showTab('import')">ایمپورت کاتالوگ (Excel)</div>
        <div class="tab" id="tab-search"   onclick="showTab('search')">جستجو و ویرایش کالا</div>
        <div class="tab" id="tab-rooms"    onclick="showTab('rooms')">اتاق‌های عمل</div>
        <div class="tab" id="tab-staff"    onclick="showTab('staff')">پرسنل</div>
        <div class="tab" id="tab-settings" onclick="showTab('settings')">تنظیمات</div>
    </div>

    <!-- IMPORT -->
    <div class="card panel" id="panel-import">
        <h2>ایمپورت کاتالوگ از Excel</h2>
        <p class="muted">فایل نمونه شامل ستون‌های IRC، نام کالا، GTIN، قیمت و واحد را می‌توانی در همین صفحه برای کاربرها لینک بدهی.</p>

        <form method="post"
              action="<c:url value='/admin/catalog/import'/>"
              enctype="multipart/form-data">
            <div class="row">
                <label>فایل Excel:</label>
                <input type="file" name="file" accept=".xlsx,.xls" required>
            </div>
            <div class="row">
                <label>نام Sheet:</label>
                <input type="text" name="sheet" placeholder="مثلاً Sheet1">
            </div>
            <div class="row">
                <label>حالت ایمپورت:</label>
                <select name="mode">
                    <option value="UPSERT">به‌روزرسانی / افزودن (پیشنهادی)</option>
                    <option value="INSERT_ONLY">فقط افزودن رکوردهای جدید</option>
                    <option value="DRY_RUN">فقط تست، بدون ذخیره در DB</option>
                </select>
            </div>
            <div class="row">
                <button type="submit" class="btn-primary">آپلود و اجرای ایمپورت</button>
                <a href="<c:url value='/admin/catalog/template'/>"
                   class="btn-secondary"
                   style="text-decoration:none;display:inline-block;margin-right:4px;">
                    دانلود فایل نمونه
                </a>
            </div>
        </form>

        <c:if test="${not empty importResult}">
            <h3>نتیجهٔ آخرین ایمپورت</h3>
            <table>
                <tr><th>کل سطرها</th><td>${importResult.totalRows}</td></tr>
                <tr><th>افزوده‌شده</th><td>${importResult.inserted}</td></tr>
                <tr><th>به‌روزرسانی‌شده</th><td>${importResult.updated}</td></tr>
                <tr><th>خطا</th><td class="danger-text">${importResult.failed}</td></tr>
            </table>

            <c:if test="${not empty importResult.messages}">
                <h4>جزئیات / هشدارها</h4>
                <ul class="muted">
                    <c:forEach var="m" items="${importResult.messages}">
                        <li><pre style="white-space:pre-wrap;margin:0;">${m}</pre></li>
                    </c:forEach>
                </ul>
            </c:if>
        </c:if>
    </div>

    <!-- SEARCH -->
    <div class="card panel" id="panel-search">
        <h2>جستجو و ویرایش کالاها</h2>
        <form method="get" action="<c:url value='/admin/catalog/search'/>">
            <div class="row">
                <input type="text" name="q" placeholder="IRC، GTIN یا نام کالا..." value="${param.q}">
                <button type="submit" class="btn-secondary">جستجو</button>
            </div>
        </form>

        <c:if test="${not empty results}">
            <table>
                <thead>
                <tr>
                    <th>IRC</th>
                    <th>GTIN</th>
                    <th>نام کالا</th>
                    <th>قیمت</th>
                    <th>وضعیت</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="it" items="${results}">
                    <tr>
                        <td>${it.ircCode}</td>
                        <td>${it.gtin}</td>
                        <td>${it.itemName}</td>
                        <td>${it.itemPrice}</td>
                        <td>${it.status}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${empty results && not empty param.q}">
            <p class="muted">هیچ موردی برای «${param.q}» یافت نشد.</p>
        </c:if>
    </div>

    <!-- ROOMS -->
    <div class="card panel" id="panel-rooms">
        <h2>مدیریت اتاق‌های عمل</h2>
        <p class="muted">CRUD ساده برای OperatingRoom – فعلاً اسکلت HTML؛ backend را مطابق Entity خودت پر کن.</p>

        <form method="post" action="<c:url value='/admin/rooms/save'/>">
            <div class="row">
                <label>کد OR:</label>
                <input type="text" name="code" required>
            </div>
            <div class="row">
                <label>نام:</label>
                <input type="text" name="name" required>
            </div>
            <div class="row">
                <label>بخش:</label>
                <input type="text" name="department">
            </div>
            <div class="row">
                <button type="submit" class="btn-primary">ذخیره</button>
            </div>
        </form>

        <!-- لیست فعلی OR ها -->
        <c:if test="${not empty rooms}">
            <table>
                <thead><tr><th>کد</th><th>نام</th><th>بخش</th></tr></thead>
                <tbody>
                <c:forEach var="r" items="${rooms}">
                    <tr>
                        <td>${r.code}</td>
                        <td>${r.name}</td>
                        <td>${r.department}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <!-- STAFF -->
    <div class="card panel" id="panel-staff">
        <h2>مدیریت پرسنل</h2>
        <p class="muted">ثبت جراح، بیهوشی و پرستار برای اتصال به پرونده‌های عمل.</p>

        <form method="post" action="<c:url value='/admin/staff/save'/>">
            <div class="row">
                <label>کد پرسنلی:</label>
                <input type="text" name="code" required>
            </div>
            <div class="row">
                <label>نام و نام خانوادگی:</label>
                <input type="text" name="fullName" required>
            </div>
            <div class="row">
                <label>نقش:</label>
                <select name="role">
                    <option value="SURGEON">جراح</option>
                    <option value="ANESTHESIA">بیهوشی</option>
                    <option value="NURSE">پرستار</option>
                </select>
            </div>
            <div class="row">
                <button type="submit" class="btn-primary">ذخیره</button>
            </div>
        </form>

        <c:if test="${not empty staff}">
            <table>
                <thead><tr><th>کد</th><th>نام</th><th>نقش</th></tr></thead>
                <tbody>
                <c:forEach var="s" items="${staff}">
                    <tr>
                        <td>${s.code}</td>
                        <td>${s.fullName}</td>
                        <td>${s.role}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <!-- SETTINGS -->
    <div class="card panel" id="panel-settings">
        <h2>تنظیمات سیستم</h2>
        <p class="muted">این مقادیر را می‌توانی در جدول تنظیمات (Config) نگه‌داری کنی.</p>

        <form method="post" action="<c:url value='/admin/settings/save'/>">
            <div class="row">
                <label>Sheet پیش‌فرض ایمپورت:</label>
                <input type="text" name="defaultSheet" value="${settings.defaultSheet}">
            </div>
            <div class="row">
                <label>شماره ستون IRC:</label>
                <input type="number" min="1" name="ircCol" value="${settings.ircCol}">
            </div>
            <div class="row">
                <label>شماره ستون نام کالا:</label>
                <input type="number" min="1" name="nameCol" value="${settings.nameCol}">
            </div>
            <div class="row">
                <label>شماره ستون GTIN:</label>
                <input type="number" min="1" name="gtinCol" value="${settings.gtinCol}">
            </div>
            <div class="row">
                <label>فرمت اعداد/اعشار:</label>
                <input type="text" name="numberFormat" value="${settings.numberFormat}">
            </div>
            <div class="row">
                <button type="submit" class="btn-primary">ذخیره تنظیمات</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
