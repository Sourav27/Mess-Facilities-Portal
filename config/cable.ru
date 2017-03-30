re ::File.expand_path('../../config/environment', __FILE__)
Rails.application.eager_load!
ActionCable.server.worker_pool
ActionCable.server.config.allowed_request_origins = %w(ws://127.0.0.1:8001/mess-facilities/ )
run ActionCable.server
