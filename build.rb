require "fileutils"
require "csv"
require "json"
require "slugify"
require "haml"
require "tilt"
require "yaml"

BUILD_DIR = "dist"
FileUtils.rm_rf(BUILD_DIR) if Dir.exist?(BUILD_DIR)
Dir.mkdir(BUILD_DIR)

primary_key = "acronym"

yml_files = Dir["./*.yml"].reject { |f| File.directory?(f) }

# Loop through each CSV file in the directory
yml_files.each do |file_name|
  dataset_slug = File.basename(file_name, ".yml").slugify
  puts "Processing #{dataset_slug}"
  Dir.mkdir("#{BUILD_DIR}/#{dataset_slug}") unless Dir.exist?("#{BUILD_DIR}/#{dataset_slug}")

  rows = Array.new

  # Write a file for each row
  YAML.load(File.read(file_name)).each do |row|
    rows.push(row.to_hash)
    target_file = row[primary_key].to_s.slugify
    if target_file
      row_json = JSON.generate(row)
      File.open("#{BUILD_DIR}/#{dataset_slug}/#{target_file}.json", "w") { |f| f.write(row_json) }
    end
  end

  # Sort by acronym and remove empty rows
  rows.sort_by!{|x| x['acronym'].to_s }.reject!(&:empty?)

  # Write full dataset to file
  rows_json = JSON.generate(rows)
  File.open("#{BUILD_DIR}/#{dataset_slug}.json", "w") { |f| f.write(rows_json) }

  # Render HTML
  template = Tilt::HamlTemplate.new('pages.haml')
  page = template.render(Object.new, rows: rows)

  File.open("#{BUILD_DIR}/#{dataset_slug}/index.html", "w") { |f| f.write(page) }
end

