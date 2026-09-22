package com.greenmart.service;

import com.greenmart.entity.Vendor;
import com.greenmart.repository.VendorRepository;

import java.util.List;

public class VendorService {
    private VendorRepository vendorRepository;

    public VendorService() {
        this.vendorRepository = new VendorRepository();
    }

    public List<Vendor> getAllVendors() {
        return vendorRepository.findAll();
    }

    public void updateVendorStatus(Long id, String status) {
        vendorRepository.updateStatus(id, status);
    }
}
