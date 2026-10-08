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

    class << self
      def inherited(subclass)
        super
        subclass.class_eval do
          slim_template module_parent::SLIM if module_parent.const_defined?(:SLIM)
        end
      end
    end

    delegate :current_user,
             :current_ability,
             :can?,
             :cannot?,
             :content_security_policy_nonce,
             :content_security_policy?,
             to: :helpers

    def format = :html

    def to_html = ApplicationController
      .new
      .view_context
      .render(self)
  end
end
