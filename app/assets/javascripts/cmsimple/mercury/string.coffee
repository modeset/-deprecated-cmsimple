String::trim = ->
  @replace(/^\s+|\s+$/g, '')


String::toCamelCase = (first = false) ->
  if first
    @toTitleCase().replace(/([\-|_][a-z])/g, ($1) -> $1.toUpperCase().replace(/[\-|_]/, ''))
  else
    @replace(/([\-|_][a-z])/g, ($1) -> $1.toUpperCase().replace(/[\-|_]/, ''))


String::toDash = ->
  @replace(/([A-Z])/g, ($1) -> "-#{$1.toLowerCase()}").replace(/^-+|-+$/g, '')


String::toUnderscore = ->
  @replace(/([A-Z])/g, ($1) -> "_#{$1.toLowerCase()}").replace(/^_+|_+$/g, '')
