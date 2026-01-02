# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module ActiveStorage
  class AttachmentAbility < Schematics::ApplicationAbility
    def initialize(user)
      super
      parent_correlation_table.each do |action, permission|
        user
          .role
          .permissions
          .select { _1.action == action.to_s }
          .map(&:model)
          .select(&Object.method(:const_defined?))
          .each { |record_type| can(permission, ::ActiveStorage::Attachment, record_type:) }
      end
      cannot :destroy, ::ActiveStorage::Attachment, record_type: 'Import'
      cannot :read, ::ActiveStorage::Attachment, record_type: 'ActiveStorage::VariantRecord'
    end

    private

    def parent_correlation_table = { update: :destroy, show: :read }
  end
end
