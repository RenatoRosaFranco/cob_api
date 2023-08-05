# == Schema Information
#
# Table name: athletes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :athlete do
    name { "#{FFaker::NameBR.name}#{rand(100)}" }
  end
end
