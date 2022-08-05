# frozen_string_literal: true

ActiveSupport.on_load(:action_controller) do
  ActionController::Renderers.add(:svg) do |resource, _options|
    serializer = Schematics::SvgSerializer.new(resource)
    send_data serializer.file, filename: serializer.filename
  end
  ActionController::Renderers.add(:ics) do |resource, _options|
    serializer = Schematics::IcsSerializer.new(resource)
    send_data serializer.file, filename: serializer.filename
  end
end
