SimpleForm.setup do |config|
  config.wrapper_mappings = {
    boolean: :custom_boolean_switch,
    check_boxes: :custom_collection,
    date: :custom_multi_select,
    datetime: :custom_multi_select,
    file: :custom_file,
    radio_buttons: :custom_collection,
    range: :custom_range,
    time: :custom_multi_select,
  }
end
