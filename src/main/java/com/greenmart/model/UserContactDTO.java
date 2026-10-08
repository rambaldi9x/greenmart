package com.greenmart.model;

import com.greenmart.entity.ChatMessage;
import com.greenmart.entity.User;

import java.io.Serializable;

public class UserContactDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private User user;
    private ChatMessage lastMessage;
    private int unreadCount;

    public UserContactDTO() {}

    public UserContactDTO(User user, ChatMessage lastMessage, int unreadCount) {
        this.user = user;
        this.lastMessage = lastMessage;
        this.unreadCount = unreadCount;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public ChatMessage getLastMessage() {
        return lastMessage;
    }

    public void setLastMessage(ChatMessage lastMessage) {
        this.lastMessage = lastMessage;
    }

    public int getUnreadCount() {
        return unreadCount;
    }

    public void setUnreadCount(int unreadCount) {
        this.unreadCount = unreadCount;
    }
}
