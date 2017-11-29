# DeepSee_TimeCharts
A DeepSee portlet to chart dates and times using [Amcharts](https://www.amcharts.com/)

### Description
Time charts in DeepSee do not yet provide a satisfactory solution for charting a dimensions with date and time.
In this project I build a portlet using 3rd party tools for charting date and time.
The files contain a cube with mock data to quickly test the portlet.


### Content
SourceCube cube and a portlet showing a chart based on Amcharts. The x-axis of the chart is based on date-time (eg "2017-11-12 09:18:00") and it also works with time dimensions based on date, months (less nice).
The motivation to create this portlet was that at the time of writing plotting time on the x-axis with DeepSee is not sufficiently good (cf ProdLog 149466). For example, there are issues with the x-axis showing gaps and not getting nice limits (which default to years), axis labels are half hidden, etc.


### Instructions
#### Programmatic import
```Set path="/home/amarin/intersystems/Perforce/workspace_amarin/Users/amarin/PortletAmcharts/"
W $system.OBJ.Load(path_"SourceCube.xml","cf")
W ##class(Ale.Source).GenerateData(1000,3) //1000 facts in the last 3 days
W ##class(%DeepSee.Utils).BuildCube("SourceCube",1,1)
W $system.OBJ.Load(path_"Ale.PortletAmcharts.xml","cf")
Do ##class(%DeepSee.UserLibrary.Utils).%Import(path_"PortletAmcharts-dashboard.xml")
W ##class(%DeepSee.TermList).%ImportCSV(path_"SourceCube colspec.txt")
```

#### Manual import
1) Import the SourceCube cube in SourceCube.xml. This file contains source class, cube class, and a pivot for the SourceCube cube;
2) Generate source data and build the cube:
```
W ##class(Ale.Source).GenerateData(100,3) //100 facts in the last 3 days
W ##class(%DeepSee.Utils).BuildCube("SourceCube",1,1)
```
3) Import the portlet class Ale.PortletAmcharts.xml in studio;
4) Import the pivot based on SourceCube and the dashboard in PortletAmcharts.dashboardpivot.xml;
5) Import the termlist SourceCube colspec.txt to use the Choose Column Spec control;
6) Open the PortletAmcharts dashboard.


### Issues
The default filter control is not used when you first load the dashboard. This has been ProdLogged


### Limitations
