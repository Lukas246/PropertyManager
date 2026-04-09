require "rails_helper"

RSpec.describe ExportMailer, type: :mailer do
  describe "send_csv" do
    let(:user) { create(:user, email: "spravce@majetek.cz") }
    let(:csv_content) { "\xEF\xBB\xBFID;Název;Kód\n1;Test Asset;ABC-123" }
    let(:mail) { ExportMailer.send_csv(user, csv_content) }

    # Definujeme očekávaný název souboru stejně jako v maileru
    let(:expected_filename) { "export-majetku-#{Date.today}.csv" }

    it "obsahuje CSV přílohu se správným dynamickým názvem" do
      # Teď už nehledáme natvrdo string, ale proměnnou
      attachment = mail.attachments[expected_filename]

      expect(attachment).to be_present
      expect(attachment.filename).to eq(expected_filename)
    end

    it "má správné kódování a obsah" do
      attachment = mail.attachments[expected_filename]
      expect(attachment.body.raw_source).to start_with("\xEF\xBB\xBF")
      expect(attachment.body.raw_source).to include("Test Asset")
    end
  end
end