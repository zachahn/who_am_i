module MiscMethods
  module_function

  def rake_run
    rake_application = Rake.application

    Rake.application = Rake::Application.new

    yield Rake.application
  ensure
    Rake.application = rake_application
  end

  def in_tmpdir
    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        yield tmpdir
      end
    end
  end
end
