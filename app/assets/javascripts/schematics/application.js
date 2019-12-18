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
});
