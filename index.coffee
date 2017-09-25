{exec} = require 'child_process'

module.exports =
  activate: ->
#-------------------------------------------------------------------------------

    @subs = atom.workspace.observeTextEditors (editor) ->
      plist = editor.getPath()
      {scopeName} = editor.getGrammar()

      #console.log "MyTest:", editor.getTitle(), plist

      if  editor.buffer?.getLines()[0]?.startsWith 'bplist00'
          # Decompile from binary to XML for editing.
          {stdout} = exec "plutil -convert xml1 -o - '#{plist}'"
          editor.setText ""
          editor.setGrammar(atom.grammars.grammarForScopeName 'text.xml.plist')
          stdout.on 'data', (XML) ->
            myBuffer = editor.getText() + XML
            editor.setText myBuffer

          editor.onDidDestroy -> # Recompile binary from XML.
            exec "plutil -convert binary1 '#{plist}'"

          #editor.onDidSave ->
          #  myBuffer = editor.getText()
          #  console.log "OnSave: ", myBuffer
          #  exec "plutil -convert binary1 '#{plist}'"
          #  editor.setText myBuffer

#-------------------------------------------------------------------------------
  deactivate: -> @subs.dispose()
