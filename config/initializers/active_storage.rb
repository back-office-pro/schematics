# frozen_string_literal: true

ActiveSupport.on_load(:active_storage_attachment) do
  ActiveStorage::Attachment.class_eval do
    acts_as_paranoid
    # has_paper_trail only: [:blob_id],
    #                 meta: { item_type: :record_type, item_id: :record_id },
    #                 on: [:create]
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
