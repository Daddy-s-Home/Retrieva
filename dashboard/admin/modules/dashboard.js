function drawAdminCharts() {
  if (!window.Chart) return;
  const node = document.getElementById('admin-chart-data');
  const trend = document.getElementById('admin-trend-chart');
  const categories = document.getElementById('admin-category-chart');
  if (!node || !trend) return;
  const data = JSON.parse(node.textContent || '{}');
  if (trend._chart) trend._chart.destroy();
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
  if (!categories) return;
  if (categories._chart) categories._chart.destroy();
  const slices = data.categories || [];
  categories._chart = new window.Chart(categories, {
    type: 'doughnut',
    data: {
      labels: slices.map((row) => row.label),
      datasets: [{ data: slices.map((row) => row.total), backgroundColor: ['#0b3d91', '#c9a227', '#1f8a5b', '#6b4ea2', '#c44747', '#5c6b7a'] }],
    },
    options: { responsive: true, plugins: { legend: { position: 'bottom' } } },
  });
}
document.addEventListener('retrieva:paint', (event) => {
  if (event.detail && event.detail.module === 'dashboard') drawAdminCharts();
});
if (document.body && document.body.dataset.page === 'dashboard') drawAdminCharts();
