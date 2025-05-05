require 'rails_helper'

describe "Room creation with participants" do
  context "when user creates a room and adds another user" do
    it "allows the added user to access only the room they were added to", js: true do
      given_two_users_exist
      login_as_creator
      user_creator_creates_room_with_select_another_user
      user_creator_creates_room_without_another_user
      creator_should_see_room_created
      logout_creator
      login_as_added_user
      added_user_should_see_only_first_room
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
    fill_in 'room_name', with: 'Room 1'
    find("input[type='checkbox'][value='#{@added_user.id}']").set(true)
    click_button 'Create Room'
  end

  def user_creator_creates_room_without_another_user
    visit root_path
    fill_in 'room_name', with: 'Room 2'
    click_button 'Create Room'
  end

  def creator_should_see_room_created
    visit root_path
    expect(page).to have_content('Room 1')
    expect(page).to have_content('Room 2')
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

  def added_user_should_see_only_first_room
    expect(page).to have_content('Room 1')
    expect(page).not_to have_content('Room 2')
  end
end
