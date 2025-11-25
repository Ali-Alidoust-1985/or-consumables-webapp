package com.mftplus.eesample.controller.api.dto;

public class PatientScanResponse {

    private Long patientId;
    private String patientCode;
    private String mrn;
    private String fullName;
    private String ward;

    private Long surgeryCaseId; // id کیس فعال (اگر هست)
    private String caseNo;      // شماره عمل (اختیاری)

    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
    }

    public String getPatientCode() {
        return patientCode;
    }

    public void setPatientCode(String patientCode) {
        this.patientCode = patientCode;
    }

    public String getMrn() {
        return mrn;
    }

    public void setMrn(String mrn) {
        this.mrn = mrn;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public Long getSurgeryCaseId() {
        return surgeryCaseId;
    }

    public void setSurgeryCaseId(Long surgeryCaseId) {
        this.surgeryCaseId = surgeryCaseId;
    }

    public String getCaseNo() {
        return caseNo;
    }

    public void setCaseNo(String caseNo) {
        this.caseNo = caseNo;
    }
}
