package com.greenmart.entity;

import javax.persistence.*;

@Entity
@Table(name = "vendors")
public class Vendor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "shop_code")
    private String shopCode;
    
    @Column(name = "shop_name")
    private String shopName;
    
    @Column(name = "contact_person")
    private String contactPerson;
    
    private String email;
    private String phone;
    private String address;
    private String category;
    
    @Column(length = 1000)
    private String description;
    
    private Double rating = 4.8;
    private String status = "Waiting";
    
    @Column(name = "registered_at")
    private String registeredAt;

    public Vendor() {}

    public Vendor(String shopCode, String shopName, String contactPerson, String email, String phone, 
                  String address, String category, String description, Double rating, String status, String registeredAt) {
        this.shopCode = shopCode;
        this.shopName = shopName;
        this.contactPerson = contactPerson;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.category = category;
        this.description = description;
        this.rating = rating != null ? rating : 4.8;
        this.status = status != null ? status : "Waiting";
        this.registeredAt = registeredAt;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getShopCode() { return shopCode; }
    public void setShopCode(String shopCode) { this.shopCode = shopCode; }
    
    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }
    
    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getRegisteredAt() { return registeredAt; }
    public void setRegisteredAt(String registeredAt) { this.registeredAt = registeredAt; }
}