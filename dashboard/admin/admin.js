function drawReportCharts() {
  if (!window.Chart) return;
  const node = document.getElementById('reports-chart-data');
  const trend = document.getElementById('reports-trend-chart');
  const categories = document.getElementById('reports-category-chart');
  if (!node || !trend || !categories) return;
  let data = {};
  try {
    data = JSON.parse(node.textContent || '{}');
  } catch (error) {
    return;
  }
  if (trend._chart) trend._chart.destroy();
  trend._chart = new window.Chart(trend, {
    type: 'bar',
    data: {
      labels: data.days || [],
      datasets: [
        { label: 'Lost', data: data.lost || [], backgroundColor: '#0b3d91' },
        { label: 'Found', data: data.found || [], backgroundColor: '#c9a227' },
      ],
    },
    options: { responsive: true, plugins: { legend: { position: 'bottom' } } },
  });
  if (categories._chart) categories._chart.destroy();
  categories._chart = new window.Chart(categories, {
    type: 'bar',
    data: {
      labels: data.categories || [],
      datasets: [
        { label: 'Lost', data: data.category_lost || [], backgroundColor: '#0b3d91' },
        { label: 'Found', data: data.category_found || [], backgroundColor: '#c9a227' },
      ],
    },
    options: { responsive: true, plugins: { legend: { position: 'bottom' } } },
  });
}

document.addEventListener('retrieva:paint', function (event) {
  if (!event.detail || event.detail.module === 'reports') drawReportCharts();
});
if (document.body && document.body.dataset.page === 'reports') drawReportCharts();
