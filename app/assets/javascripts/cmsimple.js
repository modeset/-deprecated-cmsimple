 /* CMSimple / Mercury manifest
  *
  * Vendor dependencies
  *
  * Minimum jQuery requirements are 1.7
  *= require jquery-1.7
  *= require jquery_ujs
  *
  *= require jquery.to-json
  *
  * Underscore.js
  *= require underscore-1.3.1
  *
  * Moment.js
  *= require moment-1.6.2
  *
  * Spine (1.0.6)
  *= require spine/spine
  *= require spine/ajax
  *= require spine/relation
  *= require spine/route

  *
  * Haml Coffee Templates
  *= require hamlcoffee
  *
  * Mercury specifics
  *
  * Add all requires for the support libraries that integrate nicely with Mercury Editor.
  * require mercury/support/history
  *
  * Mercury configuration
  *= require cmsimple/mercury/config
  *
  * Require Mercury Editor itself.
  *= require mercury/mercury
  *
  *= require jquery.ui.nestedSortable-1.3.4
  *= require jquery-serializeObject
  *
  * Require any localizations you wish to support
  * Example: es.locale, or fr.locale -- regional dialects are in each language file so never en_US for instance.
  * require mercury/locales/swedish_chef.locale
  *
  * Custom Mercury handlers for CMSimple
  *= require cmsimple/mercury/handlers
  *
  * CMSimple Editor
  *
  *= require cmsimple/lib/namespaces
  *= require cmsimple/lib/support
  *
  *= require cmsimple/panels/page_metadata
  *= require cmsimple/panels/publish
  *= require cmsimple/panels/sitemap
  *= require cmsimple/panels/redirects
  *= require cmsimple/panels/images
  *= require cmsimple/panels/versions
  *
  *= require cmsimple/controllers/editor
  *
  */
