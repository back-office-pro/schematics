# frozen_string_literal: true

require 'paranoia'

describe Paranoia do
  it_behaves_like 'a monkey patched instance method',
                  :each_counter_cached_associations,
                  'e286a3429f284acfdff6cb1b30e50755266602c7ee101f3ed2eb3eb08be6ef6d'
end
