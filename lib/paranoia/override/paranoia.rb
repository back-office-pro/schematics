# frozen_string_literal: true

# TODO: remove when https://github.com/rubysherpas/paranoia/pull/554 is released
module Paranoia
  module Override
    private

    def counter_cache_disabled?
      defined?(@_disable_counter_cache) && @_disable_counter_cache
    end

    def counter_cached_association_names
      return [] if counter_cache_disabled?

      super
    end

    def each_counter_cached_associations
      return [] if counter_cache_disabled?

      super
    rescue NoMethodError
      counter_cached_association_names.each do |name|
        yield association(name)
      end
    end
  end
end
