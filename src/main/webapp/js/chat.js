const currentUserId = (window.CHAT_CONFIG && window.CHAT_CONFIG.currentUserId !== undefined) ? window.CHAT_CONFIG.currentUserId : -1;
const currentUserName = (window.CHAT_CONFIG && window.CHAT_CONFIG.currentUserName !== undefined) ? window.CHAT_CONFIG.currentUserName : '';
const activeContactId = (window.CHAT_CONFIG && window.CHAT_CONFIG.activeContactId !== undefined) ? window.CHAT_CONFIG.activeContactId : null;
const initialOrderCode = (window.CHAT_CONFIG && window.CHAT_CONFIG.initialOrderCode !== undefined) ? window.CHAT_CONFIG.initialOrderCode : '';

// Web Audio Sound Chime when receiving message
    function playChime() {
      try {
        const AudioCtx = window.AudioContext || window.webkitAudioContext;
        if (!AudioCtx) return;
        const ctx = new AudioCtx();
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = 'sine';
        osc.frequency.setValueAtTime(587.33, ctx.currentTime);
        osc.frequency.setValueAtTime(880.00, ctx.currentTime + 0.08);
        gain.gain.setValueAtTime(0.12, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.35);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(ctx.currentTime + 0.35);
      } catch (e) {}
    }

    // Scroll to bottom of message container
    function scrollToBottom(smooth) {
      const container = document.getElementById('chatMessagesContainer');
      if (container) {
        if (smooth) {
          container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' });
        } else {
          container.scrollTop = container.scrollHeight;
        }
      }
    }

    // Get max message ID currently in DOM
    function getMaxMessageId() {
      const rows = document.querySelectorAll('.chat-message-row[data-msg-id]');
      let maxId = 0;
      rows.forEach(r => {
        const id = parseInt(r.getAttribute('data-msg-id'));
        if (id && id > maxId) maxId = id;
      });
      return maxId;
    }

    // Filter contacts on search input
    function filterContacts() {
      const input = document.getElementById('contactSearchInput');
      const filter = input ? input.value.toLowerCase().trim() : '';
      const items = document.querySelectorAll('.contact-item');
      items.forEach(it => {
        const name = it.getAttribute('data-name') || '';
        if (name.includes(filter)) {
          it.style.display = 'flex';
        } else {
          it.style.display = 'none';
        }
      });
    }

    // Cập nhật đoạn trích tin nhắn cuối cùng trên sidebar theo thời gian thực
    function updateSidebarSnippet(contactId, content, timeStr) {
      const contactLink = document.querySelector('.contact-item[data-contact-id="' + contactId + '"]');
      if (contactLink) {
        const lastMsgEl = contactLink.querySelector('.contact-last-msg');
        if (lastMsgEl) {
          lastMsgEl.textContent = content;
          lastMsgEl.style.color = '#334155';
          lastMsgEl.style.fontWeight = '500';
        }
        const timeEl = contactLink.querySelector('.contact-time');
        if (timeEl && timeStr) {
          timeEl.textContent = timeStr;
        }
        // Đưa cuộc trò chuyện lên đầu danh sách
        const parent = contactLink.parentElement;
        if (parent && parent.firstElementChild !== contactLink) {
          parent.insertBefore(contactLink, parent.firstElementChild);
        }
      }
    }

    // Quick emoji insertion
    function toggleEmojiPicker() {
      const tray = document.getElementById('emojiPickerTray');
      if (tray) {
        tray.style.display = (tray.style.display === 'none' || tray.style.display === '') ? 'flex' : 'none';
      }
    }

    function insertEmoji(emoji) {
      const input = document.getElementById('chatInputMessage');
      if (input) {
        input.value += emoji;
        input.focus();
      }
      const tray = document.getElementById('emojiPickerTray');
      if (tray) tray.style.display = 'none';
    }

    // Quick message click
    function sendQuickMessage(text) {
      const input = document.getElementById('chatInputMessage');
      if (input) {
        input.value = text;
        input.focus();
        handleSendMessage();
      }
    }

    function escapeHtml(text) {
      if (!text) return '';
      const div = document.createElement('div');
      div.textContent = text;
      return div.innerHTML;
    }

    function formatMessageContent(text) {
      if (!text) return '';
      let escaped = escapeHtml(text);
      return escaped.replace(/(#?GM\d{6})/gi, function(match) {
        let cleanCode = match.replace('#', '');
        return '<a href="track-order?code=' + cleanCode + '" target="_blank" class="order-link-chip" title="Xem hành trình đơn ' + match + '"><i class="fa-solid fa-receipt"></i> ' + match + '</a>';
      });
    }

    // Append a message bubble to DOM
    function appendMessageDOM(msg, isMine) {
      const container = document.getElementById('chatMessagesContainer');
      if (!container) return;

      const emptyNotice = document.getElementById('emptyNotice');
      if (emptyNotice) emptyNotice.remove();

      // Check if already in DOM
      if (document.querySelector('.chat-message-row[data-msg-id="' + msg.id + '"]')) {
        return;
      }

      const row = document.createElement('div');
      row.className = 'chat-message-row ' + (isMine ? 'row-mine' : 'row-theirs');
      row.setAttribute('data-msg-id', msg.id);

      const timeStr = msg.createdAt && msg.createdAt.length >= 16 ? msg.createdAt.substring(11, 16) : '';
      const dateStr = msg.createdAt && msg.createdAt.length >= 10 ? (msg.createdAt.substring(8, 10) + '/' + msg.createdAt.substring(5, 7)) : '';

      let senderAvatarHtml = '';
      if (!isMine) {
        const initial = (msg.senderName && msg.senderName.length > 0) ? msg.senderName.charAt(0).toUpperCase() : 'U';
        senderAvatarHtml = '<div class="message-sender-avatar">' + initial + '</div>';
      }

      let innerHtml = '';
      innerHtml += senderAvatarHtml;
      innerHtml += '<div class="bubble-and-time">';
      if (!isMine) {
        innerHtml += '<div class="message-sender-label">' + escapeHtml(msg.senderName) + '</div>';
      }
      innerHtml += '<div class="chat-bubble ' + (isMine ? 'bubble-mine' : 'bubble-theirs') + '">';
      innerHtml += formatMessageContent(msg.content);
      innerHtml += '</div>';
      innerHtml += '<div class="message-time-meta">';
      innerHtml += timeStr + ' &bull; ' + dateStr;
      innerHtml += '</div>';
      innerHtml += '</div>';

      row.innerHTML = innerHtml;
      container.appendChild(row);
      scrollToBottom(true);
    }

    // Handle send message form submit
    function handleSendMessage(e) {
      if (e && e.preventDefault) e.preventDefault();
      if (!activeContactId) return;

      const input = document.getElementById('chatInputMessage');
      const content = input ? input.value.trim() : '';
      if (!content) return;

      input.value = '';
      const submitBtn = document.getElementById('btnSubmitChat');
      if (submitBtn) submitBtn.disabled = true;

      const formData = new URLSearchParams();
      formData.append('action', 'send');
      formData.append('receiverId', activeContactId);
      formData.append('content', content);

      fetch('chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
      })
      .then(res => res.json())
      .then(data => {
        if (submitBtn) submitBtn.disabled = false;
        if (input) input.focus();
        if (data && data.status === 'success' && data.message) {
          appendMessageDOM(data.message, true);
          updateSidebarSnippet(activeContactId, 'Bạn: ' + data.message.content, 'Vừa xong');
        } else if (data && data.message) {
          alert(data.message);
        }
      })
      .catch(err => {
        if (submitBtn) submitBtn.disabled = false;
        if (input) input.focus();
        console.error('Lỗi gửi tin nhắn:', err);
      });
    }

    // Polling new messages
    function pollNewMessages() {
      if (!activeContactId) return;
      const afterId = getMaxMessageId();

      fetch('chat?action=poll&withUserId=' + activeContactId + '&afterId=' + afterId + '&ajax=1')
      .then(res => res.json())
      .then(data => {
        if (data && data.status === 'success' && Array.isArray(data.messages)) {
          let hasNewTheirs = false;
          data.messages.forEach(msg => {
            appendMessageDOM(msg, msg.isMine);
            if (!msg.isMine) {
              hasNewTheirs = true;
              const shortTime = msg.createdAt && msg.createdAt.length >= 16 ? msg.createdAt.substring(11, 16) : '';
              updateSidebarSnippet(msg.senderId, msg.content, shortTime);
            }
          });
          if (hasNewTheirs) {
            playChime();
          }
        }
      })
      .catch(err => {
        console.error('Lỗi nhận tin nhắn mới:', err);
      });
    }

    // Initial setup on load
    window.addEventListener('DOMContentLoaded', () => {
      // Format all pre-existing bubbles with clickable order codes
      document.querySelectorAll('.chat-bubble').forEach(b => {
        b.innerHTML = formatMessageContent(b.textContent.trim());
      });

      scrollToBottom(false);
      const input = document.getElementById('chatInputMessage');
      if (input) {
        if (initialOrderCode) {
          input.value = 'Chào shop, mình cần hỗ trợ về đơn hàng #' + initialOrderCode + ' ạ!';
        }
        input.focus();
      }

      // Start periodic polling every 2.5 seconds
      if (activeContactId) {
        setInterval(pollNewMessages, 2500);
      }
    });

    // Close emoji tray if clicked outside
    document.addEventListener('click', (e) => {
      const tray = document.getElementById('emojiPickerTray');
      const toggle = document.querySelector('.btn-emoji-toggle');
      if (tray && toggle && !tray.contains(e.target) && !toggle.contains(e.target)) {
        tray.style.display = 'none';
      }
    });
