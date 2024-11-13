# frozen_string_literal: true

require 'fx'
require 'fx/adapters/postgres'

describe Fx::Adapters::Postgres do
  it_behaves_like 'a monkey patched instance method',
                  :functions,
                  'c5812ab489c9a0e844dbd06b1baa6a6289af4d836dfec8ced7d1242359139575'

  it_behaves_like 'a monkey patched instance method',
                  :triggers,
                  '391051b975140a1eaa63ad986ab1a96894e114e40f7605f54986d204315a5652'
end
