# frozen_string_literal: true

# Make sure we override main app 6.0 defaults
Rails.application.config.active_storage.replace_on_assign_to_many = false

ActiveSupport.on_load(:active_storage_attachment) do
  ActiveStorage::Attachment.class_eval do
    acts_as_paranoid
  end
end

ActiveSupport.on_load(:active_storage_blob) do
  ActiveStorage::Blob.class_eval do
    acts_as_paranoid
  end
end

ActiveSupport.on_load(:active_storage_variant) do
  ActiveStorage::Variant.class_eval do
    acts_as_paranoid
  end
end
