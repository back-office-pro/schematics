# frozen_string_literal: true

pin 'chartkick', to: 'chartkick.js', preload: true
pin 'Chart.bundle', to: 'Chart.bundle.js', preload: true
pin 'schematics/application', preload: true
pin 'pagy-module', preload: true

pin_all_from Schematics::Engine.root.join('app', 'assets', 'javascripts', 'schematics', 'controllers'), # rubocop:disable Layout/LineLength
             under: 'controllers',
             to: 'schematics/controllers',
             preload: true

pin '@fortawesome/fontawesome-free', to: 'https://unpkg.com/@fortawesome/fontawesome-free@6.2.1/js/fontawesome.js'
pin '@github/hotkey', to: 'https://unpkg.com/@github/hotkey@2.0.1/dist/index.js'
pin '@popperjs/core', to: 'https://unpkg.com/@popperjs/core@2.11.6/dist/esm/index.js'
pin 'autosize', to: 'https://unpkg.com/autosize@5.0.2/dist/autosize.esm.js'
pin 'bootstrap', to: 'https://unpkg.com/bootstrap@5.2.3/dist/js/bootstrap.esm.js'
pin 'path', to: 'https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.27/nodelibs/browser/path.js'
pin 'rollbar', to: 'https://ga.jspm.io/npm:rollbar@2.26.0/dist/rollbar.umd.js'
pin 'slim-select', to: 'https://unpkg.com/slim-select@1.27.1/dist/slimselect.min.mjs'
pin 'sortablejs', to: 'https://unpkg.com/sortablejs@1.15.0/modular/sortable.esm.js'
pin 'swagger-ui-dist', to: 'https://ga.jspm.io/npm:swagger-ui-dist@4.15.5/index.js'
pin 'timeago.js', to: 'https://unpkg.com/timeago.js@4.0.2/esm/index.js'
pin 'timeago.fr.js', to: 'https://unpkg.com/timeago.js@4.0.2/esm/lang/fr.js'
pin 'tributejs', to: 'https://unpkg.com/tributejs@5.1.3/dist/tribute.esm.js'
