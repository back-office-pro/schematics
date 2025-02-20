# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

ActiveSupport.on_load(:action_controller) do
  ActionController::Renderers.add(:svg) do |resource, _options|
    serializer = Schematics::SVGSerializer.new(resource)
    send_data serializer.content, filename: serializer.filename
  end
  ActionController::Renderers.add(:ics) do |resource, _options|
    serializer = Schematics::ICSSerializer.new(resource)
    send_data serializer.content, filename: serializer.filename
  end
end
