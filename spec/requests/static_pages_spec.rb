require 'spec_helper'
# support directory is automaticaly required

describe "Static pages" do
  # let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }

  shared_examples_for "all static pages" do
    it {should have_selector('h1', text: heading)}
    it { should have_title full_title(page_title) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) {'Sample App'}
    let(:page_title) {''}

    it_should_behave_like 'all static pages'
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end
      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "messages/followers/following counts" do
        let(:other_user) {FactoryGirl.create(:user)}
        before do
          other_user.follow!(user)
          visit root_path
        end
        it {should have_link("0 following", href: following_user_path(user))}
        it {should have_link("1 followers", href: followers_user_path(user))}
        it {should have_link("0 DM's", href: messages_path)}
      end

      describe "screen name in the feed item" do
        let(:other_user) {FactoryGirl.create(:user, screen_name: "other_user")}
        let!(:micropost) {FactoryGirl.create(:micropost, user: other_user)}
        before do
          user.follow!(other_user)
          visit root_path
        end
        it {should have_selector("small", text: "@#{other_user.screen_name}")}
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) {'Help'}
    let(:page_title) {'Help'}

    it_should_behave_like 'all static pages'
  end
  
  describe "About page" do
    before { visit about_path }
    let(:heading) {'About us'}
    let(:page_title) {'About Us'}

    it_should_behave_like 'all static pages'
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) {'Contact'}
    let(:page_title) {'Contact'}

    it_should_behave_like 'all static pages'
  end

  it 'should have the right links on the layout' do
    visit root_path
    click_link 'About'
    expect(page).to have_title(full_title('About Us'))
    click_link 'Help'
    expect(page).to have_title(full_title('Help'))
    click_link 'Home'
    click_link 'Sign up now!'
    expect(page).to have_title(full_title('Sign Up'))
    click_link 'sample app'
    expect(page).to have_title(full_title(''))

  end
end
