package com.mftplus.eesample.model.entity;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity @Table(
        name="OPERATING_ROOM",
        uniqueConstraints = @UniqueConstraint(name="UK_OR_CODE", columnNames = "CODE")
)
public class OperatingRoom {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name="CODE", nullable=false, length=32)
    private String code; // مثلا OR-01

    @Column(name="NAME", length=100)
    private String name;

    @Column(name="LOCATION", length=200)
    private String location;

    // getters/setters
}
