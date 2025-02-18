# frozen_string_literal: true

class SubscriptionsController < Schematics::ResourcesController
  protected

  def show_path = admin_path
end
