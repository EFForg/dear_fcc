//= require vendor/jquery
//= require vendor/jquery-ujs
//= require_tree .

$(document).on("change", ".select-or-other select", function(e) {
  var select = this, parent = $(this).parents(".select-or-other");
  if (select.value == "other") {
    parent.addClass("other");
    $(".other input", parent).focus();
  } else {
    parent.removeClass("other");
  }
});

$(".random-choice").each(function() {
  var select = $("select", this);
  var options = $("option", select);
  var labels = $(".choices *", this);

  var choice = Math.floor(Math.random() * options.length);

  labels[choice].classList.add("chosen");
  select.val(options[choice].value);

  this.classList.add("processed");
});

$(".international-address-switch").click(function(e) {
  e.preventDefault();

  var form = $(this).parents('form');
  form.find('.us-filer, .international-address-switch').hide();
  form.find('.international-filer, .us-address-switch').show();

  form.find('.us-filer *').prop('required', null);
  form.find('.international-filer *').prop('required', true);
});

$(".us-address-switch").click(function(e) {
  e.preventDefault();

  var form = $(this).parents('form');
  form.find('.international-filer, .us-address-switch').hide();
  form.find('.us-filer, .international-address-switch').show();

  form.find('.us-filer *').prop('required', true);
  form.find('.international-filer *').prop('required', null);
});
