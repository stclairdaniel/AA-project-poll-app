class User < ActiveRecord::Base

  validates :user_name , presence: true, uniqueness: true

  has_many :authored_polls,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: 'Poll'

  has_many :responses,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'Response'

    def completed_polls
      query = <<-SQL
        SELECT polls.*
        FROM polls
        JOIN questions ON questions.poll_id = polls.id
        JOIN answer_choices ON answer_choices.question_id = questions.id
        LEFT OUTER JOIN (
          SELECT *
          FROM responses
          WHERE responses.user_id = ?
        ) AS inner_query ON inner_query.answer_choice_id = answer_choices.id
        GROUP BY polls.id
        HAVING COUNT(DISTINCT questions.id) = COUNT(inner_query.answer_choice_id)
      SQL

      Poll.find_by_sql([query, self.id])
    end

    def completed_polls_AR
      subquery = <<-SQL
        LEFT OUTER JOIN (
          SELECT *
          FROM responses
          WHERE responses.user_id = #{self.id}
        ) AS inner_query ON inner_query.answer_choice_id = answer_choices.id
      SQL
      user_completed_polls = Poll
        .select("polls.*")
        .joins(questions: :answer_choices)
        .joins("#{subquery}")
        .group("polls.id")
        .having("COUNT(DISTINCT questions.id) = COUNT(inner_query.answer_choice_id)")
    end




end
