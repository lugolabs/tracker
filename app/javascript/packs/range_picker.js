import moment from 'moment'

export default class {
  constructor(selector, label, startDate, endDate) {
    this.startDate = moment(startDate * 1000)
    this.endDate   = moment(endDate * 1000)
    const input    = $(selector).val(this.prepareValue(label, this.startDate, this.endDate))

    input.daterangepicker(this.options(), (start, end, label) => {
      input.val(this.prepareValue(label, moment(start), moment(end)))
      const data = {
        report_filter: {
          start_at: parseInt(start / 1000),
          end_at:   parseInt(end / 1000),
          interval: (label || 'Custom')
        }
      }
      const url = `/reports?${$.param(data)}`
      Turbolinks.visit(url)
    })
  }

  prepareValue(label, start, end) {
    if (label && label != 'Custom') {
      return label
    } else {
      return `${start.format('D MMM YYYY')} - ${end.format('D MMM YYYY')}`
    }
  }

  options() {
    return {
      startDate:            this.startDate,
      endDate:              this.endDate,
      autoUpdateInput:      false,
      alwaysShowCalendars:  true,
      showCustomRangeLabel: false,
      locale: {
        format: 'D MMM YYYY',
        firstDay: 1
      },
      ranges: {
        'Today':      [moment(), moment()],
        'Yesterday':  [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'This Week':  [moment().startOf('isoWeek'), moment()],
        'Last Week':  [moment().subtract(1, 'week').startOf('isoWeek'), moment().subtract(1, 'week').endOf('isoWeek')],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      }
    }
  }
}
