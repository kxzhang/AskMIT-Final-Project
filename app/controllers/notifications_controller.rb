class NotificationsController < ApplicationController

  # Requires: User must be logged in
  # Modifies: Notifications.
  # Effects: fetches all notifications current_user has, and change all unread notifications to read
  def index
    @notifications = Notification.where(:user_id => current_user.id).order('created_at DESC').all
    # mark new notifications as read
    unread = Notification.where(:user_id => current_user.id, :read => false)
    unread.each do |r|
      r.read = true
      r.save
    end
  end

  def new_notifications
    notifications = Notification.where(:user_id => current_user.id, :read => false)
    size = notifications.size
    @new_notifications = notifications.limit(10);
    render json: {
        'html' => render_to_string(:partial => 'notifications/notificationli', :collection => @new_notifications),
        'count' => size

    }
  end

  # Requires: User must log in
  # Modifies: Notifications
  # Effects: change all unread notifications to read
  def mark_read
    notifications = Notification.where(:user_id => current_user.id, :read => false)
    # mark new notifications as read
    notifications.each do |r|
      r.read = true
      r.save
    end
    render :text => "marked"
  end

end