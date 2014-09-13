# grunt-newer:
# Check for newer @import .scss files example(CoffeeScript version)
# Customized of @bellerus https://gist.github.com/bellerus/10414499
# See: https://github.com/tschaub/grunt-newer/issues/29

module.exports.checkForModifiedImports = (details, action) ->
    fs = require('fs')
    path = require('path')
    scssFile = details.path
    mTime = details.time

    fs.readFile scssFile, "utf8", (err, data) ->
        scssDir = path.dirname scssFile
        regex = /@import "(.+?)(\.scss)?";/g
        shouldInclude = false
        match

        while (match = regex.exec(data)) isnt null
            importFile = "#{scssDir}/_#{match[1]}.scss"

            if fs.existsSync importFile
                stat = fs.statSync importFile

                if stat.mtime > mTime
                    shouldInclude = true
                    break

        action shouldInclude

