require 'rails_helper'

describe "Room creation with participants" do
  context "when user creates a room and adds another user" do
    it "allows the added user to access the added room", js: true do
      given_two_users_exist
      login_as_creator
      user_creator_creates_room_with_select_another_user
      creator_should_see_room_created
      logout_creator
      login_as_added_user
      added_user_should_see_the_room
    end
  end

  def given_two_users_exist
    @creator = User.create!(email: "creator@example.com", password: "password", username: "creator_user")
    @added_user = User.create!(email: "friend@example.com", password: "password", username: "added_user")
  end

  def login_as_creator
    login_as(@creator, scope: :user)
    visit root_path
  end

  def user_creator_creates_room_with_select_another_user
    fill_in 'room_name', with: 'Test Room'
    find("input[type='checkbox'][value='#{@added_user.id}']").set(true)
    click_button 'Create Room'
  end

  def creator_should_see_room_created
    expect(page).to have_content('Test Room')
  end

  def logout_creator
    visit root_path
    expect(page).to have_button('Sign out')
    click_button 'Sign out'
  end

  def login_as_added_user
    login_as(@added_user, scope: :user)
    visit root_path
  end

  def added_user_should_see_the_room
    expect(page).to have_content('Test Room')
  end
end
