/* global $, Bloodhound, Turbolinks, ENTITY_ICONS, TYPEAHEAD_I18N_NOT_FOUND, TYPEAHEAD_I18N_PENDING */

const findDescriptor = (result) => {
  if ($.type(result) === 'object') {
    const key = Object.keys(result).find(_ => _ !== 'id') || 'id'
    return findDescriptor(result[key])
  }
  return result
}

$(document).on('turbolinks:load', function () {
  const searchSource = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/searches/%QUERY',
      wildcard: '%QUERY',
      transform: function (response) {
        const results = []
        Object.entries(response).map(([key, value]) => {
          return value.forEach(result => {
            results.push({
              url: '/' + [key, result.id].filter(Boolean).join('/'),
              icon: ENTITY_ICONS[key],
              descriptor: findDescriptor(result)
            })
          })
        })
        return results
      }
    }
  })

  $('input.typeahead-search')
    .on('typeahead:selected', (event, item) => {
      Turbolinks.visit(item.url)
    })
    .typeahead(
      {
        highlight: true,
        minLength: 3
      },
      {
        source: searchSource,
        display: 'descriptor',
        templates: {
          notFound: () => `
                        <div class="tt-suggestion tt-selectable text-truncate">
                            <i class="fa fa-exclamation-triangle text-dark fa-fw mr-2"></i>
                            ${TYPEAHEAD_I18N_NOT_FOUND}
                        </div>
                    `,
          pending: () => `
                        <div class="tt-suggestion tt-selectable text-truncate">
                            <i class="fa fa-spinner fa-spin text-dark fa-fw mr-2"></i>
                            ${TYPEAHEAD_I18N_PENDING}
                        </div>
                    `,
          suggestion: (item) => `
                        <div class="tt-suggestion tt-selectable text-truncate">
                            <i class="fa fa-${item.icon} fa-fw text-dark mr-2"></i>
                            ${item.descriptor}
                        </div>
                    `
        }
      }
    )
})
