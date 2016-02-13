// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery(document).ready(function() {

  var source = new EventSource('/costs/events');

  source.onopen = function(event) {
    console.log(event.type);
  }

  source.onmessage = function(event) {

    console.log(event);
    console.log(event.data);

    cost = JSON.parse(event.data)

    $.ajax( "/costs/" + cost.id )
      .done(function(data, status) {

        // append the partial to our list
        cost_view = $.parseHTML(data);
        $(cost_view).prependTo('table').hide().fadeIn();
      });
  }
});
