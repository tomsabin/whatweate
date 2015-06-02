class Admin::HostsController < Admin::AdminController
  before_action :assign_host, except: [:index, :new, :create]
  before_action :assign_profiles, only: [:new, :create, :edit, :update]

  def index
    @hosts = Host.all
  end

  def show
  end

  def new
    @host = Host.new
  end

  def create
    @host = Host.new(host_params)
    if @host.save
      redirect_to(admin_hosts_url, notice: "Host successfully created")
    else
      render(:new)
    end
  end

  def edit
  end

  def update
    if @host.update(host_params)
      redirect_to(admin_host_url(@host), notice: "Host successfully updated")
    else
      render(:edit)
    end
  end

  def destroy
    if @host.present?
      @host.destroy
      redirect_to(admin_hosts_url, notice: "Host successfully deleted")
    else
      redirect_to(edit_admin_host_url(@host))
    end
  end

  private

  def assign_host
    @host = Host.find(params[:id])
  end

  def assign_profiles
    @profiles = Profile.all
  end

  def host_params
    params.require(:host).permit(:name, :profile_id)
  end

end
