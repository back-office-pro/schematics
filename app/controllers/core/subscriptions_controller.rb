# frozen_string_literal: true

class SubscriptionsController < Schematics::ResourcesController
  protected

  def resource_path = admin_path
end
