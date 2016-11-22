{exec} = require 'child_process'

module.exports =
  activate: ->
#-------------------------------------------------------------------------------

    @subs = atom.workspace.observeTextEditors (editor) ->
      plist = editor.getPath()
      {scopeName} = editor.getGrammar()

      if /\.(plist|strings)$/.test(scopeName) and
        editor.buffer?.getLines()[0]?.startsWith 'bplist00'

          # Decompile from binary to XML for editing.
          {stdout} = exec "plutil -convert xml1 -o - '#{plist}'"
          stdout.on 'data', (XML) -> editor.setText XML

          editor.onDidDestroy -> # Recompile binary from XML.
            exec "plutil -convert binary1 '#{plist}'"

#-------------------------------------------------------------------------------
  deactivate: -> @subs.dispose()
