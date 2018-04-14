@app =
  start: ->
    app.timer ||= new app.Timer

  rangePicker: (selector, label, startDate, endDate) ->
    new app.RangePicker(selector, label, startDate, endDate)

  update: (daySelector, dayMarkup, slotsSelector, projectSelector, projectMarkup, dayId) ->
    dayEl = $(daySelector)
    if dayEl.length
      dayEl.html dayMarkup
      opened = $(slotsSelector).hasClass('show')
      projectEl = $(projectSelector)
      if projectEl.length
        projectEl.html projectMarkup
        $(slotsSelector).addClass('show') if opened
      else
        dayEl.after projectMarkup
    else
      markup = """
        <div class="mb-5" id="#{dayId}">
          #{dayMarkup}
          #{projectMarkup}
        </div>
      """
      $('#timer-days').prepend markup

  remove: (selector) ->
    $(selector).remove()
