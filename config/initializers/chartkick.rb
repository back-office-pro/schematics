# rubocop:disable Style/FormatStringToken
Chartkick.options = {
  colors: ['#2c3e50'],
  height: '300px',
  html: <<~HTML,
    <div id="%{id}"
      class="text-light text-center"
      style="height: %{height}; width: %{width}; line-height: %{height};">
      <i class="fas fa-spinner fa-spin fa-6x"></i>
    </div>
  HTML
  library: {
    # Google Charts
    backgroundColor: 'transparent',
    # Charts.js
    animation: {
      duration: 1000,
      easing: 'easeOutQuad',
    },
  },
}
# rubocop:enable Style/FormatStringToken
