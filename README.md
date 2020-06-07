# Schematics
Dependencies choices details.

### Searching, Sorting, filterting

:star: **searchkick**
- We need the elasticsearch daemon
- Most recent and popular solution
- Most performant
- Suggestions
- Scalable
- Easier eager loading, no need for joins
- Enable search in *Text* and *RichText* without newlines and HTML tags

~~ransack~~
+ More robust than has_scope
+ More search patterns (_cont, _matches, _any...)
- We can't sort by alias
- Not maintained

~~has_scope~~

~~pg_search~~
- Only works with text fields (no range fields for ex)

### Testing

:star: **rspec + factory_bot + rspec_api_documentation**
- Rspec is the most popular testing framework

~~minitest + fixtures + swagger-docs~~
- Swagger-docs is old and not maintained

### Pagination

:star: **pagy**
+ Most performant
+ Most recent

~~kaminari~~
~~will_paginate~~

### API JSON

:star: **active_model_serializers**

~~from scratch~~
- Works badly with `ActionText` and `Attachment`
- We need `olive_banch` to camelize keys

~~fast_jsonapi~~
+ Most performant
- Only compatible with JSONAPI

### Soft deletes

:star: **paranoia**
- Most simple

~~act_as_paranoid~~
- Older gem

~~discard~~
+ Most recent gem
- No support for recursive deletes

### Model tracking & versioning

:star: **paper_trail**
- Most popular

~~discard~~
- No metada to bind `ActionText` and `ActiveStorage`

~~public_activity~~
- Shipped with default views

~~logidze~~
+ Most performant (database level tracking)
- Not possible to have a global timeline

### PDF generation

:star: **wkhtmltopdf**
+ View system

~~prawn~~
- No view system

~~PDFKit~~

### Auth

:star: **from scratch**
+ Most personalizable solution
+ Generate `User` with from core system

~~devise + devise_auth_token~~
- Not enough personalizable

~~cleareance~~
~~sorcery~~
~~knock~~
