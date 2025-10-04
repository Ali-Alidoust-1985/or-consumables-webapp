<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8"/>
    <title>پیش‌نمایش و ویرایش فرم PM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.rtl.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container my-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">پیش‌نمایش و ویرایش فرم PM</div>
        <div class="card-body">
            <form id="confirmForm"
                  action="${pageContext.request.contextPath}/admin/confirmPMChecklist"
                  method="post"
                  onsubmit="return validateConfirmForm();">
                <input type="hidden" name="pmListId"   value="${pmListId}"/>
                <input type="hidden" name="fileName"   value="${fileName}"/>
                <input type="hidden" name="equipmentName" value="${equipmentName}"/>

                <div class="mb-4">
                    <h5 class="d-inline">فرم:</h5>
                    <span class="badge bg-secondary">${fn:escapeXml(fileName)}</span>
                    &nbsp;&nbsp;
                    <h5 class="d-inline">دستگاه:</h5>
                    <span class="badge bg-secondary">${fn:escapeXml(equipmentName)}</span>
                </div>

                <div id="questionsContainer">
                    <c:forEach var="q" items="${questionList}" varStatus="st">
                        <div class="input-group mb-2 question-item">
                            <span class="input-group-text">${st.index + 1}</span>
                            <input type="hidden" name="questionIds" value="${q.id}"/>
                            <input type="text"
                                   class="form-control"
                                   name="questions"
                                   value="${fn:escapeXml(q.questionText)}"
                                   placeholder="متن سؤال…"/>
                            <button type="button"
                                    class="btn btn-outline-danger btn-remove-question"
                                    title="حذف سؤال">&times;</button>
                        </div>
                    </c:forEach>
                </div>

                <button type="button" id="addQuestionBtn" class="btn btn-outline-success mb-3">
                    + افزودن سؤال
                </button>

                <div class="d-grid">
                    <button type="submit" class="btn btn-success">تأیید و ثبت فرم</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function validateConfirmForm() {
        const inputs = document.querySelectorAll('input[name="questions"]');
        if (!inputs.length) {
            alert('⚠️ حداقل یک سؤال لازم است.');
            return false;
        }
        for (const inp of inputs) {
            if (inp.value.trim().length < 3) {
                alert('⚠️ متن سؤالات باید حداقل ۳ کاراکتر باشد.');
                return false;
            }
        }
        return true;
    }

    function attachRemoveHandlers() {
        document.querySelectorAll('.btn-remove-question').forEach(btn => {
            btn.onclick = () => {
                btn.closest('.question-item').remove();
                updateQuestionNumbers();
            };
        });
    }

    function updateQuestionNumbers() {
        document.querySelectorAll('.question-item').forEach((el, idx) => {
            el.querySelector('.input-group-text').textContent = idx + 1;
        });
    }

    document.getElementById('addQuestionBtn')
        .addEventListener('click', () => {
            const container = document.getElementById('questionsContainer');
            const index = container.querySelectorAll('.question-item').length + 1;
            const div = document.createElement('div');
            div.className = 'input-group mb-2 question-item';
            div.innerHTML = `
        <span class="input-group-text">${index}</span>
        <input type="text" class="form-control"
               name="questions"
               placeholder="سؤال جدید…"/>
        <button type="button"
                class="btn btn-outline-danger btn-remove-question"
                title="حذف سؤال">&times;</button>`;
            container.appendChild(div);
            attachRemoveHandlers();
        });

    attachRemoveHandlers();
</script>
</body>
</html>