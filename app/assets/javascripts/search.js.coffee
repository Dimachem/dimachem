# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
jQuery ->
  $('form').on 'click', '.remove_condition', (event) ->
    $(this).closest('.row').remove()
    event.preventDefault()

  $('#formula_search').on 'click', '.add_condition', (event, type) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('form').on 'click', '.remove_sort', (event) ->
    $(this).closest('.row').remove()
    event.preventDefault()

  $('form').on 'click', '.add_sort', (event, type) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
