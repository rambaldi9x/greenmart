package com.greenmart.service;

import com.greenmart.entity.ChatMessage;
import com.greenmart.entity.User;
import com.greenmart.model.UserContactDTO;
import com.greenmart.repository.ChatMessageRepository;
import com.greenmart.repository.UserRepository;

import java.text.SimpleDateFormat;
import java.util.*;

public class ChatService {
    private final ChatMessageRepository chatRepo;
    private final UserRepository userRepo;

    public ChatService() {
        this.chatRepo = new ChatMessageRepository();
        this.userRepo = new UserRepository();
    }

    public ChatMessage sendMessage(Long senderId, String senderName, Long receiverId, String receiverName, String content) {
        if (senderId == null || receiverId == null || content == null || content.trim().isEmpty()) {
            return null;
        }
        String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        ChatMessage msg = new ChatMessage(senderId, senderName, receiverId, receiverName, content.trim(), now);
        chatRepo.save(msg);
        return msg;
    }

    public List<ChatMessage> getConversation(Long user1Id, Long user2Id) {
        if (user1Id == null || user2Id == null) return Collections.emptyList();
        return chatRepo.findConversation(user1Id, user2Id);
    }

    public List<ChatMessage> getNewMessages(Long user1Id, Long user2Id, Long afterId) {
        if (user1Id == null || user2Id == null) return Collections.emptyList();
        return chatRepo.findNewMessages(user1Id, user2Id, afterId != null ? afterId : 0L);
    }

    public void markAsRead(Long senderId, Long receiverId) {
        if (senderId != null && receiverId != null) {
            chatRepo.markAsRead(senderId, receiverId);
        }
    }

    public int getTotalUnread(Long receiverId) {
        if (receiverId == null) return 0;
        return chatRepo.countTotalUnread(receiverId);
    }

    public List<UserContactDTO> getContactsForUser(Long currentUserId) {
        List<UserContactDTO> contacts = new ArrayList<>();
        if (currentUserId == null) return contacts;

        List<User> allUsers = userRepo.findAll();
        for (User u : allUsers) {
            if (u.getId().equals(currentUserId)) continue;

            ChatMessage lastMsg = chatRepo.findLastMessage(currentUserId, u.getId());
            int unread = chatRepo.countUnreadFromSender(u.getId(), currentUserId);
            contacts.add(new UserContactDTO(u, lastMsg, unread));
        }

        // Sort contacts:
        // 1. If currentUser is customer and one is admin, admin comes first (CSKH 24/7)
        // 2. Unread messages come next
        // 3. Contacts with recent messages next
        // 4. Alphabetical by name
        // 5. Fallback ID
        contacts.sort((a, b) -> {
            boolean aIsAdmin = "admin".equalsIgnoreCase(a.getUser().getRole());
            boolean bIsAdmin = "admin".equalsIgnoreCase(b.getUser().getRole());
            if (aIsAdmin != bIsAdmin) {
                return aIsAdmin ? -1 : 1;
            }

            if (a.getUnreadCount() != b.getUnreadCount()) {
                return Integer.compare(b.getUnreadCount(), a.getUnreadCount());
            }

            boolean aHasMsg = a.getLastMessage() != null;
            boolean bHasMsg = b.getLastMessage() != null;
            if (aHasMsg && bHasMsg) {
                String timeA = a.getLastMessage().getCreatedAt() != null ? a.getLastMessage().getCreatedAt() : "";
                String timeB = b.getLastMessage().getCreatedAt() != null ? b.getLastMessage().getCreatedAt() : "";
                int cmp = timeB.compareTo(timeA);
                if (cmp != 0) return cmp;
            } else if (aHasMsg != bHasMsg) {
                return aHasMsg ? -1 : 1;
            }

            String nameA = a.getUser() != null && a.getUser().getUsername() != null ? a.getUser().getUsername() : "";
            String nameB = b.getUser() != null && b.getUser().getUsername() != null ? b.getUser().getUsername() : "";
            int cmpName = nameA.compareToIgnoreCase(nameB);
            if (cmpName != 0) return cmpName;

            Long idA = a.getUser() != null ? a.getUser().getId() : 0L;
            Long idB = b.getUser() != null ? b.getUser().getId() : 0L;
            return idA.compareTo(idB);
        });

        return contacts;
    }
}
