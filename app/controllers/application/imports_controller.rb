# frozen_string_literal: true

module Application
  module ImportsController
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Nestable
      skip_authorize_resource only: %i[new create]
      before_action -> { authorize!(:import, parent_model_class) }, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
    end

    def new
      super
      respond_to do |format|
        format.html
        format.csv do
          Schematics::GenerateCsvTemplateJob.perform_later(current_user, parent_model_class)
          head :accepted
        end
      end
    end

    def resource_defaults
      super.merge(model: parent_model_class.to_s)
    end
  end
end
