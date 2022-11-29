# frozen_string_literal: false

# Make sure i18n translations are available
Rails.configuration.after_initialize do
  Chartkick.options.merge!(
    height: '300px',
    empty: ::I18n.t('schematics.application.resource.empty'),
    refresh: 60,
    html: Schematics::ChartPlaceholder::Component.new.to_html,
    content_for: :charts_js,
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
  )
end
