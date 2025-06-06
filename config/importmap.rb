# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

pin '@rails/actiontext', to: 'actiontext.esm.js'
pin '@hotwired/turbo-rails', to: 'turbo.js'
pin '@hotwired/stimulus', to: 'stimulus.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'

pin 'chartkick', to: 'chartkick.js'
pin 'Chart.bundle', to: 'Chart.bundle.js'

pin 'schematics/application'

pin_all_from Rails.root.join('app/javascript/controllers'), under: 'controllers'
pin_all_from Schematics::Engine.root.join('app', 'assets', 'javascripts', 'schematics', 'controllers'), # rubocop:disable Layout/LineLength
             under: 'controllers',
             to: 'schematics/controllers'

pin '@fortawesome/fontawesome-free', to: '@fortawesome/fontawesome-free/js/fontawesome.js'
pin '@github/hotkey', to: '@github/hotkey/dist/index.js'
pin '@popperjs/core', to: 'https://unpkg.com/@popperjs/core@2.11.8/dist/esm/index.js'
pin 'autosize', to: 'autosize/dist/autosize.esm.js'
pin 'bootstrap', to: 'bootstrap/dist/js/bootstrap.esm.js'
pin 'crisp-sdk-web', to: 'crisp-sdk-web/dist/crisp.esm.js'
pin 'file-saver', to: 'file-saver-es/src/FileSaver.js'
pin 'monaco-editor', to: 'https://cdn.jsdelivr.net/npm/monaco-editor@0.52.2/+esm'
pin 'path', to: 'https://ga.jspm.io/npm:@jspm/core@2.1.0/nodelibs/browser/path.js'
pin 'pluralize', to: 'pluralize-esm/dist/index.js'
pin 'rollbar', to: 'https://ga.jspm.io/npm:rollbar@2.26.4/dist/rollbar.umd.js'
pin 'sortablejs', to: 'sortablejs/modular/sortable.esm.js'
pin 'swagger-ui-dist', to: 'https://ga.jspm.io/npm:swagger-ui-dist@5.24.0/index.js'
pin 'timeago.js', to: 'https://unpkg.com/timeago.js@4.0.2/esm/index.js'
pin 'timeago.fr.js', to: 'https://unpkg.com/timeago.js@4.0.2/esm/lang/fr.js'
pin 'timeago.it.js', to: 'https://unpkg.com/timeago.js@4.0.2/esm/lang/it.js'
pin 'tom-select', to: 'tom-select/dist/esm/tom-select.complete.js'
pin 'tributejs', to: 'tributejs/dist/tribute.esm.js'
pin 'trix', to: 'trix/dist/trix.esm.js'
