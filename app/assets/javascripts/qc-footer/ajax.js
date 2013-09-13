// support for live (ajax) update of table content for both search and sort
$(function () {
  
  $('body').delegate('.ajax-reload', 'click', function () {
    var action = $(this).attr('data-method');
    var onSuccess = $(this).attr('on_success');

    var element = $(this);
    var iElement = $($(this).children('i')[0]);
    var orgIcon = iElement.attr('class');
    var progressIcon = 'icon-refresh icon-spin';

    iElement.removeClass(orgIcon)
    iElement.addClass(progressIcon)
    $(this).prop('disabled', true)
    $.ajax( { 
                dataType: "script",
                url: this.href,
                type: action, 
                data: action == "delete" ? {"_method":"delete"} : {},
                success: function() {
                  iElement.removeClass(progressIcon)
                  iElement.addClass(orgIcon)
                  if (onSuccess)
                    eval(onSuccess + "(element)");
                },
                error: function() {
                  iElement.removeClass(progressIcon)
                  iElement.addClass(orgIcon)
                }
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


$(function() {
  // Support for AJAX loaded modal window.
  // Focuses on first input textbox after it loads the window.
  $('body').on('click', '[data-toggle="modal"]', function(e) {
    
    // close all open dropdown menus to be safe
    $('.open > .dropdown-toggle').dropdown('toggle');
    
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

