# frozen_string_literal: true

describe Tramway::Config do
  let(:config) { described_class.instance }

  describe '#entities=' do
    context 'when collection is not empty' do
      let(:entities) { %w[Podcast Episode] }

      before do
        config.entities = entities
      end

      it 'sets entities as an array of Tramway::Configs::Entity objects' do
        expect(config.entities).to be_an(Array)
        expect(config.entities.length).to eq(entities.length)
        expect(config.entities).to all(be_a(Tramway::Configs::Entity))
      end
    end
  end

  describe 'entities' do
    context 'with empty collection' do
      before do
        config.entities = []
      end

      it 'returns an empty array if no entities have been set' do
        expect(config.entities).to eq([])
      end
    end

    context 'with non-empty collection' do
      context 'when entities are default' do
        let(:entities) { %w[Podcast Episode] }

        before do
          config.entities = entities
        end

        it 'returns the previously set entities' do
          expect(config.entities.map(&:name)).to eq(entities)
        end
      end

      context 'with customized entities' do
        context 'when index page exists' do
          let(:entities) do
            [
              {
                name: :post,
                pages: [
                  {
                    action: :index,
                    scope: :published
                  }
                ]
              }
            ]
          end

          before do
            config.entities = entities
          end

          it 'returns the index page' do
            post_entity = config.entities.find { |entity| entity.name == 'post' }
            scope = post_entity.pages.find { |page| page.action == 'index' }.scope

            expect(scope).to eq 'published'
          end
        end
      end
    end
  end

  describe 'pagination' do
    context 'when change default value' do
      before { config.pagination = { enabled: true } }

      it 'returns updated pagination enabled value' do
        expect(config.pagination[:enabled]).to be_truthy
      end
    end
  end
end
