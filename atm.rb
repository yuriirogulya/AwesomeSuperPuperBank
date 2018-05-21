require 'yaml'
require 'io/console'
require_relative './helpers.rb'
require 'colorize'

config = YAML.load_file(ARGV.first || './config.yml')

puts 'Please Enter Your Account Number:'.colorize(:light_yellow)
account_number = gets.chomp
puts 'Enter Your Password:'.colorize(:light_yellow)
account_password = STDIN.noecho(&:gets).chomp

if config['accounts'][account_number.to_i].nil?
  puts 'ERROR: WRONG ACCOUNT NUMBER'.colorize(:red)
  return
else
  if account_password == config['accounts'][account_number.to_i]['password']
    puts '-' * 50
    puts "Hello, #{config['accounts'][account_number.to_i]['name']}\n".colorize(:green)
  else
    puts 'ERROR: ACCOUNT NUMBER AND PASSWORD DON\'T MATCH'.colorize(:red)
    return
  end
end

loop do
  puts "\nPlease Choose From the Following Options:
      1. Display Balance
      2. Withdraw
      3. Log Out\n".colorize(:light_cyan)
  option = gets.chomp.to_i

  case option
    when 1
      puts "\nYour Current Balance is ₴#{config['accounts'][account_number.to_i]['balance']}".colorize(:green)
    when 2
      loop do
        puts "\nEnter Amount You Wish to Withdraw:\n".colorize(:light_yellow)
        amount = gets.chomp.to_i

        if amount < 0
          puts "\nAMOUNT CAN\'T BE NEGATIVE\n".colorize(:red)
          amount = 0
        elsif amount > money_in_atm(config)
          puts "\nTHE MAXIMUM AMOUNT AVALIBLE IN THIS ATM IS ₴#{money_in_atm(config)}. PLEASE ENTER A DIFFERENT AMOUNT\n".colorize(:red)
        elsif amount > config['accounts'][account_number.to_i]['balance'].to_i
          puts "\nERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT\n".colorize(:red)
        elsif !can_be_composed?(amount, config)
          puts "\nTHE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT\n".colorize(:red)
        else
          withdraw(config, account_number, amount)
          break
        end
      end
    when 3
      puts "\n#{config['accounts'][account_number.to_i]['name']}, Thank You For Using Our ATM. Good-Bye!".colorize(:green)
      return
    else 
      puts "\nERROR: WRONG INPUT\n".colorize(:red)
  end
end


