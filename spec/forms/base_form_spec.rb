# frozen_string_literal: true

require 'rails_helper'
# NOTE: UserForm is a dummy class, so there is no reason to store these tests following name conventions
# rubocop:disable RSpec/SpecFilePathFormat
describe UserForm do
  context 'with persisted object' do
    subject(:form_object) { described_class.new(object) }

    let(:object) { create :user }

    describe '#initialize' do
      it 'assigns object' do
        expect(form_object).to have_attributes object:
      end
    end

    describe '.property' do
      it 'adds the attribute to properties list and delegates to the object' do
        described_class.property(:email)

        expect(described_class.properties).to include(:email)
      end

      it 'raises error when using reserved name' do
        expect { described_class.property(:fields) }.to raise_error(ArgumentError)
      end
    end

    describe '#submit' do
      context 'with default checks' do
        let(:params) { { email: 'asya@purple-magic.com' } }

        it 'updates object attributes and saves it' do
          expect(object).to receive(:save).and_return(true)
          expect(object).to receive(:reload)

          form_object.submit(params)
        end
      end

      context 'with normalizes checks' do
        let(:params) { { email: 'Asya@Purple-Magic.com' } }

        it 'updates object attributes and saves it' do
          form_object.submit(params)

          expect(object.email).to eq 'asya@purple-magic.com'
        end
      end
    end

    describe '#submit!' do
      let(:params) { { email: 'asya@purple-magic.com' } }

      it 'updates object attributes and saves it with validation' do
        expect(object).to receive(:save!).and_return(true)
        expect(object).to receive(:reload)
        form_object.submit!(params)
      end
    end

    describe '#assign' do
      let(:params) { { email: 'asya@purple-magic.com' } }

      it 'just assigns object attributes' do
        expect(object).not_to receive(:save!)
        expect(object).not_to receive(:reload)
        form_object.assign(params)
        expect(object.email).to eq 'asya@purple-magic.com'
      end
    end

    context 'with method delegation' do
      it 'delegates certain methods to the object' do
        methods_to_delegate = %i[id model_name to_key errors attributes]

        methods_to_delegate.each do |method|
          expect(object).to receive(method)

          form_object.public_send(method)
        end
      end
    end

    describe 'method_missing' do
      it 'raises NoMethodError for other cases' do
        expect { form_object.unknown_method }.to raise_error(NoMethodError)
      end
    end
  end

  context 'with not persisted' do
    let(:object) { build :user }
    let(:form) { described_class.new(object) }

    describe '#submit' do
      let(:params) { { email: 'asya@purple-magic.com' } }

      it 'updates object attributes and saves it' do
        expect(object).to receive(:save).and_return(false)
        expect(object).not_to receive(:reload)

        form.submit(params)
      end
    end

    describe '#submit!' do
      let(:params) { { email: 'asya@purple-magic.com' } }

      it 'updates object attributes and saves it with validation' do
        expect(object).to receive(:save!).and_return(false)
        expect(object).not_to receive(:reload)

        form.submit!(params)
      end
    end
  end

  context 'with non-existing attributes' do
    let(:user_email) { 'asya@purple-magic.com' }
    let(:object) { create :user, email: user_email }
    let(:form) { described_class.new(object) }

    describe '#submit' do
      let(:params) { { password: '123456' } }

      it 'does not update non-existing attributes' do
        expect(object).to receive(:save).and_return(true)
        expect(object).to receive(:reload)

        form.submit(params)

        expect(object.email).to eq user_email
      end
    end
  end

  it 'responds to to_model method' do
    form = described_class.new(create(:user))

    expect(form).to respond_to(:to_model)
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
