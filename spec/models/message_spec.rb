require 'spec_helper'

describe Message do
  let(:receiver) {FactoryGirl.create(:user)}
  let(:message) {FactoryGirl.build(:message, content: "d@#{receiver.screen_name} 
                test", receiver: receiver)}

  subject {message}
  
  it {should respond_to(:content)}
  it {should be_valid}


  describe "when message content is invalid" do
    describe "with blank content" do
      before { message.content = " " }
      it {should_not be_valid}
    end
    describe "with content greater than 140 chars" do
      before { message.content = "a" * 141 }
      it {should_not be_valid}
    end
  end

  describe "when sender is not present" do
    before {message.sender = nil}
    it {should_not be_valid}
  end

  describe "when receiver is not present" do
    before {message.receiver = nil}
    it {should_not be_valid}
  end
    

  describe "when sender is equals to receiver" do
    before {message.receiver = message.sender}
    it {should_not be_valid}
  end
end
