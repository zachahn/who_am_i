module WhoAmI
  def self.load_rake_tasks
    require "who_am_i"
    load(File.expand_path("tasks.rake", __dir__))
  end
end
