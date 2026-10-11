function showToast(msg) {
      const toast = document.getElementById('toast-notify');
      const msgEl = document.getElementById('toast-msg');
      if (!toast || !msgEl) return;
      msgEl.textContent = msg;
      toast.style.display = 'flex';
      toast.style.opacity = '1';
      clearTimeout(window.toastTimer);
      window.toastTimer = setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => { toast.style.display = 'none'; }, 300);
      }, 2500);
    }

    function formatVND(amount) {
      if (amount == null) return '0 ₫';
      return Number(amount).toLocaleString('vi-VN') + ' ₫';
    }

    function updateBadge(totalQty, subtotal) {
      const badges = document.querySelectorAll('#cart-count, .header-actions .badge');
      badges.forEach(b => { b.textContent = totalQty; });

      const floatBadge = document.getElementById('floating-cart-badge');
      if (floatBadge) {
        floatBadge.textContent = totalQty;
        floatBadge.style.display = totalQty > 0 ? 'inline-block' : 'none';
      }

      const subtotalEl = document.getElementById('floating-cart-subtotal');
      if (subtotalEl) {
        if (totalQty > 0 && subtotal !== undefined) {
          subtotalEl.textContent = formatVND(subtotal);
          subtotalEl.style.display = 'inline-block';
        } else {
          subtotalEl.style.display = 'none';
        }
      }

      const floatBtn = document.getElementById('floating-cart-btn');
      if (floatBtn) {
        floatBtn.classList.remove('cart-bounce');
        void floatBtn.offsetWidth;
        floatBtn.classList.add('cart-bounce');
      }
    }

    function handleAddToCart(productId, btnEl, maxCount) {
      const btnAdd = document.getElementById('btn-add-' + productId);
      const qtyCtrl = document.getElementById('qty-ctrl-' + productId);
      const qtyVal = document.getElementById('qty-val-' + productId);
      const prodName = btnEl ? btnEl.getAttribute('data-name') : 'sản phẩm';

      // Chuyển giao diện: Ẩn nút "Thêm giỏ", hiện bộ chọn số lượng với số 1
      if (btnAdd) btnAdd.style.display = 'none';
      if (qtyCtrl) qtyCtrl.style.display = 'flex';
      if (qtyVal) qtyVal.textContent = '1';

      const formData = new URLSearchParams();
      formData.append('action', 'add');
      formData.append('productId', productId);
      formData.append('quantity', '1');
      formData.append('ajax', '1');

      fetch('cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
      })
      .then(res => res.json())
      .then(data => {
        if (data && data.status === 'success') {
          updateBadge(data.totalQuantity, data.subtotal);
          if (qtyVal) qtyVal.textContent = data.quantity;
          showToast('Đã thêm 1 "' + prodName + '" vào giỏ hàng!');
        }
      })
      .catch(err => {
        console.error('Lỗi khi thêm giỏ hàng:', err);
      });
    }

    function handleUpdateQty(productId, delta, maxCount) {
      const btnAdd = document.getElementById('btn-add-' + productId);
      const qtyCtrl = document.getElementById('qty-ctrl-' + productId);
      const qtyVal = document.getElementById('qty-val-' + productId);

      let currentQty = parseInt(qtyVal ? qtyVal.textContent : '1') || 1;
      let nextQty = currentQty + delta;

      if (maxCount && nextQty > maxCount) {
        showToast('Sản phẩm chỉ còn tối đa ' + maxCount + ' món trong kho!');
        return;
      }

      if (nextQty <= 0) {
        // Giảm về 0: Xóa khỏi giỏ, ẩn bộ số lượng, hiện lại nút "Thêm giỏ"
        if (qtyCtrl) qtyCtrl.style.display = 'none';
        if (btnAdd) btnAdd.style.display = 'block';

        const formData = new URLSearchParams();
        formData.append('action', 'remove');
        formData.append('productId', productId);
        formData.append('ajax', '1');

        fetch('cart', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: formData
        })
        .then(res => res.json())
        .then(data => {
          if (data && data.status === 'success') {
            updateBadge(data.totalQuantity, data.subtotal);
            showToast('Đã xóa sản phẩm khỏi giỏ hàng.');
          }
        })
        .catch(err => {
          console.error('Lỗi khi xóa khỏi giỏ hàng:', err);
        });
      } else {
        // Cập nhật số lượng
        if (qtyVal) qtyVal.textContent = nextQty;

        const formData = new URLSearchParams();
        formData.append('action', 'update');
        formData.append('productId', productId);
        formData.append('delta', delta);
        formData.append('ajax', '1');

        fetch('cart', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: formData
        })
        .then(res => res.json())
        .then(data => {
          if (data && data.status === 'success') {
            updateBadge(data.totalQuantity, data.subtotal);
            if (qtyVal) qtyVal.textContent = data.quantity;
            showToast('Đã cập nhật số lượng: ' + data.quantity);
          }
        })
        .catch(err => {
          console.error('Lỗi khi cập nhật giỏ hàng:', err);
        });
      }
    }

    function changeQty(btn, delta, max) {
      const container = btn.parentElement;
      const input = container.querySelector('input[type="number"]');
      if (!input || input.disabled) return;
      let val = parseInt(input.value) || 1;
      let next = val + delta;
      if (next < 1) next = 1;
      if (max && next > max) next = max;
      input.value = next;
    }

    // Floating Live Chat Popup Functions
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

      const formData = new URLSearchParams();
      formData.append('action', 'send');
      formData.append('receiverId', '1');
      formData.append('content', content);

      fetch('chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
      })
      .then(res => res.json())
      .then(data => {})
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
