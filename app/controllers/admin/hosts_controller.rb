class Admin
  class HostsController < AdminController
    def index
      @hosts = Host.alphabetical
    end

    def show
      @host = find_host
      @user = @host.user.decorate if @host.user.present?
    end

    def new
      @host = Host.new
      @users = find_users
    end

    def create
      @host = Host.new(host_params)
      @host.subscribe(UserNotifier.new) if @host.user.present?
      @users = find_users
      if @host.save
        redirect_to(admin_hosts_url, notice: "Host successfully created")
      else
        render(:new)
      end
    end

    def edit
      @host = find_host
      @users = find_users(@host)
    end

    def update
      @host = find_host
      @users = find_users(@host)
      if @host.update(host_params)
        redirect_to(admin_host_url(@host), notice: "Host successfully updated")
      else
        render(:edit)
      end
    end

    def destroy
      @host = find_host
      if @host.present?
        if @host.destroy
          redirect_to(admin_hosts_url, notice: "Host successfully deleted")
        else
          redirect_to(admin_hosts_url, alert: @host.errors.get(:base).first)
        end
      else
        redirect_to(edit_admin_host_url(@host))
      end
    end

    private

    def find_host
      Host.friendly.find(params[:id])
    end

    def find_users(host = nil)
      users = User.completed_profile.not_host.decorate
      users << host.user if host.present? && host.user.present?
      users
    end

    def host_params
      params.require(:host).permit(:name, :user_id)
    end
  end
end
