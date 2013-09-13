// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require turbolinks
//= require_directory ./extra/
//= require theme/plugins/system/less.min.js
//= require gmaps4rails/gmaps4rails.base
//= require gmaps4rails/gmaps4rails.googlemaps
//= require jquery_nested_form
//= require jquery_ujs
//= require gritter
//= require_directory ./qc/


function init_datetimepickers()
{
  $("#datetimepicker").datetimepicker({
        autoclose: true,
        format: 'yyyy-mm-dd',
        minView: 2, // this forces the picker to not go any further than days view
        pickerPosition: "bottom-left"
    });
}

$(function(){
   init_datetimepickers();
});


var RecaptchaOptions = {
	theme : 'white'
};



function asjustMap(lat, long)
{
  if (Gmaps.map.map)
  {
    google.maps.event.trigger(map, 'resize');
    var centerpoint = new google.maps.LatLng(lat, long);
    Gmaps.map.map.setCenter(centerpoint);
  }
}

// we adjust font size based on the text length in the widget
$(function(){
    $("a.widget-stats-4 .count").each(function() {
      var numChars = $(this).text().length;
      if (numChars < 10 && numChars > 7) {
          $(this).css("font-size", "45px");
      }
      else if (numChars >= 10) {
          $(this).css("font-size", "35px");
      }
  });
}); 


$(function() {
  $('body').on('click', '.star-selectable', function() {
    var selected = $(this)
    var index = 0;
    $(this).parent().children().each(function() { 
      $(this).removeClass('active');
      if (selected.get(0) == $(this).get(0))
      {
          selected.addClass('active');
          selected.parent().children('input').val ( 5 - index );
      }

      index++;
    })
  });
});