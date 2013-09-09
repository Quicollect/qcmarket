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


// support for live (ajax) update of table content for both search and sort
$(function () {
  $('.ajax-widget').delegate('.ajax-reload', 'click', function () {
    $.getScript(this.href);
    return false;
  });

  $('.ajax-updates').delegate('.ajax-reload', 'click', function () {
    var action = $(this).attr('data-method')
    $.ajax( { 
                dataType: "script",
                url: this.href,
                type: action, 
                data: action == "delete" ? {"_method":"delete"} : {}
            });
    return false;
  });

  $('#live-results').delegate('th a', 'click', function () {
		$.getScript(this.href);
		return false;
	});

  // Search form.
  $('#live-search input').keyup(function () {
	  $.get($('#live-search').attr('action'), 
	    $('#live-search').serialize(), null, 'script');
			return false;
	});
});


$(function() {
  $('body').on('click', 'a:not(.no-spinner)[href]', function(e) {
    if ($(this).attr('href') == '#' || $(this).attr('href') == 'javascript:;' || $(this).attr('href').indexOf('javascript:void(0)') == 0)
        return true;

      activate_spinner();
  });

  $('body').on('click', '.form-submit', function(e) {
      e.preventDefault();
      submit_form(this);
      return false;
  });
});


function activate_spinner()
{
    target = $('#spinner').get(0);
    var spinner = new Spinner(opts).spin(target);
    
    // making sure navbar has higher z-index now
    $('.navbar').css('z-index', (""+parseInt( $('.overlay').css('z-index') ) + 1))
    $('.overlay').css('display', 'block');
}

function submit_form(element)
{
  var target = document.forms[0];
  if ($(element).parents('form').length > 0)
    target = $(element).parents('form').get(0)

  target.submit(); 
}


var opts = {
  lines: 13, // The number of lines to draw
  length: 20, // The length of each line
  width: 10, // The line thickness
  radius: 30, // The radius of the inner circle
  corners: 1, // Corner roundness (0..1)
  rotate: 0, // The rotation offset
  direction: 1, // 1: clockwise, -1: counterclockwise
  color: '#000', // #rgb or #rrggbb
  speed: 1, // Rounds per second
  trail: 60, // Afterglow percentage
  shadow: true, // Whether to render a shadow
  hwaccel: false, // Whether to use hardware acceleration
  className: 'spinner', // The CSS class to assign to the spinner
  zIndex: 2e9, // The z-index (defaults to 2000000000)
  top: 'auto', // Top position relative to parent in px
  left: 'auto' // Left position relative to parent in px
};


var RecaptchaOptions = {
	theme : 'white'
};

$(function() {
  // Support for AJAX loaded modal window.
  // Focuses on first input textbox after it loads the window.
  $('body').on('click', '[data-toggle="modal"]', function(e) {
    e.preventDefault();
    var url = $(this).attr('href');
    if (url.indexOf('#') == 0) {
      
      // now we check if there is data we need to pass to the modal
      // the format is id1=value1;id2=value2 etc.
      var data =  $(this).attr('html-map');
      if (data)
      {
        var elements = data.split(';');
        for (var i in elements)
        {
          var  element = elements[i];
          var key_val = element.split('=');
          $(url).find('#'+key_val[0]).html( key_val[1] );
        }
      }
      data =  $(this).attr('value-map');
      if (data)
      {
        var elements = data.split(';');
        for (var i in elements)
        {
          var  element = elements[i];
          var key_val = element.split('=');
          $(url).find('#'+key_val[0]).val( key_val[1] );
        }
      }
      
      // now we can open the modal
      $(url).modal('open');
    } 
    else {
      $.get(url, function(data) {
        // first remove old closed modal if exist
        $('#unqiue_modal').remove();

        $('<div id="unqiue_modal" class="modal hide fade">' + data + '</div>').modal();
      }).success(function() { 
          $('input:text:visible:first').focus(); 
      });
    }

    return false;
  });
});


// hooking Ctrl+S to save action
// TODO: add also for iframe (for the rich text editor)
$(window).keypress(function(event) {
    if (!(event.which == 115 && event.ctrlKey) && !(event.which == 19)) 
      return true;
    
    if ($(".form-submit").length > 0 )
    {
      event.preventDefault();
      activate_spinner();
      submit_form();
      return false;
    }

    return true;
});



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