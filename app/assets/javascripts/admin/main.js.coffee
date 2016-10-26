$(document).on 'turbolinks:load', ->
  $('#table_list').dataTable()
  $('#range-date').daterangepicker
    locale:
      format: 'YYYY/MM/DD'
  setRangeDate = (rangedate) ->
    result = rangedate.split '-'
    $('#course_start_date').val result[0]
    $('#course_end_date').val result[1]
  setRangeDate $('#range-date').val()
  $('#range-date').change ->
    setRangeDate $('#range-date').val()

