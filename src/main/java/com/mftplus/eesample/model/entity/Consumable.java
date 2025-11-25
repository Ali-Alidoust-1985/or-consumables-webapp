package com.mftplus.eesample.model.entity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
        name = "CONSUMABLE",
        indexes = {
                @Index(name = "IDX_CONSUMABLE_GTIN", columnList = "GTIN")
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Consumable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // یا SEQUENCE بسته به Oracle
    @Column(name = "ID")
    private Long id;

    // فیلدی که رویش اندکس می‌خواهیم:
    @Column(name = "GTIN", length = 50, nullable = false, unique = true)
    private String gtin;

    @Column(name = "NAME", length = 200, nullable = false)
    private String name;

    @Column(name = "DESCRIPTION", length = 1000)
    private String description;

    @Column(name = "MANUFACTURER", length = 200)
    private String manufacturer;

    @Column(name = "UOM", length = 50)
    private String unitOfMeasure;

    @Column(name = "ACTIVE", nullable = false)
    private Boolean active;

    // اگر timestamp می‌خواهی:
    @Column(name = "CREATED_AT")
    private java.time.LocalDateTime createdAt;

    @Column(name = "UPDATED_AT")
    private java.time.LocalDateTime updatedAt;
}
