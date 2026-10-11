package com.greenmart.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.greenmart.entity.ChatMessage;
import com.greenmart.entity.Order;
import com.greenmart.entity.User;
import com.greenmart.model.ServiceResult;
import com.greenmart.model.UserContactDTO;
import com.greenmart.service.ChatService;
import com.greenmart.service.OrderService;

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
    private OrderService orderService;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        chatService = new ChatService();
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
            String withUserStr = request.getParameter("withUserId");
            String afterIdStr = request.getParameter("afterId");

            Long withUserId = null;
            Long afterId = 0L;
            try {
                if (withUserStr != null) withUserId = Long.parseLong(withUserStr.trim());
                if (afterIdStr != null) afterId = Long.parseLong(afterIdStr.trim());
            } catch (Exception ignored) {}

            Map<String, Object> respMap = chatService.pollMessagesPayload(currentUser.getId(), withUserId, afterId);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(objectMapper.writeValueAsString(respMap));
            return;

        } else if ("getMessages".equalsIgnoreCase(action)) {
            String withUserStr = request.getParameter("withUserId");
            Long withUserId = null;
            try {
                if (withUserStr != null) withUserId = Long.parseLong(withUserStr.trim());
            } catch (Exception ignored) {}

            Map<String, Object> respMap = chatService.getConversationPayload(currentUser.getId(), withUserId);
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
        String withParam = request.getParameter("with");
        boolean withAdmin = "admin".equalsIgnoreCase(withParam) || "1".equals(request.getParameter("withAdmin"));

        User activeContact = chatService.resolveActiveContact(currentUser.getId(), currentUser.getRole(), contacts, withParam, withAdmin);

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

            Long receiverId = null;
            try {
                if (receiverIdStr != null) receiverId = Long.parseLong(receiverIdStr.trim());
            } catch (Exception ignored) {}

            ServiceResult<Map<String, Object>> result = chatService.sendMessageWithResult(
                    currentUser.getId(),
                    currentUser.getUsername(),
                    receiverId,
                    content
            );

            response.setContentType("application/json;charset=UTF-8");
            if (result.isSuccess()) {
                Map<String, Object> respMap = new HashMap<>();
                respMap.put("status", "success");
                respMap.put("message", result.getData());
                response.getWriter().write(objectMapper.writeValueAsString(respMap));
            } else {
                Map<String, Object> respMap = new HashMap<>();
                respMap.put("status", "error");
                respMap.put("message", result.getMessage());
                response.getWriter().write(objectMapper.writeValueAsString(respMap));
            }
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
}
