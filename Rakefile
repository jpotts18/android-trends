require './app'
require 'csv'
require './worker'

def authenticate_client
	Octokit::Client.new(:login => 'jpotts18', :password => 'TEuAKdflmZGf2mtYBJKucAE2')
end

def read_libs
	Library.where "github_user <> ''"
end

desc "Start up sidekiq"
task :start_sidekiq do
	system('bundle exec sidekiq -r ./worker.rb -C config/sidekiq.pid -d -l sidekiq.log')
end

task :default => [:migrate, :load, :extract]

desc "Delete database"
task :db_delete do
	config = YAML::load(IO.read('config/database.yml'))
	File.delete(config['development']['database'])
end

desc "Make Sync calls to Github"
task :extract do
	puts 'Making Extraction from Github'
	client = authenticate_client
	libs = read_libs
	libs.each do |l|  
		puts "Fetching data of #{l.github_user}/#{l.github_repo}"
		begin
			repo = client.repo "#{l.github_user}/#{l.github_repo}"
			# l.update_attributes(github_id: repo[:id], language: repo[:language])
			Extraction.create!({
				open_issues: repo[:open_issues],
				stargazers_count: repo[:stargazers_count],
				size: repo[:size],
				library_id: l.id,
			})
		rescue Octokit::NotFound
			puts '* Not Found '
			l.update_attributes(not_found: true)
		end
	end
end

desc "Make async calls to Github"
task :extract_async do
	puts "Making Extraction from Github (async)"
	client = authenticate_client
	libs = read_libs
	libs.each do |l|
		Worker.extract_async(l.id)
	end
end

desc "Read in CSV"
task :load do
	puts 'Reading from CSV...'
	CSV.foreach('./db/data/android.csv', :headers => true) do |csv|
		Library.create!({
			name: csv['name'],
			homepage: csv['repoLink'],
			license: csv['license'],
			tag_name: csv['tag'],
			github_user: csv['githubUser'],
			github_repo: csv['githubRepo']
		})
	end
end

desc "Run migrations"
task :migrate do
	puts 'Running migrate'
	require './db/schema'
	s = Schema.new
	s.change
end

