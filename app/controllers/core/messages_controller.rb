# frozen_string_literal: true

# :reek:MissingSafeMethod
class MessagesController < Schematics::ResourcesController
  before_action :read!, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :set_draft, only: %i[reply new edit create duplicate update]

  def reply; end

  private

  def i18n_title_path = 'messages'

  private

  def read!
    return if @resource.recipients.exclude?(current_user)

    Schematics::Version
      .where(event: 'show', item: @resource, user: current_user)
      .first_or_create!
  end
end
