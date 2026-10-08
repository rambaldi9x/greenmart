package com.greenmart.repository;

import com.greenmart.entity.Order;
import com.greenmart.entity.OrderItem;
import com.greenmart.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

public class OrderRepository {

    public List<Order> findAll() {
        List<Order> list = new ArrayList<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Order> query = session.createQuery("FROM Order ORDER BY id DESC", Order.class);
            list = query.list();
            for (Order o : list) {
                o.setItems(findItemsByOrderId(session, o.getId()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order findById(Long id) {
        Order order = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            order = session.get(Order.class, id);
            if (order != null) {
                order.setItems(findItemsByOrderId(session, order.getId()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return order;
    }

    public Order findByOrderCode(String orderCode) {
        if (orderCode == null || orderCode.trim().isEmpty()) return null;
        Order order = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Order> query = session.createQuery("FROM Order WHERE UPPER(orderCode) = UPPER(:code)", Order.class);
            query.setParameter("code", orderCode.trim());
            query.setMaxResults(1);
            order = query.uniqueResult();
            if (order != null) {
                order.setItems(findItemsByOrderId(session, order.getId()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return order;
    }

    public List<Order> findByPhone(String phone) {
        List<Order> list = new ArrayList<>();
        if (phone == null || phone.trim().isEmpty()) return list;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Order> query = session.createQuery("FROM Order WHERE phone = :phone ORDER BY id DESC", Order.class);
            query.setParameter("phone", phone.trim());
            list = query.list();
            for (Order o : list) {
                o.setItems(findItemsByOrderId(session, o.getId()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> findByUserId(Long userId) {
        List<Order> list = new ArrayList<>();
        if (userId == null) return list;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Order> query = session.createQuery("FROM Order WHERE userId = :userId ORDER BY id DESC", Order.class);
            query.setParameter("userId", userId);
            list = query.list();
            for (Order o : list) {
                o.setItems(findItemsByOrderId(session, o.getId()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<OrderItem> findItemsByOrderId(Long orderId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return findItemsByOrderId(session, orderId);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    private List<OrderItem> findItemsByOrderId(Session session, Long orderId) {
        Query<OrderItem> query = session.createQuery("FROM OrderItem WHERE orderId = :orderId", OrderItem.class);
        query.setParameter("orderId", orderId);
        return query.list();
    }

    public void save(Order order) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(order);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void saveOrderItem(OrderItem item) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(item);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void updateStatus(Long id, String status) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Order o = session.get(Order.class, id);
            if (o != null) {
                o.setStatus(status);
                session.update(o);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void delete(Long id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Query<?> qItem = session.createQuery("DELETE FROM OrderItem WHERE orderId = :orderId");
            qItem.setParameter("orderId", id);
            qItem.executeUpdate();

            Order o = session.get(Order.class, id);
            if (o != null) {
                session.delete(o);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
