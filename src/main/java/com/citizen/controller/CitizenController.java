package com.citizen.controller;

import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.citizen.dto.CitizenRequest;
import com.citizen.dto.CitizenResponse;
import com.citizen.service.CitizenService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/citizen")
@RequiredArgsConstructor
@CrossOrigin(origins = "http://localhost:5173/")
public class CitizenController {

    private final CitizenService citizenService;

    @GetMapping(path = "page/publish")
    public ResponseEntity<String> publishCitizensToKafka(
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "10") int size) {
        return ResponseEntity.status(HttpStatus.OK).body(citizenService.publishToKafka(page, size));
    }

    @GetMapping(path = "/page")
    public Page<CitizenResponse> getCitizens(
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "10") int size) {
        return citizenService.getCitizens(page, size);
    }

    @PostMapping(path = "/create")
    public CitizenResponse createCitizen(@RequestBody CitizenRequest citizenRequest) {
        // Logic to create a new citizen using the citizenService
        return citizenService.createCitizen(citizenRequest);
    }

    @GetMapping(path = "")
    public CitizenResponse getCitizen(@RequestParam(name = "citizenid") String citizenuuid) {
        return citizenService.getCitizen(citizenuuid);
    }
}
