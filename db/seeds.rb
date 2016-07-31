# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(user_name: 'Daniel')
User.create!(user_name: 'Snehi')
User.create!(user_name: 'Jimbo')

Poll.create!(title: 'Favorite', author_id: 1)
Poll.create!(title: 'Least Favorite', author_id: 2)

Question.create!(question: "Food?", poll_id: 1)
Question.create!(question: "Color?", poll_id: 2)

AnswerChoice.create!(answer_choice: 'pizza', question_id: 1)
AnswerChoice.create!(answer_choice: 'fish', question_id: 1)

AnswerChoice.create!(answer_choice: 'red', question_id: 2)
AnswerChoice.create!(answer_choice: 'blue', question_id: 2)

Response.create!(user_id: 1, answer_choice_id: 3)

Response.create!(user_id: 2, answer_choice_id: 2)

Response.create!(user_id: 3, answer_choice_id: 1)
Response.create!(user_id: 3, answer_choice_id: 3)
