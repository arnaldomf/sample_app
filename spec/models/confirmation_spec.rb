require 'spec_helper'

describe Confirmation do
  let(:user) { FactoryGirl.create(:user, state: 0)}
  let(:confirmation) {FactoryGirl.build(:confirmation, user_id: user.id)}

  subject {confirmation}

  it {should respond_to(:user_id)}
  it {should respond_to(:code)}
  it {should be_valid}

  describe "with wrong information" do
    describe "code too short" do
      before {confirmation.code = "short"}
      it {should_not be_valid}
    end

    describe "code not present" do
      before {confirmation.code = " "}
      it {should_not be_valid}
    end

    describe "many confirmations for one user" do
      before do
        @other_confirmation = FactoryGirl.create(:confirmation, user_id: user.id)
      end
      it {should_not be_valid}
    end
  end

end
