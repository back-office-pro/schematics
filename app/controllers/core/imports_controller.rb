# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class ImportsController < Schematics::ResourcesController
  include Schematics::Nestable

  skip_authorize_resource only: %i[new create]
  before_action -> { authorize!(:import, parent_model_class) }, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
  helper_method :attributes

  def new
    super
    respond_to do |format|
      format.html
      format.csv do
        Schematics::GenerateCSVTemplateJob.perform_later(current_user, parent_model_class)
        head :accepted
      end
    end
  end

  protected

  def model_name = 'Import'

  def attributes = entity
    .fillable_elements
    .grep_v(Schematics::Attributes::Jsonb)
    .map { |attribute| attribute.tap { _1.options.merge!(required: true) } }

  def resource_defaults
    super.merge(model: parent_model_class.to_s)
  end
end
