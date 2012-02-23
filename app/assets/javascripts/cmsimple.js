 /* CMSimple / Mercury manifest
  *
  * Vendor dependencies
  *
  * Minimum jQuery requirements are 1.7
  *= require mercury/dependencies/jquery-1.7
  *
  *= require jquery.to-json
  *
  * Underscore.js
  *= require underscore-1.3.1
  *
  * Spine.js (spine-rails)
  *= require spine
  *= require spine/ajax
  *= require spine/relation
  *= require spine/route
  *
  * Mercury specifics
  *
  * Add all requires for the support libraries that integrate nicely with Mercury Editor.
  * require mercury/support/history
  *
  * Mercury configuration
  *= require mercury/config
  *
  * Require Mercury Editor itself.
  *= require mercury/mercury
  *
  * Require any localizations you wish to support
  * Example: es.locale, or fr.locale -- regional dialects are in each language file so never en_US for instance.
  * require mercury/locales/swedish_chef.locale
  *
  * Custom Mercury handlers for CMSimple
  *= require mercury/handlers
  *
  * CMSimple Editor
  *
  *= require lib/namespaces
  *= require lib/support
  *
  *= require panels/page_metadata
  *= require controllers/editor
  *= require models/page
  */
