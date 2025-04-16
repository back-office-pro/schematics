# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::DataCleaning < Schematics::ApplicationRecord
  class << self
    def internal = %w[APIRequest Backup Comparison Draft LinkPreview Search Session]
      .map { |model| find_or_initialize_by(model:) }
  end

  def model_class
    model.safe_constantize
  end

  def query_method
    return :really_destroy! if really_destroy?

    :destroy!
  end

  def query_field
    return :created_at unless field

    field
      .split('#')
      .last
      .to_sym
  end

  def query_range
    ..1.public_send(period).ago
  end
end
