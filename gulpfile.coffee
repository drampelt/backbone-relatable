gulp = require 'gulp'
$ = require('gulp-load-plugins')()
wiredep = require('wiredep').stream

paths =
  test:
    html: 'test/**/*.html'
    scripts: ['test/**/*.coffee', 'src/**/*.coffee']
    components: 'test/bower_components/**/*'
  tmp: '.tmp'


gulp.task 'wiredep', ->
  gulp.src paths.test.html
    .pipe wiredep devDependencies: true, directory: 'test/bower_components'
    .pipe gulp.dest 'test/'

gulp.task 'clean', ->
  gulp.src paths.tmp, read: false
    .pipe $.clean()

gulp.task 'scripts', ['clean'], ->
  gulp.src paths.test.scripts
    .pipe $.plumber()
    .pipe $.coffee()
    .pipe gulp.dest paths.tmp

gulp.task 'html', ['clean'], ->
  gulp.src paths.test.html
    .pipe gulp.dest paths.tmp

gulp.task 'components', ['clean'], ->
  gulp.src paths.test.components
    .pipe gulp.dest paths.tmp + '/bower_components'

gulp.task 'server', ['scripts', 'html', 'components'], ->
  $.connect.server
    root: [paths.tmp]
    port: 5732
    livereload: true

gulp.task 'test-deps', ['clean', 'scripts', 'html', 'components']

gulp.task 'test-browser', ['test-deps', 'server'], ->
  $.watch glob: paths.test.scripts, (files) ->
    files
      .pipe $.plumber()
      .pipe $.coffee()
      .pipe gulp.dest paths.tmp
      .pipe $.connect.reload()

  $.watch glob: paths.test.html, (files) ->
    files
      .pipe gulp.dest paths.tmp
      .pipe $.connect.reload()

gulp.task 'test', ['test-deps'], ->
  gulp.src paths.tmp + '/index.html'
    .pipe $.mochaPhantomjs()
