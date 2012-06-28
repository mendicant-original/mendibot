PROJECT_ROOT = File.dirname(File.dirname(__FILE__))

God.watch do |w|
  script          = "bundle exec #{PROJECT_ROOT}/bin/mendibot_daemon.rb"
  w.name          = "mendibot"
  w.group         = "mendicant"
  w.interval      = 60.seconds
  w.start         = "#{script} start"
  w.restart       = "#{script} restart"
  w.stop          = "#{script} stop"
  w.start_grace   = 30.seconds
  w.restart_grace = 30.seconds
  w.pid_file      = "#{PROJECT_ROOT}/tmp/pids/mendibot.rb.pid"
  w.log           = "#{PROJECT_ROOT}/log/god.log"
  w.err_log       = "#{PROJECT_ROOT}/log/god.errors.log"
  w.env           = { 'BUNDLE_GEMFILE' => "#{PROJECT_ROOT}/Gemfile" }

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running  = false
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.notify       = 'jordan'
      c.to_state     = [:start, :restart]
      c.times        = 5
      c.within       = 5.minute
      c.transition   = :unmonitored
      c.retry_in     = 10.minutes
      c.retry_times  = 5
      c.retry_within = 2.hours
    end
  end
end
