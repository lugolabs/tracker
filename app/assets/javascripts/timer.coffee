class app.Timer
  constructor: ->
    @_playBtn      = $('#app-timer-btn')
    @_playLink     = $('#app-timer-link')
    @_playDisabled = $('#app-timer-link-disabled')
    @_taskLink     = $('#app-header-user-drop-task-link')
    @_task         = $('#app-header-user-drop-task')
    @_ticker       = $('#app-timer-ticker')

  play: (taskName, url, started) ->
    @_started = started
    @_start()
    @_taskLink.addClass('playing')
    @_task.html(taskName)
    @_playLink.attr('href': url).removeClass('hidden')
    @_playDisabled.addClass('hidden')
    @_playBtn
      .removeClass('iconly-0875-play-circle')
      .addClass('iconly-0874-stop-circle')

  stop: (url) ->
    @_stopTimer()
    @_setTicker()
    @_playLink.attr('href': url)
    @_playBtn
      .removeClass('iconly-0874-stop-circle')
      .addClass('iconly-0875-play-circle')

  _start: (started) ->
    fn = => @_setTicker(@_duration())
    @_stopTimer()
    fn()
    @_timerInterval = window.setInterval(fn, 1000)

  _setTicker: (value = '00:00:00') ->
    @_ticker.html value

  _stopTimer: ->
    window.clearInterval(@_timerInterval) if @_timerInterval

  _duration: ->
    now = moment().unix()
    duration = moment.duration(now - @_started).asMilliseconds()
    @_formatTime duration

  _formatTime: (secs) ->
    hours   = @_pad(Math.floor(secs / 3600) || 0)
    minutes = @_pad(Math.floor((secs - hours * 3600) / 60) || 0)
    seconds = @_pad((secs - hours * 3600 - minutes * 60) || 0)
    "#{hours}:#{minutes}:#{seconds}"

  _pad: (value) ->
    if value < 0
      '00'
    else if value < 10
      "0#{value}"
    else
      value
