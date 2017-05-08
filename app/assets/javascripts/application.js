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
