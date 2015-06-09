class Event
  include Mongoid::Document

  field :name, type: String
  field :date, type: Time
  field :periodicity, type: Integer, default: 1
  belongs_to :owner, class_name: 'User'
  has_many :invitations, dependent: :destroy

  validates_presence_of :name, :date
  validates_presence_of :owner, on: :create
  validates_uniqueness_of :name, scope: :owner
end
