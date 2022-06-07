# frozen_string_literal: true

ActiveSupport.on_load(:active_record) do
  connection = ActiveRecord::Base.remove_connection
  ActiveRecord::Base.establish_connection(:development)
  sql = <<~SQL.squish
    SELECT data
    FROM schema_datasets
    WHERE state IN (1, 2)
    ORDER BY created_at DESC
    LIMIT 1
  SQL
  data = ActiveRecord::Base
         .connection
         .execute(sql)
         .first
         &.fetch('data')
  Schematics::Schema.instance.load(::JSON.parse(data)) if data
rescue ActiveRecord::StatementInvalid
  nil
ensure
  ActiveRecord::Base.establish_connection(connection)
end
