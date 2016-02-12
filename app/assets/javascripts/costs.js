// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery(document).ready(function() {
  var source = new EventSource('/costs/events');
  source.onmessage = function(event) {
    cost = JSON.parse(event.data)

    $.ajax( "/costs/" + cost.id )
      .done(function(data, status) {

        // append the partial to our list
        cost_view = $.parseHTML(data);
        $(cost_view).prependTo('.cost-list').hide().slideDown("slow");
      });
  }
});
