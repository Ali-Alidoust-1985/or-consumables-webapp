package com.mftplus.eesample.controller.servlet;

import com.mftplus.eesample.model.service.PatientImportService;
import com.mftplus.eesample.model.service.dto.PatientImportResult;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;

@WebServlet("/admin/patients/import")
@MultipartConfig
public class PatientImportServlet extends HttpServlet {

    @EJB
    private PatientImportService patientImportService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            req.setAttribute("patientImportError", "فایل انتخاب نشده است");
            req.getRequestDispatcher("/admin/panel.jsp#patients").forward(req, resp);
            return;
        }

        try (InputStream in = filePart.getInputStream()) {
            PatientImportResult result = patientImportService.importFromExcel(in);
            req.setAttribute("patientImportResult", result);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("patientImportError", "خطا در خواندن فایل بیماران: " + e.getMessage());
        }

        req.getRequestDispatcher("/admin/panel.jsp#patients").forward(req, resp);
    }
}
