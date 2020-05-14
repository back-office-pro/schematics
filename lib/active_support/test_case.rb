module ActiveSupport
  class TestCase
    parallelize_setup do |worker|
      Searchkick.index_suffix = worker
      Searchkick.disable_callbacks
    end
  end
end
