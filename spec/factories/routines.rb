# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :routine do
    title "MyString"
    purpose "MyText"
    resources "MyString"
    weeks 1
    days 1
    hours 1
    minutes 1
    user nil
  end
end
