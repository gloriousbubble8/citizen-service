package com.citizen.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.citizen.model.CitizenEntity;

public interface CitizenRepository extends JpaRepository<CitizenEntity, UUID> {

}
