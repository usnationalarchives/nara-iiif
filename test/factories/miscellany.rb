FactoryGirl.define do
  sequence :misc_key do |n|
    "misc_key_#{n}"
  end

  sequence :misc_name do |n|
    "misc_name_#{n}"
  end

  sequence :misc_value do |n|
    "misc_value_#{n}"
  end

  factory :miscellany do
    key { generate(:misc_key) }
    name { generate(:misc_name) }
    description "test miscellany description"
    value { generate(:misc_value) }
  end
end
