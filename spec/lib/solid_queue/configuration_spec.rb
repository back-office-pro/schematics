# frozen_string_literal: true

require 'solid_queue/configuration'

describe SolidQueue::Configuration do
  it_behaves_like 'a monkey patched instance method',
                  :config_from,
                  'b7a9d152abba7d24d6c7c817b058b5b43689d0a9d635cb87f1e63a8a8031abdf'
end
