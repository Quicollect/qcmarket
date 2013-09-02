
var charts_utility = 
{
    chartColors: [ themerPrimaryColor, "#444", "#777", "#999", "#DDD", "#EEE" ],
    //chartBackgroundColors: ["transparent", "transparent"],
    chartBackgroundColors: ["rgba(255,255,255,0)", "rgba(255,255,255,0)"],

    applyStyle: function(that)
    {
        that.options.colors = this.chartColors;
        that.options.grid.backgroundColor = { colors: this.chartBackgroundColors };
        that.options.grid.borderColor = this.chartColors[0];
        that.options.grid.color = this.chartColors[0];
    },
    
    // generate random number for charts
    randNum: function()
    {
        return (Math.floor( Math.random()* (1+40-20) ) ) + 20;
    }
};