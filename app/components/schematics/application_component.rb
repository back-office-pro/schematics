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

module Schematics
  class ApplicationComponent < ::ViewComponent::Base
    include ::Pagy::Method
    include ::Turbo::StreamsHelper
    include ::Turbo::FramesHelper
    include ::Turbo::DriveHelper
    include ::Importmap::ImportmapTagsHelper
    include ApplicationHelper
    include ResourcesHelper
    extend ::Dry::Initializer

    delegate :current_user,
             :current_ability,
             :can?,
             :cannot?,
             :content_security_policy_nonce,
             :content_security_policy?,
             to: :helpers

    def to_html = ApplicationController
      .new
      .view_context
      .render(self)
  end
end
