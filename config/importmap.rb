# frozen_string_literal: true

pin 'trix', preload: true
pin '@rails/actiontext', to: 'actiontext.js', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true

pin 'chartkick', to: 'chartkick.js', preload: true
pin 'Chart.bundle', to: 'Chart.bundle.js', preload: true
pin 'pagy-module', preload: true

pin 'application', preload: true if Rails.root.join('app/javascript/application.js').exist?
pin 'schematics/application', preload: true

pin_all_from Rails.root.join('app/javascript/controllers'),
             under: 'controllers',
             preload: true
pin_all_from Schematics::Engine.root.join('app', 'assets', 'javascripts', 'schematics', 'controllers'), # rubocop:disable Layout/LineLength
             under: 'controllers',
             to: 'schematics/controllers',
             preload: true

pin '@fortawesome/fontawesome-free', to: '@fortawesome/fontawesome-free/js/fontawesome.js', preload: true # rubocop:disable Layout/LineLength
pin '@github/hotkey', to: '@github/hotkey/dist/index.js', preload: true
pin '@popperjs/core', to: 'https://unpkg.com/@popperjs/core@2.11.7/dist/esm/index.js', preload: true
pin 'autosize', to: 'autosize/dist/autosize.esm.js', preload: true
pin 'bootstrap', to: 'bootstrap/dist/js/bootstrap.esm.js', preload: true
pin 'path', to: 'https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/path.js', preload: true
pin 'rollbar', to: 'https://ga.jspm.io/npm:rollbar@2.26.1/dist/rollbar.umd.js', preload: true
pin 'sortablejs', to: 'sortablejs/modular/sortable.esm.js', preload: true
pin 'swagger-ui-dist', to: 'https://ga.jspm.io/npm:swagger-ui-dist@4.18.1/index.js', preload: true
pin 'timeago.js', to: 'https://unpkg.com/timeago.js@4.0.2/esm/index.js', preload: true
pin 'timeago.fr.js', to: 'https://unpkg.com/timeago.js@4.0.2/esm/lang/fr.js', preload: true
pin 'tom-select', to: 'tom-select/dist/esm/tom-select.complete.js', preload: true
pin 'tributejs', to: 'tributejs/dist/tribute.esm.js', preload: true
