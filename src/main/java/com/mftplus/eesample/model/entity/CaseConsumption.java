package com.mftplus.eesample.model.entity;

import com.mftplus.eesample.model.enums.SourceType;
import jakarta.persistence.*;
import java.time.*;

@Entity
@Table(
        name="CASE_CONSUMPTION",
        indexes = {
                @Index(name="IX_CC_CASE", columnList="CASE_ID"),
                @Index(name="IX_CC_CONS", columnList="CONSUMABLE_ID")
        }
)
public class CaseConsumption {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional=false) @JoinColumn(name="CASE_ID")
    private SurgeryCase surgeryCase;

    @ManyToOne(optional=false) @JoinColumn(name="CONSUMABLE_ID")
    private Consumable consumable;

    @Column(name="QTY")
    private int qty = 1;

    @Enumerated(EnumType.STRING)
    @Column(name="SOURCE", length=16)
    private SourceType source = SourceType.QRCODE;

    @Column(name="SCANNED_BY", length=100)
    private String scannedBy;

    private LocalDateTime scannedAt;

    @Lob @Column(name="RAW_CODE")
    private String rawCode; // متن خام بارکد/QR

    @PrePersist void pre() {
        if (scannedAt == null) scannedAt = LocalDateTime.now();
    }

    // getters/setters
}

