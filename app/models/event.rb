class Event
  include Mongoid::Document

  field :name, type: String
  field :date, type: Time
  field :periodicity, type: Integer, default: 1
  belongs_to :owner, class_name: 'User'
  has_many :invitations, dependent: :destroy

  validates :name, :date, presence: true
  validates :owner, presence: true, on: :create
  validates :name, uniqueness: { scope: :owner }
end
