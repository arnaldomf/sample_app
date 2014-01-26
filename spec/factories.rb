FactoryGirl.define do
  # alias: used because message uses a named association
  factory :user, :aliases => [:sender, :receiver] do
    sequence(:name) {|n| "Person #{n}"}  
    sequence(:email) {|n| "person_#{n}@example.com"}
    sequence(:screen_name) {|n| "person#{n}"}
    password "foobar"
    password_confirmation "foobar"
    state 1
    factory :admin do
      admin true
    end
  end
  factory :micropost do
    content "Lorem ipsum"
    user
  end
  factory :message do
    content "Lorem ipsum"
    sender
    receiver
  end
end


#FactoryGirl.define do
#  factory :user do
#    name  "Arnaldo Mendonca"
#    email "teste@teste.com"
#    password "foobar"
#    password_confirmation "foobar"
#  end
#end
