package com.citizen.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.citizen.model.CitizenEntity;

@Repository
public interface CitizenRepository extends JpaRepository<CitizenEntity, UUID> {

}
