package com.greenmart.service;

import com.greenmart.entity.Vendor;
import com.greenmart.repository.VendorRepository;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

public class VendorService {
    private final VendorRepository vendorRepository;

    public VendorService() {
        this.vendorRepository = new VendorRepository();
    }

    public List<Vendor> getAllVendors() {
        return vendorRepository.findAll();
    }

    public Vendor getVendorById(Long id) {
        return vendorRepository.findById(id);
    }

    public Vendor getVendorByCode(String code) {
        return vendorRepository.findByCode(code);
    }

    public void saveVendor(Vendor vendor) {
        if (vendor == null) return;
        if (vendor.getRegisteredAt() == null || vendor.getRegisteredAt().trim().isEmpty()) {
            vendor.setRegisteredAt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        }
        if (vendor.getStatus() == null || vendor.getStatus().trim().isEmpty()) {
            vendor.setStatus("Waiting");
        }
        vendorRepository.save(vendor);
    }

    public void updateVendor(Vendor vendor) {
        if (vendor == null) return;
        vendorRepository.update(vendor);
    }

    public void deleteVendor(Long id) {
        if (id == null) return;
        vendorRepository.delete(id);
    }

    public void updateVendorStatus(Long id, String status) {
        if (id == null) return;
        vendorRepository.updateStatus(id, status);
    }

    public List<Vendor> filterVendors(String status, String keyword) {
        List<Vendor> all = getAllVendors();
        return all.stream()
                .filter(v -> {
                    boolean matchStatus = true;
                    if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
                        matchStatus = status.trim().equalsIgnoreCase(v.getStatus());
                    }
                    if (!matchStatus) return false;

                    if (keyword != null && !keyword.trim().isEmpty()) {
                        String kw = keyword.trim().toLowerCase();
                        boolean matchName = v.getShopName() != null && v.getShopName().toLowerCase().contains(kw);
                        boolean matchCode = v.getShopCode() != null && v.getShopCode().toLowerCase().contains(kw);
                        boolean matchEmail = v.getEmail() != null && v.getEmail().toLowerCase().contains(kw);
                        boolean matchPhone = v.getPhone() != null && v.getPhone().contains(kw);
                        boolean matchAddr = v.getAddress() != null && v.getAddress().toLowerCase().contains(kw);
                        boolean matchCat = v.getCategory() != null && v.getCategory().toLowerCase().contains(kw);
                        return matchName || matchCode || matchEmail || matchPhone || matchAddr || matchCat;
                    }
                    return true;
                })
                .collect(Collectors.toList());
    }
}
