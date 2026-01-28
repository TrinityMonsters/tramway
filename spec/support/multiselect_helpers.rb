module MultiselectHelpers
  def multiselect(*options, from:)
    id = from.split('[').join('_').chomp(']') + '_multiselect'

    find("div##{id}[role='combobox']").click

    options.each do |option|
      find('div[role="option"]', text: option).click
    end
  end
end
