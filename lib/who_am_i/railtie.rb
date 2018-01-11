module WhoAmI
  class Railtie < Rails::Railtie
    railtie_name :who_am_i

    rake_tasks do
      load "who_am_i/tasks.rake"
    end
  end
end
