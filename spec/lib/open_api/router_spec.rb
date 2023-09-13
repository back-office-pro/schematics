# frozen_string_literal: true

require 'open_api/router'

describe OpenApi::Router do
  it_behaves_like 'a monkey patched instance method',
                  :routes,
                  'dd1b3554c4e9243762da72276a1647b35adc8f172875e9bc36424620efc53d10'
end
