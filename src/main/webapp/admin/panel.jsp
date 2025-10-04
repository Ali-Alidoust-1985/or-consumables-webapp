<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tab" value="${empty param.tab ? 'upload' : param.tab}" />

<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>پنل مدیریت</title>
    <link href="<c:out value='${pageContext.request.contextPath}'/>/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { direction: rtl; text-align: right; }
        .nav-tabs .nav-link { cursor: pointer; }
        /* تب QR */
        #qrcode .form-select {
            height: 44px;
            padding: .5rem .75rem;
            line-height: 1.5;
            font-size: 0.95rem;
            background-image:
                    linear-gradient(45deg, transparent 50%, #6c757d 50%),
                    linear-gradient(135deg, #6c757d 50%, transparent 50%),
                    linear-gradient(to right, #ced4da, #ced4da);
            background-position:
                    left 1.1rem center,
                    left .75rem center,
                    left 2.2rem center;
            background-size: .6rem .6rem, .6rem .6rem, 1px 60%;
            background-repeat: no-repeat;
            appearance: none;
        }
    </style>
</head>
<body>

<div class="container mt-3 text-end">
    <h5>کاربر: <strong>${sessionScope.username}</strong></h5>
</div>

<div class="container mt-4">

    <!-- Tabs -->
    <ul class="nav nav-tabs" id="adminTab" role="tablist">

        <!-- بارگذاری گروهی تجهیزات پزشکی -->
        <c:if test="${pageContext.request.isUserInRole('manager')}">
            <li class="nav-item" role="presentation">
                <button class="nav-link ${tab=='upload' ? 'active' : ''}"
                        id="upload-tab" data-bs-toggle="tab" data-bs-target="#upload"
                        type="button" role="tab">بارگذاری گروهی تجهیزات پزشکی</button>
            </li>
        </c:if>

        <!-- تولید QR تجهیزات -->
        <c:if test="${pageContext.request.isUserInRole('manager')}">
            <li class="nav-item" role="presentation">
                <button class="nav-link ${tab=='qrcode' ? 'active' : ''}"
                        id="qrcode-tab" data-bs-toggle="tab" data-bs-target="#qrcode"
                        type="button" role="tab" aria-controls="qrcode"
                        aria-selected="${tab=='qrcode'}">تولید QR تجهیزات</button>
            </li>
        </c:if>

        <!-- آپلود کدهای UMDNS -->
        <c:if test="${pageContext.request.isUserInRole('manager')}">
            <li class="nav-item" role="presentation">
                <button class="nav-link ${tab=='umdns' ? 'active' : ''}"
                        id="umdns-tab" data-bs-toggle="tab" data-bs-target="#umdns"
                        type="button" role="tab">آپلود کدهای UMDNS</button>
            </li>
        </c:if>

        <!-- مدیریت کاربر -->
        <c:if test="${pageContext.request.isUserInRole('admin') or pageContext.request.isUserInRole('manager')}">
            <li class="nav-item" role="presentation">
                <button class="nav-link ${tab=='user' ? 'active' : ''}"
                        id="user-tab" data-bs-toggle="tab" data-bs-target="#user"
                        type="button" role="tab">تعریف کاربر جدید</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link ${tab=='list' ? 'active' : ''}"
                        id="list-tab" data-bs-toggle="tab" data-bs-target="#list"
                        type="button" role="tab">لیست کاربران</button>
            </li>
        </c:if>

        <!-- آپلود فرم PM -->
        <c:if test="${pageContext.request.isUserInRole('manager')}">
            <li class="nav-item" role="presentation">
                <button class="nav-link ${tab=='checklist' ? 'active' : ''}"
                        id="checklist-tab" data-bs-toggle="tab" data-bs-target="#checklist"
                        type="button" role="tab">آپلود فرم بازدید دوره‌ای</button>
            </li>
        </c:if>
    </ul>

    <div class="tab-content p-4 border rounded-bottom" id="adminTabContent">

        <!-- تب: بارگذاری گروهی تجهیزات پزشکی -->
        <div class="tab-pane fade ${tab=='upload' ? 'show active' : ''}"
             id="upload" role="tabpanel" aria-labelledby="upload-tab">

            <form action="${pageContext.request.contextPath}/uploadExcel"
                  method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label class="form-label">انتخاب فایل:</label>
                    <input type="file" name="file" class="form-control" accept=".xls,.xlsx" required>
                </div>
                <button type="submit" class="btn btn-primary">بارگذاری</button>
            </form>

            <c:if test="${not empty message1}">
                <div class="alert alert-success mt-3">${message1}</div>
            </c:if>
        </div>

        <!-- تب: تولید QR تجهیزات -->
        <div class="tab-pane fade ${tab=='qrcode' ? 'show active' : ''}"
             id="qrcode" role="tabpanel" aria-labelledby="qrcode-tab">

            <div class="alert alert-secondary">
                برای تولید PDF برچسب‌های QR، ابتدا دانشگاه را انتخاب کنید، سپس بیمارستان و در نهایت بخش.
                اگر یکی از فیلدها را خالی بگذارید، آن سطح شامل «همه» خواهد شد.
            </div>

            <form id="qrForm" action="${pageContext.request.contextPath}/admin/generateQRCodes"
                  method="post" class="row g-3">

                <div class="col-md-4">
                    <label class="form-label">دانشگاه</label>
                    <select id="qrUniversity" name="university"  accept-charset="UTF-8" class="form-select" disabled>
                        <option value="">— همه دانشگاه‌ها —</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label">بیمارستان</label>
                    <select id="qrHospital" name="hospital" class="form-select" disabled>
                        <option value="">— همه بیمارستان‌ها —</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label">بخش / مکان</label>
                    <select id="qrLocation" name="location" class="form-select" disabled>
                        <option value="">— همه بخش‌ها —</option>
                    </select>
                </div>

                <div class="col-12 d-flex justify-content-between align-items-center">
                    <div id="qrOrgSpinner" class="d-none">
                        <div class="spinner-border spinner-border-sm" role="status"></div>
                        <span class="ms-2">در حال بارگذاری ساختار…</span>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" id="qrRefresh" class="btn btn-outline-secondary">نوسازی فهرست‌ها</button>
                        <button type="submit" class="btn btn-primary">تولید و دانلود PDF</button>
                    </div>
                </div>
            </form>

            <hr/>
            <div class="small text-muted">
                نکته: خالی گذاشتن هر فیلد یعنی «همه» در همان سطح. مثلاً فقط دانشگاه را انتخاب کنید تا برای تمام بیمارستان‌ها و بخش‌های آن تولید شود.
            </div>
        </div>

        <!-- تب: آپلود کدهای UMDNS -->
        <div class="tab-pane fade ${tab=='umdns' ? 'show active' : ''}"
             id="umdns" role="tabpanel" aria-labelledby="umdns-tab">

            <div class="alert alert-info small">
                فایل اکسل اداره‌کل تجهیزات پزشکی را بارگذاری کنید. ستون‌های قابل‌تشخیص (فارسی/انگلیسی):
                <code>UMDNS_CODE</code>، <code>EN_NAME</code>، <code>FA_NAME</code>، <code>CATEGORY/LEVELS</code>،
                <code>SYNONYMS</code>، <code>STATUS</code>.
            </div>

            <c:if test="${not empty param.msg}">
                <div class="alert ${param.ok=='1' ? 'alert-success' : 'alert-danger'}">
                        ${fn:escapeXml(param.msg)}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/umdns/upload"
                  method="post" enctype="multipart/form-data" class="mb-3">
                <div class="mb-3">
                    <label class="form-label">انتخاب فایل اکسل (xls/xlsx):</label>
                    <input type="file" name="file" class="form-control" accept=".xls,.xlsx" required>
                </div>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" value="1" id="mergeMode" name="mergeMode" checked>
                    <label class="form-check-label" for="mergeMode">
                        ادغام/به‌روزرسانی بر اساس کُد (رکوردهای موجود بروزرسانی می‌شوند)
                    </label>
                </div>

                <button type="submit" class="btn btn-primary">آپلود و پردازش</button>
            </form>

            <c:if test="${tab == 'umdns'}">
                <div class="alert ${param.ok == '1' ? 'alert-success' : 'alert-danger'} mt-3">
                        ${fn:escapeXml(param.msg)}
                </div>
            </c:if>
        </div>

        <!-- تب: تعریف کاربر -->
        <div class="tab-pane fade ${tab=='user' ? 'show active' : ''}"
             id="user" role="tabpanel" aria-labelledby="user-tab">

            <c:if test="${not empty message2}">
                <div class="alert <c:out value='${fn:startsWith(message2, "خطا") ? "alert-danger" : "alert-success"}'/>">
                        ${message2}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/createOrUpdateUser" method="post">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">نام کاربری:</label>
                        <input type="text" name="username" class="form-control" required
                               value="${editUser != null ? editUser.username : ''}"
                        ${editUser != null ? 'readonly' : ''}/>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">رمز عبور:</label>
                        <input type="password" name="password" class="form-control"
                        ${editUser == null ? 'required' : ''}/>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label">نقش‌ها:</label>
                        <select name="roles" class="form-select" multiple required>
                            <c:forEach var="r" items="${allRoles}">
                                <option value="${r.roleName}"
                                        <c:if test="${editUser != null && editUser.roleList.contains(r)}">selected</c:if>>
                                        ${r.roleName}
                                </option>
                            </c:forEach>
                        </select>
                        <small class="form-text text-muted">برای انتخاب چند نقش، کلید Ctrl را نگه دارید.</small>
                    </div>
                </div>

                <button type="submit" class="btn btn-success mt-3">
                    ${editUser != null ? 'ویرایش کاربر' : 'ایجاد کاربر'}
                </button>
            </form>
        </div>

        <!-- تب: لیست کاربران -->
        <div class="tab-pane fade ${tab=='list' ? 'show active' : ''}"
             id="list" role="tabpanel" aria-labelledby="list-tab">

            <input type="text" class="form-control mb-3" placeholder="جستجوی نام کاربری…">

            <table class="table table-striped table-responsive">
                <thead>
                <tr>
                    <th>#</th>
                    <th>نام کاربری</th>
                    <th>نقش‌ها</th>
                    <th>عملیات</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}" varStatus="st">
                    <tr>
                        <td>${st.index + 1}</td>
                        <td>${u.username}</td>
                        <td>
                            <c:forEach var="r" items="${u.roleList}" varStatus="rs">
                                ${r.roleName}<c:if test="${!rs.last}">، </c:if>
                            </c:forEach>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/editUser"
                                  method="get" style="display:inline;">
                                <input type="hidden" name="username" value="${u.username}"/>
                                <button class="btn btn-sm btn-warning">ویرایش</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/deleteUser"
                                  method="post" style="display:inline;">
                                <input type="hidden" name="username" value="${u.username}"/>
                                <button class="btn btn-sm btn-danger"
                                        onclick="return confirm('آیا مطمئن هستید؟');">حذف</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- تب: آپلود فرم بازدید دوره‌ای -->
        <div class="tab-pane fade ${tab=='checklist' ? 'show active' : ''}"
             id="checklist" role="tabpanel" aria-labelledby="checklist-tab">

            <c:if test="${not empty pmLists}">
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>نام فرم</th>
                        <th>دستگاه</th>
                        <th>عملیات</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="PM" items="${pmLists}" varStatus="st">
                        <tr>
                            <td>${st.index + 1}</td>
                            <td>${fn:escapeXml(PM.formName)}</td>
                            <td>${fn:escapeXml(PM.equipmentName)}</td>
                            <td>
                                <a class="btn btn-sm btn-secondary"
                                   href="${pageContext.request.contextPath}/admin/previewPMChecklist?pmListId=${PM.id}">
                                    پیش‌نمایش/ویرایش
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty pmLists}">
                <div class="alert alert-info">هنوز هیچ فرمی آپلود نشده.</div>
            </c:if>

            <hr/>

            <form action="${pageContext.request.contextPath}/admin/previewPMChecklist"
                  method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label class="form-label">فایل فرم PM:</label>
                    <input type="file" name="checklistFile" class="form-control"
                           accept=".pdf,.docx,.xlsx" required/>
                    <input type="hidden" name="pmListId" value="${pmListId}"/>
                </div>
                <button type="submit" class="btn btn-primary">آپلود و پیش‌نمایش فرم جدید</button>
            </form>

            <div id="checklistUploadAlert" class="alert d-none mt-3" role="alert"></div>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show mt-3 mx-auto w-100 text-center"
                     role="alert" style="max-width: 600px;">
                        ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
        </div>

        <button class="btn btn-sm btn-danger mt-3" onclick="logout()">خروج</button>
    </div>
</div>

<script>
    function logout() {
        fetch("<c:out value='${pageContext.request.contextPath}'/>/logout");
        window.location.replace("<c:out value='${pageContext.request.contextPath}'/>/index.jsp");
    }
    function showChecklistAlert(message, type) {
        const alertBox = document.getElementById("checklistUploadAlert");
        alertBox.className = "alert alert-" + type;
        alertBox.innerHTML = message;
        alertBox.classList.remove("d-none");
    }
</script>
<script>
    (function(){
        const ctx   = "<c:out value='${pageContext.request.contextPath}'/>";
        const orgUrl = ctx + "/orgStructure";

        const $uni  = document.getElementById('qrUniversity');
        const $hosp = document.getElementById('qrHospital');
        const $loc  = document.getElementById('qrLocation');
        const $spin = document.getElementById('qrOrgSpinner');
        const $btnRefresh = document.getElementById('qrRefresh');

        if (!$uni || !$hosp || !$loc) return; // اگر تب وجود نداشت

        const ORG = { unis: [], hospByUni: Object.create(null), locByUniHosp: Object.create(null) };

        function setLoading(on){ $spin && (on ? $spin.classList.remove('d-none') : $spin.classList.add('d-none')); }

        function buildIndexes(tree){
            ORG.unis = [];
            ORG.hospByUni = Object.create(null);
            ORG.locByUniHosp = Object.create(null);

            (tree || []).forEach(u=>{
                if (!u || !u.text) return;
                const uni = u.text;
                ORG.unis.push(uni);
                if (!ORG.hospByUni[uni]) ORG.hospByUni[uni] = [];
                (u.children || []).forEach(h=>{
                    if (!h || !h.text) return;
                    const hosp = h.text;
                    if (!ORG.hospByUni[uni].includes(hosp)) ORG.hospByUni[uni].push(hosp);
                    const key = uni + '||' + hosp;
                    if (!ORG.locByUniHosp[key]) ORG.locByUniHosp[key] = [];
                    (h.children || []).forEach(d=>{
                        if (d && d.text && !ORG.locByUniHosp[key].includes(d.text)){
                            ORG.locByUniHosp[key].push(d.text);
                        }
                    });
                });
            });

            ORG.unis = Array.from(new Set(ORG.unis));
            Object.keys(ORG.hospByUni).forEach(k => ORG.hospByUni[k] = Array.from(new Set(ORG.hospByUni[k])));
            Object.keys(ORG.locByUniHosp).forEach(k => ORG.locByUniHosp[k] = Array.from(new Set(ORG.locByUniHosp[k])));
        }

        // ابزارک ساخت گزینه‌ها بدون innerHTML
        function resetSelect(sel, placeholder, disabled){
            sel.replaceChildren(); // پاک‌سازی امن
            const opt = document.createElement('option');
            opt.value = '';
            opt.textContent = placeholder;
            sel.appendChild(opt);
            sel.disabled = !!disabled;
        }
        function addOptions(sel, arr){
            arr.forEach(v=>{
                const o = document.createElement('option');
                o.value = v;
                o.textContent = v; // امن؛ خود مرورگر escape می‌کند
                sel.appendChild(o);
            });
        }

        function fillUni(){
            resetSelect($uni, '— همه دانشگاه‌ها —', false);
            addOptions($uni, ORG.unis);
            // وابسته‌ها را ریست کن
            fillHosp(null);
        }
        function fillHosp(selectedUni){
            resetSelect($hosp, '— همه بیمارستان‌ها —', selectedUni == null);
            if (selectedUni){
                addOptions($hosp, ORG.hospByUni[selectedUni] || []);
            }
            fillLoc(selectedUni, null);
        }
        function fillLoc(selectedUni, selectedHosp){
            const key = (selectedUni && selectedHosp) ? (selectedUni + '||' + selectedHosp) : null;
            resetSelect($loc, '— همه بخش‌ها —', !(selectedUni && selectedHosp));
            if (key){
                addOptions($loc, ORG.locByUniHosp[key] || []);
            }
        }

        function loadOrg(){
            setLoading(true);
            fetch(orgUrl, {cache:'no-store'})
                .then(r => {
                    if (!r.ok) throw new Error('HTTP ' + r.status);
                    return r.json();
                })
                .then(tree => { buildIndexes(tree); fillUni(); })
                .catch(err => { console.error('orgStructure error:', err); })
                .finally(() => setLoading(false));
        }

        $uni.addEventListener('change', function(){ fillHosp(this.value || null); });
        $hosp.addEventListener('change', function(){ fillLoc($uni.value || null, this.value || null); });

        $btnRefresh && $btnRefresh.addEventListener('click', function(){
            resetSelect($uni,  '— همه دانشگاه‌ها —', true);
            resetSelect($hosp, '— همه بیمارستان‌ها —', true);
            resetSelect($loc,  '— همه بخش‌ها —', true);
            loadOrg();
        });
        // شروع
        loadOrg();
    })();
</script>



<script src="<c:out value='${pageContext.request.contextPath}'/>/js/bootstrap.bundle.min.js"></script>
</body>
</html>