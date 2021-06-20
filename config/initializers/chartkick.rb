# frozen_string_literal: false

require 'chroma'

# Make sure i18n translations are available
Rails.configuration.after_initialize do
  Chartkick.options = {
    colors: '#2c3e50'.paint.palette.analogous(as: :hex),
    height: '300px',
    empty: I18n.t('schematics.application.resource.empty'),
    refresh: 60,
    # rubocop:disable Style/FormatStringToken
    html: <<~HTML,
      <div id="%{id}" class="text-light text-center" style="height: %{height}; width: %{width}; line-height: %{height};">
        <i class="fas fa-spinner fa-spin fa-6x"></i>
      </div>
    HTML
    # rubocop:enable Style/FormatStringToken
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
end
