
DOCTYPES = {
  '5': '<!DOCTYPE html>'
}

# Valid HTML 5 elements requiring a closing tag.
# Note: the `var` element is out for obvious reasons, please use `tag 'var'`.
REGULAR_TAGS = 'a abbr address article aside audio b bdi bdo blockquote body
  button canvas caption cite code colgroup datalist dd del details dfn div dl dt
  em fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
  html i iframe ins kbd label legend li main map mark menu meter nav noscript
  object ol optgroup option output p pre progress q rp rt ruby s samp script
  section select small span strong sub summary sup style svg table tbody td
  textarea tfoot th thead time title tr u ul video'.split ' '

# Valid self-closing HTML 5 elements.
SELF_CLOSING_TAGS = 'area base br col command embed hr img input keygen link
  meta param source track wbr'.split ' '

# list of lemoncup methods
METHODS = 'comment doctype _escape ie normalizeArgs raw render tag text'.split ' '

class Lemoncup
  constructor: ->
    @_html = null
    @_data = []

  clear: ->
    @_data = []

  attrOrder: ['id', 'class']

  resetBuffer: (html=null) ->
    previous = @_html
    @_html = html
    return previous

  render: (template, args...) ->

    # define elements
    for name, fn of lemoncup
      global?[name] = fn
      window?[name] = fn

    previous = @resetBuffer('')
    try
      template(args...)
    finally
      html = @resetBuffer previous

    # cleanup elements
    for name, fn of lemoncup
      delete global?[name]
      delete window?[name]

    return html

  renderAttr: (name, value) ->

    # if value is undefined, use attribute name but no value
    if not value?
      return " #{name}"

    # no attribute if value is false
    if value is false
      return ''

    # set value to name if value is true
    if value is true
      value = name

    # grouped data attributes
    if name is 'data' and typeof value is 'object'
      return (@renderAttr "data-#{k}", v for k, v of value).join('')

    # specify classes with a map of class -> boolean
    if name is 'class' and typeof value is 'object'
      value = ("#{k}" for k, v of value when v).join ' '
      return '' if value is ''

    # specify inline styles with an object
    if name is 'style' and typeof value is 'object'
      value = ("#{k}:#{v}" for k, v of value).join ';'
      return '' if value is ''

    # lemon event handler shorthand
    if name[0] is "$"
      name = "lemon-on:#{name.replace '$', ''}"

    # lemon event handlers
    if name is 'on' and typeof value is 'object'
      return (@renderAttr "lemon-on:#{k}", v for k, v of value).join('')

    # lemon attribute binding shorthand
    if name[0] is '_'
      name = "lemon-bind:#{name.replace '_', ''}"

    # lemon attribute bindings
    if name is 'bind' and typeof value is 'object'
      return (@renderAttr "lemon-bind:#{k}", v for k, v of value).join('')

    # lemon refs
    if name is 'ref'
      name = "lemon-ref"

    # lemon data passing
    if typeof value in ['function', 'object'] or name is 'lemon-data'
      @_data.push value
      value = @_data.length - 1

    # render attribute
    return " #{name}=#{@_quote @_escape value.toString()}"

  renderAttrs: (obj) ->
    result = ''

    # render explicitly ordered attributes first
    for name in @attrOrder when name of obj
      result += @renderAttr name, obj[name]

    # then unordered attrs
    for name, value of obj
      continue if name in @attrOrder
      result += @renderAttr name, value

    return result

  renderContents: (contents, rest...) ->
    if not contents?
      return
    else if typeof contents is 'function'
      result = contents.apply @, rest
      @text result if typeof result is 'string'
    else
      @text contents

  isSelector: (string) ->
    string.length > 1 and string.charAt(0) in ['#', '.']

  parseSelector: (selector) ->
    id = null
    classes = []
    for token in selector.split '.'
      token = token.trim()
      if id
        classes.push token
      else
        [klass, id] = token.split '#'
        classes.push token unless klass is ''
    return {id, classes}

  normalizeArgs: (args) ->
    attrs = {}
    selector = null
    contents = null

    for arg, index in args when arg?
      switch typeof arg
        when 'string'
          if index is 0 and @isSelector(arg)
            selector = arg
            parsedSelector = @parseSelector(arg)
          else
            contents = arg
        when 'function', 'number', 'boolean'
          contents = arg
        when 'object'
          if arg.constructor == Object
            attrs = arg
          else
            contents = arg
        else
          contents = arg

    if parsedSelector?
      {id, classes} = parsedSelector
      attrs.id = id if id?
      if classes?.length
        if attrs.class
          classes.push attrs.class
        attrs.class = classes.join(' ')

    return {attrs, contents, selector}

  tag: (tagName, args...) ->
    {attrs, contents} = @normalizeArgs args
    @raw "<#{tagName}#{@renderAttrs attrs}>"
    @renderContents contents
    @raw "</#{tagName}>"

  selfClosingTag: (tag, args...) ->
    {attrs, contents} = @normalizeArgs args
    @raw "<#{tag}#{@renderAttrs attrs} />"

  comment: (text) ->
    @raw "<!--#{@_escape text}-->"

  doctype: (type=5) ->
    @raw DOCTYPES[type]

  ie: (condition, contents) ->
    @raw "<!--[if #{@_escape condition}]>"
    @renderContents contents
    @raw "<![endif]-->"

  text: (s) ->
    @_html += s? and @_escape(s.toString()) or ''
    null

  raw: (s) ->
    return unless s?
    @_html += s
    null

  #
  # Filters
  # return strings instead of appending to buffer
  #

  # Don't escape single quote (') because we always quote attributes with double quote (")
  _escape: (text) ->
    text.toString().replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')

  _quote: (value) ->
    "\"#{value}\""

  #
  # Binding
  #
  bind: ->
    methods = [].concat METHODS, REGULAR_TAGS, SELF_CLOSING_TAGS
    for method in methods
      @[method] = @[method].bind this

# Define tag functions on the prototype for pretty stack traces
for tag in REGULAR_TAGS
  do (tag) ->
    Lemoncup::[tag] = (args...) -> @tag tag, args...

# Define tag functions on the prototype for pretty stack traces
for tag in SELF_CLOSING_TAGS
  do (tag) ->
    Lemoncup::[tag] = (args...) -> @selfClosingTag tag, args...

# export
lemoncup = new Lemoncup()
lemoncup.bind()
if module?.exports
  global.lemoncup = lemoncup
  module.exports = lemoncup
else
  window.lemoncup = lemoncup
