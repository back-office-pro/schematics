//= require rails-ujs
//= require activestorage
//= require jquery3
//= require popper
//= require bootstrap
//= require twitter/typeahead
//= require_tree .

$(function() {
    $('.custom-file-input').on('change', function () {
        $(this).siblings('.custom-file-label').addClass('selected').html(Array.from($(this).get(0).files).map(_ => _.name).join(', '));
    });

    $('input.typeahead')
        .on('typeahead:selected', function() { this.form.submit() })
        .typeahead(null, {
            display: '__FIELD__',
            source: new Bloodhound({
                datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
                queryTokenizer: Bloodhound.tokenizers.whitespace,
                remote: {
                    url: `${window.location.pathname}?__FIELD__=%QUERY`,
                    wildcard: "%QUERY",
                    transport: function (options, onSuccess, onError) {
                        const scope = $(document.activeElement).attr('id');
                        const searchParams = new URLSearchParams(window.location.search);
                        const [url, query] = options.url.split('?__FIELD__=');
                        searchParams.set(scope, query);
                        options.url = url + '?' + searchParams;
                        $.ajax(options)
                            .done(function(data, textStatus, request) { onSuccess(data); })
                            .fail(function(request, textStatus, errorThrown) { onError(errorThrown); });
                    },
                    transform: function(response) {
                        const name = $(document.activeElement).attr('id').substring(3);
                        return response.map(field => ({ __FIELD__: field[name] }));
                    }
                }
            })
        });
});
