# frozen_string_literal: true

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
