document.addEventListener('DOMContentLoaded', function() {
  // Client-side Instant Filter for Products
  const filterChips = document.querySelectorAll('.prod-filter-chip');
  const productRows = document.querySelectorAll('.product-item-row');
  const emptyRow = document.getElementById('productsEmptyRow');

  if (filterChips.length > 0 && productRows.length > 0) {
    const urlParams = new URLSearchParams(window.location.search);
    const stockParam = urlParams.get('stockFilter');
    const catParam = urlParams.get('categoryFilter');

    function applyFilter(filterType, filterVal) {
      let visibleCount = 0;
      productRows.forEach(function(row) {
        let match = false;
        if (filterType === 'all' || !filterVal || filterVal === 'all') {
          match = true;
        } else if (filterType === 'stock') {
          match = (row.getAttribute('data-stock-status') === filterVal);
        } else if (filterType === 'category') {
          const rowCat = row.getAttribute('data-cat-slug');
          match = (rowCat === filterVal);
        }

        if (match) {
          row.style.display = '';
          visibleCount++;
        } else {
          row.style.display = 'none';
        }
      });

      if (emptyRow) {
        emptyRow.style.display = (visibleCount === 0) ? '' : 'none';
      }
    }

    filterChips.forEach(function(chip) {
      chip.addEventListener('click', function(e) {
        e.preventDefault();
        
        filterChips.forEach(function(c) { c.classList.remove('active'); });
        this.classList.add('active');

        const filterType = this.getAttribute('data-filter-type') || 'all';
        const filterVal = this.getAttribute('data-filter-val');

        applyFilter(filterType, filterVal);

        const url = new URL(window.location);
        url.searchParams.delete('stockFilter');
        url.searchParams.delete('categoryFilter');
        if (filterType === 'stock' && filterVal && filterVal !== 'all') {
          url.searchParams.set('stockFilter', filterVal);
        } else if (filterType === 'category' && filterVal && filterVal !== 'all') {
          url.searchParams.set('categoryFilter', filterVal);
        }
        window.history.replaceState({}, '', url);
      });
    });

    if (stockParam) {
      applyFilter('stock', stockParam);
    } else if (catParam) {
      applyFilter('category', catParam);
    }
  }

  // Client-side Instant Filter & Instant Search for Vendors
  const vendorChips = document.querySelectorAll('.vendor-filter-chip');
  const vendorRows = document.querySelectorAll('.vendor-item-row');
  const vendorEmptyRow = document.getElementById('vendorsClientEmptyRow');
  const vendorSearchInput = document.getElementById('vendorSearchInput');

  if (vendorRows.length > 0) {
    let currentVendorFilter = 'all';
    let currentVendorKeyword = '';

    function filterVendors() {
      let visibleCount = 0;
      vendorRows.forEach(function(row) {
        const rowStatus = row.getAttribute('data-status') || '';
        const rowKeyword = (row.getAttribute('data-keyword') || '').toLowerCase();

        let statusMatch = (currentVendorFilter === 'all' || !currentVendorFilter || rowStatus.toLowerCase() === currentVendorFilter.toLowerCase());
        let keywordMatch = (!currentVendorKeyword || rowKeyword.indexOf(currentVendorKeyword) !== -1);

        if (statusMatch && keywordMatch) {
          row.style.display = '';
          visibleCount++;
        } else {
          row.style.display = 'none';
        }
      });

      if (vendorEmptyRow) {
        vendorEmptyRow.style.display = (visibleCount === 0) ? '' : 'none';
      }
    }

    if (vendorChips.length > 0) {
      vendorChips.forEach(function(chip) {
        chip.addEventListener('click', function(e) {
          e.preventDefault();
          vendorChips.forEach(function(c) { c.classList.remove('active'); });
          this.classList.add('active');

          currentVendorFilter = this.getAttribute('data-filter-val') || 'all';
          filterVendors();

          const url = new URL(window.location);
          if (currentVendorFilter && currentVendorFilter !== 'all') {
            url.searchParams.set('statusFilter', currentVendorFilter);
          } else {
            url.searchParams.delete('statusFilter');
          }
          window.history.replaceState({}, '', url);
        });
      });
    }

    if (vendorSearchInput) {
      vendorSearchInput.addEventListener('input', function() {
        currentVendorKeyword = this.value.trim().toLowerCase();
        filterVendors();
      });
    }
  }
});
