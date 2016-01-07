# Trainer controller
class Dashboard::TrainerController < Dashboard::BaseController
  def index
    card_by_request_param
  end

  def review_card
    @card = current_user.cards.find(params[:card_id])

    check_result = @card.check_translation(trainer_params[:user_translation])

    if check_result[:state]
      check_distant(check_result)
      redirect_to trainer_path
    else
      flash[:alert] = t(:incorrect_translation_alert)
      redirect_to trainer_path(id: @card.id)
    end
  end

  private

  def trainer_params
    params.permit(:user_translation)
  end

  def check_distant(check_result)
    if check_result[:distance] == 0
      flash[:notice] = t(:correct_translation_notice)
    else
      flash[:alert] = t 'translation_from_misprint_alert',
                        user_translation: trainer_params[:user_translation],
                        original_text: @card.original_text,
                        translated_text: @card.translated_text
    end
  end
end
