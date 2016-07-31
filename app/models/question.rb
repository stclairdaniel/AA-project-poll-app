class Question < ActiveRecord::Base
  validates :question, :poll_id, presence: true

  belongs_to :poll,
    primary_key: :id,
    foreign_key: :poll_id,
    class_name: 'Poll'

  has_many :answer_choices,
    primary_key: :id,
    foreign_key: :question_id,
    class_name: 'AnswerChoice'

  has_many :responses,
    through: :answer_choices,
    source: :responses


  def results_n_plus_one
    responses = {}
    self.answer_choices.each do |answer_choice|
      responses[answer_choice.answer_choice] = answer_choice.responses.count
    end
    responses
  end

  def results_includes
    responses = {}
    answer_choices = self.answer_choices.includes(:responses)
    answer_choices.each do |answer_choice|
      responses[answer_choice.answer_choice] = answer_choice.responses.length
    end
    responses
  end

  def results_improved
    answer_choices_with_counts = self
    .answer_choices
    .select("answer_choices.*, COUNT(*) AS responses_count")
    .joins(:responses)
    .group("answer_choices.id")
    answer_choices_with_counts.map do |answer_choice|
      [answer_choice.answer_choice, answer_choice.responses_count]
    end
  end

end
