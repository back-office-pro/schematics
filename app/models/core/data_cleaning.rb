# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
