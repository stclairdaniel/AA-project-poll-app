class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
  validate :unique_response
  validate :not_author_response

  def not_author_response
    if author_response?
      self.errors[:respondent] << "is poll author"
    end
  end

  def unique_response
    if respondent_already_answered?
      self.errors[:respondent] << "already answered this question"
    end
  end

  belongs_to :answer_choice,
    primary_key: :id,
    foreign_key: :answer_choice_id,
    class_name: 'AnswerChoice'

  belongs_to :respondent,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'User'

  has_one :question,
    through: :answer_choice,
    source: :question

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    responses = self.sibling_responses.select do |response|
      response.user_id == self.user_id
    end
    responses.count > 0
  end

  def author_response?
    self.answer_choice.question.poll.author_id == self.user_id
  end
end
