require "ostruct"

FactoryBot.define do
  factory :user , class: OpenStruct do
    username  { "test6726@fakemail.com" }
    password  { "Ashish@1234" }
  end
end