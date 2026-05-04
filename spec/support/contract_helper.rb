# frozen_string_literal: true

module ContractHelper
  def load_contract(name)
    path = File.join(Rails.application.config.x.natsuzora_contracts_root, "#{name}.ntzc")
    contract_file = Natsuzora::Contract::Parser.new(File.read(path)).parse_file
    contract_file.to_contract
  end
end

RSpec.configure do |config|
  config.include ContractHelper
end
