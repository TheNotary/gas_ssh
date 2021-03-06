require 'rbconfig'

SSH_DIRECTORY = "#{ENV['HOME']}/.ssh" # File.expand_path('~/.ssh')
GITHUB_SERVER = 'api.github.com'
IS_WINDOWS = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)

require 'sshkey' #external

require 'gas'

require 'gas_ssh/prompter'
require 'gas_ssh/ssh'
require 'gas_ssh/github_speaker'
require 'gas_ssh/settings'

module GasSsh

  @config = Gas::Config.new

  # Sets _nickname_ as current user
  # @param [String] nickname The nickname to use
  def self.use(nickname)
    # confirm that this user has an ssh and if so, swap it in safely
    Ssh.swap_in_rsa nickname

    Gas.show
  end

  # Adds a author to the config
  # @param [String] nickname The nickname of the author
  # @param [String] name The name of the author
  # @param [String] email The email of the author
  def self.add(nickname, name, email, github_speaker = nil)
    if Gas.has_user?(nickname)
      user = @config[nickname]
    else
      user = Gas::User.new name, email, nickname
    end

    using_ssh = Ssh.setup_ssh_keys user

    Ssh.upload_public_key_to_github(user, github_speaker) if using_ssh

    puts 'Added new author'
    puts user
  end


  # Adds an ssh key for the specified user
  def self.ssh(nickname)
    if nickname.nil?
      puts "Oh, so you'd like an elaborate explanation on how ssh key juggling works?  Well pull up a chair!"
      puts
      puts "Gas can juggle ssh keys for you.  It works best in a unix based environment (so at least use git bash or cygwin on a windows platform)."
      puts "You will be prompted if you would like to handle SSH keys when you create a new user."
      puts "If you are a long time user of gas, you can add ssh to an author by the command..."
      puts "\$  gas ssh NICKNAME"
      puts
      puts "Your ssh keys will be stored in ~/.gas/NICKNAME_id_rsa and automatically copied to ~/.ssh/id_rsa when you use the command..."
      puts "\$  gas use NICKNAME"
      puts "If ~/.ssh/id_rsa already exists, you will be prompted UNLESS that rsa file is already backed up in the .gas directory (I'm so sneaky, huh?)"
      puts
      puts "The unix command ssh-add is used in order to link up your rsa keys when you attempt to make an ssh connection (git push uses ssh keys of course)"
      puts
      puts "The ssh feature of gas offers you and the world ease of use, and even marginally enhanced privacy against corporate databases.  Did you know that IBM built one of the first automated database systems?  These ancient database machines (called tabulators) were used to facilitate the holocaust =("
    else
      user = @config[nickname]


      # Prompt Remake this user's ssh keys?

      # check for ssh keys
      if !Ssh.corresponding_rsa_files_exist?(nickname)
        Ssh.setup_ssh_keys user
        Ssh.upload_public_key_to_github user
      else
        Ssh.setup_ssh_keys user
        Ssh.upload_public_key_to_github user
      end
    end
  end

  # Deletes an author from the config using nickname
  # @param [String] nickname The nickname of the author
  def self.delete(nickname)

    return false unless Gas.no_user? nickname        # I re-engineered this section so I could use Gas.delete in a test even when that author didn't exist
                                                      # TODO: The name no_user? is now very confusing.  It should be changed to something like "user_exists?" now maybe?
    Ssh.delete nickname

    return true
  end

end
