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
  module Attributes
    class RichText < Attribute
      include Behaviours::Renderable
      include Behaviours::Multisearchable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Fillable
      include Behaviours::Translatable

      def available_options = super.excluding(Options::Default)

      def default = 'MyRichText'

      def format(value)
        value&.to_plain_text
      end

      def icon = :align_justify

      def preload = [association_name => [embeds_attachments: :blob]]
        .concat(super)
        .compact

      def search_column = :"#{search_column_association}_body"

      def search_column_association = "rich_text_#{name}"

      def to_sql = 'action_text_rich_texts.body'

      def to_str
        if translated?
          <<~RUBY
            translates :#{name}, backend: :action_text, column_fallback: false
          RUBY
        else
          <<~RUBY
            has_rich_text :#{name}, store_if_blank: false
          RUBY
        end
      end

      def translatable_type = 'rich_text'

      private

      def association_name = [type, name]
        .join('_')
        .to_sym
    end
  end
end
