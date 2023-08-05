# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompetitionInterface, type: :interface do
  subject { FactoryBot.create(:competition, { status: 'open' }) }

  context '.status?' do
    context 'with status open' do
      it { expect(subject.status?).to eq('aberta') }
    end

    context 'with status closed' do
      before { subject.update(status: 'closed') }

      it { expect(subject.status?).to eq('encerrada') }
    end
  end

  context '.subscribed?' do
    subject { competition }

    let(:competition) { FactoryBot.create(:competition, { status: 'open' }) }
    let(:athlete) { FactoryBot.create(:athlete, { name: 'Piotr Lisek' }) }

    context 'with subscribed athlete' do
      before do
        FactoryBot.create(:competition_athlete, { athlete: athlete, competition: competition })
      end

      it { expect(subject.subscribed?(athlete)).to eq(true) }
    end

    context 'without subscribed athlete' do
      it { expect(subject.subscribed?(athlete)).to eq(false) }
    end
  end
end
