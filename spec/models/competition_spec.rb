# == Schema Information
#
# Table name: competitions
#
#  id           :integer          not null, primary key
#  max_attempts :integer          default(1)
#  name         :string
#  status       :integer          default("open")
#  unit         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Competition, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
