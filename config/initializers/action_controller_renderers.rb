# frozen_string_literal: true

ActiveSupport.on_load(:action_controller) do
  ActionController::Renderers.add(:csv) do |resources, _options|
    send_data Schematics::CsvSerializer.new(resources).to_csv,
              filename: "#{model_name_plural.dasherize}-#{I18n.l(Time.current)}.csv"
  end
  ActionController::Renderers.add(:xls) do |resources, _options|
    send_data Schematics::CsvSerializer.new(resources).to_xls,
              filename: "#{model_name_plural.dasherize}-#{I18n.l(Time.current)}.xls"
  end
end
