package com.greenmart.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.greenmart.entity.ChatMessage;
import com.greenmart.entity.Order;
import com.greenmart.entity.User;
import com.greenmart.model.UserContactDTO;
import com.greenmart.service.ChatService;
import com.greenmart.service.OrderService;
import com.greenmart.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "ChatServlet", urlPatterns = {"/chat"})
public class ChatServlet extends HttpServlet {
    private ChatService chatService;
    private UserService userService;
    private OrderService orderService;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        chatService = new ChatService();
        userService = new UserService();
        orderService = new OrderService();
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        String isAjax = request.getParameter("ajax");

        if (currentUser == null) {
            if ("1".equals(isAjax)) {
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Vui lòng đăng nhập để sử dụng tính năng trò chuyện\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/auth?mode=login&redirect=chat");
            return;
        }

        String action = request.getParameter("action");

        if ("poll".equalsIgnoreCase(action)) {
            // Long polling or interval polling for new messages
            String withUserStr = request.getParameter("withUserId");
            String afterIdStr = request.getParameter("afterId");

            Long withUserId = null;
            Long afterId = 0L;
            try {
                if (withUserStr != null) withUserId = Long.parseLong(withUserStr.trim());
                if (afterIdStr != null) afterId = Long.parseLong(afterIdStr.trim());
            } catch (Exception ignored) {}

            List<ChatMessage> newMessages = Collections.emptyList();
            if (withUserId != null) {
                newMessages = chatService.getNewMessages(currentUser.getId(), withUserId, afterId);
                chatService.markAsRead(withUserId, currentUser.getId());
            }

            int unreadTotal = chatService.getTotalUnread(currentUser.getId());

            List<Map<String, Object>> listJson = new ArrayList<>();
            for (ChatMessage m : newMessages) {
                listJson.add(messageToMap(m, currentUser.getId()));
            }

            Map<String, Object> respMap = new HashMap<>();
            respMap.put("status", "success");
            respMap.put("messages", listJson);
            respMap.put("totalUnread", unreadTotal);

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(objectMapper.writeValueAsString(respMap));
            return;

        } else if ("getMessages".equalsIgnoreCase(action)) {
            String withUserStr = request.getParameter("withUserId");
            Long withUserId = null;
            try {
                if (withUserStr != null) withUserId = Long.parseLong(withUserStr.trim());
            } catch (Exception ignored) {}

            List<ChatMessage> messages = Collections.emptyList();
            if (withUserId != null) {
                messages = chatService.getConversation(currentUser.getId(), withUserId);
                chatService.markAsRead(withUserId, currentUser.getId());
            }

            List<Map<String, Object>> listJson = new ArrayList<>();
            for (ChatMessage m : messages) {
                listJson.add(messageToMap(m, currentUser.getId()));
            }

            Map<String, Object> respMap = new HashMap<>();
            respMap.put("status", "success");
            respMap.put("messages", listJson);

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(objectMapper.writeValueAsString(respMap));
            return;

        } else if ("unreadCount".equalsIgnoreCase(action)) {
            int unread = chatService.getTotalUnread(currentUser.getId());
            Map<String, Object> respMap = new HashMap<>();
            respMap.put("status", "success");
            respMap.put("unread", unread);

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(objectMapper.writeValueAsString(respMap));
            return;
        }

        // Standard GET: Render chat.jsp
        List<UserContactDTO> contacts = chatService.getContactsForUser(currentUser.getId());

        User activeContact = null;
        String withParam = request.getParameter("with");
        if ("admin".equalsIgnoreCase(withParam) || "1".equals(request.getParameter("withAdmin"))) {
            for (UserContactDTO c : contacts) {
                if ("admin".equalsIgnoreCase(c.getUser().getRole())) {
                    activeContact = c.getUser();
                    break;
                }
            }
        } else if (withParam != null && !withParam.trim().isEmpty()) {
            try {
                Long targetId = Long.parseLong(withParam.trim());
                activeContact = userService.getUserById(targetId);
            } catch (Exception ignored) {}
        }

        if (activeContact == null && !"admin".equalsIgnoreCase(currentUser.getRole())) {
            for (UserContactDTO c : contacts) {
                if ("admin".equalsIgnoreCase(c.getUser().getRole())) {
                    activeContact = c.getUser();
                    break;
                }
            }
        }

        if (activeContact == null && !contacts.isEmpty()) {
            activeContact = contacts.get(0).getUser();
        }

        List<ChatMessage> conversation = Collections.emptyList();
        if (activeContact != null) {
            conversation = chatService.getConversation(currentUser.getId(), activeContact.getId());
            chatService.markAsRead(activeContact.getId(), currentUser.getId());
        }

        int totalUnread = chatService.getTotalUnread(currentUser.getId());

        String orderCodeParam = request.getParameter("orderCode");
        Order referencedOrder = null;
        if (orderCodeParam != null && !orderCodeParam.trim().isEmpty()) {
            referencedOrder = orderService.getOrderByCode(orderCodeParam.trim());
        }

        request.setAttribute("currentUser", currentUser);
        request.setAttribute("contacts", contacts);
        request.setAttribute("activeContact", activeContact);
        request.setAttribute("messages", conversation);
        request.setAttribute("totalUnread", totalUnread);
        request.setAttribute("orderCodeParam", orderCodeParam);
        request.setAttribute("referencedOrder", referencedOrder);

        request.getRequestDispatcher("/chat.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Vui lòng đăng nhập\"}");
            return;
        }

        String action = request.getParameter("action");

        if ("send".equalsIgnoreCase(action)) {
            String receiverIdStr = request.getParameter("receiverId");
            String content = request.getParameter("content");

            if (content == null || content.trim().isEmpty()) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Nội dung tin nhắn không được để trống\"}");
                return;
            }

            Long receiverId = null;
            try {
                receiverId = Long.parseLong(receiverIdStr.trim());
            } catch (Exception ignored) {}

            User receiver = (receiverId != null) ? userService.getUserById(receiverId) : null;
            if (receiver == null) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Người nhận không tồn tại\"}");
                return;
            }

            ChatMessage msg = chatService.sendMessage(
                currentUser.getId(),
                currentUser.getUsername(),
                receiver.getId(),
                receiver.getUsername(),
                content.trim()
            );

            Map<String, Object> respMap = new HashMap<>();
            respMap.put("status", "success");
            respMap.put("message", messageToMap(msg, currentUser.getId()));

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(objectMapper.writeValueAsString(respMap));
            return;

        } else if ("markRead".equalsIgnoreCase(action)) {
            String senderIdStr = request.getParameter("senderId");
            try {
                if (senderIdStr != null) {
                    Long senderId = Long.parseLong(senderIdStr.trim());
                    chatService.markAsRead(senderId, currentUser.getId());
                }
            } catch (Exception ignored) {}

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"status\":\"success\"}");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/chat");
    }

    private Map<String, Object> messageToMap(ChatMessage m, Long currentUserId) {
        Map<String, Object> map = new HashMap<>();
        if (m == null) return map;
        map.put("id", m.getId());
        map.put("senderId", m.getSenderId());
        map.put("senderName", m.getSenderName());
        map.put("receiverId", m.getReceiverId());
        map.put("receiverName", m.getReceiverName());
        map.put("content", m.getContent());
        map.put("createdAt", m.getCreatedAt());
        map.put("isMine", m.getSenderId().equals(currentUserId));
        map.put("isRead", Boolean.TRUE.equals(m.getIsRead()));
        return map;
    }
}
