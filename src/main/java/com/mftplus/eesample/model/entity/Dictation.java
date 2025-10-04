package com.mftplus.eesample.model.entity;

import java.time.OffsetDateTime;


public class Dictation {
    public enum Status { STARTED, STREAMING, REVIEW, FINALIZED, CANCELED }


    private Long id;
    private String createdBy;
    private String departmentCode;
    private String language;
    private String modelHint;
    private Status status;
    private OffsetDateTime startedAt;
    private OffsetDateTime endedAt;
    private String finalText;


    // getters/setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public String getDepartmentCode() { return departmentCode; }
    public void setDepartmentCode(String departmentCode) { this.departmentCode = departmentCode; }
    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }
    public String getModelHint() { return modelHint; }
    public void setModelHint(String modelHint) { this.modelHint = modelHint; }
    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }
    public OffsetDateTime getStartedAt() { return startedAt; }
    public void setStartedAt(OffsetDateTime startedAt) { this.startedAt = startedAt; }
    public OffsetDateTime getEndedAt() { return endedAt; }
    public void setEndedAt(OffsetDateTime endedAt) { this.endedAt = endedAt; }
    public String getFinalText() { return finalText; }
    public void setFinalText(String finalText) { this.finalText = finalText; }
}