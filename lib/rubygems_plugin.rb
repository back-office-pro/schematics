# frozen_string_literal: true

Gem.post_install do |installer|
  Dir.chdir(installer.gem_dir) { `yarn` }
end
