package com.mftplus.eesample.model.service;

import com.mftplus.eesample.controller.api.dto.ItemScanResponse;
import com.mftplus.eesample.controller.api.dto.PatientScanResponse;
import com.mftplus.eesample.model.entity.*;
import com.mftplus.eesample.model.enums.CaseStatus;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.List;

@Stateless
public class OrScanService {

    @PersistenceContext(unitName = "mft")
    private EntityManager em;

    // --- استثناءهای اختصاصی برای هندل تمیز در Resource‌ها

    public static class PatientNotFoundException extends RuntimeException {
        public PatientNotFoundException(String msg) { super(msg); }
    }

    public static class CaseNotFoundException extends RuntimeException {
        public CaseNotFoundException(String msg) { super(msg); }
    }

    public static class ItemNotFoundException extends RuntimeException {
        public ItemNotFoundException(String msg) { super(msg); }
    }

    // --- 1) اسکن مچ‌بند بیمار
    public PatientScanResponse handlePatientScan(String code) {

        // 1) پیدا کردن بیمار بر اساس PATIENT_CODE
        TypedQuery<Patient> q = em.createQuery(
                "SELECT p FROM Patient p WHERE p.patientCode = :code",
                Patient.class
        );
        q.setParameter("code", code);
        List<Patient> pts = q.getResultList();

        if (pts.isEmpty()) {
            throw new PatientNotFoundException("بیمار با این مچ‌بند پیدا نشد");
        }

        Patient p = pts.get(0);

        // 2) آخرین کیس بازِ این بیمار (وضعیت SCHEDULED یا IN_PROGRESS)
        TypedQuery<SurgeryCase> qCase = em.createQuery(
                "SELECT c FROM SurgeryCase c " +
                        "WHERE c.patient = :p AND c.status IN (:s1, :s2) " +
                        "ORDER BY c.id DESC",
                SurgeryCase.class
        );
        qCase.setParameter("p", p);
        qCase.setParameter("s1", CaseStatus.SCHEDULED);
        qCase.setParameter("s2", CaseStatus.IN_PROGRESS); // مطمئن شو تو enum‌ات این مقدار هست
        qCase.setMaxResults(1);
        List<SurgeryCase> cases = qCase.getResultList();

        SurgeryCase sc = cases.isEmpty() ? null : cases.get(0);

        // 3) ساخت DTO برای فرانت
        PatientScanResponse dto = new PatientScanResponse();
        dto.setPatientId(p.getId());
        dto.setPatientCode(p.getPatientCode());
        dto.setMrn(p.getMrn());
        dto.setFullName(p.getFullName());
        dto.setWard(p.getWard());
        dto.setGender(p.getGender() != null ? p.getGender().name() : null);


        if (sc != null) {
            dto.setSurgeryCaseId(sc.getId());
            dto.setCaseNo(sc.getCaseNo()); // اگر در DTO‌ات این فیلد را نداری، اضافه‌اش کن
        }

        return dto;
    }

    // --- 2) اسکن کالای مصرفی برای یک کیس مشخص
    public ItemScanResponse handleItemScan(Long caseId, String rawCode) {

        // 1) کیس
        SurgeryCase sc = em.find(SurgeryCase.class, caseId);
        if (sc == null) {
            throw new CaseNotFoundException("caseId نامعتبر است");
        }

        // 2) مصرفی (بر اساس GTIN)
        TypedQuery<Consumable> qCons = em.createQuery(
                "SELECT c FROM Consumable c " +
                        "WHERE c.gtin = :code AND (c.active = TRUE OR c.active IS NULL)",
                Consumable.class
        );
        qCons.setParameter("code", rawCode);
        List<Consumable> consList = qCons.getResultList();
        if (consList.isEmpty()) {
            throw new ItemNotFoundException("مصرفی با این کد پیدا نشد");
        }
        Consumable cons = consList.get(0);

        // 3) آیا قبلاً برای این کیس ثبت شده؟
        TypedQuery<SurgeryConsumableUsage> qUsage = em.createQuery(
                "SELECT u FROM SurgeryConsumableUsage u " +
                        "WHERE u.surgery = :sc AND u.consumable = :cons",
                SurgeryConsumableUsage.class
        );
        qUsage.setParameter("sc", sc);
        qUsage.setParameter("cons", cons);
        List<SurgeryConsumableUsage> usages = qUsage.getResultList();

        SurgeryConsumableUsage usage;
        if (usages.isEmpty()) {
            usage = new SurgeryConsumableUsage();
            usage.setSurgery(sc);
            usage.setConsumable(cons);
            usage.setQuantity(1);
            usage.setUsageTime(LocalDateTime.now());
            em.persist(usage);
        } else {
            usage = usages.get(0);
            usage.setQuantity(usage.getQuantity() + 1);
            usage.setUsageTime(LocalDateTime.now());
        }

        // 4) DTO خروجی
        ItemScanResponse dto = new ItemScanResponse();
        dto.setSurgeryCaseId(sc.getId());
        dto.setItemCode(rawCode);
        dto.setItemName(cons.getName());
        dto.setQty(1); // این اسکن مشخص = یک عدد اضافه شد
        dto.setTotalQtyForItem(usage.getQuantity());

        return dto;
    }

    // --- 3) نهایی کردن کیس (مثلاً وقتی پرستار دکمه "ثبت نهایی" را می‌زند)
    public void finalizeCase(Long caseId) {
        SurgeryCase sc = em.find(SurgeryCase.class, caseId);
        if (sc == null) {
            throw new CaseNotFoundException("Case not found");
        }
        // اینجا وضعیت را ببند – مقدار دقیق را مطابق enum خودت تنظیم کن
        sc.setStatus(CaseStatus.COMPLETED); // اگر COMPLETED نداری، مثلا CLOSED یا DONE بگذار
    }
}
