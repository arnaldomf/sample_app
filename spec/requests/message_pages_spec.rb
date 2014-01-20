require 'spec_helper'

describe "Messages pages" do
  subject { page }

  describe "for non signed in user" do
    before { visit messages_path }
    it {should have_content("Please sign in.")}
  end

  describe "for signed in user" do
    let(:sender) { FactoryGirl.create(:user) }
    let(:receiver) { FactoryGirl.create(:user) }
    before { sign_in(sender) }

    describe "message creation" do
      before {visit root_path}

      describe "with valid information" do
        before do
          fill_in 'micropost_content', with: "d@#{receiver.screen_name} blah"
        end

        it "should not create a micropost" do
          expect { click_button "Post"}.not_to change(Micropost, :count)
        end
        it "should create a message" do
          expect {click_button "Post"}.to change(Message, :count).by(1)
        end
      end

    end

  end
end

  # describe "for signed in user" do
  #   let(:sender) { FactoryGirl.create(:user) }
  #   let(:receiver) { FactoryGirl.create(:user) }
  #   before { sign_in(sender) }

  #   describe "message creation" do
  #     before { visit root_path }
      
  #     describe "with valid information" do
  #       before { fill_in 'micropost_content', with: "d@#{receiver.screen_name} Lorem ipsum" }
        
  #       it "should not create a micropost" do
  #         expect { click_button "Post"}.not_to change(Micropost, :count)
  #       end

  #       it "should create a message" do
  #         expect { click_button "Post"}.to change(Message, :count).by(1)
  #       end
  #     end

  #     describe "with invalid information" do
  #       describe "with inexistent receiver" do
  #         before { fill_in 'micropost_content', with: "d@inexistent Lorem ipsum"}
          
  #         it "should not create a message" do
  #           expect { click_button "Post" }.not_to change(Message, :count)
  #         end

  #       end

  #       describe "without content" do
          
  #         it "should not create a message" do
  #           expect { click_button "Post" }.not_to change(Message, :count)
  #         end
  #       end
  #     end
  #   end
  # end
  # describe "for non signed in user" do
  #   visit messages_path
  #   it {should have_css('div.alert.alert-notice')}
  # end

