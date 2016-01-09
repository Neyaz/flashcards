# Home controller
class Home::HomeController < Home::BaseController
  def index
    card_by_request_param
  end
end
