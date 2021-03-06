/// This class contains a cube based on DeepSee.Study.Patients. 
/// <p>This class also contains utility methods used by this cube.
Class DeepSee.Model.PatientsCube2 Extends %DeepSee.CubeDefinition [ DependsOn = DeepSee.Study.Patient ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Patients2" displayName="Patients2" description="Represents patients in a fictitious study" disabled="false" abstract="false" sourceClass="DeepSee.Study.Patient" owner="_SYSTEM" nullReplacement="None" countMeasureName="%COUNT" countMeasureCaption="Patient Count" bucketSize="8" bitmapChunkInMemory="false" defaultListing="Patient details" precompute="0" disableListingGroups="false">
  <dimension name="AgeD" displayName="AgeD" description="These levels group patients by age at study date. This is a data dimension, not an age dimension." disabled="false" hasAll="true" allCaption="All Patients" allDisplayName="All Patients" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Age Group" displayName="Age Group" description="Group patients by large age ranges" disabled="false" sourceProperty="Age" factName="DxAgeGroup" list="false" rangeExpression="(,29]:0 to 29;[30,59]:30 to 59;[60,):60+;" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Age Bucket" displayName="Age Bucket" description="Group patients by age in ten-year bands" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetAgeBucket(%source.Age)" factName="DxAgeBucket" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Age" displayName="Age" description="Group patients by age in years" disabled="false" sourceProperty="Age" factName="DxAge" list="false" useDisplayValue="false" sort="asc numeric" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AllerD" displayName="AllerD" description="This level groups patients by their allergies (possibly more than one per patient). No Data Available means the allergy data is null." disabled="false" hasAll="false" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Allergies" displayName="Allergies" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetAllergies(%source.%ID)" factName="DxAllergies" list="true" nullReplacement="No Data Available" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AllerSevD" displayName="AllerSevD" description="This level groups patients by their allergy severities (possibly more than one per patient). No Data Available means the allergy data is null." disabled="false" hasAll="false" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Allergy Severities" displayName="Allergy Severities" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetAllergySeverities(%source.%ID)" factName="DxAllergySeverities" list="true" nullReplacement="No Data Available" useDisplayValue="false" useAsFilter="true" hidden="false">
        <property name="SeveritySort" displayName="SeveritySort" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetSeveritySort(%value)" factName="PxSort" hidden="false" sort="asc numeric" isName="false" isDescription="false" isReference="false" useDisplayValue="false">
        </property>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="BirthD" displayName="BirthD" description="These levels group patients by birth date" disabled="false" hasAll="false" sourceProperty="BirthDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Decade" displayName="Decade" disabled="false" timeFunction="Decade" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Year" displayName="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Quarter Year" displayName="Quarter Year" disabled="false" timeFunction="QuarterYear" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Period" displayName="Period" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Date" displayName="Date" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="BirthQD" displayName="BirthQD" description="This level groups patients by birth quarter. This lets you see seasonality, independent of year." disabled="false" hasAll="false" sourceProperty="BirthDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Quarter" displayName="Quarter" disabled="false" timeFunction="QuarterNumber" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Month" displayName="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="BirthTD" displayName="BirthTD" description="This level groups patients by birth time. This lets you see hourly variations, independent of day." disabled="false" hasAll="false" sourceProperty="BirthDateTimeStamp" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Birth Time" displayName="Birth Time" disabled="false" factName="DxBirthTime" timeFunction="HourNumber" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="BirthWeekdayD" displayName="BirthWeekdayD" description="This level groups patients by the day of the week on which each patient was born. This lets you see periodicity, independent of year or month." disabled="false" hasAll="false" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Weekday" displayName="Weekday" disabled="false" sourceExpression="$system.SQL.DAYNAME(%source.BirthDate)" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
        <member name="Sunday" displayName="Sunday" disabled="false">
        </member>
        <member name="Monday" displayName="Monday" disabled="false">
        </member>
        <member name="Tuesday" displayName="Tuesday" disabled="false">
        </member>
        <member name="Wednesday" displayName="Wednesday" disabled="false">
        </member>
        <member name="Thursday" displayName="Thursday" disabled="false">
        </member>
        <member name="Friday" displayName="Friday" disabled="false">
        </member>
        <member name="Saturday" displayName="Saturday" disabled="false">
        </member>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ColorD" displayName="ColorD" description="This level groups patients by their favorite color, if known" disabled="false" hasAll="false" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Favorite Color" displayName="Favorite Color" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetFavoriteColor(%source.PatientID)" factName="DxColor" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DiagD" displayName="DiagD" description="This level groups patients by their diagnoses (possibly more than one per patient). None means no diagnosis relevant to the study." disabled="false" hasAll="false" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Diagnoses" displayName="Diagnoses" disabled="false" sourceProperty="DiagnosesAsLB" factName="DxDiagnoses" list="true" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DocD" displayName="DocD" description="These levels group patients by their primary care physician (if any)." disabled="false" hasAll="false" type="data" hidden="false" showHierarchies="false">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Doctor Group" displayName="Doctor Group" description="Doctors are assigned to Doctor Groups, in this fictitious study." disabled="false" sourceProperty="PrimaryCarePhysician.DoctorGroup" factName="DxDocGroup" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Doctor" displayName="Doctor" description="Duplicate names are possible. Keys are forced to be unique." disabled="false" sourceExpression="%source.PrimaryCarePhysician" factName="DxDoc" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
        <property name="Name" displayName="Name" disabled="false" sourceExpression="%source.PrimaryCarePhysician.LastName_&quot;, &quot;_%source.PrimaryCarePhysician.FirstName" factName="PxDoc" hidden="true" sort="asc" isName="true" isDescription="false" isReference="false" useDisplayValue="false">
        </property>
      </level>
    </hierarchy>
    <hierarchy name="H2" displayName="H2" disabled="false" hidden="false">
      <level name="Doctor Type" displayName="Doctor Type" description="Primary discipline of the doctor" disabled="false" sourceProperty="PrimaryCarePhysician.DoctorType" factName="DxDocType" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="GenD" displayName="GenD" description="This level groups patients by gender." disabled="false" hasAll="false" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Gender" displayName="Gender" disabled="false" sourceProperty="Gender" factName="DxGender" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="HomeD" displayName="HomeD" description="These levels group patients by home address." disabled="false" hasAll="false" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="ZIP" displayName="ZIP" description="In this demo, cities are contained inside ZIP codes." disabled="false" sourceProperty="HomeCity.PostalCode" factName="DxHomeZIP" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="City" displayName="City" description="This level has three properties. One property is used as the city name; this one is hidden." disabled="false" sourceProperty="HomeCity" factName="DxHomeCity" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
        <property name="Population" displayName="Population" disabled="false" sourceProperty="HomeCity.Population" factName="PxPopulation" hidden="false" isName="false" isDescription="false" isReference="true" useDisplayValue="false">
        </property>
        <property name="Principal Export" displayName="Principal Export" disabled="false" sourceProperty="HomeCity.PrincipalExport" factName="PxExport" hidden="false" isName="false" isDescription="false" isReference="true" useDisplayValue="false">
        </property>
        <property name="Name" displayName="Name" disabled="false" sourceProperty="HomeCity.Name" factName="PxName" hidden="true" isName="true" isDescription="false" isReference="true" useDisplayValue="false">
        </property>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PatGrpD" displayName="PatGrpD" disabled="false" hasAll="false" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Tested" displayName="Tested" description="We have test scores only for patients in groups A and B." disabled="false" sourceExpression="$SELECT(%source.TestScore=&quot;&quot;:&quot;No&quot;,1:&quot;Yes&quot;)" factName="DxTested" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Patient Group" displayName="Patient Group" description="Patients are assigned to Patient Groups, in this fictitious study." disabled="false" sourceExpression="$CASE(%source.PatientGroup,&quot;A&quot;:&quot;Group A&quot;,&quot;B&quot;:&quot;Group B&quot;,:&quot;None&quot;)" factName="DxPatGroup" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ProfD" displayName="ProfD" description="These levels group patients by profession and industry." disabled="false" hasAll="false" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Industry" displayName="Industry" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetIndustry(%source.PatientID)" factName="DxIndustry" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Profession" displayName="Profession" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetProfession(%source.PatientID)" factName="DxProfession" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ComputedD" displayName="ComputedD" disabled="false" hasAll="false" type="computed" dimensionClass="%DeepSee.ComputedDimension.SQL" hidden="false" showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" hidden="false">
      <level name="Computed" displayName="Computed" disabled="false" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
        <member name="member 1" displayName="member 1" description="This computed member is defined by an SQL query" disabled="false" spec="select ID from DeepSee_Model_PatientsCube.Fact WHERE MxAge&lt;50 AND DxHomeCity-&gt;PxName=&apos;Elm Heights&apos;">
        </member>
        <member name="member 2" displayName="member 2" description="This computed member is defined by an SQL query" disabled="false" spec="select ID from $$$TABLE WHERE MxAge=40 AND DxHomeCity-&gt;PxName=&apos;Juniper&apos;">
        </member>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="BirthDateTime" disabled="false" hasAll="false" allCaption="All BirthDateTime" allDisplayName="BirthDateTime" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="YMD hms" disabled="false" sourceExpression="$ZDT(%source.BirthDate_&quot;,&quot;_%source.BirthTime,3)" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Age" displayName="Age" disabled="false" sourceProperty="Age" factName="MxAge" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="Avg Age" displayName="Avg Age" disabled="false" sourceProperty="Age" aggregate="AVG" hidden="false" searchable="false">
  </measure>
  <measure name="Allergy Count" displayName="Allergy Count" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetAllergyCount(%source.%ID)" aggregate="SUM" type="integer" hidden="false" searchable="true">
  </measure>
  <measure name="Avg Allergy Count" displayName="Avg Allergy Count" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetAllergyCount(%source.%ID)" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="Encounter Count" displayName="Encounter Count" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetEncounterCount(%source.%ID)" aggregate="SUM" type="integer" hidden="false" searchable="true">
  </measure>
  <measure name="Avg Enc Count" displayName="Avg Enc Count" disabled="false" sourceExpression="##class(DeepSee.Model.PatientsCube).GetEncounterCount(%source.%ID)" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="Test Score" displayName="Test Score" disabled="false" sourceProperty="TestScore" aggregate="SUM" hidden="false" searchable="true">
  </measure>
  <measure name="Avg Test Score" displayName="Avg Test Score" disabled="false" sourceProperty="TestScore" aggregate="AVG" hidden="false" searchable="false">
  </measure>
  <calculatedMember name="Unique Doctor Count" displayName="Unique Doctor Count" description="This calculated measure counts members of the DocD dimension" disabled="false" dimension="Measures" valueExpression="COUNT([docd].[h1].[doctor].MEMBERS,EXCLUDEEMPTY)" hidden="false">
  </calculatedMember>
  <calculatedMember name="Median Test Score" displayName="Median Test Score" description="This calculated member demos the sample median plugin" disabled="false" dimension="Measures" valueExpression="%KPI(&quot;%DeepSee.Median&quot;,&quot;MEDIAN&quot;,1,&quot;%measure&quot;,&quot;Test Score&quot;,&quot;%CONTEXT&quot;)" formatString="#.##" hidden="false">
  </calculatedMember>
  <calculatedMember name="90th Percentile Test Score" displayName="90th Percentile Test Score" description="This calculated member demos the sample percentile plugin" disabled="false" dimension="Measures" valueExpression="%KPI(&quot;%DeepSee.Percentile&quot;,&quot;PERCENTILE&quot;,1,&quot;%measure&quot;,&quot;Test Score&quot;,&quot;%percentile&quot;,&quot;90&quot;,&quot;%CONTEXT&quot;)" formatString="#.##" hidden="false">
  </calculatedMember>
  <calculatedMember name="Primary Colors" displayName="Primary Colors" description="This calculated member uses %OR to combine members of the ColorD dimension" disabled="false" dimension="ColorD" valueExpression="%OR({[COLORD].[H1].[FAVORITE COLOR].&amp;[Blue],[COLORD].[H1].[FAVORITE COLOR].&amp;[Red],[COLORD].[H1].[FAVORITE COLOR].&amp;[Yellow]})" hidden="false">
  </calculatedMember>
  <calculatedMember name="Secondary Colors" displayName="Secondary Colors" description="This calculated member uses %OR to combine members of the ColorD dimension" disabled="false" dimension="ColorD" valueExpression="%OR({[COLORD].[H1].[FAVORITE COLOR].&amp;[Green],[COLORD].[H1].[FAVORITE COLOR].&amp;[Orange],[COLORD].[H1].[FAVORITE COLOR].&amp;[Purple]})" hidden="false">
  </calculatedMember>
  <namedSet name="Sample Set" displayName="Sample Set" disabled="false" setExpression="homed.h1.city.MEMBERS">
  </namedSet>
  <namedSet name="Sample Set 2" displayName="Sample Set 2" disabled="false" setExpression="{colord.h1.[favorite color].red,allerd.h1.allergies.wheat,aged.h1.age.75}">
  </namedSet>
  <listing name="Patient details" displayName="Patient details" disabled="false" listingType="table" fieldList="PatientID,Age,Gender,HomeCity-&gt;Name AS &quot;Home City&quot;,TestScore AS &quot;Test Score&quot;" orderBy="Age,Gender">
  </listing>
  <listing name="Doctor details" displayName="Doctor details" disabled="false" listingType="table" fieldList="PatientID,PrimaryCarePhysician-&gt;LastName As &quot;Doctor Last Name&quot;,PrimaryCarePhysician-&gt;FirstName AS &quot;Doctor First Name&quot;,PrimaryCarePhysician-&gt;DoctorType AS &quot;Doctor Type&quot;,PrimaryCarePhysician-&gt;DoctorGroup AS &quot;Doctor Group&quot;" orderBy="PatientID">
  </listing>
  <listing name="Custom SQL listing" displayName="Custom SQL listing" disabled="false" listingType="table" sql="SELECT source.PatientID,FavoriteColor FROM $$$SOURCE, DeepSee_Study.PatientDetails details   WHERE $$$RESTRICT AND source.PatientID=details.PatientID ORDER BY source.PatientID">
  </listing>
</cube>
}

/// Returns the number of allergies the patient has or null if there are no recorded allergies; 
/// used by the Allergy Count measure.
ClassMethod GetAllergyCount(ID As %Numeric) As %Numeric
{
	Set allergies=##class(DeepSee.Study.Patient).%OpenId(ID,0).Allergies
    //check to see if patient has any recorded allergy data
    //if not, count is null
    
    If allergies.Count()=0 {
		Set allcount=""
		}
		 //check to see if patient has "Nil known allergies"
		 //in this case, the patient has one "allergen" whose code is 000
		Elseif ((allergies.Count()=1) && (allergies.GetAt(1).Allergen.Code="000")) {
		        Set allcount=0
		        }
		Else {
	        Set allcount=allergies.Count()
	        }		        
	    
	Quit allcount
	
	//Quit allergies.Count() ; old simple version doesn't handle case where "allergen"
	//is "Nil known allergies"
}

/// Returns the number of encounters recorded for the patient; 
/// used by the Encounter Count measure.
ClassMethod GetEncounterCount(ID As %Numeric) As %Numeric
{
    Set myquery="SELECT Count(*) AS ReturnValue FROM DeepSee_Study.PatientEncounter "
              _ "WHERE Patient=?"
    Set rset=##class(%ResultSet).%New("%DynamicQuery:SQL")
    Set status=rset.Prepare(myquery)
    If $$$ISERR(status) {Do $System.Status.DisplayError(status) Write "Prepare error"}
    Set status=rset.Execute(ID)
    If $$$ISERR(status) {Do $System.Status.DisplayError(status) Write "Execute error"}
    While rset.Next() {
     Set ReturnValue=rset.Data("ReturnValue")
     }
    If ReturnValue="" {
        Set ReturnValue=0
        }        
    Quit ReturnValue
}

/// Returns a $LIST of the allergies of the patient; 
/// used by the [AllerD].[H1].[Allergies] level."
ClassMethod GetAllergies(ID As %Numeric) As %List
{
    Set allergies=##class(DeepSee.Study.Patient).%OpenId(ID,0).Allergies
    If (allergies.Count()=0) {Quit $LISTFROMSTRING("")}
    Set list=""
    For i=1:1:allergies.Count() {
        Set $LI(list,i)=allergies.GetAt(i).Allergen.Description
        }
    Quit list
}

/// Returns a $LIST of the allergy severities of the patient; 
/// used by the [AllerSevD].[H1].[Allergy Severities] level.
/// <p>Not currently used.
ClassMethod GetAllergySeverities(ID As %Numeric) As %List
{
    Set allergies=##class(DeepSee.Study.Patient).%OpenId(ID,0).Allergies
    If (allergies.Count()=0) {
	    Set list=$LISTFROMSTRING("")
	    }
        //check to see if patient has "Nil known allergies"
		//in this case, the patient has one "allergen" whose code is 000
	    Elseif ((allergies.Count()=1) && (allergies.GetAt(1).Allergen.Code="000")) {
		    Set list=$LISTFROMSTRING("Nil known allergies")
		    }
    	Else {
	    	Set list=""
            For i=1:1:allergies.Count() {
                Set $LI(list,i)=allergies.GetAt(i).Severity.Description
                }
	        }
    Quit list
}

/// Returns a $LIST of the allergy severities of the patient; 
/// used by the [AllerSevD].[H1].[Allergy Severities] level.
/// <p> In this version, prepend each severity with the corresponding numeric code
/// (or an invented code), in order to force the members to sort as wanted.
ClassMethod GetAllergySeverities2(ID As %Numeric) As %List
{
    Set allergies=##class(DeepSee.Study.Patient).%OpenId(ID,0).Allergies
    If (allergies.Count()=0) {
	    Set list=$LISTFROMSTRING("999 No Data Available")
	    }
        //check to see if patient has "Nil known allergies"
		//in this case, the patient has one "allergen" whose code is 000
	    Elseif ((allergies.Count()=1) && (allergies.GetAt(1).Allergen.Code="000")) {
		    Set list=$LISTFROMSTRING("000 Nil known allergies")
		    }
    	Else {
	    	Set list=""
            For i=1:1:allergies.Count() {
	            //get the code, check to see if null
	            //if so, replace with standard no data available string
	            Set code=allergies.GetAt(i).Severity.Code
	            If code="" { Set code="999 No Data Available"}
                Set $LI(list,i)=code_" "_allergies.GetAt(i).Severity.Description
                }
	        }
    Quit list
}

/// Returns a $LIST of the diagnoses of the patient; 
/// used by the [DiagD].[H1].[Diagnoses] level.
ClassMethod GetDiagnoses(ID As %Numeric) As %List
{
    Set diagnoses=##class(DeepSee.Study.Patient).%OpenId(ID,0).DiagnosesAsChildren
    If (diagnoses.Count()=0) {Quit $LISTFROMSTRING("")}
    Set list=""
    For i=1:1:diagnoses.Count() {
        Set $LI(list,i)=diagnoses.GetAt(i).DiagnosisCode
        }
    Quit list
}

/// Returns the favorite color of the patient; 
/// used by the [ColorD].[H1].[Favorite Color] level.
ClassMethod GetFavoriteColor(patientID As %String) As %String
{
    New SQLCODE
    &sql(SELECT FavoriteColor INTO :ReturnValue 
    FROM DeepSee_Study.PatientDetails 
    WHERE PatientID=:patientID)
    If (SQLCODE'=0) {
        Set ReturnValue=""
        }
    Quit ReturnValue
}

/// Returns the profession of the patient; 
/// used by the [ProfD].[H1].[Profession] level.
ClassMethod GetProfession(patientID As %String) As %String
{
    New SQLCODE
    &sql(SELECT Profession->Profession INTO :ReturnValue 
    FROM DeepSee_Study.PatientDetails 
    WHERE PatientID=:patientID)
    If (SQLCODE'=0) {
        Set ReturnValue=""
        }
    Quit ReturnValue
}

/// Returns the industry of the patient; 
/// used by the [ProfD].[H1].[Industry] level.
ClassMethod GetIndustry(patientID As %String) As %String
{
    New SQLCODE
    &sql(SELECT Profession->Industry INTO :ReturnValue 
    FROM DeepSee_Study.PatientDetails 
    WHERE PatientID=:patientID)
    If (SQLCODE'=0) {
        Set ReturnValue=""
        }
    Quit ReturnValue
}

/// Returns the name of the patient's primary care physician. 
/// Not used by the cube but included as an example of a utility method.
ClassMethod GetDocName(ID As %Numeric) As %String
{
    Set pat=##class(DeepSee.Study.Patient).%OpenId(ID,0)
    Set doc=pat.PrimaryCarePhysician
    
    Set docname=""
    If (doc'="") {
	      Set docname=doc.LastName_", "_doc.FirstName
		  }
	Quit docname
}

/// Given a number, returns one of the strings "0 to 9", "10 to 19", "20 to 29", etc. 
/// Used by the cube as an alternative to rangeExpression
ClassMethod GetAgeBucket(age As %Numeric) As %String
{
    If (age="") {Set return=""}
    ElseIf (age<10) {Set return="0 to 9"}
    ElseIf (age<20) {Set return="10 to 19"}
    ElseIf (age<30) {Set return="20 to 29"}
    ElseIf (age<40) {Set return="30 to 39"}
    ElseIf (age<50) {Set return="40 to 49"}
    ElseIf (age<60) {Set return="50 to 59"}
    ElseIf (age<70) {Set return="60 to 69"}
    ElseIf (age<80) {Set return="70 to 79"}
    Else {Set return="80+"}
    Quit return
}

/// Given a number, returns one of the strings "0 to 29", "30 to 59",or "60+". 
/// Not used by the cube, but included as an example of a utility method.
ClassMethod GetAgeGroup(age As %Numeric) As %String
{
    If (age="") {Set return=""}
    ElseIf (age<30) {Set return="0 to 29"}
    ElseIf (age<60) {Set return="30 to 59"}
    Else {Set return="60+"}
    Quit return
}

/// Given a patient, returns the name of the doctor at the patient's last encounter, if any.
/// Not used by the cube but included as an example of a utility method.
ClassMethod GetLastDoctor(pat As %Numeric) As %String
{
    New SQLCODE
    Set docname=""
    &sql(select TOP 1 PrimaryDoctor INTO :doctor 
	FROM Deepsee_Study.PatientEncounter 
	WHERE Patient=:pat ORDER BY EncounterNumber )
    If (SQLCODE'=0) {
        Quit ""
        }
    Set doc=##class(DeepSee.Study.Doctor).%OpenId(doctor,0)
    Set docname=doc.LastName_", "_doc.FirstName
    Quit docname
}

/// used to control sort order of Allergy Severity level
ClassMethod GetSeveritySort(severity As %String) As %Integer
{
   if (severity="Nil known allergies") {
	   set sort=1
   } elseif (severity="Minor") {
		set sort=2
   } elseif (severity="Moderate") {
		set sort=3
   } elseif (severity="Life-threatening") {
		set sort=4
   } elseif (severity="Inactive") {
		set sort=5
   } elseif (severity="Unable to determine") {
		set sort=6
   } else {
	   set sort=99
   }
   quit sort
}

Parameter DOMAIN = "PATIENTSAMPLE";

}

