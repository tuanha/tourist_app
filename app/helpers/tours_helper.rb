module ToursHelper

  def device_info (user, tour)
    if user.device
      "#{user.device.name} <i class='fa fa-times remove-device' aria-hidden='true' data-device-id='#{user.device.id}' data-tour-id='#{tour.id}'></i>".html_safe
    else
      select_tag 'device',options_from_collection_for_select(@device_availabes, 'id', 'name'), class: 'set-device', data_type: user.class.name, data_user_id: user.id, data_tour_id: tour.id,include_blank: 'Choose Device'
    end
  end
end
