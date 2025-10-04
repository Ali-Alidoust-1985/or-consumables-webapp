<%--
  Created by IntelliJ IDEA.
  User: Asus
  Date: 7/9/2025
  Time: 11:32 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<meta name="viewport" content=" width=device-width, initial-scale=1, shrink-to-fit=no">
<html lang="fa" dir="auto">
<head>
    <title>درباره اپلیکیشن</title>
<style>
    @font-face {
        font-family: 'Vazir';
        src: url('../fonts/farsi-fonts/vazir-font-v18.0.0/Vazir.woff2') format('woff2'),
        url('../fonts/farsi-fonts/vazir-font-v18.0.0/Vazir.ttf') format('truetype');
        font-weight: normal;
        font-style: normal;
    }
    body {
        background-color: #e8f0f7;
        font-family: 'Vazir', sans-serif;
    }
    .center-all{
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
    }
</style>


</head>
<body>
<!-- لوگو -->
<div class="center-all img-fluid">
    <div class="d-flex justify-content-between align-items-center">
    <img src="../images/Firoozgar-Logo.gif" style="max-width: 100px;" class="img-fluid" alt="Hospital Logo">
        <img src="../images/YPJ-Logo.jpg" style="max-width: 100px;" class="img-fluid" alt="Company Logo">
        <!-- اگر بخوای وسطش متن یا محتوایی باشه می‌تونی اینجا بذاری -->
    <div class="mx-3"> </div>
    </div>
</div>


<div class="container my-5 center-all">
    <h2 class="text-center mb-4">درباره اپلیکیشن</h2>

    <div class="card p-4 shadow-sm">
        <p class="lead">
            این اپلیکیشن با هدف بهبود خدمات درمانی طراحی شده و امکاناتی نظیر مدیریت فرآیندهای تجهیزات پزشکی، ثبت PM تجهیزات از روی اسکن QRcode، مشاهده اطلاعات دستگاه ها، و مدیریت فرم‌ها و گزارش گیری هوشمند را در اختیار کاربران قرار میدهد.
        </p>

        <hr>

        <ul class="list-unstyled">
            <li><strong>نسخه فعلی:</strong> 1.0.3</li>
            <li><strong>آخرین بروزرسانی:</strong> تیر ۱۴۰۴</li>
            <li><strong>توسعه‌دهنده:</strong> واحد تجهیزات پزشکی بیمارستان فیروزگر با همکاری شرکت دانش بنیان یکتا پیشگام جاوید</li>
        </ul>

        <div class="text-center mt-4">
            <button class="btn btn-outline-info mx-2">راهنمای استفاده از اپلیکیشن</button>
            <button class="btn btn-outline-info mx-2">تماس با ما</button>
        </div>
    </div>
</div>
<li><a class="center-all" style="font-family: 'Vazir' , sans-serif; font-weight: normal; font-size: 1rem" href="${pageContext.request.contextPath}/index.jsp">بازگشت به صفحه اصلی</a></li>


</body>
</html>
