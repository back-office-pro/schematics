# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class MessagesController < Schematics::ResourcesController
  before_action :read!, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter

  private

  def read!
    return if @resource.recipients.exclude?(current_user)

    Schematics::NotifyJob.perform_later(@resource, 'show', current_user)
  end
end
