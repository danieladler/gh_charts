class User < ActiveRecord::Base
  # methods for sorting repo objects returned by Octokit

  def client # client makes requests to github API
    @client ||= Octokit::Client.new(:access_token => self.token)
  end

  def github_user # current user's github user
    @github_user ||= client.user
  end

  def all_client_repos
    @all_client_repos ||= client.repositories #if client
  end

  def private_repo_count
    @priv_rep_count = 0
    all_client_repos.each do |r|
      if r[:private] == true
        @priv_rep_count += 1
      end
    end
    @priv_rep_count
  end

  # def public_repos
  #
  # end
  #
  # def joined_repos
  #
  # end

  # def repo_type_count
  #   @priv_rep_count = 0
  #   @pub_rep_count = 0
  #   @other_rep_count = 0
  #   all_client_repos.each do |r|
  #     if r[:private] == true
  #       @priv_rep_count += 1
  #     elsif r[:private] == false && r[:owner][:login] == current_user.username
  #       @pub_rep_count += 1
  #     elsif r[:owner][:login] != current_user.username
  #       @other_rep_count += 1
  #     end
  #   end
  # end

  def last_ten_repos
    sorted   = all_client_repos.sort_by {|r| r[:updated_at]}
    just_ten = sorted[0..9]
  end

  def all_gists
    @all_gists ||= Octokit.gists(self.username)
  end

  def last_five_gists
    sorted   = self.all_gists.sort_by {|g| g[:updated_at]}
    just_ten = sorted[0..4]
  end

end
