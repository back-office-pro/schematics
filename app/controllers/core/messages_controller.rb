# frozen_string_literal: true

module Core
  # :reek:MissingSafeMethod
  class MessagesController < Schematics::ResourcesController
    before_action :read!, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter

  def read!
    return if @resource.recipients.exclude?(current_user)

      Schematics::Version
        .where(event: 'show', item: @resource, user: current_user)
        .first_or_create!
    end
  end
end
