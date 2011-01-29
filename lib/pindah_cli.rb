require 'fileutils'

module PindahCLI
  def self.log(msg)
    STDERR.puts msg
  end

  def self.mkdir(base, directory)
    location = File.join(base, directory)
    FileUtils.mkdir_p location
    log "Created '#{location}'."
    location
  end
  
  def self.create(package, location, activity=nil)
    segments = package.split('.')
    src_dir = mkdir location, File.join('src', *segments)
    mkdir location, 'bin'
    mkdir location, 'libs'
    mkdir location, 'res'
    mkdir location, 'res/drawable-hdpi'
    mkdir location, 'res/drawable-ldpi'
    mkdir location, 'res/drawable-mdpi'
    mkdir location, 'res/layout'
    mkdir location, 'res/values'

    create_android_manifest package, location, activity
    create_initial_activity src_dir, activity if activity
  end

  def self.create_initial_activity(src_dir, activity)
    activity_location = File.join(src_dir, "#{activity}.mirah")
    template = File.read(File.join(File.dirname(__FILE__),
                                   '..', 'templates',
                                   'initial_activity.mirah'))

    template.gsub!(/INITIAL_ACTIVITY/, activity)
    File.open(activity_location, 'w') { |f| f.puts template }
    
    log "Created Activity '#{activity}' in '#{activity_location}'."
  end

  def self.create_android_manifest(package, location, activity)
    manifest = File.join(location, "AndroidManifest.xml")

    if activity
      template = File.read(File.join(File.dirname(__FILE__),
                                     '..', 'templates',
                                     'AndroidManifest.xml.with-activity'))
      template.gsub!(/INITIAL_ACTIVITY/, activity) if activity
    else
      template = File.read(File.join(File.dirname(__FILE__),
                                     '..', 'templates',
                                     'AndroidManifest.xml.no-activity'))
    end
    template.gsub!(/PACKAGE/, package)
    File.open(manifest, 'w') { |f| f.puts template }
    
    log "Wrote #{manifest}."
  end
end
