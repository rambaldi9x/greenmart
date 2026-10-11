// Quick coupon click
    function applyQuickCoupon(code) {
      const input = document.getElementById('couponInput');
      if (input) {
        input.value = code;
        document.getElementById('couponForm').submit();
      }
    }

    // Interactive payment selection
    function selectPayment(type) {
      document.querySelectorAll('.payment-option-card').forEach(c => c.classList.remove('selected'));
      const radio = document.querySelector('input[name="custPayment"][value="' + type + '"]');
      if (radio) radio.checked = true;

      const card = document.getElementById('card-' + type.toLowerCase());
      if (card) card.classList.add('selected');

      const bankBox = document.getElementById('bankDetailsBox');
      if (bankBox) {
        bankBox.style.display = (type === 'BANK') ? 'block' : 'none';
      }
    }

    // Toggle & Close Floating Chat Popup
    function toggleFloatingChat(forceClose) {
      const widget = document.getElementById('liveChatWidget');
      if (!widget) return;
      const isOpen = widget.classList.contains('active') || widget.style.display === 'flex';
      if (forceClose === true || isOpen) {
        widget.classList.remove('active');
        widget.style.setProperty('display', 'none', 'important');
      } else {
        widget.classList.add('active');
        widget.style.setProperty('display', 'flex', 'important');
        scrollWidgetBottom();
        const input = document.getElementById('widgetChatInput');
        if (input) input.focus();
      }
    }

    function closeFloatingChat(e) {
      if (e) {
        e.preventDefault();
        e.stopPropagation();
      }
      toggleFloatingChat(true);
    }

    function scrollWidgetBottom() {
      const body = document.getElementById('liveChatBody');
      if (body) body.scrollTop = body.scrollHeight;
    }

    function sendWidgetQuick(text) {
      const input = document.getElementById('widgetChatInput');
      if (input) {
        input.value = text;
        handleWidgetSend(new Event('submit'));
      }
    }

    function handleWidgetSend(e) {
      if (e && e.preventDefault) e.preventDefault();
      const input = document.getElementById('widgetChatInput');
      const content = input ? input.value.trim() : '';
      if (!content) return;

      input.value = '';

      // Append to widget view
      const body = document.getElementById('liveChatBody');
      if (body) {
        const row = document.createElement('div');
        row.className = 'chat-message-row row-mine';
        row.innerHTML = 
          '<div class="bubble-and-time">' +
            '<div class="chat-bubble bubble-mine">' + escapeHtml(content) + '</div>' +
            '<div class="message-time-meta">Vừa xong</div>' +
          '</div>';
        body.appendChild(row);
        scrollWidgetBottom();
      }

      // Send via AJAX to chat servlet
      const formData = new URLSearchParams();
      formData.append('action', 'send');
      formData.append('receiverId', '1'); // Default to Admin
      formData.append('content', content);

      fetch('chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
      })
      .then(res => res.json())
      .then(data => {
        // Automatically simulate instant helpful response if needed or wait for poll
      })
      .catch(err => {
        console.error('Lỗi gửi chat popup:', err);
      });
    }

    function escapeHtml(text) {
      if (!text) return '';
      const div = document.createElement('div');
      div.textContent = text;
      return div.innerHTML;
    }
