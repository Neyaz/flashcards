# Module with translation checking functions
module Translationable
  def check_translation(user_translation)
    distance = Levenshtein.distance(full_downcase(translated_text),
                                    full_downcase(user_translation))

    sm_hash = SuperMemo.algorithm(interval,
                                  repeat,
                                  efactor,
                                  attempt,
                                  distance,
                                  1)

    check_distance(distance, sm_hash)
  end

  private

  def check_distance(distance, sm_hash)
    state = true
    if distance <= 1
      sm_hash.merge!(review_date: Time.zone.now + interval.to_i.days,
                       attempt: 1)
    else
      sm_hash.merge!(attempt: [attempt + 1, 5].min)
      state = false
    end

    update(sm_hash)
    { state: state, distance: distance }
  end
end
