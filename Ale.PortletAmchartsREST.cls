Class Ale.PortletAmchartsREST Extends %DeepSee.Component.Portlet.abstractPortlet
{

/// Parameter INCLUDEFILES = "script:https://www.amcharts.com/lib/3/themes/light.js,script:https://www.amcharts.com/lib/3/amcharts.js,script:https://www.amcharts.com/lib/3/serial.js,script:https://www.amcharts.com/lib/3/plugins/export/export.min.js,script:https://www.amcharts.com/lib/3/plugins/export/export.js";
Parameter INCLUDEFILES = "https://www.amcharts.com/lib/3/amcharts.js,https://www.amcharts.com/lib/3/serial.js,https://d3js.org/d3.v3.min.js,https://www.amcharts.com/lib/3/plugins/export/export.js,https://www.amcharts.com/lib/3/plugins/export/export.css";

Parameter JSINCLUDES = "zenCSLM.js,DeepSee.js,https://www.amcharts.com/lib/3/plugins/export/export.js";

/// Chart height (percentage of widget)
Property chartheight As %Integer;

/// Chart width (percentage of widget)
Property chartwidth As %Integer;

/// Area Transparency Setting
Property fillalphas As %Numeric;

/// Line color
Property linecolor As %String;

/// Chart color
Property fillcolor As %String;

/// Bullet shape
Property bullet As %String;

/// Bullet size
Property bulletsize As %Integer;

/// Enable Export of chart
Property amchartsexport As %Boolean;

/// Namespace for the connection
Property namespace As %String;

/// Return the localized caption of this portlet.
/// This is displayed in the Widget Builder dialog.
/// This should be overridden in subclasses.
ClassMethod %OnGetPortletName() As %String
{
	Quit "PortletAmchartsREST"
}

ClassMethod %OnGetPortletSettings(Output pInfo As %List, ByRef pSettings) As %Status
{
 Kill pInfo
 Set pInfo($I(pInfo)) = $LB("CHARTHEIGHT","100","%Integer","% Chart height","Chart height (percentage of widget)")
 Set pInfo($I(pInfo)) = $LB("CHARTWIDTH","100","%Integer","% Chart width","Chart width (percentage of widget)")
 Set pInfo($I(pInfo)) = $LB("FILLALPHAS","0.5","%Numeric","Area Transparency","Set the transparency of the area plot [0 to 1]")
 Set pInfo($I(pInfo)) = $LB("LINECOLOR","red","DRILL^Red:red,Black:black,Blue:blue,Purple:purple,Yellow:yellow,Green:green","Line Color","Line color")
 Set pInfo($I(pInfo)) = $LB("FILLCOLOR","red","DRILL^Red:red,Blue:blue,Purple:purple,Yellow:yellow,Green:green","Chart Color","Chart color")
 Set pInfo($I(pInfo)) = $LB("BULLET","bubble","DRILL^none:none,round:round,square:square,triangleUp:triangleUp,triangleDown:triangleDown,bubble:bubble","Bullet","Bullet shape")
 Set pInfo($I(pInfo)) = $LB("BULLETSIZE","6","%Integer","Bullet size","Size of bullet in the chart")
 Set pInfo($I(pInfo)) = $LB("AMEXPORT","false","ENUM^true:1,false:0","Enable Export","Enable Export") 
 Quit pInfo
}

/// When filters get applied to the portlet, re-query the data from the pivot with the appropriate new filters in place.
ClientMethod onApplyFilters(refresh, widget) [ Language = javascript ]
{
	console.log('onApplyFilters')    
    //widget.applyFilters(false) //infinite loop with onApplyFilters, with both true and false
	var portlet = widget.findComponent('portlet');
   	this.renderContents(widget,portlet);
}

Method %DrawHTML()
{
  //In a portlet that accesses data do nothing but force a modification of the renderFlag property
  Set ..renderFlag = ..renderFlag + 1
  //Settings: they will be available in renderContent (and drawChart) as e.g. this.fillalphas
  Set ..fillalphas = ..settings("FILLALPHAS")
  Set ..amchartsexport = ..settings("AMEXPORT")
  Set ..chartheight = ..settings("CHARTHEIGHT")
  Set ..chartwidth = ..settings("CHARTWIDTH")
  Set ..fillcolor = ..settings("FILLCOLOR")
  Set ..bullet = ..settings("BULLET")
  Set ..bulletsize = ..settings("BULLETSIZE")
  //Get the namespace
  Set ..namespace = $NAMESPACE
  //Show a message while loading
  &html< <div id="chartdiv">Content is loading...</div>	>
}

ClientMethod renderContents(widget, portlet) [ Language = javascript ]
{
	console.log('renderContents')
	console.log(arguments.callee.caller);
	//Get the widget and portlet objects
	var widgetIdArray = this.id.split("/")
	var widgetId = widgetIdArray[0]
	if (!widget) {
		widget = zen(widgetId);
	}
	if (!portlet) {
		portlet = widget.findComponent('portlet');
	}
	//Quit if the portlet object was not found. This happens during the initial server load 
	//when renderContents gets called before it is time to load the data
	if (!portlet) {		
		this.getEnclosingDiv().innerHTML = "";
		return true;
	}
	var portletId = portlet.id
    //Get the widget's data controller to get to the source data in the pivot
    var controller = this.getController();
    if (null == controller) {
        this.connectToController();
        controller = this.getController();
    }
	//Get the chartdiv div created in %DrawHTML
	var chartdiv = document.getElementById('chartdiv');
	chartdiv.style.width = this.chartwidth+'%';
    chartdiv.style.height = this.chartheight+'%';
    chartdiv.style.visibility = 'visible'
	//Initialize variables to create a connection
	var query = controller.GetCurrentQueryText();
	console.log('The MDX query is:\n'+query)
    var host = window.location.protocol + '//' + window.location.host;
    var connection = new DeepSeeConnection("","",host,"/api/deepsee/v1", this.namespace);
    //Create the DeepSeeResultSet object with the connection..
    var resultSet = new DeepSeeResultSet(connection,widgetId);
    //..which uses the drawChart method to go throught the results and create the Amcharts chart in chartdiv
    //Notice that .bind is used to pass the scope of renderContents to drawChart    
    resultSet.runMDXQuery(query,this.drawChart.bind(this), this.drawChart.bind(this));
    //I find that the previous responds better than this:
    //resultSet.runMDXQuery(query,this.drawChart.bind(this));
}

/// NB it is assumed that dates are in the format yyyy-mm-dd hh:mm:ss and that they are sorted chronologically
ClientMethod drawChart(resultSet) [ Language = javascript ]
{
	console.log('drawChart')
	console.log(arguments.callee.caller.caller.caller);
	//window.caller=arguments.callee.caller
	
	var chartDataPoint;
	var chartLabel;
	var chartData = [];
	//Populate chartData needed for AmCharts from resultSet
	console.time('resultSet loop');
	for (var i = 1; i <= resultSet.getRowCount(); ++i) {
		for (var j = 1; j <= resultSet.getColumnCount(); ++j) {
			chartDataPoint = resultSet.getOrdinalValue(i,j);
			chartLabel = resultSet.getOrdinalLabel(2,i); //label of member on rows
			chartData[chartData.length] = { "date":chartLabel[0],"y":chartDataPoint};
		}
	}
	//If no data, get rid of data array containg empty/undefined values
	if ((resultSet.parsedData.Result.CellData.length == 1) && (resultSet.parsedData.Result.CellData[0]["ValueLogical"]=="")) {
		chartData=[];
	}
	console.timeEnd('resultSet loop');
	console.log(chartData)
	var columnLabel = resultSet.getOrdinalLabel(1,1);
	//Set the minimum date to midnight of the first day in the data
	var minimumDate = chartData[0].date.slice(0,11)+'00:00:00';
	//AmChart code	
	if (typeof AmCharts=="undefined")  { 
		alert('Please download amCharts JavaScript Charts (http://www.amcharts.com/download/) and place the "amcharts" directory in /csp/broker/  ');
		return;
	}
	var chart = AmCharts.makeChart("chartdiv", {
		"type": "serial",
		"theme": "light",
		"marginRight": 80,
		"dataProvider": chartData,
		"valueAxes": [{
			"position": "left",
			"title": columnLabel,
			"minimum":minimumDate,
			"maximum":"undefined",
			"showFirstLabel": true,
			"autoGridCount": true,
			"labelFrequency": 2
		}],
		"graphs": [{
			"id": "g1",
			"lineThickness": 2,
			"bullet": this.bullet,
			"bulletSize": this.bulletsize,
			"lineColor": this.linecolor,
			"fillColors": this.fillcolor,
			"fillAlphas": this.fillalphas,
			"valueField": "y",
			"balloonText": "<div style='margin:5px; font-size:19px;'>"+columnLabel+": <b>[[value]]</b></div>"
		}],
		"chartScrollbar": {
			"graph": "g1",
			"scrollbarHeight": 30,
			"backgroundAlpha": 0,
			"selectedBackgroundAlpha": 0.1,
			"selectedBackgroundColor": "#888888", //Gray background
			"graphFillAlpha": 0,
			"graphLineAlpha": 0.5,
			"selectedGraphFillAlpha": 0,
			"selectedGraphLineAlpha": 1,
			"autoGridCount": true,
			"color": "#AAAAAA"
		},
		"chartCursor": {
			"categoryBalloonDateFormat": "JJ:NN, DD MMMM", //Hours:Minute, Day Month
			"cursorPosition": "mouse"
		},
		"categoryField": "date",
		"categoryAxis": {
			"minPeriod": "hh",
			"parseDates": true,
			"showFirstLabel": false
		},
		"export": {
			"enabled": this.amchartsexport,
			"dateFormat": "YYYY-MM-DD HH:NN:SS"
		}
	});
	//Show message if no data
	if (chart.dataProvider === undefined || chart.dataProvider.length === 0) {
		chart.addLabel("50%", "50%", "The chart contains no data", "middle", 15);
	}
}

/// URL of the icon for this portlet displayed in the Widget Builder dialog.
ClassMethod %OnGetPortletIcon() As %String
{
	Quit "https://avatars1.githubusercontent.com/u/6652854?s=460&v=4"
}

}

