package com.mftplus.eesample.model.entity;

import jakarta.persistence.*;

@Entity @Table(name="STAFF", indexes = @Index(name="IX_STAFF_CODE", columnList="CODE"))
public class Staff {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name="CODE", length=64)
    private String code; // کد پرسنلی

    @Column(name="FULL_NAME", length=200)
    private String fullName;

    @Column(name="ROLE", length=64) // SURGEON, ANESTHESIOLOGIST, NURSE,...
    private String role;

    // getters/setters
}
