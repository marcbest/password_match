class PasswordCheck

  def initialize(sha)
    @sha = sha
  end

  def check
    return check_for_match(@sha)
  end

  private

  def create_or_uppdate_guess
    result = Guess.find_by_sha(@sha)
    if result
      result.increment!(:searched_count)
      return result
    else
      breach_match = begin
        get_password(@sha).present? ? true : false
      rescue Azure::Core::Http::HTTPError
        false
      end
      password_guess = Guess.new(sha: @sha, found: breach_match)
      password_guess.save
      return password_guess
    end
  end

  def check_for_match(password_guess)
    guessed_match = create_or_uppdate_guess
    if guessed_match.found && guessed_match.searched_count == 1
      return { message: "Congratulations, you were the first to find this password", status: :ok  }
    elsif guessed_match.found
      return { message: "Already found! It has been searched for by #{guessed_match.searched_count - 1} people before", status: :ok  }
    elsif guessed_match.searched_count > 1
      return { message: "Unlucky, this password was not in a breach, however #{guessed_match.searched_count - 1} people have tried this before", status: :ok  }
    else
      return { message: "Unlucky password not found", status: :ok }
    end
  end

  def client
    client ||= Azure::Storage.setup(:storage_account_name => 'passwordmatch', :storage_access_key => 'mykey')
  end

  def tables_getter
    client
    Azure::Storage::Table::TableService.new
  end

  def get_password(hashed_password)
    tables_getter.get_entity('breachedpasswords', hashed_password[0,4], hashed_password)
  end

end