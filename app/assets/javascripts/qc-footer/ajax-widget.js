var widget_opt = {
  lines: 12, // The number of lines to draw
  length: 7, // The length of each line
  width: 3, // The line thickness
  radius: 12, // The radius of the inner circle
  corners: 0.5, // Corner roundness (0..1)
  rotate: 0, // The rotation offset
  direction: 1, // 1: clockwise, -1: counterclockwise
  color: '#000', // #rgb or #rrggbb
  speed: 1, // Rounds per second
  trail: 60, // Afterglow percentage
  shadow: true, // Whether to render a shadow
  hwaccel: false, // Whether to use hardware acceleration
  className: 'spinner', // The CSS class to assign to the spinner
  top: '20px', // Top position relative to parent in px
  left: 'auto' // Left position relative to parent in px
};

$('.ajax-widget').each(function() {
	var spinner = new Spinner(widget_opt).spin(this);
	var data_url = $(this).attr('data-url');
	$(function() {
    	$.getScript(data_url);
	});
});

function refetch_widget_data(element, data_url) {
  var spinner = new Spinner(widget_opt).spin(element);
  $.getScript(data_url);
}