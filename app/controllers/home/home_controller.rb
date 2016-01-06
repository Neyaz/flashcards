class Home::HomeController < Home::BaseController

  def index
    get_card_by_request_param
  end
end
