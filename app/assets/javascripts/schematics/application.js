//= require rails-ujs
//= require activestorage
//= require jquery3
//= require popper
//= require bootstrap
//= require twitter/typeahead
//= require chartkick
//= require Chart.bundle
//= require_tree .

$(function() {
    $('.toast').toast({ delay: 5000 }).toast('show');
    $('[data-toggle="tooltip"]').tooltip();
    $('.custom-file-input').on('change', function () {
        $(this).siblings('.custom-file-label').addClass('selected').html(Array.from($(this).get(0).files).map(_ => _.name).join(', '));
    });
    $('form.form-inline').on('submit', function() {
        return $(this).find(':input').filter(function() { return !this.value; }).attr('disabled', true);
    });
});
