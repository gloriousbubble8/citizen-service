package com.citizen.dto;

import java.time.LocalDate;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CitizenRequest {
    private String ssn;
    private String firstName;
    private String middleName;
    private String lastName;
    private LocalDate dateOfBirth;
    private Integer genderId;
    private Integer statusId;
    private String email;
    private String phoneNumber;
    private Integer birthCityId;
}
