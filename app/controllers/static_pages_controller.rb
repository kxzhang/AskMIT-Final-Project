class StaticPagesController < ApplicationController
  skip_before_filter :require_login
  #Static pages to make overall app look nice

  def home
  end

  def about
  end

  def contact
  end

end
