class ExportMailer < ApplicationMailer
  default from: "system@inventar.cz"

  def send_csv(user, csv_data)
    attachments["export-majetku-#{Date.today}.csv"] = {
      mime_type: "text/csv",
      content: csv_data
    }
    mail(to: user.email, subject: "Export Majetku")
  end
end
