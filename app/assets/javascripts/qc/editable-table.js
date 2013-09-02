function calcSliderValue(step)
{
  if (step < 101) return step * 10;
  if (step < 191) return 1000 + (step - 100) * 100;
  if (step < 281) return 10000 + (step - 190) * 1000;
  if (step < 371) return 100000 + (step - 280) * 10000;
  return 1000000 + (step - 370) * 100000;
}

function reverseCalcSliderValue(value)
{
  steps = 0;
  intervals = [100000, 10000, 1000, 100, 10]
  offsets = [1000000, 100000, 10000, 1000, 0]
  for (var i=0; i < intervals.length; i++)
  {
    inc_steps = Math.floor((value - offsets[i]) / intervals[i]); 
    if (inc_steps > 0)
    {
      steps += inc_steps;
      value -= inc_steps*intervals[i];  
    }
  }

  return steps;
}

(function ($) {
    "use strict";

    var RangeSlider = function (options) {
        this.init('range_slider', options, RangeSlider.defaults);
    };

    $.fn.editableutils.inherit(RangeSlider, $.fn.editabletypes.abstractinput);
    
    $.extend(RangeSlider.prototype, {
        myself: null,

        from_slider: function(val) 
        {
            if (this.non_linear)
                return calcSliderValue(val);
            else
                return val;

        },

        to_slider: function(val)
        {
            if (this.non_linear)
                return reverseCalcSliderValue(val);
            else
                return val;
        },
        
        render: function () {
            this.myself = this.$input.find('.slider');

            var root = this.$input.closest(".editable-container").parent().children('a[data-type="range_slider"]');
            var min_value = root.attr('min-value') ? root.attr('min-value') : 0;
            var max_value = root.attr('max-value') ? root.attr('max-value'): 100;
            this.non_linear = root.attr('non-linear') ? true : false;
            
            this.myself.slider({
              create: JQSliderCreate,
                  range: true,
                  min: this.to_slider(min_value),
                  max: this.to_slider(max_value),
                  step: 1,
                  values: [this.to_slider(this.options.values[0]), 
                           this.to_slider(this.options.values[1])],
                  parent: this,

                  slide: function( event, ui ) 
                  {
                      var parent = $(this).slider('option', 'parent');
                      var label = ui.values[ 0 ] == ui.value ? '#min' : '#max';
                      parent.set_slider(label, ui.value, ui.handle);
                  },
                  start: function() { if (typeof mainYScroller != 'undefined') mainYScroller.disable(); },
                  stop: function() { if (typeof mainYScroller != 'undefined') mainYScroller.enable(); }
              });
        },

        set_slider: function(id, val, handle) {
            $(id).html(this.from_slider(val)).position({
                                      my: 'center top',
                                      at: 'center bottom',
                                      of: handle,
                                      offset: "0, 10"
                                    });
        },
        
        value2html: function(value, element) {
            var text = this.value2str(value);
            RangeSlider.superclass.value2html(text, element);
        },

        html2value: function(html) {
            return html;
        },

        value2str: function(value) {
            return "" + value[0] + " - " + value[1];
       },

        str2value: function(str) {
            var values = str;
            if (typeof(str) == 'string')
            {
                var split = str.split('-');
                if (split.length == 2)
                    values = [parseInt(split[0].trim()), parseInt(split[1].trim())];
            }

            this.options.values = values;

            return values;
        },

        value2submit: function(value) {
            return value;
        },
        
        value2input: function(value) {
            return "";
        },

        input2value: function() {
            return [    this.from_slider(this.myself.slider('values', 0)),
                        this.from_slider(this.myself.slider('values', 1))];
        },

        activate: function() {

            // initialize the labels
            var sliders = this.myself.find('.ui-slider-handle');
            var values = this.input2value()
            this.set_slider("#min", this.myself.slider('values', 0), sliders.get(0));
            this.set_slider("#max", this.myself.slider('values', 1), sliders.get(1));
        },

        clear: function() {
        },

        autosubmit: function() {

       }
    });

    RangeSlider.defaults = $.extend({}, $.fn.editabletypes.abstractinput.defaults, {
        /**
        @property tpl
        @default <div></div>
        **/
        tpl:'<div class="range-slider row-fluid"> \
                <div class="slider slider-primary"></div> \
                <div style="width:50px; text-align: center;"  id="min"> </div> \
                <div style="width:50px; text-align: center;" id="max"> </div> \
            </div>',
        /**
        @property inputclass
        @default null
        **/
        inputclass: null,

        /**
        Configuration of datepicker.
        Full list of options: http://vitalets.github.com/bootstrap-datepicker

        @property datepicker
        @type object
        @default {
        weekStart: 0,
        startView: 0,
        minViewMode: 0,
        autoclose: false
        }
        **/
        values: [500, 50000],
        /**
        Text shown as clear date button.
        If <code>false</code> clear button will not be rendered.

        @property clear
        @type boolean|string
        @default 'x clear'
        **/
        clear: false
    });

    $.fn.editabletypes.range_slider = RangeSlider;

}(window.jQuery));


function editableTable()
{
  $(".editable-cell").each(function() {

    // this is to handle each only once
    $(this).removeClass("editable-cell");
    $(this).editable( {
        disabled: $(this).attr('readonly')? true : false,
        success: function(response, newValue) {
            if (typeof(newValue) == 'string')
              newValue = [newValue];
            
            // remove errors if exist
            $(this).removeClass("alert-error");
            $(this).attr('title', '');
            
            // now iterate backward and fill the hidden inputs with the values
            element = $(this);
            for (var i = newValue.length-1; i >= 0 ; i--)
            {
                element = element.prev();
                element.val(newValue[i]);
            }    
        }
      });
  });
}