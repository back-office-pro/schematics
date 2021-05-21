# frozen_string_literal: true

ActiveSupport.on_load(:action_controller) do
  ActionController::Renderers.add(:csv) do |resources, _options|
    filename = "#{model_name.human.downcase.pluralize.dasherize}-#{I18n.l(Time.current)}.csv"
    send_data Schematics::CsvSerializer.new(resources).to_csv, filename: filename
  end
  ActionController::Renderers.add(:xls) do |resources, _options|
    filename = "#{model_name.human.downcase.pluralize.dasherize}-#{I18n.l(Time.current)}.xls"
    send_data Schematics::CsvSerializer.new(resources).to_xls, filename: filename
  end
end
