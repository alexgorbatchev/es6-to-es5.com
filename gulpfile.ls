require! {
  'gulp'
  'gulp-filesize' : filesize
  'gulp-concat'   : concat
  'gulp-print'    : print
  'gulp-uglify'   : uglify
}

gulp.task 'build-thirdparty', ->
  gulp.src [
    # 'bower_components/jquery/dist/jquery.js'
    'bower_components/jquery-throttle-debounce/jquery.ba-throttle-debounce.js'

    # codemirror
    'bower_components/codemirror/lib/codemirror.js'
    'bower_components/codemirror/addon/mode/overlay.js'
    'bower_components/codemirror/addon/hint/show-hint.js'
    'bower_components/codemirror/addon/hint/anyword-hint.js'
    'bower_components/codemirror/addon/dialog/dialog.js'
    'bower_components/codemirror/addon/search/search.js'
    'bower_components/codemirror/addon/search/search.js'
    'bower_components/codemirror/addon/selection/active-line.js'
    'bower_components/codemirror/addon/search/searchcursor.js'
    'bower_components/codemirror/mode/javascript/javascript.js'
    'bower_components/codemirror/keymap/vim.js'

    # 'bower_components/mousetrap/mousetrap.js'
    # 'bower_components/mousetrap/plugins/global-bind/mousetrap-global-bind.js'
  ]
  .pipe concat 'thirdparty.js'
  .pipe uglify!
  .pipe gulp.dest 'app/public'
  .pipe print -> "Generated -> #{it}"

gulp.task 'build', ['build-thirdparty']
