import { Controller } from 'stimulus'
import moment from 'moment'

export default class extends Controller {
  static targets = ['play', 'taskName', 'taskNameLink', 'task', 'ticker']

  connect() {
    this.startTime = this.data.get('start')
    if (this.startTime) this.play()
  }

  toggle(e) {
    e.preventDefault()
    if (this.element.classList.contains('disabled')) return
    if (this.playing) {
      this.stop()
    } else {
      this.playNow()
    }
  }

  playTask(e) {
    e.preventDefault()
    this.url = e.target.getAttribute('data-url')
    this.taskNameLinkTarget.classList.add('loaded')
    this.taskNameTarget.innerHTML = e.target.getAttribute('data-name')
    this.playNow()
  }

  playNow() {
    this.startTime = moment().unix()
    this.play()
    $.post(this.url, (response) => { this.updatePageOnPlay(response) })
  }

  play() {
    this.start()
    this.element.classList.remove('disabled')
    this.element.classList.add('playing')
    this.playing = true
  }

  stop() {
    this.stopTimer()
    this.setTicker()
    this.element.classList.remove('playing')
    $.post(this.stopUrl, (response) => { this.updatePage(response) })
    this.playing = false
  }

  updatePageOnPlay(response) {
    if (response.stop_url) this.stopUrl = response.stop_url
    if (response.day_el) this.updatePage(response)
  }

  updatePage(response) {
    app.update(response.day_el, response.day, response.slots_el, response.project_day_el, response.slots)
  }

  start() {
    const fn = () => { this.setTicker(this.duration()) }
    this.stopTimer()
    fn()
    this.timerInterval = window.setInterval(fn, 1000)
  }

  duration() {
    const now = moment().unix()
    const duration = moment.duration(now - this.startTime).asMilliseconds()
    return this.formatTime(duration)
  }

  formatTime(secs) {
    const hours   = this.padValue(Math.floor(secs / 3600) || 0)
    const minutes = this.padValue(Math.floor((secs - hours * 3600) / 60) || 0)
    const seconds = this.padValue((secs - hours * 3600 - minutes * 60) || 0)
    return `${hours}:${minutes}:${seconds}`
  }

  padValue(value) {
    if (value < 0) {
      return '00'
    } else if (value < 10) {
      return `0${value}`
    } else {
      return value
    }
  }

  setTicker(value) {
    value = value || '00:00:00'
    this.tickerTarget.innerHTML = value
  }

  stopTimer() {
    if (this.timerInterval) window.clearInterval(this.timerInterval)
  }

  get stopUrl() {
    return this.data.get('stop')
  }

  set stopUrl(value) {
    this.data.set('stop', value)
  }

  get playing() {
    return this.data.get('playing') === '1'
  }

  set playing(value) {
    this.data.set('playing', value ? '1' : '0')
  }
}
