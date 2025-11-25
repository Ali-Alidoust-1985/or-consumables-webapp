package com.mftplus.eesample.model.service;

import com.mftplus.eesample.model.entity.Patient;
import com.mftplus.eesample.model.enums.Gender;
import com.mftplus.eesample.model.service.dto.PatientImportResult;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.apache.poi.ss.usermodel.*;

import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Stateless
public class PatientImportService {

    @PersistenceContext(unitName = "mft")
    private EntityManager em;

    public PatientImportResult importFromExcel(InputStream in) throws Exception {
        PatientImportResult result = new PatientImportResult();

        Workbook wb = WorkbookFactory.create(in);
        Sheet sheet = wb.getSheetAt(0);

        // فرض: ردیف اول Header است
        int firstRow = sheet.getFirstRowNum() + 1;
        int lastRow  = sheet.getLastRowNum();

        for (int r = firstRow; r <= lastRow; r++) {
            Row row = sheet.getRow(r);
            if (row == null) continue;

            result.setTotalRows(result.getTotalRows() + 1);

            String patientCode = getString(row, 0);   // ستون 0: patientCode
            String fullName    = getString(row, 1);   // ستون 1: fullName
            String genderStr   = getString(row, 2);   // ستون 2: gender
            String birthDateStr= getString(row, 3);   // ستون 3: birthDate (اختیاری)
            String ward        = getString(row, 4);   // ستون 4: ward (اختیاری)

            if (patientCode == null || patientCode.isBlank()) {
                result.addMessage("ردیف " + (r+1) + ": patientCode خالی است - ردیف رد شد.");
                continue;
            }

            Patient p = findByCode(patientCode);
            boolean isNew = (p == null);
            if (isNew) {
                p = new Patient();
                p.setPatientCode(patientCode);
            }

            if (fullName != null && !fullName.isBlank())
                p.setFullName(fullName);

            if (genderStr != null && !genderStr.isBlank()) {
                p.setGender(parseGender(genderStr));
            }

            if (birthDateStr != null && !birthDateStr.isBlank()) {
                // مثال: 1400/01/20 یا 2021-04-09
                try {
                    LocalDate d;
                    if (birthDateStr.contains("/")) {
                        // اینجا بسته به فرمت واقعی بعداً اصلاح می‌کنیم؛ فعلاً ساده
                        DateTimeFormatter f = DateTimeFormatter.ofPattern("yyyy/MM/dd");
                        d = LocalDate.parse(birthDateStr, f);
                    } else {
                        d = LocalDate.parse(birthDateStr); // فرمت ISO
                    }
                    p.setBirthDate(d);
                } catch (Exception ex) {
                    result.addMessage("ردیف " + (r+1) + ": تاریخ تولد قابل تبدیل نیست (" + birthDateStr + ")");
                }
            }

            if (ward != null && !ward.isBlank())
                p.setWard(ward);

            if (isNew) {
                em.persist(p);
                result.setInserted(result.getInserted() + 1);
            } else {
                result.setUpdated(result.getUpdated() + 1);
            }
        }

        return result;
    }

    private Patient findByCode(String code) {
        TypedQuery<Patient> q = em.createQuery(
                "SELECT p FROM Patient p WHERE p.patientCode = :code",
                Patient.class
        );
        q.setParameter("code", code);
        return q.getResultStream().findFirst().orElse(null);
    }

    private String getString(Row row, int idx) {
        Cell c = row.getCell(idx);
        if (c == null) return null;
        c.setCellType(CellType.STRING);
        String v = c.getStringCellValue();
        return (v != null) ? v.trim() : null;
    }

    private Gender parseGender(String g) {
        g = g.trim().toLowerCase(Locale.ROOT);
        if (g.startsWith("m") || g.startsWith("ذ") || g.contains("مرد")) {
            return Gender.MALE;
        }
        if (g.startsWith("f") || g.contains("زن")) {
            return Gender.FEMALE;
        }
        return null; // اجازه می‌دهیم خالی بماند
    }
}

