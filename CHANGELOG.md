### 1.1.1
* Fix for sites not appearing on the world map
* Validations for ICCA site coordinates to stop invalid coordinates from being entered in.
* Ensure that page slugs are transliterated when the corresponding ICCA site is updated. 

### 1.1.0
* Updated with news and stories section 
    - Index page of articles with pagination enabled
    - Individual article page with social sharing links
* Small miscellaneous fixes, including language switching, update of map styles etc.

### 1.0.3
* Updated map styles as old Mapbox styles were deprecated.
* Fixed images that were too high for gallery. 

### 1.0.2

* Fixed a bug that would cause the case study pages to break if only one photo is present

### 1.0.1

* Changed CartoDB links in the HEAD to use HTTPS instead of HTTP.
* Photos are no longer excessively stretched on the case study pages if only two are present.

### 1.0.0 

* Migrated to ActiveStorage from Paperclip
* Migrated to using Webpacker alongside using Sprockets with legacy CoffeeScript
* Bower replaced with Yarn, which also means that the project now has its own set of stylesheets within the repo as opposed to pulling it in from protectedplanet-frontend.
* Installed Vue
* Fixed various issues, a few of which were major, to do with both the CMS and the website which were unfixed.
    - CMS UI has been improved for the upgraded CMS, as well as adding much-needed validations for adding resources, related links, photos, countries, ICCA sites and others.
    - Carousel for individual case studies now appears properly.
    - Removed hard-coded links and text and gave control back to admins.

### 0.0.2

* Update the method of checking for a data attribute on a dropdown so that it doesn't error out.

### 0.0.1

* Put in a fix so that the explore page doesn't error when a country page has been deleted.
* Merge in PR for new server details.