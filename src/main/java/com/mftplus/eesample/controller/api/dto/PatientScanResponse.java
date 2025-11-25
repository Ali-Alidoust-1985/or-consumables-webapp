package com.mftplus.eesample.controller.api.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

public class PatientScanResponse {

    private Long patientId;
    private String patientCode;
    private String mrn;
    private String fullName;
    private String ward;
    private String gender;
    private String birthDatePersian; // یا age به انتخاب خودت

    private Long surgeryCaseId; // id کیس فعال (اگر هست)
    private String caseNo;      // شماره عمل (اختیاری)
    public PatientScanResponse() {
    }
    // اگر دوست داری می‌توانی یک all-args هم اضافه کنی ولی public:
    public PatientScanResponse(Long patientId, String patientCode, String fullName,
                               String ward, String gender, String birthDatePersian,
                               Long surgeryCaseId, String caseNo) {
        this.patientId = patientId;
        this.patientCode = patientCode;
        this.fullName = fullName;
        this.ward = ward;
        this.gender = gender;
        this.birthDatePersian = birthDatePersian;
        this.surgeryCaseId = surgeryCaseId;
        this.caseNo = caseNo;
    }

    // --- getters & setters ---

}
