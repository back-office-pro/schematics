# frozen_string_literal: true

require 'sidekiq/batch'

describe Sidekiq::Batch do
  it_behaves_like 'a monkey patched instance method',
                  :jobs,
                  'a4d38d0593383c6a227868c0f1a62931722ef2cf4f00360fa6ced810689945e2'

  it_behaves_like 'a monkey patched class method',
                  :enqueue_callbacks,
                  'f684542a62f5ba034000eae692e875b2eee09a5c3f725bf95b02d999cbfb3bb3'
end
