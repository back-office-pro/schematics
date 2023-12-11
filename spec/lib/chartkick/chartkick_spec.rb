# frozen_string_literal: true

require 'rails'
require 'chartkick'

describe Chartkick do
  it_behaves_like 'a monkey patched class method',
                  :options,
                  '7c0c51d30126b00952b6097090dd8e80b4b48c2ff0504c731382939a3ea79db0'
end
