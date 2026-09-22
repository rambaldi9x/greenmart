package com.greenmart.service;

import com.greenmart.entity.Coupon;
import com.greenmart.repository.CouponRepository;

import java.util.List;

public class CouponService {
    private CouponRepository couponRepository;

    public CouponService() {
        this.couponRepository = new CouponRepository();
    }

    public Coupon getCouponByCode(String code) {
        return couponRepository.findByCode(code);
    }

    public List<Coupon> getAllCoupons() {
        return couponRepository.findAll();
    }
}
