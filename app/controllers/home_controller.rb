class HomeController < ApplicationController
  def index
    @home = "Home page #{session[:user_id]}, #{session[:user_name]}"
  end

  def about
  end

  def contact
  end

  def terms
  end

  def privacy
  end
end
