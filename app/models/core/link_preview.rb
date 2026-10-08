# frozen_string_literal: true

class ::LinkPreview < Schematics::ApplicationRecord
  def title
    super || url
  end
end
