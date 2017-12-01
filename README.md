# DeepSee_TimeCharts
A DeepSee portlet to chart dates and times using [Amcharts](https://www.amcharts.com/)

### Description
This project shows a portlet using 3rd party tools for charting date and time.
The files contain a cube with mock data to quickly test the portlet.
See the documentation on portlets: [Creating Portlets for Use in Dashboards](http://docs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=D2IMP_ch_portlets).

### Content
SourceCube cube and a portlet showing a chart based on Amcharts. The x-axis of the chart is based on date-time (eg "2017-11-12 09:18:00") and it also works with time dimensions based on date, months (less nice).

![Alt Text](https://github.com/aless80/DeepSee_TimeCharts/blob/master/img/TimeAmchart.png)           


### Instructions
#### Programmatic import from Caché console
```
Set path="/home/amarin/DeepSee_TimeCharts/"  //Set your path
W $system.OBJ.Load(path_"SourceCube.xml","cf")  //source, cube, pivot
W ##class(Ale.Source).GenerateData(1000,3)  //1000 facts in the last 3 days
W ##class(%DeepSee.Utils).%BuildCube("SourceCube",1,1)
W ##class(%DeepSee.TermList).%ImportCSV(path_"SourceCube colspec.txt") //termlist
W $system.OBJ.Load(path_"Ale.PortletAmchartsREST.xml","cf")
W $system.OBJ.Load(path_"Ale.PortletAmcharts.xml","cf")
Do ##class(%DeepSee.UserLibrary.Utils).%Import(path_"PortletAmchartsREST-dashboard.xml",1)
Do ##class(%DeepSee.UserLibrary.Utils).%Import(path_"PortletAmcharts-dashboard.xml",1)
```

#### Manual import
1) Import the SourceCube cube in SourceCube.xml. This file contains source class, cube class, and a pivot for the SourceCube cube;
2) Generate source data and build the cube:
```
W ##class(Ale.Source).GenerateData(100,3) //100 facts in the last 3 days
W ##class(%DeepSee.Utils).%BuildCube("SourceCube",1,1)
```
3) Import the termlist SourceCube colspec.txt to use the Choose Column Spec control;
4) Import the portlet class Ale.PortletAmchartsREST.xml in studio;
5) Import the portlet class Ale.PortletAmcharts.xml in studio;
6) Open the PortletAmcharts dashboard.


### Limitations
The default filter control is not used when you first load the dashboard. This has been ProdLogged.  
The current implementation of onApplyFilters calls renderContents. This makes the filters work but renderContents runs two times at startup. This has to be ProdLogged.
