namespace :who_am_i do
  desc "Annotate models"
  task :main do
    if !ActiveRecord::Base.connected?
      # Do something
    end

    main = WhoAmI::Function::Main.new(File.expand_path("."))
    main.call
  end
end

desc "Annotate"
task who_am_i: "who_am_i:main"
