# frozen_string_literal: true

require 'rails_helper'

feature 'MultiselectComponent', :js, type: :feature do
  before do
    visit new_user_path

    find('#user_role_multiselect').click
  end

  scenario 'allows user to select one option' do
    find('.mx-2.leading-6', text: 'Admin').click

    find('body').click

    click_on 'Create user'

    expect(User.last.role).to eq('admin')
  end

  scenario 'allows user to select multiple options' do
    multiselect 'Admin', 'User', from: 'user_role'

    expect(page).to have_selector('.text-xs.font-normal.leading-none.max-w-full.flex-initial', text: 'Admin')
    expect(page).to have_selector('.text-xs.font-normal.leading-none.max-w-full.flex-initial', text: 'User')

    click_on 'Create user'

    expect(User.last.role).to eq('admin,user')
  end

  scenario 'allows user to select 2 options and the last one' do
    find('.mx-2.leading-6', text: 'Admin').click
    find('.mx-2.leading-6', text: 'User').click

    find('.cursor-pointer[data-action="click->multiselect#toggleItem"][data-value="user"]', text: '⨯').click

    expect(page).not_to have_selector('.text-xs.font-normal.leading-none.max-w-full.flex-initial', text: 'User')
    expect(page).to have_selector('.text-xs.font-normal.leading-none.max-w-full.flex-initial', text: 'Admin')

    click_on 'Create user'

    expect(User.last.role).to eq('admin')
  end

  scenario 'allows user to select 2 options and the first one' do
    find('.mx-2.leading-6', text: 'Admin').click
    find('.mx-2.leading-6', text: 'User').click

    find('.cursor-pointer[data-action="click->multiselect#toggleItem"][data-value="admin"]', text: '⨯').click

    expect(page).not_to have_selector('.text-xs.font-normal.leading-none.max-w-full.flex-initial', text: 'Admin')
    expect(page).to have_selector('.text-xs.font-normal.leading-none.max-w-full.flex-initial', text: 'User')

    click_on 'Create user'

    expect(User.last.role).to eq('user')
  end

  scenario 'runs onchange stimulus action' do
    collect_console_logs(page)

    find('.mx-2.leading-6', text: 'Admin').click

    logs = page.evaluate_script('window.collectedLogs')

    expect(logs.any? { |log| log.include?('Form updated') }).to be(true)
  end
end
