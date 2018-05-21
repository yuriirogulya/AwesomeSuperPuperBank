def can_be_composed?(amount, config)
  bills = Array(config['banknotes'].keys)
  values = Array(config['banknotes'].values)

  (config['banknotes'].keys.count).times do |i|
    issued_banknotes = (amount - (amount % bills[i])) / bills[i]
    if issued_banknotes <= values[i]
     amount -= bills[i] * issued_banknotes
     config['banknotes'][bills[i]] -= issued_banknotes
    else
     amount -= bills[i] * values[i]
    end
  end
  File.open("./config.yml", 'w') { |f| YAML.dump(config, f) }
  amount == 0
end

def money_in_atm(config)
  money_in_atm = config['banknotes'].reduce(0) { |summ, (key, value)| summ + key * value }
end

def withdraw(config, account_number, amount)
  new_balance = config['accounts'][account_number.to_i]['balance'].to_i - amount
  config['accounts'][account_number.to_i]['balance'] = new_balance
  File.open("./config.yml", 'w') { |f| YAML.dump(config, f) } 
  puts "\nYour New Balance is ₴#{new_balance}\n".colorize(:green)
end