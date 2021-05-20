$(document).on('turbolinks:load', function() {
    $('.toast')
        .toast({ delay: 5000 })
        .toast('show');
});
