$(document).on('turbolinks:load', function () {
  $('#choice').on('change', function () {
    $(this).parents('form').submit();
  })

  $('input[name="rating"]').on('click', function () {
    var form = $(this).parents('form')
    var userRate = $(this).val()
    var url = form.attr('action')

    $.ajax({
      type: 'post',
      url: url,
      data: { rate: { value: userRate } },
      dataType: 'script'
    });
  });

});
