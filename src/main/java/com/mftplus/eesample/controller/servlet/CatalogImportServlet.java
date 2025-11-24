package com.mftplus.eesample.controller.servlet;

import com.mftplus.eesample.model.service.IrcCatalogImportService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;

@WebServlet(urlPatterns = "/admin/catalog/import")
@MultipartConfig
public class CatalogImportServlet extends HttpServlet {

    @Inject
    private IrcCatalogImportService importService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Part file = req.getPart("file");
        String sheet = req.getParameter("sheet");
        if (file == null || file.getSize() == 0) {
            req.setAttribute("error", "فایل انتخاب نشده است.");
            req.getRequestDispatcher("/WEB-INF/jsp/admin.jsp").forward(req, resp);
            return;
        }
        try (InputStream in = file.getInputStream()) {
            var result = importService.importXlsx(in, sheet);
            req.setAttribute("importResult", result);
            req.setAttribute("ok", "ایمپورت انجام شد.");
        } catch (Exception e) {
            req.setAttribute("error", "خطا در ایمپورت: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/jsp/admin.jsp").forward(req, resp);
    }
}

