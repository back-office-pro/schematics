# frozen_string_literal: true

pin 'chartkick', to: 'chartkick.js', preload: true
pin 'Chart.bundle', to: 'Chart.bundle.js', preload: true
pin 'pagy-module'
pin 'routes'

pin_all_from Schematics::Engine.root.join('app', 'assets', 'javascripts', 'schematics', 'controllers'), # rubocop:disable Layout/LineLength
             under: 'controllers',
             to: 'schematics/controllers',
             preload: true

pin '@client-side-validations/client-side-validations', to: 'https://ga.jspm.io/npm:@client-side-validations/client-side-validations@0.3.0/dist/client-side-validations.esm.js'
pin '@client-side-validations/simple-form', to: '/assets/@client-side-validations/simple-form/dist/simple-form.bootstrap4.esm.js' # rubocop:disable Layout/LineLength
pin '@fortawesome/fontawesome-free', to: 'https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.1.1/js/fontawesome.js'
pin '@popperjs/core', to: 'https://ga.jspm.io/npm:@popperjs/core@2.11.5/dist/esm/index.js'
pin 'autosize', to: 'https://ga.jspm.io/npm:autosize@5.0.1/dist/autosize.esm.js'
pin 'bootstrap', to: 'https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.esm.js'
pin 'file-saver', to: 'https://ga.jspm.io/npm:file-saver@2.0.5/dist/FileSaver.min.js'
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js'
pin 'path', to: 'https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/path.js'
pin 'rollbar', to: 'https://ga.jspm.io/npm:rollbar@2.25.0/dist/rollbar.umd.min.js'
pin 'slim-select', to: 'https://ga.jspm.io/npm:slim-select@1.27.1/dist/slimselect.min.mjs'
pin 'sortablejs', to: 'https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js'
pin 'swagger-ui-dist', to: 'https://ga.jspm.io/npm:swagger-ui-dist@4.12.0/index.js'
pin 'timeago.js', to: '/assets/timeago.js/esm/index.js'
pin 'timeago.fr.js', to: '/assets/timeago.js/esm/lang/fr.js'
pin 'tributejs', to: 'https://ga.jspm.io/npm:tributejs@5.1.3/dist/tribute.min.js'
