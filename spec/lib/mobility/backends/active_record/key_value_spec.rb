# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_record'
require 'mobility'
require 'mobility/backends/active_record/key_value'

describe Mobility::Backends::ActiveRecord::KeyValue do
  it_behaves_like 'a monkey patched class method',
                  :define_has_many_association,
                  '9374dc8f6150d7595a8269867203a03d79cdfb44cd34f6f00ab71fd5c3cc8114'
end
