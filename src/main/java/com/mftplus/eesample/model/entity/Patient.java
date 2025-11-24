package com.mftplus.eesample.model.entity;

import com.mftplus.eesample.model.enums.Gender;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.*;

@Entity @Table(
        name = "PATIENT",
        uniqueConstraints = @UniqueConstraint(name="UK_PATIENT_CODE", columnNames = "PATIENT_CODE"),
        indexes = { @Index(name="IX_PATIENT_CODE", columnList="PATIENT_CODE") }
)
public class Patient {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name="PATIENT_CODE", nullable=false, length=64) // کد مچ‌بند / شناسه‌ی بیمار
    private String patientCode;

    @Column(name="MRN", length=64) // اگر MRN جداست
    private String mrn;

    @Column(name="NATIONAL_ID", length=20)
    private String nationalId;

    @Column(name="FULL_NAME", length=200)
    private String fullName;

    @Enumerated(EnumType.STRING)
    @Column(name="GENDER", length=16)
    private Gender gender;

    private LocalDate birthDate;

    @Column(name="PHONE", length=32)
    private String phone;

    @Column(name="WARD", length=64) // بخش فعلی/محل بستری (اختیاری)
    private String ward;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = false)
    private List<SurgeryCase> cases = new ArrayList<>();

    // getters/setters
}
