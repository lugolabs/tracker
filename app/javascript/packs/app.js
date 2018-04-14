import RangePicker from './range_picker'

export default class App {
  static start() {
    $(document)
      .on('turbolinks:load', function() {
        $('[data-toggle="tooltip"]').tooltip();
      })
      .on('ajax:complete', '[data-replace]', function(e) {
        $($(this).data('replace'))
          .replaceWith(e.detail[0].response)
          .find('[autofocus="autofocus"]').focus()
      })
      .on('ajax:complete', 'form', function(e) {
        $(this)
          .replaceWith(e.detail[0].response)
          .find('[autofocus="autofocus"]').focus()
      });

    window.app = window.app || new App;
  }

  update(daySelector, dayMarkup, slotsSelector, projectSelector, projectMarkup, dayId) {
    const dayEl = $(daySelector)
    if (dayEl.length) {
      dayEl.html(dayMarkup)
      const opened = $(slotsSelector).hasClass('show')
      const projectEl = $(projectSelector)
      if (projectEl.length) {
        projectEl.replaceWith(projectMarkup)
        if (opened) $(slotsSelector).addClass('show')
      } else {
        dayEl.after(projectMarkup)
      }
    } else {
      $('#timer-days').prepend(`<div class="mb-5" id="${dayId}">${dayMarkup}${projectMarkup}</div>`)
    }
  }

  remove(selector) {
    $(selector).remove()
  }

  rangePicker(selector, label, startDate, endDate) {
    new RangePicker(selector, label, startDate, endDate)
  }
}
