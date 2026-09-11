package com.citizen.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "citizen")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder 
public class CitizenEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "citizen_id", updatable = false, nullable = false)
    private UUID citizenId;

    @Column(name = "ssn", unique = true, nullable = false, length = 20)
    private String ssn;

    @Column(name = "first_name", nullable = false, length = 100)
    private String firstName;

    @Column(name = "middle_name", length = 100)
    private String middleName;

    @Column(name = "last_name", nullable = false, length = 100)
    private String lastName;

    @Column(name = "date_of_birth", nullable = false)
    private LocalDate dateOfBirth;

    @Column(name = "gender_id")
    private Integer genderId;

    @Column(name = "status_id")
    private Integer statusId;

    @Column(name = "email", length = 200)
    private String email;

    @Column(name = "phone_number", length = 30)
    private String phoneNumber;

    @Column(name = "birth_city_id")
    private Integer birthCityId;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "is_deleted")
    private Boolean isDeleted;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (isDeleted == null) isDeleted = false;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
