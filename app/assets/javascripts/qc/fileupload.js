
$(function () {
    
    $('#fileupload').fileupload({ url: '/resources/', uploadDir: '/resources/' } )
    .bind('fileuploadsubmit', function (e, data) {
        data.formData = { 'display_name': $('#input_disply_name_' + data.files[0].upload_id).val() };
    })

    $("#fileupload").bind("fileuploaddone", function (e, data) {
        result = $.parseJSON(data.jqXHR.responseText);
        $("#fileupload").trigger('fileupload', [ result.files[0] ]);
    });

    $("#fileupload").bind('fileuploaddestroy', function (e, data) {
        parts = data.url.split('/')
        resource_id = parts[parts.length-1];
        $("#fileupload").trigger('filedeleted', [ resource_id ]);
    });

    // 
    // Load existing files:
    if ($('#fileupload').attr('preload'))
    {
        $.getJSON($('#fileupload').attr('preload'), function (files) 
        {
          files = $.parseJSON(files.files);
          var fu = $('#fileupload').data('blueimpFileupload'), template;
          if (fu)
          {
            fu._adjustMaxNumberOfFiles(-files.length);
            template = fu._renderDownload(files).appendTo($('#fileupload .files'));

            // Force reflow:
            fu._reflow = fu._transition && template.length && template[0].offsetWidth;
            template.addClass('in');
            $('#loading').remove();
          }
        });
    }
});

