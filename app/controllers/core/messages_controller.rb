# frozen_string_literal: true

module Core
  module MessagesController
    extend ActiveSupport::Concern

    prepended do
      before_action :read!, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter
    end

    def read!
      return if @resource.users.exclude?(current_user)

      Schematics::Version
        .where(event: 'show', item: @resource, user: current_user)
        .first_or_create!
    end
  end
end
