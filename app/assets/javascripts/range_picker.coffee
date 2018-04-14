class app.RangePicker
  _CUSTOM: 'Custom'

  constructor: (selector, label, startDate, endDate) ->
    @_startDate   = moment(startDate * 1000)
    @_endDate     = moment(endDate * 1000)
    input         = $(selector).val(@_prepareValue(label, @_startDate, @_endDate))
    form          = input.parents('form')
    startInput    = $('#report_filter_start_at')
    endInput      = $('#report_filter_end_at')
    intervalInput = $('#report_filter_interval')

    input.daterangepicker @_options(), (start, end, label) =>
      input.val @_prepareValue(label, moment(start), moment(end))
      data =
        report_filter:
          start_at: parseInt(start / 1000)
          end_at:   parseInt(end / 1000)
          interval: (label || @_CUSTOM)
      url = "/reports?#{$.param(data)}"
      Turbolinks.visit url

  _prepareValue: (label, start, end) ->
    if label && label != @_CUSTOM
      label
    else
      "#{start.format('D MMM YYYY')} - #{end.format('D MMM YYYY')}"

  _options: ->
    startDate:            @_startDate
    endDate:              @_endDate
    autoUpdateInput:      false
    alwaysShowCalendars:  true
    showCustomRangeLabel: false
    locale:
      format: 'D MMM YYYY'
      firstDay: 1
    ranges:
      'Today':      [moment(), moment()]
      'Yesterday':  [moment().subtract(1, 'days'), moment().subtract(1, 'days')]
      'This Week':  [moment().startOf('isoWeek'), moment()]
      'Last Week':  [moment().subtract(1, 'week').startOf('isoWeek'), moment().subtract(1, 'week').endOf('isoWeek')]
      'This Month': [moment().startOf('month'), moment().endOf('month')]
      'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
