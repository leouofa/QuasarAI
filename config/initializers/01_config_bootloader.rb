# frozen_string_literal: true

# find all files in core directory
Dir.chdir('blueprints')
files = Dir['**/**']

# select only YML files
files.select! { |entry| entry.include?('yml') == true }

# add all file as a source to the settings
files.each { |entry| Settings.add_source!(Rails.root.join('blueprints', entry).to_s) }

Settings.reload!

# Backup a directory
Dir.chdir('..')
