# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Licensable
    extend ActiveSupport::Concern

    included do
      before_create :authorize_create!
      before_restore :authorize_restore!
    end

    private

    def authorize_create!
      throw :abort if ability.cannot?(:create, self)
    end

    def authorize_restore!
      throw :abort if ability.cannot?(:restore, self)
    end

    def ability
      @ability ||= RecordAbility.new.merge(LicenseAbility.new)
    end
  end
end
