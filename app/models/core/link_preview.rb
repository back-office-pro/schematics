# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ::LinkPreview < Schematics::ApplicationRecord
  def title
    super || url
  end
end
