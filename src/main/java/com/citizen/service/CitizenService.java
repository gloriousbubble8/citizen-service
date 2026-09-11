package com.citizen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.citizen.dto.CitizenResponse;
import com.citizen.model.CitizenEntity;
import com.citizen.repository.CitizenRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service 
@RequiredArgsConstructor 
public class CitizenService {

    private final CitizenRepository citizenRepository;

    public Page<CitizenResponse> getCitizens(int page, int size){
        Pageable pageable = PageRequest.of(page, size);
        Page<CitizenResponse> responsePage = citizenRepository.findAll(pageable).map(entity -> mapEntityToDto(entity));
        return responsePage;
    }

    public CitizenResponse mapEntityToDto(CitizenEntity ce){
        return CitizenResponse.builder()
            .citizenId(ce.getCitizenId())
            .dateOfBirth(ce.getDateOfBirth())
            .email(ce.getEmail())
            .firstName(ce.getFirstName())
            .genderId(ce.getGenderId())
            .lastName(ce.getLastName())
            .middleName(ce.getMiddleName())
            .phoneNumber(ce.getPhoneNumber())
            .ssn(ce.getSsn())
            .build();
    }
}
