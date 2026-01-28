<cfsetting showdebugoutput="no">

<!--- change this to your CF datasource name --->
<cfparam name="request.dsn" default="IncidentMaster">

<!--- put your real Google Maps key here --->
<cfset googleKey = "REPLACE_WITH_REAL_KEY">

<!--- pull marker data from dbo.Dept --->
<cfquery name="qDept" datasource="#request.dsn#">
  SELECT
    DeptID,
    Department,
    latitude,
    longitude,
    ImageName
  FROM dbo.Dept
  WHERE latitude IS NOT NULL
    AND longitude IS NOT NULL
  ORDER BY Department
</cfquery>

<!--- build an array of structs for JS --->
<cfset houseArray = []>
<cfloop query="qDept">
  <cfset arrayAppend(houseArray, {
    id = qDept.DeptID,
    name = qDept.Department,
    lat = qDept.latitude,
    lng = qDept.longitude,
    icon = qDept.ImageName
  })>
</cfloop>

<cfset serializedData = serializeJSON(houseArray)>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>CHAS Map Test</title>

  <style>
    html, body { height: 100%; margin: 0; padding: 0; }
    #map { height: 100%; width: 100%; }
  </style>
</head>
<body>

    <cfdump var="#qDept.recordcount#" label="qDept.recordcount">
<cfdump var="#qDept#" top="15">


<div id="map"></div>

<script>
  var houses = <cfoutput>#serializedData#</cfoutput>;

  // Convert coords + fix icon URL
  houses.forEach(h => {
    h.LAT = parseFloat(h.LAT);
    h.LNG = parseFloat(h.LNG);

    // change /chasdatahub/assets/img/logo/xxx.png  -> /hello_world/map/assets/img/xxx.png
    if (h.ICON) {
      h.ICON = h.ICON.replace("/chasdatahub/assets/img/logo/", "/hello_world/map/assets/img/logo/");
    }
  });

  function initMap() {
    const map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: 39.9525, lng: -75.1965 },
      zoom: 16
    });

    houses.forEach(house => {
      if (!isFinite(house.LAT) || !isFinite(house.LNG)) return;

      new google.maps.Marker({
        position: { lat: house.LAT, lng: house.LNG },
        map,
        title: house.NAME,
        icon: house.ICON ? { url: house.ICON, scaledSize: new google.maps.Size(60, 91) } : null
      });
    });
  }
</script>




<script async defer
  src="https://maps.googleapis.com/maps/api/js?key=<cfoutput>#googleKey#</cfoutput>&callback=initMap">
</script>

</body>
</html>
