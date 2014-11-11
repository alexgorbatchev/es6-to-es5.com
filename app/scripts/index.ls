<-! $

defaultValue = '''
  class Foo {
    static foo() {

    }
  }

  class Bar extends Foo {
    static foo() {
      super();
    }
  }
  '''

codeMirrorOptions =
  lineNumbers     : true
  tabSize         : 2
  mode            : 'javascript'
  theme           : 'neat'
  styleActiveLine : true

setupPreview = ->
  element = $ '.Preview .CodeMirror-container' .get 0

  CodeMirror element, {} <<< codeMirrorOptions <<<
    readOnly  : true
    autofocus : false

setupEditor = (preview) ->
  element = $ '.Source .CodeMirror-container' .get 0
  smc = null

  editor = CodeMirror element, {} <<< codeMirrorOptions <<<
    value     : defaultValue
    autofocus : true
    gutters   : [\CodeMirror-linenumbers, \CodeMirror-errors]

    extraKeys:
      'Ctrl-Space': 'autocomplete'

  highlightActiveLine = !->
    {line, ch: column} = editor.getCursor!

    if smc?
      opts =
        source : 'es6-to-es5.js'
        line   : line + 1
        column : column

      {line, column} = smc.generatedPositionFor opts
      preview.setCursor line: line - 1, ch: column

  generateES5 = !->
    {left, top} = preview.getScrollInfo!
    selections = preview.listSelections!
    smc := null

    try
      editor.clearGutter \CodeMirror-errors

      {code, map, ast} = to5.transform editor.getValue!,
        sourceMap : true
        filename  : 'es6-to-es5.js'

      preview.setValue code
      preview.scrollTo left, top

      smc := new sourceMap.SourceMapConsumer map
      highlightActiveLine!
    catch e
      if e._6to5
        preview.setValue e.message
        editor.setGutterMarker e.loc.line - 1, \CodeMirror-errors, makeErrorGutterElement!
      else
        console.error e

  makeErrorGutterElement = (title) ->
    $ "<div class=\"CodeMirror-errorMarker\" title=\"#title\">&#10095;</div>" .get 0

  syncScrolling = ->
    $main = $ '.Source .CodeMirror-scroll'
    secondary = $('.Preview .CodeMirror-scroll').get 0

    $main.on 'scroll', $.throttle 50, ->
      percentage = @scrollTop / (@scrollHeight - @offsetHeight)
      secondary.scrollTop = percentage * (secondary.scrollHeight - secondary.offsetHeight)

  editor.on 'cursorActivity', highlightActiveLine
  editor.on 'change', $.debounce 1000, generateES5

  syncScrolling!
  generateES5!

  editor

setupEditor setupPreview!
