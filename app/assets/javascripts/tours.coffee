# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.remove-device').on 'click', ->
    if confirm('Are you sure?')
      device_id = $(this).attr('data-device-id')
      tour_id = $(this).attr('data-tour-id')
      $.ajax
        url: '/tours/remove_device'
        type: 'post'
        dateType: 'json'
        data: 'device_id=' + device_id + '&id=' + tour_id
        success: (result) ->
          window.location.reload()
          return
    return

  $('.set-device').on 'change', ->
    device_id = $(this).val()
    type = $(this).attr('data_type')
    user_id = $(this).attr('data_user_id')
    tour_id = $(this).attr('data_tour_id')
    if device_id == ''
      return false
    else
      $.ajax
        url: '/tours/set_device'
        type: 'post'
        dateType: 'json'
        data: 'device_id=' + device_id + '&type=' + type + '&user_id=' + user_id + '&id=' + tour_id
        success: (result) ->
          window.location.reload()
          return
    return

  $('.select_tourguide').on 'click', ->
    tour_id = $(this).attr('data-tour-id')
    tourguide_id = $(this).attr('data-tourguide-id')
    $.ajax
      url: '/tours/select_tourguide'
      method: 'POST'
      data: 'id=' + tour_id + '&tourguide_id=' + tourguide_id
      dataType: 'json'
      success: (data) ->
        window.location.reload()
        return
    return

  $('.cancel-tourguide').on 'click', ->
    if confirm('Are you sure?')
      tourguide_id = $(this).attr('data-tourguide-id')
      tour_id = $(this).attr('data-tour-id')
      $.ajax
        url: '/tours/cancel_tourguide'
        method: 'POST'
        data: 'tourguide_id=' + tourguide_id + '&id=' + tour_id
        dataType: 'json'
        success: (data) ->
          window.location.reload()
          return
    return

  $('.action-traveller').on 'click', ->
    traveller_id = $(this).attr('data-traveller-id')
    tour_id = $(this).attr('data-tour-id')
    status = $(this).attr('data-status')
    $.ajax
      url: '/tours/action_traveller'
      method: 'POST'
      data: 'id=' + tour_id + '&traveller_id=' + traveller_id + '&status=' + status
      dataType: 'script'
      success: (data) ->
    return
