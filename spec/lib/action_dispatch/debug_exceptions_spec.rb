# frozen_string_literal: true

require 'action_dispatch/middleware/debug_exceptions'

describe ActionDispatch::DebugExceptions do
  it_behaves_like 'a monkey patched instance method',
                  :render_exception,
                  'acc75a7eb74d8e60c86951ed9c63b13ca8b4a0b9ad0a9f68f09d8e03f9e6be62'
end
