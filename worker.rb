require 'octokit'

class Worker
  include Sidekiq::Worker

  def extract(lib_id)
    
    lib = Library.find lib_id
	puts "Async Request on #{lib.github_user} #{lib.github_repo}"
	begin
		client = Octokit::Client.new(:login => 'jpotts18', :password => 'TEuAKdflmZGf2mtYBJKucAE2')
		repo = client.repo "#{lib.github_user}/#{lib.github_repo}"
		# l.update_attributes(github_id: repo[:id], language: repo[:language])
		Extraction.create!({
			open_issues: repo[:open_issues],
			stargazers_count: repo[:stargazers_count],
			size: repo[:size],
			library_id: lib.id,
		})
	rescue Octokit::NotFound
		puts '* Not Found '
		l.update_attributes(not_found: true)
	end

  end
end