package com.mftplus.eesample.model.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "SURGERY_CONSUMABLE_USAGE",
        indexes = {
                @Index(name = "IDX_USAGE_SURGERY", columnList = "SURGERY_ID"),
                @Index(name = "IDX_USAGE_CONSUMABLE", columnList = "CONSUMABLE_ID")
        })
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SurgeryConsumableUsage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "SURGERY_ID", nullable = false)
    private SurgeryCase surgery;  // موجودیت عمل یا Procedure

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "CONSUMABLE_ID", nullable = false)
    private Consumable consumable;

    @Column(name = "QUANTITY", nullable = false)
    private Integer quantity;

    @Column(name = "USAGE_TIME")
    private java.time.LocalDateTime usageTime;
}

