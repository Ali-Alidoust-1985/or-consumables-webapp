package com.mftplus.eesample.model.entity;

import jakarta.persistence.*;
import java.time.*;

@Entity
@Table(
        name="CASE_REPORT",
        indexes = @Index(name="IX_REPORT_CASE", columnList="CASE_ID")
)
public class CaseReport {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional=false) @JoinColumn(name="CASE_ID")
    private SurgeryCase surgeryCase;

    @Column(name="IS_LATEST")
    private boolean latest = true;

    private LocalDateTime generatedAt;

    @Lob @Column(name="JSON_SNAPSHOT") // خروجی JSON (همان چیزی که برای HIS می‌فرستی)
    private String jsonSnapshot;

    @Column(name="HIS_PUSH_STATUS", length=32) // PENDING, SENT, FAILED
    private String hisPushStatus = "PENDING";

    private LocalDateTime hisPushAt;

    @Lob @Column(name="HIS_RESPONSE")
    private String hisResponse;

    @PrePersist void pre() {
        if (generatedAt == null) generatedAt = LocalDateTime.now();
    }

    // getters/setters
}
