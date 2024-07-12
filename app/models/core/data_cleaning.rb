# frozen_string_literal: true

class DataCleaning < Schematics::ApplicationRecord
  class << self
    def internal = find_or_initialize_by(model: %w[Comparison Draft Search Session])
  end

  def model_class
    model.safe_constantize
  end

  def query_method
    return :delete_all if really_destroy?

    :destroy_all
  end

  def query_fields = { field.to_sym => ..1.public_send(period).ago }
end
