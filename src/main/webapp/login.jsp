<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/fonts/icomoon/style.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/css-login/owl.carousel.min.css">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/css-login/bootstrap.min.css">

    <!-- Style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/css-login/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/farsi-fonts.css">

</head>
<body>
<div class="content">
    <div class="container">
        <div class="row justify-content-center">
            <!-- <div class="col-md-6 order-md-2">
              <img src="images/undraw_file_sync_ot38.svg" alt="Image" class="img-fluid">
            </div> -->
            <div class="col-md-6 contents">
                <div class="row justify-content-center">
                    <div class="col-md-12">
                        <div class="form-block">
                            <div class="mb-4">
                                <h3 style="font-family: 'Vazir';font-weight: normal; font-size:large; text-align: center" >  ورود به سامانه </h3>
                                <p style="font-family: 'Vazir';font-weight: normal; font-size:large; text-align: center" class="mb-4">نام کاربری و رمز عبور خود را وارد کنید</p>
                            </div>
                            <form action="j_security_check" method="post">
                                <div class="form-group first">
                                    <label style="font-family: 'Vazir';font-weight: normal; font-size:small" for="username">نام کاربری</label>
                                    <input type="text" class="form-control" id="username" name="j_username">

                                </div>
                                <div class="form-group last mb-4">
                                    <label style="font-family: 'Vazir';font-weight: normal; font-size:small" for="password">رمز عبور</label>
                                    <input type="password" class="form-control" id="password" name="j_password">

                                </div>

                                <div class="d-flex mb-5 align-items-center">
                                    <label style="font-family: 'Vazir';font-weight: normal; font-size:small" class="control control--checkbox mb-0"><span style="font-family: 'Vazir';font-weight: normal; font-size:large" class="caption">مرا به خاطر بسپار</span>
                                        <input type="checkbox" checked="checked"/>
                                        <div class="control__indicator"></div>
                                    </label>
                                    <span style="font-family: 'Vazir';font-weight: normal; font-size:small" class="ml-auto"><a href="#" class="forgot-pass">رمز خود را فراموش کرده اید؟</a></span>
                                </div>

                                <input type="submit" value="login" class="btn btn-pill text-white btn-block btn-primary">

                                <span class="d-block text-center my-4 text-muted"> or sign in with</span>

                                <div class="social-login text-center">
                                    <a href="#" class="facebook">
                                        <span class="icon-facebook mr-3"></span>
                                    </a>
                                    <a href="#" class="twitter">
                                        <span class="icon-twitter mr-3"></span>
                                    </a>
                                    <a href="#" class="google">
                                        <span class="icon-google mr-3"></span>
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </div>
</div>


<script src="${pageContext.request.contextPath}/js/js-login/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/js-login/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/js/js-login/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/js-login/main.js"></script>

<%--<form action="j_security_check" method="post">--%>
<%--    <input type="text" name="j_username">--%>
<%--    <input type="password" name="j_password">--%>
<%--    <input type="submit" value="login">--%>
<%--</form>--%>


</body>
</html>