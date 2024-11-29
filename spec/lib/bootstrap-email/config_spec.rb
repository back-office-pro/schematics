# frozen_string_literal: true

require 'bootstrap-email/config'

describe BootstrapEmail::Config do
  it_behaves_like 'a monkey patched instance method',
                  :config_for_option,
                  'fea04a68bcd12f77a5c4691c6241422d9659f05cad12f8bbd78ec84b0d99596e'
end
