ActiveSupport.on_load(:action_controller) do
  ActionController::Renderers.add(:csv) do |records, options|
    filename = "#{model_name.human.downcase.pluralize.dasherize}-#{I18n.l(Time.current)}.csv"
    send_data Schematics::CsvSerializer.new(records).to_csv, filename: filename
  end
  ActionController::Renderers.add(:xls) do |records, options|
    filename = "#{model_name.human.downcase.pluralize.dasherize}-#{I18n.l(Time.current)}.xls"
    send_data Schematics::CsvSerializer.new(records).to_xls, filename: filename
  end
end
