# frozen_string_literal: true

require 'solid_queue/configuration'

describe SolidQueue::Configuration do
  it_behaves_like 'a monkey patched instance method',
                  :config_from,
                  '18af6f31d538af20590ef92ed70c43b37f9c41a4483d397e1f72c346c333363e'
end
