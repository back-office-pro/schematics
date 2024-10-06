# frozen_string_literal: true

module Core
  module DataCleanings
    class Run
      include Interactor

      delegate :data_cleaning, to: :context, private: true
      delegate :model_class,
               :query_field,
               :query_range,
               :query_method,
               to: :data_cleaning,
               private: true

      def call = model_class
        .preload_all
        .where(query_field => query_range)
        .find_each(&query_method)
    end
  end
end
