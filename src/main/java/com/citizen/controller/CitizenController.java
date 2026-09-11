package com.citizen.controller;

import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.citizen.dto.CitizenResponse;
import com.citizen.service.CitizenService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/citizen")
@RequiredArgsConstructor 
@CrossOrigin(origins = "http://localhost:5173/") 
public class CitizenController {

    private final CitizenService citizenService;

    @GetMapping("") 
    public Page<CitizenResponse> getCitizens(
                @RequestParam(name = "page" , defaultValue = "0")   int page, 
                @RequestParam(name = "size", defaultValue = "10")  int size){
        return citizenService.getCitizens(page, size);
    }
}
