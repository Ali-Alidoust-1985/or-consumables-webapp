package com.mftplus.eesample.model.service;



import com.mftplus.eesample.model.entity.Dictation;
import com.mftplus.eesample.model.entity.TranscriptSegment;


import java.time.OffsetDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;


public class DictationService {
    private static final DictationService INSTANCE = new DictationService();
    public static DictationService get() { return INSTANCE; }


    private final AtomicLong idGen = new AtomicLong(1000);
    private final AtomicLong segIdGen = new AtomicLong(1);
    private final Map<Long, Dictation> dictations = new ConcurrentHashMap<>();
    private final Map<Long, List<TranscriptSegment>> segments = new ConcurrentHashMap<>();


    public Dictation start(String username, String dept, String lang, String modelHint) {
        Dictation d = new Dictation();
        d.setId(idGen.incrementAndGet());
        d.setCreatedBy(username != null ? username : "demo");
        d.setDepartmentCode(dept);
        d.setLanguage(lang != null ? lang : "fa");
        d.setModelHint(modelHint);
        d.setStatus(Dictation.Status.STARTED);
        d.setStartedAt(OffsetDateTime.now());
        dictations.put(d.getId(), d);
        segments.put(d.getId(), Collections.synchronizedList(new ArrayList<>()));
        return d;
    }


    public void addSegment(Long dictId, String text, boolean isFinal, Double s, Double e) {
        Dictation d = dictations.get(dictId);
        if (d == null) throw new IllegalArgumentException("Dictation not found");
        TranscriptSegment seg = new TranscriptSegment();
        seg.setId(segIdGen.getAndIncrement());
        seg.setDictationId(dictId);
        seg.setText(text);
        seg.setFinal(isFinal);
        seg.setStartSec(s);
        seg.setEndSec(e);
        segments.get(dictId).add(seg);
        System.out.println("SEGMENT ADDED dict=" + segIdGen + " final=" + isFinal + " text=" + text);
        if (d.getStatus() == Dictation.Status.STARTED) d.setStatus(Dictation.Status.STREAMING);
    }


    public Dictation finalizeText(Long dictId, String finalText) {
        Dictation d = dictations.get(dictId);
        if (d == null) throw new IllegalArgumentException("Dictation not found");
        d.setFinalText(finalText);
        d.setStatus(Dictation.Status.FINALIZED);
        d.setEndedAt(OffsetDateTime.now());
        return d;
    }


    public List<TranscriptSegment> segments(Long dictId) {
        return new ArrayList<>(segments.getOrDefault(dictId, List.of()));
    }
}
