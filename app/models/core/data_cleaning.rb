# frozen_string_literal: true

class DataCleaning < Schematics::ApplicationRecord
  class << self
    def internal = %w[APIRequest Comparison Draft Search Session]
      .map { |model| find_or_initialize_by(model:) }
  end

  def model_class
    model.safe_constantize
  end

  def query_method
    return :delete_all if really_destroy?

    :destroy_all
  end

  def query_filters = { query_field => query_range }

  private

  def query_field
    return :created_at unless field

    field
      .split('#')
      .second
      .to_sym
  end

  def query_range
    ..1.public_send(period).ago
  end
end
