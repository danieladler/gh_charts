class User < ActiveRecord::Base
  # methods for sorting repo objects returned by Octokit
  # in view, methods called on:
    # current_user are custom-built here
    # current_user.github user are natively available from 'client.user' object from Octokit

  def client # client makes requests to github API
    @client ||= Octokit::Client.new(:access_token => self.token)
  end

  def github_user # current user's github user
    @github_user ||= client.user
  end

  def all_client_repos
    @all_client_repos ||= client.repositories
  end

  def private_repo_count
    priv_rep_count = 0
    all_client_repos.each do |r|
      priv_rep_count += 1 if r[:private] == true
    end
    priv_rep_count
  end

  def public_repo_count
    pub_rep_count = 0
    all_client_repos.each do |r|
      pub_rep_count +=1 if r[:private] == false && r[:owner][:login] == self.username
    end
    pub_rep_count
  end

  def joined_repo_count
    join_rep_count = 0
    all_client_repos.each do |r|
      join_rep_count += 1 if r[:owner][:login] != self.username
    end
    join_rep_count
  end

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

  def repo_language_types
    @lang_arr ||= all_client_repos.map {|r| r[:language]}
    lang_hash = {}
    @lang_arr.each do |l|
      l = "Other" if l == nil
      lang_hash[l] ||= 0
      lang_hash[l] += 1
    end
    lang_hash
  end

  def last_300_events
    @raw_event_data ||= self.client.user_events("#{self.github_user.login}", {:per_page => 100, :page => 1}).concat(
      self.client.user_events("#{self.github_user.login}", {:per_page => 100, :page => 2}),
    ).concat(
      self.client.user_events("#{self.github_user.login}", {:per_page => 100, :page => 3})
    )

    @event_arr ||= @raw_event_data.map {|e| e[:type]}
    arr_hash = {}
    @event_arr.each do |e|
      arr_hash[e] ||= 0
      arr_hash[e] +=  1
    end
    arr_hash
  end

end
