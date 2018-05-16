require 'yaml'

config = YAML.load_file(ARGV.first || './config.yml')

BANKNOTES = config['banknotes']
ACCOUNTS = config['accounts']
error = 'ERROR: ACCOUNT NUMBER AND PASSWORD DON\'T MATCH'

money_in_atm = 0
BANKNOTES.each{ |x,y| money_in_atm += x*y }


def can_be_composed?(amount)
  bills = Array(BANKNOTES.keys)
  values = Array(BANKNOTES.values)

  (BANKNOTES.keys.count).times do |i|
    issued_banknotes = (amount - (amount % bills[i])) / bills[i]
    if issued_banknotes <= values[i]
      amount-= bills[i]*issued_banknotes
    else
      amount-= bills[i]*values[i]
    end  
  end 
  amount == 0
end


puts 'Please Enter Your Account Number: '
account_number = gets.chomp
puts 'Enter Your Password: '
account_password = gets.chomp

if ACCOUNTS[account_number.to_i].nil?
  puts error
  return
else
  if account_password == ACCOUNTS[account_number.to_i]['password']
    puts '-------------------------------------------------'
    puts "Hello, #{ACCOUNTS[account_number.to_i]['name']}"
    puts
  else
    puts error
    return
  end
end

loop do
  puts
  puts 'Please Choose From the Following Options:
      1. Display Balance
      2. Withdraw
      3. Log Out'
  puts
  option = gets.chomp.to_i
  puts
  case option
    when 1
      puts "Your Current Balance is ₴#{ACCOUNTS[account_number.to_i]['balance']}" 
    when 2
      loop do
        puts 'Enter Amount You Wish to Withdraw: '
        amount = gets.chomp.to_i

        if can_be_composed?(amount)
          if amount > ACCOUNTS[account_number.to_i]['balance'].to_i
            puts
            puts 'ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT: '
            puts
          elsif amount > money_in_atm
            puts
            puts "THE MAXIMUM AMOUNT AVALIBLE IN THIS ATM IS ₴#{money_in_atm}. PLEASE ENTER A DIFFERENT AMOUNT: " 
            puts
          else
            new_balance = ACCOUNTS[account_number.to_i]['balance'].to_i - amount
            config['accounts'][account_number.to_i]['balance'] = new_balance
            File.open("./config.yml", 'w') { |f| YAML.dump(config, f) } 
            puts "Your New Balance is ₴#{new_balance}"
            break
          end
        else
          puts
          puts 'THE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT: '
          puts
        end
      end
    when 3
      puts "#{ACCOUNTS[account_number.to_i]['name']}, Thank You For Using Our ATM. Good-Bye!"
      return
    else puts 'INPUT ERROR'
  end
end


