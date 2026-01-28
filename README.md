# datahub-map-icons
This repository contains updated map icons used by DataHub.

All updated icons live in the `assets` folder.

## Google Maps API Key
Provide your own Google Maps API key.

Example placeholder:

googleKey = "REPLACE_WITH_REAL_KEY"

## Google Maps API Key
The following logic redirects existing logo paths to the updated assets location:

if (h.ICON) {
  h.ICON = h.ICON.replace(
    "/chasdatahub/assets/img/logo/",
    "/map/assets/img/logo/"
  );
}

## Icon Sizing
The (60, 91) size preserves the original aspect ratio of the icons:

icon: house.ICON
  ? { url: house.ICON, scaledSize: new google.maps.Size(60, 91) }
  : null
