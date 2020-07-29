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