class Admin
  class PagesController < AdminController
    def dashboard
      render "admin/dashboard"
    end
  end
end
