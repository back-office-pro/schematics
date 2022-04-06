# frozen_string_literal: false

# Make sure i18n translations are available
Rails.configuration.after_initialize do
  Chartkick.options = {
    colors: (::Setting.instance.palette rescue []),
    height: '300px',
    empty: ::I18n.t('schematics.application.resource.empty'),
    refresh: 60,
    # rubocop:disable Style/FormatStringToken
    html: <<~HTML,
      <div id='%{id}' class='chart' style='height: %{height}; width: %{width};'>
        <p class='card-text placeholder-glow'>
          #{"<span class='placeholder col-12 bg-light'></span>" * 16}
        </p>
      </div>
    HTML
    # rubocop:enable Style/FormatStringToken
    library: {
      # Google Charts
      backgroundColor: 'transparent',
      # Charts.js
      animation: {
        duration: 1000,
        easing: 'easeOutQuad'
      },
      title: {
        font: {
          size: 12
        }
      },
      scales: {
        y: {
          title: {
            font: {
              size: 12
            }
          }
        },
        x: {
          title: {
            font: {
              size: 12
            }
          }
        }
      }
    }
  }
end
