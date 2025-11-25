package com.mftplus.eesample.model.entity;

import com.mftplus.eesample.model.enums.AnesthesiaType;
import com.mftplus.eesample.model.enums.CaseStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.*;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity @Table(
        name="SURGERY_CASE",
        uniqueConstraints = @UniqueConstraint(name="UK_CASE_NO", columnNames = "CASE_NO"),
        indexes = {
                @Index(name="IX_CASE_PATIENT", columnList="PATIENT_ID"),
                @Index(name="IX_CASE_STATUS", columnList="STATUS")
        }
)
public class SurgeryCase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name="CASE_NO", length=64) // شماره/کد عمل
    private String caseNo;

    @ManyToOne(optional=false) @JoinColumn(name="PATIENT_ID")
    private Patient patient;

    @ManyToOne @JoinColumn(name="OR_ID")
    private OperatingRoom operatingRoom;

    @ManyToOne @JoinColumn(name="SURGEON_ID")
    private Staff surgeon;

    @ManyToOne @JoinColumn(name="ANESTHESIOLOGIST_ID")
    private Staff anesthesiologist;

    @Column(name="PROCEDURE_NAME", length=300)
    private String procedureName; // نام عمل

    @Column(name="DIAGNOSIS", length=500)
    private String diagnosis;

    @Enumerated(EnumType.STRING)
    @Column(name="ANESTHESIA", length=16)
    private AnesthesiaType anesthesiaType;

    @Enumerated(EnumType.STRING)
    @Column(name="STATUS", length=16)
    private CaseStatus status = CaseStatus.SCHEDULED;

    private LocalDateTime scheduledStart;
    private LocalDateTime actualStart;
    private LocalDateTime actualEnd;

    @Column(name="NOTES", length=2000)
    private String notes;

    // getters/setters
}
