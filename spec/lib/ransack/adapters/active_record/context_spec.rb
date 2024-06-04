# frozen_string_literal: true

require 'ransack/adapters/active_record/context'

describe Ransack::Adapters::ActiveRecord::Context do
  it_behaves_like 'a monkey patched instance method',
                  :join_sources,
                  '9a93681ba31bc4396de713eae569088715ce579afd383e899fc809fc9d94672b'

  it_behaves_like 'a monkey patched instance method',
                  :build_joins,
                  'f06ac340b8f181661573bbbadb975027111385eb4b3cb3d43cdacf66668f6f78'
end
