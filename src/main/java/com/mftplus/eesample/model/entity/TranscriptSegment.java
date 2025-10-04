package com.mftplus.eesample.model.entity;


public class TranscriptSegment {
    private Long id;
    private Long dictationId;
    private boolean isFinal;
    private String text;
    private Double startSec;
    private Double endSec;


    // getters/setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getDictationId() { return dictationId; }
    public void setDictationId(Long dictationId) { this.dictationId = dictationId; }
    public boolean isFinal() { return isFinal; }
    public void setFinal(boolean aFinal) { isFinal = aFinal; }
    public String getText() { return text; }
    public void setText(String text) { this.text = text; }
    public Double getStartSec() { return startSec; }
    public void setStartSec(Double startSec) { this.startSec = startSec; }
    public Double getEndSec() { return endSec; }
    public void setEndSec(Double endSec) { this.endSec = endSec; }
}
