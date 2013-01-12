module EasyRuby

  def self.build!

    components = [
      BSDTar, SevenZip, Git, Ruby193,
      PostgresServer, Sqlite3, Sqlite3Dll
    ]

    components.each do |package|
      section  package.title
      download package
      extract  package
    end

    stage_sqlite

    stage_git

    stage_postgresql

    stage_gems

    stage_todo_application

    stage_setup_scripts

    stage_msvc_runtime
  end

  #
  # package()
  #
  # Packages a binary installer release version together as a
  # self contained installer using Inno Setup scripting.
  #
  def self.package!

    unless %x{iscc --version}.scan("Inno Setup 5")
      printf "ERROR: Inno Setup 5 is required in order to package EasyRuby.\n"
      printf "  http://www.jrsoftware.org/isdl.php#qsp\n"
      printf "Please see README for full EasyRuby instructions.\n"
      exit 1
    end

    easyruby_version = File.read(File.join(EasyRuby::Root, "VERSION.txt")).chomp

    printf "\nPackaging... this *will* take a while...\n"

    iscc "\"#{File.join(EasyRuby::Root, "resources", "easyruby", "easyruby.iss")}\"",
          "/dInstallerVersion=#{easyruby_version}",
          "/dStagePath=\"#{EasyRuby::Stage}\"",
          "/dRubyPath=\"#{EasyRuby::Ruby193.rename}\"",
          "/dResourcesPath=\"#{File.join(EasyRuby::Root, "resources")}\"",
          "/o\"#{EasyRuby::PackageDir}\"",
          "/feasyruby-#{easyruby_version}"

  end

end
