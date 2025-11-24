package com.mftplus.eesample.model.entity;


import com.mftplus.eesample.model.enums.SourceType;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity @Table(
        name="CONSUMABLE",
        indexes = {
                @Index(name="IX_CONS_GTIN", columnList="GTIN"),
                @Index(name="IX_CONS_IRC", columnList="IRC_CODE")
        }
)
public class Consumable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false) @JoinColumn(name = "CASE_ID")
    private SurgeryCase surgeryCase;

    @ManyToOne(optional = false) @JoinColumn(name = "CONSUMABLE_ID")
    private Consumable consumable;

    @Column(name = "QTY")
    private int qty = 1;

    // Snapshots for stable reporting (even if catalog changes later)
    @Column(name = "ITEM_NAME_SNAPSHOT", length = 512)
    private String itemNameSnapshot;

    @Column(name = "IRC_CODE_SNAPSHOT", length = 128)
    private String ircCodeSnapshot;

    @Column(name = "UNIT_PRICE")
    private BigDecimal unitPrice;

    @Column(name = "TOTAL_PRICE")
    private BigDecimal totalPrice;

    @Enumerated(EnumType.STRING)
    @Column(name = "SOURCE", length = 16)
    private SourceType source = SourceType.QRCODE;

    @Column(name = "SCANNED_BY", length = 100)
    private String scannedBy;

    private LocalDateTime scannedAt;

    @Lob @Column(name = "RAW_CODE")
    private String rawCode;

    @PrePersist void pre() {
        if (scannedAt == null) scannedAt = LocalDateTime.now();
        if (unitPrice != null && totalPrice == null) {
            totalPrice = unitPrice.multiply(java.math.BigDecimal.valueOf(qty));
        }
    }

    // --- getters/setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public SurgeryCase getSurgeryCase() { return surgeryCase; }
    public void setSurgeryCase(SurgeryCase surgeryCase) { this.surgeryCase = surgeryCase; }

    public Consumable getConsumable() { return consumable; }
    public void setConsumable(Consumable consumable) { this.consumable = consumable; }

    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }

    public String getItemNameSnapshot() { return itemNameSnapshot; }
    public void setItemNameSnapshot(String itemNameSnapshot) { this.itemNameSnapshot = itemNameSnapshot; }

    public String getIrcCodeSnapshot() { return ircCodeSnapshot; }
    public void setIrcCodeSnapshot(String ircCodeSnapshot) { this.ircCodeSnapshot = ircCodeSnapshot; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public SourceType getSource() { return source; }
    public void setSource(SourceType source) { this.source = source; }

    public String getScannedBy() { return scannedBy; }
    public void setScannedBy(String scannedBy) { this.scannedBy = scannedBy; }

    public LocalDateTime getScannedAt() { return scannedAt; }
    public void setScannedAt(LocalDateTime scannedAt) { this.scannedAt = scannedAt; }

    public String getRawCode() { return rawCode; }
    public void setRawCode(String rawCode) { this.rawCode = rawCode; }
}
