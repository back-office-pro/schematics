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
  module Nestable
    extend ActiveSupport::Concern

    included do
      helper_method :parent_model_class
      helper_method :record
      delegate :human_name,
               :human_name_plural,
               :gender,
               to: :parent_model_class,
               prefix: :parent,
               allow_nil: true
    end

    def view_assigns = super.merge(parent_human_name_plural:)

    protected

    def parent_model_class = ::SchemaCache
      .entities
      .to_h { [_1.class_name, _1.model_class] }
      .fetch(parent_model_name)

    def parent_model_name = resolve_model_name_from_route

    def record = parent_model_class
      .preload_all
      .with_string_translations
      .load_async
      .finder(params[:id])

    def set_breadcrumb
      return unless can?(:index, parent_model_class)

      title = t('titles.schematics.resources.index', human_name_plural: parent_human_name_plural)
      breadcrumb title, resources_path(parent_model_class)
    end
  end
end
