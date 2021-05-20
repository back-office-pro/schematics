$(document).on('turbolinks:load', function() {
    const filterSource = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: {
            url: `${window.location.pathname}/autocomplete/?__FIELD__=%QUERY`,
            wildcard: "%QUERY",
            transport: function (options, onSuccess, onError) {
                const scope = $(document.activeElement).attr('name');
                const element = scope.match(/filter\[(\w+)\]/)[1];
                const searchParams = new URLSearchParams(window.location.search);
                const [url, query] = options.url.split('?__FIELD__=');
                searchParams.delete('page');
                searchParams.delete('per_page');
                searchParams.delete('sort');
                searchParams.set('field', element);
                searchParams.set(scope, decodeURI(query));
                searchParams.set('sort', element);
                options.url = url + '?' + searchParams;
                $.ajax(options)
                    .done(function(data, textStatus, request) { onSuccess(data); })
                    .fail(function(request, textStatus, errorThrown) { onError(errorThrown); });
            }
        }
    });

    $('input.typeahead-filter')
        .on('typeahead:selected', function() {
            $(this.form).submit();
        })
        .typeahead(
            {
                highlight: true,
                minLength: 3
            },
            {
                source: filterSource,
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
                            <i class="fa fa-search fa-fw text-dark mr-2"></i>
                            ${item}
                        </div>
                    `
                }
            }
        );
});
