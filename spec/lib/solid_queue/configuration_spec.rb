# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'solid_queue/configuration'

describe SolidQueue::Configuration do
  it_behaves_like 'a monkey patched instance method',
                  :default_options,
                  '11bacf11fcda3899940dfc1c4b3e836c845d6f82fa1304434243379bb8c1aa14'
end
