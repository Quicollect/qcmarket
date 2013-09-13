
function register_select(id, arr, values)
{
  $(function () {
    $("#"+id).val(values).select2(
        { tags: arr,
          createSearchChoice: function() { return null; }
        });
  });
}

/*** 
 * supported options:
 * id, url, placeholder, selectedText, per_page
 */
function register_select2(options)
{
  options = options || {};
  $(function () {
    
    $("#"+options.id).select2({
        placeholder: options.placeholder,
        minimumInputLength: 0,
        ajax: {
          url: options.url,
          dataType: "json",
          quietMillis: 200,
          data: function (term, page) {
            return {
              search: term, // search term
              per_page: options.per_page,
              page: page
            };
          },

          results: function (data, page) { 
            return data;
          }
        },

        formatResult: formatAResult,
          
        formatSelection: function(item) {
            // if we need to notify on select change
            if (options.onSelectionChange)
              options.onSelectionChange(item);

            return item.text;
        },

        initSelection : function (element, callback) {
          var data = {id: element.val(), text: options.selectedText};
          callback(data);
        }
    });

  });
}


function formatASelection(item)
{
  // if there is somwhere else which present the thumbnail in a bigger form we update it
  $('#selection-display').attr('src', item.thumbnail )
  return item.text;
}

function formatAResult(result) {
    var markup = "<table class='select-result'><tr>";
    if (result.thumbnail !== undefined) {
        markup += "<td class='select-image'><img src='" + result.thumbnail + "'/></td>";
    }
    else if (result.thumbnail_html != undefined) {
      markup += "<td class='select-image'>" + result.thumbnail_html + "</td>";
    }
    markup += "<td class='movie-info'><div class='movie-title'>" + result.text + "</div>";
    markup += "</td></tr></table>";

    return markup;
}