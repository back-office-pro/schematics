# frozen_string_literal: true

get '/:resource',
    to: 'schematics/routing#index',
    constraints: { format: %w[html json turbo_stream csv pdf svg ics] },
    as: :resources
get '/:resource/new',
    to: 'schematics/routing#new',
    constraints: { format: %w[html turbo_stream] },
    as: :new_resource
post '/:resource',
     to: 'schematics/routing#create',
     constraints: { format: %w[html json turbo_stream] }
get '/:resource(/:id)/edit',
    to: 'schematics/routing#edit',
    constraints: { format: %w[html turbo_stream] },
    as: :edit_resource
get '/:resource(/:id)',
    to: 'schematics/routing#show',
    constraints: { format: %w[html json turbo_stream pdf svg ics] },
    as: :resource
patch '/:resource(/:id)',
      to: 'schematics/routing#update',
      constraints: { format: %w[html json turbo_stream] }
put '/:resource(/:id)',
    to: 'schematics/routing#update',
    constraints: { format: %w[html json turbo_stream] }
delete '/:resource/:id',
       to: 'schematics/routing#destroy',
       constraints: { format: %w[html json turbo_stream] }
delete '/:resource/:id/archive',
       to: 'schematics/routing#archive',
       constraints: { format: %w[html json turbo_stream] },
       as: :archive_resource
delete '/:resource/:id/restore',
       to: 'schematics/routing#restore',
       constraints: { format: %w[html json turbo_stream] },
       as: :restore_resource
post '/:resource/:id/duplicate',
     to: 'schematics/routing#duplicate',
     constraints: { format: %w[html json turbo_stream] },
     as: :duplicate_resource
get '/:resource/:id/delete',
    to: 'schematics/routing#delete',
    constraints: { format: %w[html turbo_stream] },
    as: :delete_resource
get '/:resource/imports/new',
    to: 'imports#new',
    constraints: { format: %w[html turbo_stream csv] },
    as: :new_import_resource
post '/:resource/imports',
     to: 'imports#create',
     constraints: { format: %w[html json turbo_stream] },
     as: :import_resource
post '/:resource/comparisons',
     to: 'comparisons#create',
     constraints: { format: :json },
     as: :compare_resource
post '/:resource/bulk_actions',
     to: 'schematics/bulk_actions#create',
     constraints: { format: :json },
     as: :bulk_resource
post '/:resource/autocompletions',
     to: 'schematics/autocompletions#create',
     constraints: { format: :json },
     as: :autocomplete_resource
get '/:resource(/:id)/comments/new',
    to: 'comments#new',
    constraints: { format: %w[html turbo_stream] },
    as: :new_comment_resource
get '/:resource(/:id)/emailings/new',
    to: 'emailings#new',
    constraints: { format: %w[html turbo_stream] },
    as: :new_emailing_resource
post '/:resource(/:id)/comments',
     to: 'comments#create',
     constraints: { format: %w[html json turbo_stream] },
     as: :comment_resource
post '/:resource(/:id)/emailings',
     to: 'emailings#create',
     constraints: { format: %w[html json turbo_stream] },
     as: :emailing_resource
patch '/:resource(/:id)/:state/:event',
      to: 'schematics/routing#trigger',
      constraints: { format: %w[html json turbo_stream] },
      as: :trigger_resource
