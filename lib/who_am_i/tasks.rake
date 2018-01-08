namespace :who_am_i do
  desc "Annotate models"
  task :main do
    main = WhoAmI::Function::Main.new(File.expand_path("."))
    main.call
  end
end

desc "Annotate"
task who_am_i: "who_am_i:main"

config = WhoAmI::Function::LoadConfig.new(File.expand_path(".")).call

if config.autorun_enabled?
  config.autorun_after_tasks.each do |task_name|
    Rake::Task[task_name].enhance do
      Rake::Task["who_am_i:main"].invoke
    end
  end
end
