package com.greenmart.repository;

import com.greenmart.entity.ChatMessage;
import com.greenmart.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

public class ChatMessageRepository {

    static {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            session.createNativeQuery("CREATE TABLE IF NOT EXISTS `chat_message` (" +
                "`id` BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                "`sender_id` BIGINT, " +
                "`receiver_id` BIGINT, " +
                "`sender_name` VARCHAR(100), " +
                "`receiver_name` VARCHAR(100), " +
                "`content` TEXT, " +
                "`created_at` VARCHAR(50), " +
                "`is_read` BOOLEAN DEFAULT FALSE" +
            ")").executeUpdate();
            tx.commit();
        } catch (Exception ignored) {}
    }

    public void save(ChatMessage msg) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(msg);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public List<ChatMessage> findConversation(Long user1Id, Long user2Id) {
        List<ChatMessage> list = new ArrayList<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<ChatMessage> query = session.createQuery(
                "FROM ChatMessage WHERE (senderId = :u1 AND receiverId = :u2) OR (senderId = :u2 AND receiverId = :u1) ORDER BY id ASC",
                ChatMessage.class
            );
            query.setParameter("u1", user1Id);
            query.setParameter("u2", user2Id);
            list = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ChatMessage> findNewMessages(Long user1Id, Long user2Id, Long afterId) {
        List<ChatMessage> list = new ArrayList<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<ChatMessage> query = session.createQuery(
                "FROM ChatMessage WHERE ((senderId = :u1 AND receiverId = :u2) OR (senderId = :u2 AND receiverId = :u1)) AND id > :afterId ORDER BY id ASC",
                ChatMessage.class
            );
            query.setParameter("u1", user1Id);
            query.setParameter("u2", user2Id);
            query.setParameter("afterId", afterId != null ? afterId : 0L);
            list = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ChatMessage findLastMessage(Long user1Id, Long user2Id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<ChatMessage> query = session.createQuery(
                "FROM ChatMessage WHERE (senderId = :u1 AND receiverId = :u2) OR (senderId = :u2 AND receiverId = :u1) ORDER BY id DESC",
                ChatMessage.class
            );
            query.setParameter("u1", user1Id);
            query.setParameter("u2", user2Id);
            query.setMaxResults(1);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countUnreadFromSender(Long senderId, Long receiverId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(m.id) FROM ChatMessage m WHERE m.senderId = :s AND m.receiverId = :r AND m.isRead = false",
                Long.class
            );
            query.setParameter("s", senderId);
            query.setParameter("r", receiverId);
            Long count = query.uniqueResult();
            return count != null ? count.intValue() : 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countTotalUnread(Long receiverId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(m.id) FROM ChatMessage m WHERE m.receiverId = :r AND m.isRead = false",
                Long.class
            );
            query.setParameter("r", receiverId);
            Long count = query.uniqueResult();
            return count != null ? count.intValue() : 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void markAsRead(Long senderId, Long receiverId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Query<?> query = session.createQuery(
                "UPDATE ChatMessage SET isRead = true WHERE senderId = :s AND receiverId = :r AND isRead = false"
            );
            query.setParameter("s", senderId);
            query.setParameter("r", receiverId);
            query.executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
