# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'puma'
require 'puma/configuration'

describe Puma::Configuration do
  it_behaves_like 'a monkey patched instance method',
                  :config_files,
                  '4827f23bf69d1b2bbb33c47f85cba7862d325fe2e6a71ce1984df3f38a1a0e21'
end
