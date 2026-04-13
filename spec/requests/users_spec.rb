require 'rails_helper'

RSpec.describe "Users Management", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:regular_user) { create(:user) }

  describe "GET /users" do
    context "jako přihlášený admin" do
      before { sign_in admin } # Metoda z Devise

      it "vrátí úspěšnou odpověď a zobrazí seznam" do
        get users_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Správa uživatelů")
      end
    end

    context "jako běžný uživatel" do
      before { sign_in regular_user }

      it "vyhodí chybu nebo přesměruje (CanCanCan)" do
        get users_path
        # CanCanCan obvykle vyhodí AccessDenied, který Rails zachytí
        # a přesměrují na root nebo zobrazí flash zprávu
        expect(response).to redirect_to(root_path)
        follow_redirect!
      end
    end

    context "jako nepřihlášený host" do
      it "přesměruje na login" do
        get users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end