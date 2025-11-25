package com.mftplus.eesample.model.service.dto;

import java.util.ArrayList;
import java.util.List;

public class PatientImportResult {
    private int totalRows;
    private int inserted;
    private int updated;
    private List<String> messages = new ArrayList<>();

    public int getTotalRows() { return totalRows; }
    public void setTotalRows(int totalRows) { this.totalRows = totalRows; }

    public int getInserted() { return inserted; }
    public void setInserted(int inserted) { this.inserted = inserted; }

    public int getUpdated() { return updated; }
    public void setUpdated(int updated) { this.updated = updated; }

    public List<String> getMessages() { return messages; }
    public void addMessage(String msg) { this.messages.add(msg); }
}
