package com.citizen.service;

import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.citizen.dto.CitizenRequest;
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
    
    public CitizenResponse createCitizen(CitizenRequest citizenRequest){
        CitizenEntity citizenEntity = mapDtoToEntity(citizenRequest);
        CitizenEntity savedCitizen = citizenRepository.save(citizenEntity);
        return mapEntityToDto(savedCitizen);    
    }
    
    public CitizenResponse getCitizen(String citizenuuid) {
    		Optional<CitizenEntity> citizenEntityOptional =  citizenRepository.findById(UUID.fromString(citizenuuid));
    		if(citizenEntityOptional.isPresent()) {
    			return mapEntityToDto(citizenEntityOptional.get());
    		} else {
    			throw new NoSuchElementException("The element with this Id does not exists");
    		}
    }

    private CitizenEntity mapDtoToEntity(CitizenRequest citizenRequest){
        return CitizenEntity.builder()
            .ssn(citizenRequest.getSsn())
            .firstName(citizenRequest.getFirstName())
            .middleName(citizenRequest.getMiddleName())
            .lastName(citizenRequest.getLastName())
            .dateOfBirth(citizenRequest.getDateOfBirth())
            .genderId(citizenRequest.getGenderId())
            .statusId(citizenRequest.getStatusId()) 
            .birthCityId(citizenRequest.getBirthCityId())
            .build();
    }

    private CitizenResponse mapEntityToDto(CitizenEntity ce){
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
