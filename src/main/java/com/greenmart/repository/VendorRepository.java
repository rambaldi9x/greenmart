package com.greenmart.repository;

import com.greenmart.entity.Vendor;
import com.greenmart.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

public class VendorRepository {

    public List<Vendor> findAll() {
        List<Vendor> list = new ArrayList<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Vendor> query = session.createQuery("FROM Vendor ORDER BY id ASC", Vendor.class);
            list = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Vendor findById(Long id) {
        Vendor v = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            v = session.get(Vendor.class, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return v;
    }

    public void updateStatus(Long id, String status) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Vendor v = session.get(Vendor.class, id);
            if (v != null) {
                v.setStatus(status);
                session.update(v);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void save(Vendor vendor) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(vendor);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
