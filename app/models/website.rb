class Website < ApplicationRecord
  # Aqui você pode definir as validações e associações do seu modelo

  # Validações
  validates :search_id, presence: true
  validates :classification, presence: true
  validates :site, presence: true
  validates :category, presence: true
  validates :ranking_last_change, presence: true
  validates :average_visit_duration, presence: true
  validates :total_visits, presence: true
  validates :bounce_rate, presence: true
  validates :pages_per_visit, presence: true
  validates :top_countries, presence: true
  validates :gender_distribution, presence: true
  validates :age_distribution, presence: true
  validates :company, presence: true
  validates :year_founded, presence: true
  validates :hq, presence: true
end
