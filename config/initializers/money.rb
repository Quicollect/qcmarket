# encoding : utf-8

MoneyRails.configure do |config|

  # To set the default currency
  #
  # config.default_currency = :usd

  # Set default bank object
  #
  # TODO: move this to proper cache & updated regularly
  cache = 'tmp/rates.xml'
  bank = EuCentralBank.new
  bank.update_rates(cache)

  if !bank.rates_updated_at || bank.rates_updated_at < Time.now - 3.days
    Rails.logger.info "QC | Updating exchange rates. Last was updated at #{bank.rates_updated_at}"
    bank.update_rates
    bank.save_rates(cache)
  else
    Rails.logger.info "QC | Using existing exchange rates from #{bank.rates_updated_at}"
  end

  # update what currencies are supported
  Rails.application.config.currencies = {}
  bank.rates.each do |r|
    symbol = r.first.sub('EUR_TO_', '').downcase.to_sym
    Rails.application.config.currencies[symbol] = Money::Currency.table[symbol]
  end

  config.default_bank = bank


  # Add exchange rates to current money bank object.
  # (The conversion rate refers to one direction only)
  #
  # Example:
  # config.add_rate "USD", "CAD", 1.24515
  # config.add_rate "CAD", "USD", 0.803115

  # To handle the inclusion of validations for monetized fields
  # The default value is true
  #
  # config.include_validations = true

  # Default ActiveRecord migration configuration values for columns:
  #
  # config.amount_column = { prefix: '',           # column name prefix
  #                          postfix: '_cents',    # column name  postfix
  #                          column_name: nil,     # full column name (overrides prefix, postfix and accessor name)
  #                          type: :integer,       # column type
  #                          present: true,        # column will be created
  #                          null: false,          # other options will be treated as column options
  #                          default: 0
  #                        }
  #
  # config.currency_column = { prefix: '',
  #                            postfix: '_currency',
  #                            column_name: nil,
  #                            type: :string,
  #                            present: true,
  #                            null: false,
  #                            default: 'USD'
  #                          }

  # Register a custom currency
  #
  # Example:
  # config.register_currency = {
  #   :priority            => 1,
  #   :iso_code            => "EU4",
  #   :name                => "Euro with subunit of 4 digits",
  #   :symbol              => "€",
  #   :symbol_first        => true,
  #   :subunit             => "Subcent",
  #   :subunit_to_unit     => 10000,
  #   :thousands_separator => ".",
  #   :decimal_mark        => ","
  # }

  # Set money formatted output globally.
  # Default value is nil meaning "ignore this option".
  # Options are nil, true, false.
  #
  # config.no_cents_if_whole = nil
  # config.symbol = nil
end
