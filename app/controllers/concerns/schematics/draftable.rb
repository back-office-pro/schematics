# frozen_string_literal: true

module Schematics
  module Draftable
    extend ActiveSupport::Concern

    included do
      before_action :set_draft, only: %i[new edit create update] # rubocop:disable Rails/LexicallyScopedActionFilter
    end

    private

    def set_draft
      @draft = current_user.drafts.find_by(action: polymorphic_path(@resource || model_class))
    end
  end
end
