# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module EmailTemplate
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Interpolable
    end
  end
end
