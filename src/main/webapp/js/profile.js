function switchTab(tabId, el) {
      document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
      document.querySelectorAll('.menu-item').forEach(m => m.classList.remove('active'));
      
      const targetPane = document.getElementById('tab-' + tabId);
      if (targetPane) {
        targetPane.classList.add('active');
      }
      if (el) {
        el.classList.add('active');
      }
    }

    function filterUserOrders(status, btnEl) {
      document.querySelectorAll('.profile-order-tab-btn').forEach(b => b.classList.remove('active'));
      if (btnEl) btnEl.classList.add('active');

      const cards = document.querySelectorAll('.order-card-v2');
      let visibleCount = 0;

      cards.forEach(card => {
        const orderStatus = (card.getAttribute('data-order-status') || '').trim();
        let match = false;
        if (status === 'all') {
          match = true;
        } else if (status === 'Completed') {
          match = (orderStatus === 'Completed' || orderStatus === 'Delivered');
        } else if (status === 'Canceled') {
          match = (orderStatus === 'Canceled' || orderStatus === 'Cancelled');
        } else {
          match = (orderStatus.toLowerCase() === status.toLowerCase());
        }

        if (match) {
          card.style.display = 'block';
          visibleCount++;
        } else {
          card.style.display = 'none';
        }
      });

      const notice = document.getElementById('noFilteredOrdersNotice');
      if (notice) {
        notice.style.display = (visibleCount === 0) ? 'block' : 'none';
      }
    }

    // Auto open tab based on URL hash if present
    window.addEventListener('DOMContentLoaded', () => {
      const hash = window.location.hash.replace('#', '');
      if (hash && ['profile', 'password', 'orders'].includes(hash)) {
        const link = document.querySelector('a[href="#' + hash + '"]');
        switchTab(hash, link);
      }
    });
