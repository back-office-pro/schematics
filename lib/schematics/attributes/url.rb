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
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Url < String
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      delegate :schemes, to: :options

      def available_options = super
        .excluding(Options::CaseInsensitive)
        .push(Options::Schemes)

      def case_insensitive? = true

      def default = ::URI
        .const_get(schemes&.first&.upcase || :HTTPS)
        .build(host: "www.#{SecureRandom.base58}.com")
        .to_s

      def openai_description = 'An attribute which represents a URL'

      def icon = :wifi

      def normalization = :downcase

      def validators = super.merge(
        url: { allow_blank:, schemes: }
      )
    end
  end
end
