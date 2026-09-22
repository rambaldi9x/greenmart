package com.greenmart.repository;

import com.greenmart.entity.Coupon;
import com.greenmart.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

public class CouponRepository {

    public Coupon findByCode(String code) {
        if (code == null) return null;
        Coupon coupon = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Coupon> query = session.createQuery("FROM Coupon WHERE code = :code AND active = 1", Coupon.class);
            query.setParameter("code", code.trim().toUpperCase());
            coupon = query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return coupon;
    }

    public List<Coupon> findAll() {
        List<Coupon> list = new ArrayList<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Coupon> query = session.createQuery("FROM Coupon", Coupon.class);
            list = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
