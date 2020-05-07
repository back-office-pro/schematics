Rails.application.config.assets.paths << Pagy.root.join('javascripts')
Rails.application.config.assets.precompile += %w(schematics/themes/*.css schematics/mailer.css)
