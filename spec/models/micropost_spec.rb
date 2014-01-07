require 'spec_helper'

describe Micropost do
  let(:user) {FactoryGirl.create(:user)}
  before { @micropost = user.microposts.build(content: "Lorem ipsum")}

  subject { @micropost }

  it {should respond_to(:content)}
  it {should respond_to(:user_id)}
  it {should respond_to(:user)}
  it {should respond_to(:in_reply_to)}
  its(:user) {should eq user }

  it {should be_valid}

  describe "when user_id is not present" do
      before { @micropost.user_id = nil}
      it {should_not be_valid}
  end
  describe "with blank content" do
    before {@micropost.content = " "}
    it {should_not be_valid}
  end
  describe "with content that is too long" do
    before { @micropost.content = "a" * 141}
    it {should_not be_valid}
  end
  describe "when a user reply to another user" do
    let(:other_user) {FactoryGirl.create(:user, screen_name: "other_user")}
    before do
      @micropost.content = "@#{other_user.screen_name} Lorem ipsum"
      @micropost.save
    end
    its(:in_reply_to) {should eq other_user.id}
  end
end
