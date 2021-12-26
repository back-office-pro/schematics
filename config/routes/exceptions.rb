# frozen_string_literal: true

get '404', to: 'exception#not_found'
get '500', to: 'exception#internal_server_error'
