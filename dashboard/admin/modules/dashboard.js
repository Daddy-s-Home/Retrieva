function drawAdminCharts() {
  const node = document.getElementById('admin-chart-data');
  const trend = document.getElementById('admin-trend-chart');
  const categories = document.getElementById('admin-category-chart');
  if (!node || !trend) return;
  let data;
  try {
    data = JSON.parse(node.textContent || '{}');
  } catch (error) {
    const emptyState = document.getElementById('admin-category-empty-state');
    if (emptyState) {
      emptyState.textContent = 'The category chart data could not be loaded.';
      emptyState.hidden = false;
    }
    console.error('Could not parse dashboard chart data.', error);
    return;
  }
  if (trend._chart) trend._chart.destroy();
  if (window.Chart) {
    trend._chart = new window.Chart(trend, {
      type: 'line',
      data: {
        labels: data.days || [],
        datasets: [
          { label: 'Found', data: data.found || [], borderColor: '#0b3d91', tension: 0.3 },
          { label: 'Lost', data: data.lost || [], borderColor: '#c9a227', tension: 0.3 },
        ],
      },
      options: { responsive: true, plugins: { legend: { position: 'bottom' } } },
    });
  }
  if (!categories) return;

  const tabList = document.querySelector('.admin-category-tabs');
  const tabs = Array.from(document.querySelectorAll('[data-category-tab]'));
  const chartPanel = document.getElementById('admin-category-panel');
  const legend = document.getElementById('admin-category-legend');
  const emptyState = document.getElementById('admin-category-empty-state');
  const colors = ['#2E6FF2', '#F5A623', '#7C5CFC', '#17A673', '#C44747', '#5C6B7A', '#16A0A8', '#BA4C96', '#A06D2C', '#507D2B', '#7A6E5B', '#8E6C8A'];

  function renderLegend(rows, type, hasData) {
    if (!legend || !emptyState) return;
    legend.replaceChildren();

    legend.hidden = false;
    emptyState.textContent = `No ${type} item categories have been recorded yet.`;
    emptyState.hidden = hasData;
    rows.forEach((row, index) => {
      const item = document.createElement('li');
      const label = document.createElement('span');
      const swatch = document.createElement('span');
      const name = document.createElement('span');
      const count = document.createElement('strong');

      label.className = 'admin-category-legend-label';
      swatch.className = 'admin-category-legend-swatch';
      swatch.style.backgroundColor = colors[index % colors.length];
      swatch.setAttribute('aria-hidden', 'true');
      name.className = 'admin-category-legend-name';
      name.textContent = String(row.label);
      count.className = 'admin-category-legend-count';
      count.textContent = String(row.total);

      label.append(swatch, name);
      item.append(label, count);
      legend.append(item);
    });
  }

  function renderCategoryChart(type) {
    const itemType = type === 'lost' ? 'lost' : 'found';
    const rows = itemType === 'lost' ? (data.categories_lost || []) : (data.categories || []);
    const hasData = rows.length > 0 && rows.some((row) => Number(row.total) > 0);

    tabs.forEach((tab) => {
      const selected = tab.dataset.categoryTab === itemType;
      tab.setAttribute('aria-selected', String(selected));
      tab.tabIndex = selected ? 0 : -1;
    });
    if (chartPanel) chartPanel.setAttribute('aria-labelledby', `admin-category-tab-${itemType}`);
    categories.setAttribute('aria-label', `${itemType === 'found' ? 'Found items' : 'Lost items'} by category`);
    renderLegend(rows, itemType, hasData);

    if (!window.Chart) {
      if (categories._chart) categories._chart.destroy();
      categories.hidden = true;
      if (emptyState) {
        emptyState.textContent = hasData
          ? 'The chart library is unavailable. Reload the page to try again.'
          : `No ${itemType} item categories have been recorded yet. The chart library is unavailable.`;
        emptyState.hidden = false;
      }
      return;
    }

    if (categories._chart) categories._chart.destroy();
    categories.hidden = false;
    const labels = rows.map((row) => {
      const label = String(row.label);
      if (label === 'Food containers and utensils') return ['Food containers', 'and utensils'];
      if (label === 'Tumbler/Flask/Bottled Water') return ['Tumbler/Flask/', 'Bottled Water'];
      return label;
    });
    const values = rows.map((row) => Number(row.total));
    categories._chart = new window.Chart(categories, {
      type: 'bar',
      data: {
        labels,
        datasets: [{
          data: values,
          backgroundColor: rows.map((row, index) => colors[index % colors.length]),
          borderWidth: 0,
          borderRadius: 4,
          maxBarThickness: 22,
        }],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        indexAxis: 'y',
        animation: { duration: 450 },
        plugins: {
          legend: { display: false },
          tooltip: { enabled: hasData },
        },
        scales: {
          x: { beginAtZero: true, ticks: { precision: 0, stepSize: 1 } },
          y: { reverse: true, grid: { display: false }, ticks: { autoSkip: false } },
        },
      },
    });
  }

  if (tabList) tabList.renderCategoryChart = renderCategoryChart;
  if (tabList && tabList.dataset.bound !== '1') {
    tabList.dataset.bound = '1';
    tabList.addEventListener('click', (event) => {
      const tab = event.target.closest('[data-category-tab]');
      if (!tab || !tabList.contains(tab)) return;
      tabList.renderCategoryChart(tab.dataset.categoryTab);
    });
    tabList.addEventListener('keydown', (event) => {
      const currentIndex = tabs.indexOf(event.target);
      if (currentIndex < 0) return;
      let nextIndex = currentIndex;
      if (event.key === 'ArrowRight') nextIndex = (currentIndex + 1) % tabs.length;
      else if (event.key === 'ArrowLeft') nextIndex = (currentIndex - 1 + tabs.length) % tabs.length;
      else if (event.key === 'Home') nextIndex = 0;
      else if (event.key === 'End') nextIndex = tabs.length - 1;
      else return;
      event.preventDefault();
      tabs[nextIndex].focus();
      tabList.renderCategoryChart(tabs[nextIndex].dataset.categoryTab);
    });
  }

  renderCategoryChart('found');
}
document.addEventListener('retrieva:paint', (event) => {
  if (event.detail && event.detail.module === 'dashboard') drawAdminCharts();
});
if (document.body && document.body.dataset.page === 'dashboard') drawAdminCharts();
