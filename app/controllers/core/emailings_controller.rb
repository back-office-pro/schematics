# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class EmailingsController < Schematics::ResourcesController
  include Schematics::Nestable

  skip_authorize_resource only: %i[new create]
  before_action :authorize_create!, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter

  protected

  def authorize_create!
    authorize!(:show, record)
    authorize!(:email, parent_model_class)
  end

  def model_name = 'Emailing'

  def record
    @resource.try(:record) || super
  end

  def resource_defaults = super.merge(record:)
end
