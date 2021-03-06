require "spec_helper"

describe RedboothRuby::Note, vcr: 'notes' do
  include_context 'authentication'

  let(:create_params) do
    { project_id: 2,
      name: 'new created note',
      content: 'bla bla bla' }
  end
  let(:new_record) { client.note(:create, create_params) }
  let(:endpoint) { 'notes' }
  let(:note) do
    client.note(:show, id: 1)
  end

  describe "#initialize" do
    subject { note }

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'Site content' }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.permalink).to eql 'site-content' }
    it { expect(subject.is_private).to eql false }
  end

  describe ".show" do
    subject { note }

    it "makes a new GET request using the correct API endpoint to receive a specific note" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "#{endpoint}/1", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'Site content' }
    it { expect(subject.project_id).to eql 2 }
  end

  describe ".update" do
    subject { client.note(:update, id: 2, name: 'new test name') }

    it "makes a new PUT request using the correct API endpoint to receive a specific note" do
      expect(RedboothRuby).to receive(:request).with(:put, nil, "#{endpoint}/2", { name: 'new test name' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new test name' }
    it { expect(subject.id).to eql 2 }
  end

  describe ".create" do
    subject { new_record }

    it "makes a new POST request using the correct API endpoint to create a specific note" do
      expect(RedboothRuby).to receive(:request).with(:post, nil, endpoint, create_params, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new created note' }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.user_id).to eql 1 }
  end

  describe ".delete" do
    subject { client.note(:delete, id: new_record.id) }

    it "makes a new DELETE request using the correct API endpoint to delete a specific note" do
      expect(RedboothRuby).to receive(:request).with(:delete, nil, "#{endpoint}/#{new_record.id}", {}, { session: session }).and_call_original
      subject
    end
  end

  describe ".index" do
    subject { client.note(:index) }

    it "makes a new GET request using the correct API endpoint to receive notes collection" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, endpoint, {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql RedboothRuby::Request::Collection }
  end
end
