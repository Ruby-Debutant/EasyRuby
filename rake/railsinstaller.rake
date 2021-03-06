task :default do
  printf "\nEasyRuby Rake Tasks:

  {bootstrap, build, package}

See README for more details.\n\n"
end

task :require_easyruby do

  require "easyruby"

end

desc "Bootstrap EasyRuby development environment (gems)"
task :bootstrap do

  require "rubygems/dependency_installer"

  gems = File.read(File.join(ProjectRoot, ".gems")).gsub(" -v", ' ').split("\n")

  gems.each do |gem|

    printf "Ensuring #{gem} is installed...\n"

    name, version, options = gem.split(/\s+/)

    installer = Gem::DependencyInstaller.new(
      { :generate_rdoc => false, :generate_ri => false }
    )

    version ? installer.install(name, version) : installer.install(name)

  end

  printf "Bootstrapped.\nDo not forget to download and install InnoSetup, see README for more information. \n"

end

desc "Download and build all components and dependencies into stage/."
task :build => [ :require_easyruby ] do

  EasyRuby.build!

end

desc "Package all components into a single executable installer into pkg/."
task :package => [ :require_easyruby ] do

  EasyRuby.package!

end
