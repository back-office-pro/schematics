# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

get '/:resource', to: 'schematics/routing#index', as: :resources
get '/:resource/new', to: 'schematics/routing#new', as: :new_resource
post '/:resource', to: 'schematics/routing#create'
get '/:resource/:id/edit', to: 'schematics/routing#edit', as: :edit_resource
get '/:resource/:id', to: 'schematics/routing#show', as: :resource
patch '/:resource/:id', to: 'schematics/routing#update'
put '/:resource/:id', to: 'schematics/routing#update'
delete '/:resource/:id', to: 'schematics/routing#destroy'
delete '/:resource/:id/archive', to: 'schematics/routing#archive', as: :archive_resource
delete '/:resource/:id/restore', to: 'schematics/routing#restore', as: :restore_resource
post '/:resource/:id/duplicate', to: 'schematics/routing#duplicate', as: :duplicate_resource
get '/:resource/:id/delete', to: 'schematics/routing#delete', as: :delete_resource
get '/:resource/imports/new', to: 'imports#new', as: :new_import_resource
post '/:resource/imports', to: 'imports#create', as: :import_resource
post '/:resource/comparisons', to: 'comparisons#create', as: :compare_resource
post '/:resource/bulk_actions', to: 'schematics/bulk_actions#create', as: :bulk_resource
post '/:resource/autocompletions', to: 'schematics/autocompletions#create', as: :autocomplete_resource # rubocop:disable Layout/LineLength
get '/:resource/:id/comments/new', to: 'comments#new', as: :new_comment_resource
get '/:resource/:id/emailings/new', to: 'emailings#new', as: :new_emailing_resource
post '/:resource/:id/comments', to: 'comments#create', as: :comment_resource
post '/:resource/:id/emailings', to: 'emailings#create', as: :emailing_resource
patch '/:resource/:id/:state/:event', to: 'schematics/routing#trigger', as: :trigger_resource
