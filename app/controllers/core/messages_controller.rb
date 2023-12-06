# frozen_string_literal: true

# :reek:MissingSafeMethod
class MessagesController < Schematics::ResourcesController
  before_action :read!, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :set_draft, only: %i[reply new edit create duplicate update] # rubocop:disable Rails/LexicallyScopedActionFilter

  def reply
    breadcrumb @resource.to_s, @resource
    @resource = @resource.new_reply
    render :new
  end

  private

  def read!
    return if @resource.recipients.exclude?(current_user)

    Schematics::Version
      .where(event: 'show', item: @resource, user: current_user)
      .first_or_create!
  end
end
