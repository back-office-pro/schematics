# frozen_string_literal: true

Gem.post_install do |installer|
  `cd #{installer.gem_dir} && yarn`
end
