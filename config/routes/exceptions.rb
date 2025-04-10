# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

get '404', to: 'exception#not_found', as: :not_found
get '500', to: 'exception#internal_server_error', as: :internal_server_error
get '503', to: 'exception#maintenance_mode', as: :maintenance_mode
get 'offline', to: 'exception#offline', as: :offline
