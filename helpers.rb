require 'yaml'

config = YAML.load_file(ARGV.first || './config.yml')

BANKNOTES = config['banknotes']
ACCOUNTS = config['accounts']

def can_be_composed?(amount)
  bills = Array(BANKNOTES.keys)
  values = Array(BANKNOTES.values)

  (BANKNOTES.keys.count).times do |i|
    issued_banknotes = (amount - (amount % bills[i])) / bills[i]
    if issued_banknotes <= values[i]
      amount -= bills[i] * issued_banknotes
    else
      amount -= bills[i] * values[i]
    end  
  end 
  amount == 0
end

def money_in_atm
  money_in_atm = 0
  BANKNOTES.each{ |x,y| money_in_atm += x*y }
  money_in_atm  
end